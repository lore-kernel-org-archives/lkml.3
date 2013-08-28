Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754038Ab3H1Rna (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Aug 2013 13:43:30 -0400
Received: from mga02.intel.com ([134.134.136.20]:26763 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753033Ab3H1Rn3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Aug 2013 13:43:29 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.89,977,1367996400"; 
   d="scan'208";a="394857159"
Date: Wed, 28 Aug 2013 10:43:28 -0700
From: Sarah Sharp <sarah.a.sharp@linux.intel.com>
To: Dmitry Kasatkin <d.kasatkin@samsung.com>
Cc: gregkh@linuxfoundation.org, dmitry.kasatkin@gmail.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCHv2 1/2] dev-core: fix build break when DEBUG is enabled
Message-ID: <20130828174328.GG26483@xanatos>
References: <7f53397d0aa93e644124037d44188da5067336fc.1377614854.git.d.kasatkin@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <7f53397d0aa93e644124037d44188da5067336fc.1377614854.git.d.kasatkin@samsung.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Applying: dev-core: fix build break when DEBUG is enabled
WARNING: Avoid unnecessary line continuations
#18: FILE: include/linux/device.h:1110:
+	   "callbacks suppressed" */					\

WARNING: Prefer dev_dbg(... to dev_printk(KERN_DEBUG, ...
#33: FILE: include/linux/device.h:1123:
+		dev_printk(KERN_DEBUG, dev, fmt, ##__VA_ARGS__);	\

total: 0 errors, 2 warnings, 31 lines checked

I'm just going to fix the first warning myself by moving your comment
above the macro.  Please don't add comments inside macros, and please
run your patches through checkpatch.pl.

Sarah Sharp

On Tue, Aug 27, 2013 at 05:47:34PM +0300, Dmitry Kasatkin wrote:
> When DEBUG is defined, dev_dbg_ratelimited uses dynamic debug data
> structures even when CONFIG_DYNAMIC_DEBUG is not defined.
> It leads to build break.
> For example, when I try to use dev_dbg_ratelimited in USB code and
> CONFIG_USB_DEBUG is enabled, but CONFIG_DYNAMIC_DEBUG is not, I get:
> 
>   CC [M]  drivers/usb/host/xhci-ring.o
>   drivers/usb/host/xhci-ring.c: In function ‘xhci_queue_intr_tx’:
>   drivers/usb/host/xhci-ring.c:3059:3: error: implicit declaration of function ‘DEFINE_DYNAMIC_DEBUG_METADATA’ [-Werror=implicit-function-declaration]
>   drivers/usb/host/xhci-ring.c:3059:3: error: ‘descriptor’ undeclared (first use in this function)
>   drivers/usb/host/xhci-ring.c:3059:3: note: each undeclared identifier is reported only once for each function it appears in
>   drivers/usb/host/xhci-ring.c:3059:3: error: implicit declaration of function ‘__dynamic_pr_debug’ [-Werror=implicit-function-declaration]
>   drivers/usb/host/xhci-ring.c: In function ‘xhci_queue_isoc_tx_prepare’:
>   drivers/usb/host/xhci-ring.c:3847:3: error: ‘descriptor’ undeclared (first use in this function)
>   cc1: some warnings being treated as errors
>   make[2]: *** [drivers/usb/host/xhci-ring.o] Error 1
>   make[1]: *** [drivers/usb/host] Error 2
>   make: *** [drivers/usb/] Error 2
> 
> This patch separates definition for CONFIG_DYNAMIC_DEBUG and DEBUG cases.
> 
> Signed-off-by: Dmitry Kasatkin <d.kasatkin@samsung.com>
> ---
>  include/linux/device.h | 17 ++++++++++++++---
>  1 file changed, 14 insertions(+), 3 deletions(-)
> 
> diff --git a/include/linux/device.h b/include/linux/device.h
> index 22b546a..d336beb 100644
> --- a/include/linux/device.h
> +++ b/include/linux/device.h
> @@ -1099,17 +1099,28 @@ do {									\
>  	dev_level_ratelimited(dev_notice, dev, fmt, ##__VA_ARGS__)
>  #define dev_info_ratelimited(dev, fmt, ...)				\
>  	dev_level_ratelimited(dev_info, dev, fmt, ##__VA_ARGS__)
> -#if defined(CONFIG_DYNAMIC_DEBUG) || defined(DEBUG)
> +#if defined(CONFIG_DYNAMIC_DEBUG)
>  #define dev_dbg_ratelimited(dev, fmt, ...)				\
>  do {									\
>  	static DEFINE_RATELIMIT_STATE(_rs,				\
>  				      DEFAULT_RATELIMIT_INTERVAL,	\
>  				      DEFAULT_RATELIMIT_BURST);		\
>  	DEFINE_DYNAMIC_DEBUG_METADATA(descriptor, fmt);			\
> +	/* descriptor check is first to prevent flooding with		\
> +	   "callbacks suppressed" */					\
>  	if (unlikely(descriptor.flags & _DPRINTK_FLAGS_PRINT) &&	\
>  	    __ratelimit(&_rs))						\
> -		__dynamic_pr_debug(&descriptor, pr_fmt(fmt),		\
> -				   ##__VA_ARGS__);			\
> +		__dynamic_dev_dbg(&descriptor, dev, fmt,		\
> +				  ##__VA_ARGS__);			\
> +} while (0)
> +#elif defined(DEBUG)
> +#define dev_dbg_ratelimited(dev, fmt, ...)				\
> +do {									\
> +	static DEFINE_RATELIMIT_STATE(_rs,				\
> +				      DEFAULT_RATELIMIT_INTERVAL,	\
> +				      DEFAULT_RATELIMIT_BURST);		\
> +	if (__ratelimit(&_rs))						\
> +		dev_printk(KERN_DEBUG, dev, fmt, ##__VA_ARGS__);	\
>  } while (0)
>  #else
>  #define dev_dbg_ratelimited(dev, fmt, ...)			\
> -- 
> 1.8.1.2
> 
