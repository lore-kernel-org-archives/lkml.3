Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751457AbaCGEIK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Mar 2014 23:08:10 -0500
Received: from e28smtp05.in.ibm.com ([122.248.162.5]:39756 "EHLO
	e28smtp05.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751004AbaCGEII (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Mar 2014 23:08:08 -0500
Message-ID: <531945D1.7010503@linux.vnet.ibm.com>
Date: Fri, 07 Mar 2014 09:36:41 +0530
From: Anshuman Khandual <khandual@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Sudeep Holla <sudeep.holla@arm.com>
CC: linux-kernel@vger.kernel.org,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>, linuxppc-dev@lists.ozlabs.org
Subject: Re: [PATCH RFC/RFT v3 6/9] powerpc: move cacheinfo sysfs to generic
 cacheinfo infrastructure
References: <1392825976-17633-1-git-send-email-sudeep.holla@arm.com> <1392825976-17633-7-git-send-email-sudeep.holla@arm.com>
In-Reply-To: <1392825976-17633-7-git-send-email-sudeep.holla@arm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14030704-8256-0000-0000-00000BD0A53C
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/19/2014 09:36 PM, Sudeep Holla wrote:
> From: Sudeep Holla <sudeep.holla@arm.com>
> 
> This patch removes the redundant sysfs cacheinfo code by making use of
> the newly introduced generic cacheinfo infrastructure.
> 
> Signed-off-by: Sudeep Holla <sudeep.holla@arm.com>
> Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
> Cc: Paul Mackerras <paulus@samba.org>
> Cc: linuxppc-dev@lists.ozlabs.org
> ---
>  arch/powerpc/kernel/cacheinfo.c | 831 ++++++----------------------------------
>  arch/powerpc/kernel/cacheinfo.h |   8 -
>  arch/powerpc/kernel/sysfs.c     |   4 -
>  3 files changed, 109 insertions(+), 734 deletions(-)
>  delete mode 100644 arch/powerpc/kernel/cacheinfo.h
> 
> diff --git a/arch/powerpc/kernel/cacheinfo.c b/arch/powerpc/kernel/cacheinfo.c
> index 2912b87..05b7580 100644
> --- a/arch/powerpc/kernel/cacheinfo.c
> +++ b/arch/powerpc/kernel/cacheinfo.c
> @@ -10,38 +10,10 @@
>   * 2 as published by the Free Software Foundation.
>   */
> 
> +#include <linux/cacheinfo.h>
>  #include <linux/cpu.h>
> -#include <linux/cpumask.h>
>  #include <linux/kernel.h>
> -#include <linux/kobject.h>
> -#include <linux/list.h>
> -#include <linux/notifier.h>
>  #include <linux/of.h>
> -#include <linux/percpu.h>
> -#include <linux/slab.h>
> -#include <asm/prom.h>
> -
> -#include "cacheinfo.h"
> -
> -/* per-cpu object for tracking:
> - * - a "cache" kobject for the top-level directory
> - * - a list of "index" objects representing the cpu's local cache hierarchy
> - */
> -struct cache_dir {
> -	struct kobject *kobj; /* bare (not embedded) kobject for cache
> -			       * directory */
> -	struct cache_index_dir *index; /* list of index objects */
> -};
> -
> -/* "index" object: each cpu's cache directory has an index
> - * subdirectory corresponding to a cache object associated with the
> - * cpu.  This object's lifetime is managed via the embedded kobject.
> - */
> -struct cache_index_dir {
> -	struct kobject kobj;
> -	struct cache_index_dir *next; /* next index in parent directory */
> -	struct cache *cache;
> -};
> 
>  /* Template for determining which OF properties to query for a given
>   * cache type */
> @@ -60,11 +32,6 @@ struct cache_type_info {
>  	const char *nr_sets_prop;
>  };
> 
> -/* These are used to index the cache_type_info array. */
> -#define CACHE_TYPE_UNIFIED     0
> -#define CACHE_TYPE_INSTRUCTION 1
> -#define CACHE_TYPE_DATA        2
> -
>  static const struct cache_type_info cache_type_info[] = {
>  	{
>  		/* PowerPC Processor binding says the [di]-cache-*
> @@ -77,246 +44,115 @@ static const struct cache_type_info cache_type_info[] = {
>  		.nr_sets_prop    = "d-cache-sets",
>  	},
>  	{
> -		.name            = "Instruction",
> -		.size_prop       = "i-cache-size",
> -		.line_size_props = { "i-cache-line-size",
> -				     "i-cache-block-size", },
> -		.nr_sets_prop    = "i-cache-sets",
> -	},
> -	{
>  		.name            = "Data",
>  		.size_prop       = "d-cache-size",
>  		.line_size_props = { "d-cache-line-size",
>  				     "d-cache-block-size", },
>  		.nr_sets_prop    = "d-cache-sets",
>  	},
> +	{
> +		.name            = "Instruction",
> +		.size_prop       = "i-cache-size",
> +		.line_size_props = { "i-cache-line-size",
> +				     "i-cache-block-size", },
> +		.nr_sets_prop    = "i-cache-sets",
> +	},
>  };


Hey Sudeep,

After applying this patch, the cache_type_info array looks like this.

static const struct cache_type_info cache_type_info[] = {
        {
                /* 
                 * PowerPC Processor binding says the [di]-cache-*
                 * must be equal on unified caches, so just use
                 * d-cache properties.
                 */
                .name            = "Unified",
                .size_prop       = "d-cache-size",
                .line_size_props = { "d-cache-line-size",
                                     "d-cache-block-size", },
                .nr_sets_prop    = "d-cache-sets",
        },
        {
                .name            = "Data",
                .size_prop       = "d-cache-size",
                .line_size_props = { "d-cache-line-size",
                                     "d-cache-block-size", },
                .nr_sets_prop    = "d-cache-sets",
        },
        {
                .name            = "Instruction",
                .size_prop       = "i-cache-size",
                .line_size_props = { "i-cache-line-size",
                                     "i-cache-block-size", },
                .nr_sets_prop    = "i-cache-sets",
        },
};

and this function computes the the array index for any given cache type
define for PowerPC.

static inline int get_cacheinfo_idx(enum cache_type type)
{
        if (type == CACHE_TYPE_UNIFIED)
                return 0;
        else
                return type;
}

These types are define in include/linux/cacheinfo.h as

enum cache_type {
        CACHE_TYPE_NOCACHE = 0,
        CACHE_TYPE_INST = BIT(0),		---> 1
        CACHE_TYPE_DATA = BIT(1),		---> 2
        CACHE_TYPE_SEPARATE = CACHE_TYPE_INST | CACHE_TYPE_DATA,
        CACHE_TYPE_UNIFIED = BIT(2),
};

When it is UNIFIED we return index 0, which is correct. But the index
for instruction and data cache seems to be swapped which wrong. This
will fetch invalid properties for any given cache type.

I have done some initial review and testing for this patch's impact on
PowerPC (ppc64 POWER specifically). I am trying to do some code clean-up
and re-arrangements. Will post out soon. Thanks !

Regards
Anshuman



