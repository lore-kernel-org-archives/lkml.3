Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754104AbaAaKby (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Jan 2014 05:31:54 -0500
Received: from mail-pd0-f180.google.com ([209.85.192.180]:54771 "EHLO
	mail-pd0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753504AbaAaKbv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Jan 2014 05:31:51 -0500
Date: Fri, 31 Jan 2014 02:31:48 -0800 (PST)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Sebastian Capella <sebastian.capella@linaro.org>
cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org, linux-pm@vger.kernel.org,
        linaro-kernel@lists.linaro.org, patches@linaro.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Joe Perches <joe@perches.com>, Mikulas Patocka <mpatocka@redhat.com>,
        Michel Lespinasse <walken@google.com>, Shaohua Li <shli@kernel.org>,
        Jerome Marchand <jmarchan@redhat.com>,
        Joonsoo Kim <iamjoonsoo.kim@lge.com>
Subject: Re: [PATCH v6 1/2] mm: add kstrimdup function
In-Reply-To: <1391129654-12854-2-git-send-email-sebastian.capella@linaro.org>
Message-ID: <alpine.DEB.2.02.1401310230310.7183@chino.kir.corp.google.com>
References: <1391129654-12854-1-git-send-email-sebastian.capella@linaro.org> <1391129654-12854-2-git-send-email-sebastian.capella@linaro.org>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 30 Jan 2014, Sebastian Capella wrote:

> kstrimdup creates a whitespace-trimmed duplicate of the passed
> in null-terminated string.  This is useful for strings coming
> from sysfs that often include trailing whitespace due to user
> input.
> 
> Thanks to Joe Perches for this implementation.
> 
> Signed-off-by: Sebastian Capella <sebastian.capella@linaro.org>

Acked-by: David Rientjes <rientjes@google.com>

> ---
>  include/linux/string.h |    1 +
>  mm/util.c              |   30 ++++++++++++++++++++++++++++++
>  2 files changed, 31 insertions(+)
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
> index 808f375..a8b731c 100644
> --- a/mm/util.c
> +++ b/mm/util.c
> @@ -1,6 +1,7 @@
>  #include <linux/mm.h>
>  #include <linux/slab.h>
>  #include <linux/string.h>
> +#include <linux/ctype.h>
>  #include <linux/export.h>
>  #include <linux/err.h>
>  #include <linux/sched.h>
> @@ -63,6 +64,35 @@ char *kstrndup(const char *s, size_t max, gfp_t gfp)
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
> + */
> +char *kstrimdup(const char *s, gfp_t gfp)
> +{
> +	char *buf;
> +	char *begin = skip_spaces(s);

This could be const.

> +	size_t len = strlen(begin);
> +
> +	while (len && isspace(begin[len - 1]))
> +		len--;
> +
> +	buf = kmalloc_track_caller(len + 1, gfp);
> +	if (!buf)
> +		return NULL;
> +
> +	memcpy(buf, begin, len);
> +	buf[len] = '\0';
> +
> +	return buf;
> +}
> +EXPORT_SYMBOL(kstrimdup);
> +
> +/**
>   * kmemdup - duplicate region of memory
>   *
>   * @src: memory region to duplicate
