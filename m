Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753427AbaJQH6K (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Oct 2014 03:58:10 -0400
Received: from a.ns.miles-group.at ([95.130.255.143]:65276 "EHLO radon.swed.at"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750851AbaJQH6G (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Oct 2014 03:58:06 -0400
Message-ID: <5440CC07.3000205@nod.at>
Date: Fri, 17 Oct 2014 09:57:59 +0200
From: Richard Weinberger <richard@nod.at>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.1.0
MIME-Version: 1.0
To: Peter Hurley <peter@hurleysoftware.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC: linux-serial@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jiri Slaby <jslaby@suse.cz>,
        One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>,
        Jeff Dike <jdike@addtoit.com>,
        user-mode-linux-devel@lists.sourceforge.net
Subject: Re: [PATCH -next 04/10] uml: Fix unsafe pid reference to foreground
 process group
References: <1413485990-16855-1-git-send-email-peter@hurleysoftware.com> <1413485990-16855-5-git-send-email-peter@hurleysoftware.com>
In-Reply-To: <1413485990-16855-5-git-send-email-peter@hurleysoftware.com>
Content-Type: text/plain; charset=iso-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am 16.10.2014 um 20:59 schrieb Peter Hurley:
> Although the tty core maintains a pid reference for the foreground
> process group, if the foreground process group is changed that
> pid reference is dropped. Thus, the pid reference used for signalling
> could become stale.
> 
> Safely obtain a pid reference to the foreground process group and
> release the reference after signalling is complete.
> 
> cc: Jeff Dike <jdike@addtoit.com>
> cc: Richard Weinberger <richard@nod.at>
> cc: user-mode-linux-devel@lists.sourceforge.net
> Signed-off-by: Peter Hurley <peter@hurleysoftware.com>

Acked-by: Richard Weinberger <richard@nod.at>

> ---
>  arch/um/drivers/line.c | 6 +++++-
>  1 file changed, 5 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/um/drivers/line.c b/arch/um/drivers/line.c
> index 8035145..6208702 100644
> --- a/arch/um/drivers/line.c
> +++ b/arch/um/drivers/line.c
> @@ -632,6 +632,7 @@ static irqreturn_t winch_interrupt(int irq, void *data)
>  	int fd = winch->fd;
>  	int err;
>  	char c;
> +	struct pid *pgrp;
>  
>  	if (fd != -1) {
>  		err = generic_read(fd, &c, NULL);
> @@ -657,7 +658,10 @@ static irqreturn_t winch_interrupt(int irq, void *data)
>  		if (line != NULL) {
>  			chan_window_size(line, &tty->winsize.ws_row,
>  					 &tty->winsize.ws_col);
> -			kill_pgrp(tty->pgrp, SIGWINCH, 1);
> +			pgrp = tty_get_pgrp(tty);
> +			if (pgrp)
> +				kill_pgrp(pgrp, SIGWINCH, 1);
> +			put_pid(pgrp);
>  		}
>  		tty_kref_put(tty);
>  	}
> 
