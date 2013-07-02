Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754571Ab3GBS7W (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Jul 2013 14:59:22 -0400
Received: from mailout39.mail01.mtsvc.net ([216.70.64.83]:60762 "EHLO
	n12.mail01.mtsvc.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754024Ab3GBS7V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Jul 2013 14:59:21 -0400
Message-ID: <51D32303.2060904@hurleysoftware.com>
Date: Tue, 02 Jul 2013 14:59:15 -0400
From: Peter Hurley <peter@hurleysoftware.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130623 Thunderbird/17.0.7
MIME-Version: 1.0
To: Andre Naujoks <nautsch2@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC: linux-kernel@vger.kernel.org, Jiri Slaby <jslaby@suse.cz>,
        Dean Jenkins <Dean_Jenkins@mentor.com>
Subject: Re: [PATCH] kernel panic, pty.c: remove direct call to tty_wakup
 in pty_write
References: <51D196EA.7010809@gmail.com>
In-Reply-To: <51D196EA.7010809@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Authenticated-User: 990527 peter@hurleysoftware.com
X-MT-INTERNAL-ID: 8fa290c2a27252aacf65dbc4a42f3ce3735fb2a4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/01/2013 10:49 AM, Andre Naujoks wrote:
> Hello.
>
> This patch removes the direct call to tty_wakeup in pty_write. I have
> not noticed any drawbacks with this but I am not familiar with the pty
> driver at all. I think what happens is a recursive loop,
> write_wakeup->write->write_wakeup ...
>
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
>
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

An identical patch is in Greg's queue for linux-next:
   'tty: Remove extra wakeup from pty write() path'

That patch's commit message details why tty_wakeup() is unnecessary,
but does not foresee or document the SLIP ldisc write()/write_wakeup()
recursion.

Since this fix will now likely go back through stable, the commit
message should include a description of the recursion, so that Greg can
merge the commit messages.

Separately, the stack trace for the WARN and the oops implicates
the network stack alone. Maybe there is some other problem?

Regards,
Peter Hurley



