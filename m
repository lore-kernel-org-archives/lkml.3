Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932290AbaICK7J (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Sep 2014 06:59:09 -0400
Received: from 251.110.2.81.in-addr.arpa ([81.2.110.251]:51820 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932129AbaICK7H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Sep 2014 06:59:07 -0400
Date: Wed, 3 Sep 2014 11:58:52 +0100
From: One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>
To: Peter Hurley <peter@hurleysoftware.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jiri Slaby <jslaby@suse.cz>, linux-serial@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 21/26] tty: Convert tty_struct bitfield to bools
Message-ID: <20140903115852.5a720754@alan.etchedpixels.co.uk>
In-Reply-To: <1409693975-1028-22-git-send-email-peter@hurleysoftware.com>
References: <1409693975-1028-1-git-send-email-peter@hurleysoftware.com>
	<1409693975-1028-22-git-send-email-peter@hurleysoftware.com>
Organization: Intel Corporation
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.23; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue,  2 Sep 2014 17:39:30 -0400
Peter Hurley <peter@hurleysoftware.com> wrote:

> The stopped, hw_stopped, flow_stopped and packet bits are smp-unsafe
> and interrupt-unsafe. For example,
> 
> CPU 0                         | CPU 1
>                               |
> tty->flow_stopped = 1         | tty->hw_stopped = 0
> 
> One of these updates will be corrupted, as the bitwise operation
> on the bitfield is non-atomic.
> 
> Ensure each flag has a separate memory location, so concurrent
> updates do not corrupt orthogonal states.

Ouch....

Alas the fix is not sufficient on some platforms. gcc will happily use
32bit operations on those fields if it thinks its a performance win.

It needs to use set_bit and friends.

x86 is generally ok, but ia64 gcc will do things like load all four
bytes, mask and write the dword back. I believe ARM gcc may also
sometimes generate similar results.


> 
> Signed-off-by: Peter Hurley <peter@hurleysoftware.com>
> ---
>  include/linux/tty.h | 5 ++++-
>  1 file changed, 4 insertions(+), 1 deletion(-)
> 
> diff --git a/include/linux/tty.h b/include/linux/tty.h
> index 1c3316a..7cf61cb 100644
> --- a/include/linux/tty.h
> +++ b/include/linux/tty.h
> @@ -261,7 +261,10 @@ struct tty_struct {
>  	unsigned long flags;
>  	int count;
>  	struct winsize winsize;		/* winsize_mutex */
> -	unsigned char stopped:1, hw_stopped:1, flow_stopped:1, packet:1;
> +	bool stopped;
> +	bool hw_stopped;
> +	bool flow_stopped;
> +	bool packet;
>  	unsigned char ctrl_status;	/* ctrl_lock */
>  	unsigned int receive_room;	/* Bytes free for queue */
>  	int flow_change;
