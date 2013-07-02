Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932609Ab3GBJjT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Jul 2013 05:39:19 -0400
Received: from relay1.mentorg.com ([192.94.38.131]:38748 "EHLO
	relay1.mentorg.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932250Ab3GBJjS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Jul 2013 05:39:18 -0400
Message-ID: <51D29FC2.9010407@mentor.com>
Date: Tue, 02 Jul 2013 10:39:14 +0100
From: Dean Jenkins <Dean_Jenkins@mentor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130625 Thunderbird/17.0.7
MIME-Version: 1.0
To: Andre Naujoks <nautsch2@gmail.com>
CC: linux-kernel@vger.kernel.org, Jiri Slaby <jslaby@suse.cz>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: [PATCH] kernel panic, pty.c: remove direct call to tty_wakup
 in pty_write
References: <51D196EA.7010809@gmail.com>
In-Reply-To: <51D196EA.7010809@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 02 Jul 2013 09:39:15.0859 (UTC) FILETIME=[0475B630:01CE7708]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/07/13 15:49, Andre Naujoks wrote:
> Hello.
>
> This patch removes the direct call to tty_wakeup in pty_write. I have
> not noticed any drawbacks with this but I am not familiar with the pty
> driver at all. I think what happens is a recursive loop,
> write_wakeup->write->write_wakeup ...
Indeed there is a recursive loop that I have witnessed whilst using SLIP 
over USB HID.

In the failure case for SLIP, xleft remains positive and recursion 
causes a stack overflow as xleft is not updated during the recursion:
sl_encaps()-->pty_write()-->tty_wakeup()-->slip_write_wakeup()-->pty_write()-->tty_wakeup()-->slip_write_wakeup() 
etc.

The underlying issue being pty_write() calling tty_wakeup() within the 
initial write thread. Note that the TTY wakeup event uses tty_wakeup() 
as a callback to request more data.
> The documentation for the tty interface forbids this direct call:
>
> (from Documentation/serial/tty.txt)
> write_wakeup()  - May be called at any point between open and close.
>        The TTY_DO_WRITE_WAKEUP flag indicates if a call
>        is needed but always races versus calls. Thus the
>        ldisc must be careful about setting order and to
>        handle unexpected calls. Must not sleep.
>
>        The driver is forbidden from calling this directly
>        from the ->write call from the ldisc as the ldisc
>        is permitted to call the driver write method from
>        this function. In such a situation defer it.
I also saw that documentation and the code seems to be breaking that 
description.

It is possible to mitigate against 
pty-write-->tty_wakeup()-->slip_write_wakeup() by clearing and setting 
TTY_DO_WRITE_WAKEUP at the "correct" time in the layers bound to 
PTY/TTY. Indeed, I modified SLIP to do that and sent patches to the 
linux-netdev mailing list although I am not aware of any progress in 
having those patches accepted.

Perhaps this mitigation could be applied to your scenario ?

Eventually, your patch could be used when all protocols have mitigration 
in place.

>
>
> The direct call caused a reproducable kernel panic (see bottom of this
> mail) for me with the following setup:
>
> - using can-utils from git://gitorious.org/linux-can/can-utils.git
>    slcan_attach and cangen are used
>
> - create a network link between two serial CAN interfaces with:
>    $ socat PTY,link=/tmp/slcan0,raw TCP4-LISTEN:50000 &
>    $ socat TCP4:localhost:50000 PTY,link=/tmp/slcan1,raw &
>    $ slcan_attach /tmp/slcan0
>    $ slcan_attach /tmp/slcan1
>    $ ip link set slcan0 up
>    $ ip link set slcan1 up
>
> - produce a kernel panic by overloading the CAN interfaces:
>    $ cangen slcan0 -g0
>
>
> Please keep me in CC. I am not subscribed to the list.
> If I can provide any more information, I will be glad to do so.
>
> This is the patch. It applies to the current linux master branch:
>
>
>  From 9f67139bebb938026406a66c1411e0b50628a238 Mon Sep 17 00:00:00 2001
> From: Andre Naujoks <nautsch2@googlemail.com>
> Date: Mon, 1 Jul 2013 15:45:13 +0200
> Subject: [PATCH 1/2] remove direct call to tty_wakeup in pty_write.
>
> Signed-off-by: Andre Naujoks <nautsch2@googlemail.com>
> ---
>   drivers/tty/pty.c | 1 -
>   1 file changed, 1 deletion(-)
>
> diff --git a/drivers/tty/pty.c b/drivers/tty/pty.c
> index abfd990..5dcb782 100644
> --- a/drivers/tty/pty.c
> +++ b/drivers/tty/pty.c
> @@ -127,7 +127,6 @@ static int pty_write(struct tty_struct *tty, const
> unsigned char *buf, int c)
>   		/* And shovel */
>   		if (c) {
>   			tty_flip_buffer_push(to->port);
> -			tty_wakeup(tty);
>   		}
>   	}
>   	return c;
I agree that this looks to be a simple remedy to the issue. However, 
this code has existed in this state for many years so there is a risk 
that some applications rely on this "feature" in order to work. For 
example, SLIP uses this "feature" although I am not certain that the 
existing SLIP code would break if your patch were applied. The TTY 
wakeup event should take care of completing the transmission (in theory).

I think a lower risk approach would be to modify the upper layers in the 
protocol write function to clear the TTY_DO_WRITE_WAKEUP flag before 
pty_write is called and set TTY_DO_WRITE_WAKEUP afterwards to allow the 
TTY wakeup event to complete the transmission. I did this in the SLIP 
sl_encaps() and slip_write_wakeup() functions. Note that the SLIP 
segmentation mechanism is also broken as it is possible to send 
truncated SLIP frames upon a failure to send all characters of the 
frame. This leads to the recursive loop on the transmission of next SLIP 
frame because xleft remains positive (uninitialised) and this causes the 
kernel to crash catastrophically. The scheduler crashes due to the stack 
overflow overwriting the task data structures.

If anyone is interested, I could upload my SLIP patches to the 
linux-kernel mailing list.

Regards,
Dean Jenkins
Mentor Graphics
