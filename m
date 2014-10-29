Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934232AbaJ2P5O (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Oct 2014 11:57:14 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:44533 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932994AbaJ2P5M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Oct 2014 11:57:12 -0400
Date: Wed, 29 Oct 2014 23:56:02 +0800
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Johan Hovold <johan@kernel.org>
Cc: linux-usb@vger.kernel.org, Jim Paris <jim@jtan.com>,
        Oliver Neukum <oliver@neukum.org>, linux-kernel@vger.kernel.org,
        Peter Hurley <peter@hurleysoftware.com>
Subject: Re: [PATCH] USB: cdc-acm: only raise DTR on transitions from B0
Message-ID: <20141029155602.GC17399@kroah.com>
References: <20141029150716.GG2265@localhost>
 <1414596640-28555-1-git-send-email-johan@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1414596640-28555-1-git-send-email-johan@kernel.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 29, 2014 at 04:30:40PM +0100, Johan Hovold wrote:
> Make sure to only raise DTR on transitions from B0 in set_termios.
> 
> Also allow set_termios to be called from open with a termios_old of
> NULL. Note that DTR will not be raised prematurely in this case.
> 
> Signed-off-by: Johan Hovold <johan@kernel.org>
> ---
>  drivers/usb/class/cdc-acm.c | 5 +++--
>  1 file changed, 3 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/usb/class/cdc-acm.c b/drivers/usb/class/cdc-acm.c
> index e934e19f49f5..7e58bbfd6319 100644
> --- a/drivers/usb/class/cdc-acm.c
> +++ b/drivers/usb/class/cdc-acm.c
> @@ -980,11 +980,12 @@ static void acm_tty_set_termios(struct tty_struct *tty,
>  	/* FIXME: Needs to clear unsupported bits in the termios */
>  	acm->clocal = ((termios->c_cflag & CLOCAL) != 0);
>  
> -	if (!newline.dwDTERate) {
> +	if (C_BAUD(tty) == B0) {
>  		newline.dwDTERate = acm->line.dwDTERate;
>  		newctrl &= ~ACM_CTRL_DTR;
> -	} else
> +	} else if (termios_old && (termios_old->c_cflag & CBAUD) == B0) {
>  		newctrl |=  ACM_CTRL_DTR;
> +	}
>  
>  	if (newctrl != acm->ctrlout)
>  		acm_set_control(acm, acm->ctrlout = newctrl);

This should go to older kernels as well, right?
