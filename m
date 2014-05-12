Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756005AbaELMI3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 May 2014 08:08:29 -0400
Received: from e06smtp12.uk.ibm.com ([195.75.94.108]:60364 "EHLO
	e06smtp12.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753381AbaELMI2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 May 2014 08:08:28 -0400
Message-ID: <5370B9B3.4050705@linux.vnet.ibm.com>
Date: Mon, 12 May 2014 14:08:19 +0200
From: Peter Oberparleiter <oberpar@linux.vnet.ibm.com>
MIME-Version: 1.0
To: Yuan Pengfei <coolypf@qq.com>
CC: linux-kernel <linux-kernel@vger.kernel.org>, yuanpf12@sei.pku.edu.cn
Subject: Re: [PATCH] gcov: add support for GCC 4.9
References: <tencent_339F323E15E730DF6D7AC23A@qq.com>
In-Reply-To: <tencent_339F323E15E730DF6D7AC23A@qq.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14051212-8372-0000-0000-000009A2CF0C
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11.05.2014 06:55, Yuan Pengfei wrote:
> From: Yuan Pengfei <coolypf@qq.com>
> 
> This patch handles the gcov-related changes in GCC 4.9:
>   A new counter (time profile) is added.

It appears that this patch contains two independent sets of changes:
1. Updates to gcov-kernel required to work with GCC 4.9
   (#counters + new merge function stub)
2. A bug-fix required when using GCC option -fprofile-values
   which is currently not supported by gcov-kernel
   (see https://lkml.org/lkml/2014/2/19/74)

Please split these changes into separate patches.

Change 1) is definitely useful as without it .gcda file creation will
fail when compiling the kernel with GCC 4.9.

Regarding change 2) I still don't think this is necessary unless:
a) there is a way to trigger the problem without -fprofile-values, or
b) you intend to send an additional patch set that enables
   -fprofile-values profiling for gcov-kernel in which case the fix
   should be part of that patch set.

> See http://gcc.gnu.org/gcc-4.9/changes.html
> Signed-off-by: Yuan Pengfei <coolypf@qq.com>
> ---
>  kernel/gcov/base.c    | 6 ++++++
>  kernel/gcov/gcc_3_4.c | 2 +-
>  kernel/gcov/gcc_4_7.c | 7 ++++++-
>  3 files changed, 13 insertions(+), 2 deletions(-)
> 
> diff --git a/kernel/gcov/base.c b/kernel/gcov/base.c
> index f45b75b..b358a80 100644
> --- a/kernel/gcov/base.c
> +++ b/kernel/gcov/base.c
> @@ -85,6 +85,12 @@ void __gcov_merge_ior(gcov_type *counters, unsigned int n_counters)
>  }
>  EXPORT_SYMBOL(__gcov_merge_ior);
>  
> +void __gcov_merge_time_profile(gcov_type *counters, unsigned int n_counters)
> +{
> +	/* Unused. */
> +}
> +EXPORT_SYMBOL(__gcov_merge_time_profile);
> +
>  /**
>   * gcov_enable_events - enable event reporting through gcov_event()
>   *
> diff --git a/kernel/gcov/gcc_3_4.c b/kernel/gcov/gcc_3_4.c
> index 27bc88a..1c1f425 100644
> --- a/kernel/gcov/gcc_3_4.c
> +++ b/kernel/gcov/gcc_3_4.c
> @@ -269,7 +269,7 @@ struct gcov_info *gcov_info_dup(struct gcov_info *info)
>  		dup->counts[i].num = ctr->num;
>  		dup->counts[i].merge = ctr->merge;
>  		dup->counts[i].values = vmalloc(size);
> -		if (!dup->counts[i].values)
> +		if (size && !dup->counts[i].values)
>  			goto err_free;
>  		memcpy(dup->counts[i].values, ctr->values, size);
>  	}
> diff --git a/kernel/gcov/gcc_4_7.c b/kernel/gcov/gcc_4_7.c
> index 2c6e463..7f74b59 100644
> --- a/kernel/gcov/gcc_4_7.c
> +++ b/kernel/gcov/gcc_4_7.c
> @@ -18,7 +18,12 @@
>  #include <linux/vmalloc.h>
>  #include "gcov.h"
>  
> +#if __GNUC__ == 4 && __GNUC_MINOR__ >= 9
> +#define GCOV_COUNTERS			9
> +#else
>  #define GCOV_COUNTERS			8
> +#endif
> +
>  #define GCOV_TAG_FUNCTION_LENGTH	3
>  
>  static struct gcov_info *gcov_info_head;
> @@ -290,7 +295,7 @@ struct gcov_info *gcov_info_dup(struct gcov_info *info)
>  
>  			dci_ptr->values = vmalloc(cv_size);
>  
> -			if (!dci_ptr->values)
> +			if (cv_size && !dci_ptr->values)
>  				goto err_free;
>  
>  			dci_ptr->num = sci_ptr->num;
> 

-- 
Peter Oberparleiter
Linux on System z Development - IBM Germany

