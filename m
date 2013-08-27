Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753578Ab3H0QUh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Aug 2013 12:20:37 -0400
Received: from perches-mx.perches.com ([206.117.179.246]:53252 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753296Ab3H0QUe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Aug 2013 12:20:34 -0400
Message-ID: <1377620432.6337.12.camel@joe-AO722>
Subject: Re: [PATCHv2 1/2] dev-core: fix build break when DEBUG is enabled
From: Joe Perches <joe@perches.com>
To: Dmitry Kasatkin <d.kasatkin@samsung.com>, Hiroshi Doyu <hdoyu@nvidia.com>,
        Jason Baron <jbaron@akamai.com>
Cc: sarah.a.sharp@linux.intel.com, gregkh@linuxfoundation.org,
        dmitry.kasatkin@gmail.com, linux-kernel@vger.kernel.org
Date: Tue, 27 Aug 2013 09:20:32 -0700
In-Reply-To: <7f53397d0aa93e644124037d44188da5067336fc.1377614854.git.d.kasatkin@samsung.com>
References: <7f53397d0aa93e644124037d44188da5067336fc.1377614854.git.d.kasatkin@samsung.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2013-08-27 at 17:47 +0300, Dmitry Kasatkin wrote:
> When DEBUG is defined, dev_dbg_ratelimited uses dynamic debug data
> structures even when CONFIG_DYNAMIC_DEBUG is not defined.
> It leads to build break.
> For example, when I try to use dev_dbg_ratelimited in USB code and
> CONFIG_USB_DEBUG is enabled, but CONFIG_DYNAMIC_DEBUG is not, I get:

Jason?

Seems mostly sensible to me but I think the first check
needs to be

#if defined(CONFIG_DYNAMIC_DEBUG) && defined(DEBUG)

Also, it's curious why it was ever using __dynamic_pr_debug
instead of __dynamic_dev_dbg

Maybe for completeness there should be a
dev_vdbg_ratelimited too.

Additional bit below...

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

I think this needs to be

#if defined(CONFIG_DYNAMIC_DEBUG) && defined(DEBUG)

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



