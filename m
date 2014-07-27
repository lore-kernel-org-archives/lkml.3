Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752538AbaG0SJz (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Jul 2014 14:09:55 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:39909 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751960AbaG0SJy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Jul 2014 14:09:54 -0400
Date: Sun, 27 Jul 2014 11:09:53 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: "xinhui.pan" <xinhuix.pan@intel.com>
Cc: Jiri Slaby <jslaby@suse.cz>, linux-kernel@vger.kernel.org,
        "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>,
        mnipxh <mnipxh@gmail.com>, Peter Hurley <peter@hurleysoftware.com>,
        gnomes@lxorguk.ukuu.org.uk
Subject: Re: [PATCH] tty/n_gsm.c: do not clear gsm_mux entry when the gsm is
 not closed
Message-ID: <20140727180953.GA7232@kroah.com>
References: <53D0CF0D.9060103@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <53D0CF0D.9060103@intel.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 24, 2014 at 05:17:01PM +0800, xinhui.pan wrote:
> If the gsmtty is still used by some process, we could not just
> simply clear gsm_mux[gsm->num]. Clear it when gsm is being free.
> Otherwise we will hit crashes when userspace close the gsmtty.
> 
> Also add gsm_mux_get() and gsm_mux_put() to make gsm_mux[] is used safely.
> We can do activation/deactivation with same gsm more than once now.
> This is for fixing the FIXME.
> 
> Signed-off-by: xinhui.pan <xinhuiX.pan@intel.com>
> Reviewed-by: Zhang Yanmin <yanmin_zhang@linux.intel.com>
> ---
>  drivers/tty/n_gsm.c |   84 ++++++++++++++++++++++++++++++++++++---------------
>  1 file changed, 60 insertions(+), 24 deletions(-)
> 
> diff --git a/drivers/tty/n_gsm.c b/drivers/tty/n_gsm.c
> index 81e7ccb..290df56 100644
> --- a/drivers/tty/n_gsm.c
> +++ b/drivers/tty/n_gsm.c
> @@ -2020,6 +2020,58 @@ static void gsm_error(struct gsm_mux *gsm,
>  }
>  
>  /**
> + *	gsm_mux_get		-	get/fill one entry in gsm_mux
> + *	@gsm: our gsm
> + *
> + *	Although its name end with get, it don't inc ref-count actually.

Then don't call it a 'get' function :(

> + *	get one entry is just like fill pte, first memory access will
> + *	cause page_fault, the next accesses don't. So do here.

This doesn't make much sense to me, can you please explain it better?

> + */
> +

blank line?

> +static int gsm_mux_get(struct gsm_mux *gsm)
> +{
> +	int i;
> +
> +	if (gsm->num >= MAX_MUX) /* gsm is alloc by kzalloc, just be careful */
> +		return -EIO;

-EIO?

> +	if (gsm_mux[gsm->num] == gsm) /* We have already set gsm->num */
> +		return 0;
> +
> +	spin_lock(&gsm_mux_lock);
> +	for (i = 0; i < MAX_MUX; i++) {
> +		if (gsm_mux[i] == NULL) {
> +			gsm->num = i;
> +			gsm_mux[i] = gsm;
> +			break;
> +		}
> +	}
> +	spin_unlock(&gsm_mux_lock);
> +
> +	if (i == MAX_MUX)
> +		return -EBUSY;
> +	return 0;
> +}
> +
> +/**
> + *	gsm_mux_put		-	put/clear one entry in gsm_mux
> + *	@gsm: our gsm
> + *
> + *	Although its name end with put, it don't dec ref-count actually.
> + *	put one entry is just like clear pte, So do here.
> + */
> +
> +static void gsm_mux_put(struct gsm_mux *gsm)
> +{
> +	if (gsm->num >= MAX_MUX)
> +		return;
> +
> +	spin_lock(&gsm_mux_lock);
> +	if (gsm_mux[gsm->num] == gsm)

How can this not be true?

> +		gsm_mux[gsm->num] = NULL;
> +	spin_unlock(&gsm_mux_lock);
> +}

Why can't you do dynamic reference counting of your structure, that
would allow you to get rid of your global array, right?

thanks,

greg k-h
