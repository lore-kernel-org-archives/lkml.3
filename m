Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967315Ab3HIK6Q (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Aug 2013 06:58:16 -0400
Received: from aserp1040.oracle.com ([141.146.126.69]:28537 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966851Ab3HIK6O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Aug 2013 06:58:14 -0400
Date: Fri, 9 Aug 2013 13:57:54 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Won Kang <wkang77@gmail.com>
Cc: linux-kernel@vger.kernel.org, devel@driverdev.osuosl.org, joe@perches.co,
        gregkh@linuxfoundation.org, Won Kang <wonkang@gctsemi.com>,
        sachin.kamat@linaro.org
Subject: Re: [PATCH] staging: gdm7240: a TTY rewrite according to the latest
 TTY APIs
Message-ID: <20130809105754.GJ5502@mwanda>
References: <1376036357-7216-1-git-send-email-wonkang@gctsemi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1376036357-7216-1-git-send-email-wonkang@gctsemi.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Whenever I see "rewrite" in the subject, my first reaction is to
start typing, "Please break this big patch up into a series of small
patches".  In this case, I guess it's hard to do that so you're ok.
I do wish you had put the variable renaming into a separate patch
though.

On Fri, Aug 09, 2013 at 05:19:17PM +0900, Won Kang wrote:
> Removed the old style reference countings and termios.

I guess this is clear but if you wanted to say some more comments
about this in the change log that would be nice as well.

> Renamed variables to meaninful ones.
> 
> Signed-off-by: Won Kang <wonkang@gctsemi.com>

This signed-off-by doesn't match the email address where the patch
was sent.

> +static void gdm_port_destruct(struct tty_port *port)
> +{
> +	struct gdm *gdm = container_of(port, struct gdm, port);
> +
> +	mutex_lock(&gdm_table_lock);
> +	gdm_table[gdm->index][gdm->minor] = NULL;
> +	mutex_unlock(&gdm_table_lock);
> +
> +	kfree(gdm);

We only take the lock when we are getting the "gdm" pointer from the
gdm_table.  We release the lock as soon as we have our pointer but
we still are using it after we have released the lock.  In other
words:

	mutex_lock(&gdm_table_lock);
	gdm = gdm_table[index][minor];
	mutex_unlock(&gdm_table_lock);

	if (!GDM_TTY_READY(gdm)) {  <-- we have released the lock
	                                but we are still using the
					pointer.

So this could be a use after free bug here.  I haven't followed
through to actaully see how this is called, this sort of locking is
a common bug.

> +		gdm = kmalloc(sizeof(struct gdm), GFP_KERNEL);
> +		if (!gdm)
> +			return -ENOMEM;
>  
> -int register_lte_tty_device(struct tty_dev *tty_dev, struct device *dev)
> -{
> -	struct tty_str *tty_str;
> -	int i, j;
> +		mutex_lock(&gdm_table_lock);
>  
> -	for (i = 0; i < TTY_MAX_COUNT; i++) {
>  		for (j = 0; j < GDM_TTY_MINOR; j++) {
> -			if (!g_tty_str[i][j])
> +			if (!gdm_table[i][j])
>  				break;
>  		}
>  
>  		if (j == GDM_TTY_MINOR) {
> -			tty_dev->minor[i] = j;
> -			return -1;
> +			tty_dev->minor[i] = GDM_TTY_MINOR;
> +			mutex_unlock(&gdm_table_lock);
> +			return -EINVAL;

Static checkers will complain that we need to kfree(gdm) here.  It's
unlikely that this affects real life, but it's good to be pedantic.

regards,
dan carpenter

