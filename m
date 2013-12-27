Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754730Ab3L0SrI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Dec 2013 13:47:08 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:59337 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752234Ab3L0SrG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Dec 2013 13:47:06 -0500
Date: Fri, 27 Dec 2013 10:47:40 -0800
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Ben Hutchings <ben@decadent.org.uk>
Cc: LKML <linux-kernel@vger.kernel.org>, Joe Perches <joe@perches.com>,
        Kay Sievers <kay@vrfy.org>
Subject: Re: [PATCH] drivers/base: Fix length checks in
 create_syslog_header()/dev_vprintk_emit()
Message-ID: <20131227184740.GA5180@kroah.com>
References: <1388164698.26981.73.camel@deadeye.wl.decadent.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1388164698.26981.73.camel@deadeye.wl.decadent.org.uk>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 27, 2013 at 06:18:18PM +0100, Ben Hutchings wrote:
> snprintf() returns the number of bytes that could have been written
> (excluding the null), not the actual number of bytes written.  Given a
> long enough subsystem or device name, these functions will advance
> beyond the end of the on-stack buffer in dev_vprintk_exit(), resulting
> in an information leak or stack corruption.  I don't know whether such
> a long name is currently possible.
> 
> In case snprintf() returns a value >= the buffer size, do not add
> structured logging information.  Also WARN the first time this
> happens, so we can fix the driver or increase the buffer size.
> 
> Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
> ---
>  drivers/base/core.c | 9 +++++++++
>  1 file changed, 9 insertions(+)
> 
> diff --git a/drivers/base/core.c b/drivers/base/core.c
> index 67b180d..989a93c 100644
> --- a/drivers/base/core.c
> +++ b/drivers/base/core.c
> @@ -2022,6 +2022,8 @@ create_syslog_header(const struct device *dev, char *hdr, size_t hdrlen)
>  		return 0;
>  
>  	pos += snprintf(hdr + pos, hdrlen - pos, "SUBSYSTEM=%s", subsys);
> +	if (pos >= hdrlen)
> +		goto overflow;
>  
>  	/*
>  	 * Add device identifier DEVICE=:
> @@ -2053,7 +2055,14 @@ create_syslog_header(const struct device *dev, char *hdr, size_t hdrlen)
>  				"DEVICE=+%s:%s", subsys, dev_name(dev));
>  	}
>  
> +	if (pos >= hdrlen)
> +		goto overflow;
> +
>  	return pos;
> +
> +overflow:
> +	dev_WARN_ONCE(dev, 1, "device/subsystem name too long");

Why only warn once?  Any device/subsystem mix should be complained
about, if for only that we should be really annoying about it to get it
resolved.

thanks,

greg k-h
