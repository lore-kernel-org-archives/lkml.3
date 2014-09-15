Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932188AbaIOVuy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Sep 2014 17:50:54 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:47345 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757024AbaIOVuw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Sep 2014 17:50:52 -0400
Date: Mon, 15 Sep 2014 14:50:50 -0700
From: Darren Hart <dvhart@infradead.org>
To: Frans Klaver <fransklaver@gmail.com>
Cc: Corentin Chary <corentin.chary@gmail.com>,
        Rafael Wysocki <rafael.j.wysocki@intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        acpi4asus-user@lists.sourceforge.net,
        platform-driver-x86@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 11/13] eeepc-laptop: propagate errors from get_cpufv
Message-ID: <20140915215050.GC64909@vmdeb7>
References: <1410563212-31565-1-git-send-email-fransklaver@gmail.com>
 <1410563212-31565-12-git-send-email-fransklaver@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1410563212-31565-12-git-send-email-fransklaver@gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Sep 13, 2014 at 01:06:50AM +0200, Frans Klaver wrote:
> In show_available_cpufv, show_cpufv, and store_cpufv, errors from
> get_cpufv are mapped to -ENODEV. To paint a clear picture to callers,
> propagate the errors instead.
> 

Ooops, should have forwarded this one around instead. I generally agree with
this approach, but do want confirmation from Greg and others that this is
an acceptable change to the sysfs interface.

--
Darren

> Signed-off-by: Frans Klaver <fransklaver@gmail.com>
> ---
>  drivers/platform/x86/eeepc-laptop.c | 16 ++++++++++------
>  1 file changed, 10 insertions(+), 6 deletions(-)
> 
> diff --git a/drivers/platform/x86/eeepc-laptop.c b/drivers/platform/x86/eeepc-laptop.c
> index 828db56..732b012 100644
> --- a/drivers/platform/x86/eeepc-laptop.c
> +++ b/drivers/platform/x86/eeepc-laptop.c
> @@ -351,8 +351,9 @@ static ssize_t show_available_cpufv(struct device *dev,
>  	int i;
>  	ssize_t len = 0;
>  
> -	if (get_cpufv(eeepc, &c))
> -		return -ENODEV;
> +	i = get_cpufv(eeepc, &c);
> +	if (i)
> +		return i;
>  	for (i = 0; i < c.num; i++)
>  		len += sprintf(buf + len, "%d ", i);
>  	len += sprintf(buf + len, "\n");
> @@ -365,9 +366,11 @@ static ssize_t show_cpufv(struct device *dev,
>  {
>  	struct eeepc_laptop *eeepc = dev_get_drvdata(dev);
>  	struct eeepc_cpufv c;
> +	int rv;
>  
> -	if (get_cpufv(eeepc, &c))
> -		return -ENODEV;
> +	rv = get_cpufv(eeepc, &c);
> +	if (rv)
> +		return rv;
>  	return sprintf(buf, "%#x\n", (c.num << 8) | c.cur);
>  }
>  
> @@ -381,8 +384,9 @@ static ssize_t store_cpufv(struct device *dev,
>  
>  	if (eeepc->cpufv_disabled)
>  		return -EPERM;
> -	if (get_cpufv(eeepc, &c))
> -		return -ENODEV;
> +	rv = get_cpufv(eeepc, &c);
> +	if (rv)
> +		return rv;
>  	rv = parse_arg(buf, &value);
>  	if (rv < 0)
>  		return rv;
> -- 
> 2.1.0
> 
> --
> To unsubscribe from this list: send the line "unsubscribe platform-driver-x86" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

-- 
Darren Hart
Intel Open Source Technology Center
