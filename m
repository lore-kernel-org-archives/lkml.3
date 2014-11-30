Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751892AbaK3E5X (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Nov 2014 23:57:23 -0500
Received: from smtp302.phy.lolipop.jp ([210.157.22.85]:53122 "EHLO
	smtp302.phy.lolipop.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751705AbaK3E5W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Nov 2014 23:57:22 -0500
X-Greylist: delayed 318 seconds by postgrey-1.27 at vger.kernel.org; Sat, 29 Nov 2014 23:57:22 EST
Message-ID: <547AA272.6070308@sakamocchi.jp>
Date: Sun, 30 Nov 2014 13:52:02 +0900
From: Takashi Sakamoto <o-takashi@sakamocchi.jp>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Joe Perches <joe@perches.com>, Takashi Iwai <tiwai@suse.de>
CC: alsa-devel@alsa-project.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] sound: use enum names instead of magic numbers
References: <1417201196-12392-1-git-send-email-KyleChamberlin@project20million.org> <s5h7fydbv6w.wl-tiwai@suse.de> <1417294692.818.3.camel@perches.com>
In-Reply-To: <1417294692.818.3.camel@perches.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2014年11月30日 05:58, Joe Perches wrote:
> There's an enum defined for these magic numbers,
> might as well use it.
> 
> Miscellanea:
> o Use ##__VA_ARGS__
> 
> Signed-off-by: Joe Perches <joe@perches.com>
> ---
>  include/sound/core.h | 28 +++++++++++++++-------------
>  sound/core/misc.c    |  6 +++---
>  2 files changed, 18 insertions(+), 16 deletions(-)

I think it better to split this patch into two parts, one is for
enumeration identifier and another is for variadic macro.

> diff --git a/include/sound/core.h b/include/sound/core.h
> index 1df3f2f..40418e7 100644
> --- a/include/sound/core.h
> +++ b/include/sound/core.h
> @@ -325,7 +325,7 @@ void release_and_free_resource(struct resource *res);
>  /* --- */
>  
>  /* sound printk debug levels */
> -enum {
> +enum snd_level {
>  	SND_PR_ALWAYS,
>  	SND_PR_DEBUG,
>  	SND_PR_VERBOSE,
> @@ -333,11 +333,11 @@ enum {
>  
>  #if defined(CONFIG_SND_DEBUG) || defined(CONFIG_SND_VERBOSE_PRINTK)
>  __printf(4, 5)
> -void __snd_printk(unsigned int level, const char *file, int line,
> +void __snd_printk(enum snd_level snd_level, const char *file, int line,
>  		  const char *format, ...);
>  #else
> -#define __snd_printk(level, file, line, format, args...) \
> -	printk(format, ##args)
> +#define __snd_printk(snd_level, file, line, format, ...) \
> +	printk(format, ##__VA_ARGS__)
>  #endif
>  /**
> @@ -347,8 +347,8 @@ void __snd_printk(unsigned int level, const char *file, int line,
>   * Works like printk() but prints the file and the line of the caller
>   * when configured with CONFIG_SND_VERBOSE_PRINTK.
>   */
> -#define snd_printk(fmt, args...) \
> -	__snd_printk(0, __FILE__, __LINE__, fmt, ##args)
> +#define snd_printk(fmt, ...) \
> +	__snd_printk(SND_PR_ALWAYS, __FILE__, __LINE__, fmt, ##__VA_ARGS__)
>  
>  #ifdef CONFIG_SND_DEBUG
>  /**
> @@ -358,10 +358,10 @@ void __snd_printk(unsigned int level, const char *file, int line,
>   * Works like snd_printk() for debugging purposes.
>   * Ignored when CONFIG_SND_DEBUG is not set.
>   */
> -#define snd_printd(fmt, args...) \
> -	__snd_printk(1, __FILE__, __LINE__, fmt, ##args)
> -#define _snd_printd(level, fmt, args...) \
> -	__snd_printk(level, __FILE__, __LINE__, fmt, ##args)
> +#define snd_printd(fmt, ...) \
> +	__snd_printk(SND_PR_DEBUG, __FILE__, __LINE__, fmt, ##__VA_ARGS__)
> +#define _snd_printd(level, fmt, ...) \
> +	__snd_printk(level, __FILE__, __LINE__, fmt, ##__VA_ARGS__)
>  
>  /**
>   * snd_BUG - give a BUG warning message and stack trace
> @@ -390,7 +390,8 @@ void __snd_printk(unsigned int level, const char *file, int line,
>  __printf(1, 2)
>  static inline void snd_printd(const char *format, ...) {}
>  __printf(2, 3)
> -static inline void _snd_printd(int level, const char *format, ...) {}
> +static inline void _snd_printd(enum snd_level snd_level,
> +			       const char *format, ...) {}
>  
>  #define snd_BUG()			do { } while (0)
>  
> @@ -411,8 +412,9 @@ static inline bool snd_printd_ratelimit(void) { return false; }
>   * Works like snd_printk() for debugging purposes.
>   * Ignored when CONFIG_SND_DEBUG_VERBOSE is not set.
>   */
> -#define snd_printdd(format, args...) \
> -	__snd_printk(2, __FILE__, __LINE__, format, ##args)
> +#define snd_printdd(format, ...)				\
> +	__snd_printk(SND_PR_VERBOSE, __FILE__, __LINE__,	\
> +		     format, ##__VA_ARGS__)
>  #else
>  __printf(1, 2)
>  static inline void snd_printdd(const char *format, ...) {}
> diff --git a/sound/core/misc.c b/sound/core/misc.c
> index f2e8226..03b3f56 100644
> --- a/sound/core/misc.c
> +++ b/sound/core/misc.c
> @@ -63,7 +63,7 @@ static const char *sanity_file_name(const char *path)
>  #endif
>  
>  #if defined(CONFIG_SND_DEBUG) || defined(CONFIG_SND_VERBOSE_PRINTK)
> -void __snd_printk(unsigned int level, const char *path, int line,
> +void __snd_printk(enum snd_level snd_level, const char *path, int line,
>  		  const char *format, ...)
>  {
>  	va_list args;
> @@ -74,7 +74,7 @@ void __snd_printk(unsigned int level, const char *path, int line,
>  #endif
>  
>  #ifdef CONFIG_SND_DEBUG
> -	if (debug < level)
> +	if (debug < snd_level)
>  		return;
>  #endif
>  
> @@ -88,7 +88,7 @@ void __snd_printk(unsigned int level, const char *path, int line,
>  		const char *end_of_header = printk_skip_level(format);
>  		memcpy(verbose_fmt, format, end_of_header - format);
>  		vaf.fmt = end_of_header;
> -	} else if (level)
> +	} else if (snd_level)
>  		memcpy(verbose_fmt, KERN_DEBUG, sizeof(KERN_DEBUG) - 1);
>  	printk(verbose_fmt, sanity_file_name(path), line, &vaf);

There's no need to rename variable names.


Regards

Takashi Sakamoto
o-takashi@sakamocchi.jp

