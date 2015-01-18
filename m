Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751894AbbARA40 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Jan 2015 19:56:26 -0500
Received: from smtprelay0225.hostedemail.com ([216.40.44.225]:38592 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751708AbbARA4Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Jan 2015 19:56:24 -0500
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::,RULES_HIT:2:41:69:355:379:541:599:800:960:973:988:989:1260:1261:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1535:1593:1594:1605:1730:1747:1777:1792:2393:2559:2562:2828:3138:3139:3140:3141:3142:3622:3865:3867:3868:3871:4049:4118:4321:4605:5007:6119:7652:10004:10848:11026:11232:11658:11914:12043:12291:12296:12438:12517:12519:12555:12683:12740:13019:21080,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: crow34_54c71fe166800
X-Filterd-Recvd-Size: 7382
Message-ID: <1421542580.29879.2.camel@perches.com>
Subject: Re: [PATCH] device: Change dev_<level> logging functions to return
 void
From: Joe Perches <joe@perches.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>
Date: Sat, 17 Jan 2015 16:56:20 -0800
In-Reply-To: <1419548824.6157.19.camel@perches.com>
References: <1419548824.6157.19.camel@perches.com>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.12.7-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2014-12-25 at 15:07 -0800, Joe Perches wrote:
> No caller or macro uses the return value so make all
> the functions return void.

Ping?

> Compiled x86 allyesconfig and defconfig w/o CONFIG_PRINTK
> 
> Signed-off-by: Joe Perches <joe@perches.com>
> ---
> This change is associated to a desire to eventually
> change printk to return void.
> 
>  drivers/base/core.c    | 29 +++++++++---------------
>  include/linux/device.h | 60 ++++++++++++++++++++++++--------------------------
>  2 files changed, 40 insertions(+), 49 deletions(-)
> 
> diff --git a/drivers/base/core.c b/drivers/base/core.c
> index 97e2baf..07304a3 100644
> --- a/drivers/base/core.c
> +++ b/drivers/base/core.c
> @@ -2080,54 +2080,47 @@ int dev_printk_emit(int level, const struct device *dev, const char *fmt, ...)
>  }
>  EXPORT_SYMBOL(dev_printk_emit);
>  
> -static int __dev_printk(const char *level, const struct device *dev,
> +static void __dev_printk(const char *level, const struct device *dev,
>  			struct va_format *vaf)
>  {
> -	if (!dev)
> -		return printk("%s(NULL device *): %pV", level, vaf);
> -
> -	return dev_printk_emit(level[1] - '0', dev,
> -			       "%s %s: %pV",
> -			       dev_driver_string(dev), dev_name(dev), vaf);
> +	if (dev)
> +		dev_printk_emit(level[1] - '0', dev, "%s %s: %pV",
> +				dev_driver_string(dev), dev_name(dev), vaf);
> +	else
> +		printk("%s(NULL device *): %pV", level, vaf);
>  }
>  
> -int dev_printk(const char *level, const struct device *dev,
> -	       const char *fmt, ...)
> +void dev_printk(const char *level, const struct device *dev,
> +		const char *fmt, ...)
>  {
>  	struct va_format vaf;
>  	va_list args;
> -	int r;
>  
>  	va_start(args, fmt);
>  
>  	vaf.fmt = fmt;
>  	vaf.va = &args;
>  
> -	r = __dev_printk(level, dev, &vaf);
> +	__dev_printk(level, dev, &vaf);
>  
>  	va_end(args);
> -
> -	return r;
>  }
>  EXPORT_SYMBOL(dev_printk);
>  
>  #define define_dev_printk_level(func, kern_level)		\
> -int func(const struct device *dev, const char *fmt, ...)	\
> +void func(const struct device *dev, const char *fmt, ...)	\
>  {								\
>  	struct va_format vaf;					\
>  	va_list args;						\
> -	int r;							\
>  								\
>  	va_start(args, fmt);					\
>  								\
>  	vaf.fmt = fmt;						\
>  	vaf.va = &args;						\
>  								\
> -	r = __dev_printk(kern_level, dev, &vaf);		\
> +	__dev_printk(kern_level, dev, &vaf);			\
>  								\
>  	va_end(args);						\
> -								\
> -	return r;						\
>  }								\
>  EXPORT_SYMBOL(func);
>  
> diff --git a/include/linux/device.h b/include/linux/device.h
> index fb50673..3c17713 100644
> --- a/include/linux/device.h
> +++ b/include/linux/device.h
> @@ -1038,22 +1038,22 @@ extern __printf(3, 4)
>  int dev_printk_emit(int level, const struct device *dev, const char *fmt, ...);
>  
>  extern __printf(3, 4)
> -int dev_printk(const char *level, const struct device *dev,
> -	       const char *fmt, ...);
> +void dev_printk(const char *level, const struct device *dev,
> +		const char *fmt, ...);
>  extern __printf(2, 3)
> -int dev_emerg(const struct device *dev, const char *fmt, ...);
> +void dev_emerg(const struct device *dev, const char *fmt, ...);
>  extern __printf(2, 3)
> -int dev_alert(const struct device *dev, const char *fmt, ...);
> +void dev_alert(const struct device *dev, const char *fmt, ...);
>  extern __printf(2, 3)
> -int dev_crit(const struct device *dev, const char *fmt, ...);
> +void dev_crit(const struct device *dev, const char *fmt, ...);
>  extern __printf(2, 3)
> -int dev_err(const struct device *dev, const char *fmt, ...);
> +void dev_err(const struct device *dev, const char *fmt, ...);
>  extern __printf(2, 3)
> -int dev_warn(const struct device *dev, const char *fmt, ...);
> +void dev_warn(const struct device *dev, const char *fmt, ...);
>  extern __printf(2, 3)
> -int dev_notice(const struct device *dev, const char *fmt, ...);
> +void dev_notice(const struct device *dev, const char *fmt, ...);
>  extern __printf(2, 3)
> -int _dev_info(const struct device *dev, const char *fmt, ...);
> +void _dev_info(const struct device *dev, const char *fmt, ...);
>  
>  #else
>  
> @@ -1065,35 +1065,35 @@ static inline __printf(3, 4)
>  int dev_printk_emit(int level, const struct device *dev, const char *fmt, ...)
>  { return 0; }
>  
> -static inline int __dev_printk(const char *level, const struct device *dev,
> -			       struct va_format *vaf)
> -{ return 0; }
> +static inline void __dev_printk(const char *level, const struct device *dev,
> +				struct va_format *vaf)
> +{}
>  static inline __printf(3, 4)
> -int dev_printk(const char *level, const struct device *dev,
> -	       const char *fmt, ...)
> -{ return 0; }
> +void dev_printk(const char *level, const struct device *dev,
> +		const char *fmt, ...)
> +{}
>  
>  static inline __printf(2, 3)
> -int dev_emerg(const struct device *dev, const char *fmt, ...)
> -{ return 0; }
> +void dev_emerg(const struct device *dev, const char *fmt, ...)
> +{}
>  static inline __printf(2, 3)
> -int dev_crit(const struct device *dev, const char *fmt, ...)
> -{ return 0; }
> +void dev_crit(const struct device *dev, const char *fmt, ...)
> +{}
>  static inline __printf(2, 3)
> -int dev_alert(const struct device *dev, const char *fmt, ...)
> -{ return 0; }
> +void dev_alert(const struct device *dev, const char *fmt, ...)
> +{}
>  static inline __printf(2, 3)
> -int dev_err(const struct device *dev, const char *fmt, ...)
> -{ return 0; }
> +void dev_err(const struct device *dev, const char *fmt, ...)
> +{}
>  static inline __printf(2, 3)
> -int dev_warn(const struct device *dev, const char *fmt, ...)
> -{ return 0; }
> +void dev_warn(const struct device *dev, const char *fmt, ...)
> +{}
>  static inline __printf(2, 3)
> -int dev_notice(const struct device *dev, const char *fmt, ...)
> -{ return 0; }
> +void dev_notice(const struct device *dev, const char *fmt, ...)
> +{}
>  static inline __printf(2, 3)
> -int _dev_info(const struct device *dev, const char *fmt, ...)
> -{ return 0; }
> +void _dev_info(const struct device *dev, const char *fmt, ...)
> +{}
>  
>  #endif
>  
> @@ -1119,7 +1119,6 @@ do {						     \
>  ({								\
>  	if (0)							\
>  		dev_printk(KERN_DEBUG, dev, format, ##arg);	\
> -	0;							\
>  })
>  #endif
>  
> @@ -1215,7 +1214,6 @@ do {									\
>  ({								\
>  	if (0)							\
>  		dev_printk(KERN_DEBUG, dev, format, ##arg);	\
> -	0;							\
>  })
>  #endif
>  
> 



