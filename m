Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756049Ab3GWJRK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jul 2013 05:17:10 -0400
Received: from aserp1040.oracle.com ([141.146.126.69]:23819 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752241Ab3GWJRI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jul 2013 05:17:08 -0400
Message-ID: <51EE49D7.4060501@oracle.com>
Date: Tue, 23 Jul 2013 17:16:07 +0800
From: Bob Liu <bob.liu@oracle.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130221 Thunderbird/17.0.3
MIME-Version: 1.0
To: Seth Jennings <sjenning@linux.vnet.ibm.com>
CC: Andrew Morton <akpm@linux-foundation.org>, Dave Hansen <dave@sr71.net>,
        Bob Liu <lliubbo@gmail.com>, Minchan Kim <minchan@kernel.org>,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mm: zswap: add runtime enable/disable
References: <1374521642-25478-1-git-send-email-sjenning@linux.vnet.ibm.com>
In-Reply-To: <1374521642-25478-1-git-send-email-sjenning@linux.vnet.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/23/2013 03:34 AM, Seth Jennings wrote:
> Right now, zswap can only be enabled at boot time.  This patch
> modifies zswap so that it can be dynamically enabled or disabled
> at runtime.
> 
> In order to allow this ability, zswap unconditionally registers as a
> frontswap backend regardless of whether or not zswap.enabled=1 is passed
> in the boot parameters or not.  This introduces a very small overhead
> for systems that have zswap disabled as calls to frontswap_store() will
> call zswap_frontswap_store(), but there is a fast path to immediately
> return if zswap is disabled.

There is also overhead in frontswap_load() after all pages are faulted
back into memory.

> 
> Disabling zswap does not unregister zswap from frontswap.  It simply
> blocks all future stores.
> 
> Signed-off-by: Seth Jennings <sjenning@linux.vnet.ibm.com>
> ---
>  Documentation/vm/zswap.txt | 18 ++++++++++++++++--
>  mm/zswap.c                 |  9 +++------
>  2 files changed, 19 insertions(+), 8 deletions(-)
> 
> diff --git a/Documentation/vm/zswap.txt b/Documentation/vm/zswap.txt
> index 7e492d8..d588477 100644
> --- a/Documentation/vm/zswap.txt
> +++ b/Documentation/vm/zswap.txt
> @@ -26,8 +26,22 @@ Zswap evicts pages from compressed cache on an LRU basis to the backing swap
>  device when the compressed pool reaches it size limit.  This requirement had
>  been identified in prior community discussions.
>  
> -To enabled zswap, the "enabled" attribute must be set to 1 at boot time.  e.g.
> -zswap.enabled=1
> +Zswap is disabled by default but can be enabled at boot time by setting
> +the "enabled" attribute to 1 at boot time. e.g. zswap.enabled=1.  Zswap
> +can also be enabled and disabled at runtime using the sysfs interface.
> +An exmaple command to enable zswap at runtime, assuming sysfs is mounted
> +at /sys, is:
> +
> +echo 1 > /sys/modules/zswap/parameters/enabled
> +
> +When zswap is disabled at runtime, it will stop storing pages that are
> +being swapped out.  However, it will _not_ immediately write out or
> +fault back into memory all of the pages stored in the compressed pool.

I don't know what's you use case of adding this feature.
In my opinion I'd perfer to flush all the pages stored in zswap when
disabled it, so that I can run testing without rebooting the machine.

> +The pages stored in zswap will continue to remain in the compressed pool
> +until they are either invalidated or faulted back into memory.  In order
> +to force all pages out of the compressed pool, a swapoff on the swap
> +device(s) will fault all swapped out pages, included those in the
> +compressed pool, back into memory.
>  
>  Design:
>  
> diff --git a/mm/zswap.c b/mm/zswap.c
> index deda2b6..199b1b0 100644
> --- a/mm/zswap.c
> +++ b/mm/zswap.c
> @@ -75,9 +75,9 @@ static u64 zswap_duplicate_entry;
>  /*********************************
>  * tunables
>  **********************************/
> -/* Enable/disable zswap (disabled by default, fixed at boot for now) */
> +/* Enable/disable zswap (disabled by default) */
>  static bool zswap_enabled __read_mostly;
> -module_param_named(enabled, zswap_enabled, bool, 0);
> +module_param_named(enabled, zswap_enabled, bool, 0644);
>  
>  /* Compressor to be used by zswap (fixed at boot for now) */
>  #define ZSWAP_COMPRESSOR_DEFAULT "lzo"
> @@ -612,7 +612,7 @@ static int zswap_frontswap_store(unsigned type, pgoff_t offset,
>  	u8 *src, *dst;
>  	struct zswap_header *zhdr;
>  
> -	if (!tree) {
> +	if (!zswap_enabled || !tree) {
>  		ret = -ENODEV;
>  		goto reject;
>  	}
> @@ -908,9 +908,6 @@ static void __exit zswap_debugfs_exit(void) { }
>  **********************************/
>  static int __init init_zswap(void)
>  {
> -	if (!zswap_enabled)
> -		return 0;
> -
>  	pr_info("loading zswap\n");
>  	if (zswap_entry_cache_create()) {
>  		pr_err("entry cache creation failed\n");
> 

-- 
Regards,
-Bob
