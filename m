Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752019AbaA3A6t (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Jan 2014 19:58:49 -0500
Received: from mx1.redhat.com ([209.132.183.28]:37977 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751166AbaA3A6s (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Jan 2014 19:58:48 -0500
Date: Wed, 29 Jan 2014 19:58:36 -0500 (EST)
From: Mikulas Patocka <mpatocka@redhat.com>
X-X-Sender: mpatocka@file01.intranet.prod.int.rdu2.redhat.com
To: Sebastian Capella <sebastian.capella@linaro.org>
cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org, linux-pm@vger.kernel.org,
        linaro-kernel@lists.linaro.org, patches@linaro.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Michel Lespinasse <walken@google.com>, Shaohua Li <shli@kernel.org>,
        Jerome Marchand <jmarchan@redhat.com>,
        Joonsoo Kim <iamjoonsoo.kim@lge.com>
Subject: Re: [PATCH v4 1/2] mm: add kstrimdup function
In-Reply-To: <1391039304-3172-2-git-send-email-sebastian.capella@linaro.org>
Message-ID: <alpine.LRH.2.02.1401291956510.8304@file01.intranet.prod.int.rdu2.redhat.com>
References: <1391039304-3172-1-git-send-email-sebastian.capella@linaro.org> <1391039304-3172-2-git-send-email-sebastian.capella@linaro.org>
User-Agent: Alpine 2.02 (LRH 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Wed, 29 Jan 2014, Sebastian Capella wrote:

> kstrimdup will duplicate and trim spaces from the passed in
> null terminated string.  This is useful for strings coming from
> sysfs that often include trailing whitespace due to user input.
> 
> Signed-off-by: Sebastian Capella <sebastian.capella@linaro.org>
> Cc: Andrew Morton <akpm@linux-foundation.org>
> Cc: Rik van Riel <riel@redhat.com> (commit_signer:5/10=50%)
> Cc: Michel Lespinasse <walken@google.com>
> Cc: Shaohua Li <shli@kernel.org>
> Cc: Jerome Marchand <jmarchan@redhat.com>
> Cc: Mikulas Patocka <mpatocka@redhat.com>
> Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
> ---
>  include/linux/string.h |    1 +
>  mm/util.c              |   19 +++++++++++++++++++
>  2 files changed, 20 insertions(+)
> 
> diff --git a/include/linux/string.h b/include/linux/string.h
> index ac889c5..f29f9a0 100644
> --- a/include/linux/string.h
> +++ b/include/linux/string.h
> @@ -114,6 +114,7 @@ void *memchr_inv(const void *s, int c, size_t n);
>  
>  extern char *kstrdup(const char *s, gfp_t gfp);
>  extern char *kstrndup(const char *s, size_t len, gfp_t gfp);
> +extern char *kstrimdup(const char *s, gfp_t gfp);
>  extern void *kmemdup(const void *src, size_t len, gfp_t gfp);
>  
>  extern char **argv_split(gfp_t gfp, const char *str, int *argcp);
> diff --git a/mm/util.c b/mm/util.c
> index a24aa22..da17de5 100644
> --- a/mm/util.c
> +++ b/mm/util.c
> @@ -63,6 +63,25 @@ char *kstrndup(const char *s, size_t max, gfp_t gfp)
>  EXPORT_SYMBOL(kstrndup);
>  
>  /**
> + * kstrimdup - Trim and copy a %NUL terminated string.
> + * @s: the string to trim and duplicate
> + * @gfp: the GFP mask used in the kmalloc() call when allocating memory
> + *
> + * Returns an address, which the caller must kfree, containing
> + * a duplicate of the passed string with leading and/or trailing
> + * whitespace (as defined by isspace) removed.

It doesn't remove leading whitespace. To remove them, you need to do

char *p = strim(ret);
memmove(ret, p, strlen(p) + 1);

Mikulas

> + */
> +char *kstrimdup(const char *s, gfp_t gfp)
> +{
> +	char *ret = kstrdup(skip_spaces(s), gfp);
> +
> +	if (ret)
> +		strim(ret);
> +	return ret;
> +}
> +EXPORT_SYMBOL(kstrimdup);
> +
> +/**
>   * kmemdup - duplicate region of memory
>   *
>   * @src: memory region to duplicate
> -- 
> 1.7.9.5
> 
