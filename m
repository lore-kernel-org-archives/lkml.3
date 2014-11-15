Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755271AbaKOCCR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Nov 2014 21:02:17 -0500
Received: from mail-pa0-f43.google.com ([209.85.220.43]:53832 "EHLO
	mail-pa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754812AbaKOCCQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Nov 2014 21:02:16 -0500
Message-ID: <5466B421.7070801@gmail.com>
Date: Fri, 14 Nov 2014 18:02:09 -0800
From: Florian Fainelli <f.fainelli@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
CC: dan.j.williams@intel.com, akpm@linux-foundation.org, jkosina@suse.cz,
        horia.geanta@freescale.com, computersforpeace@gmail.com
Subject: Re: [PATCH 2/2] dma-debug: prevent early callers from crashing
References: <1415939462-28174-1-git-send-email-f.fainelli@gmail.com> <1415939462-28174-3-git-send-email-f.fainelli@gmail.com>
In-Reply-To: <1415939462-28174-3-git-send-email-f.fainelli@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/13/2014 08:31 PM, Florian Fainelli wrote:
> dma_debug_init() is called by architecture specific code at different
> levels, but typically as a fs_initcall due to the debugfs
> initialization. Some platforms may have early callers of the DMA-API,
> running prior to the fs_initcall() level, which is not much of an issue
> unless CONFIG_DMA_API_DEBUG is set. Whe the DMA-API debugging facilities
> are turned on a caller will go through:
> 
> debug_dma_map_{single,page}
> 	-> dma_mapping_error (inline function usually)
> 		-> debug_dma_mapping_error
> 			-> get_hash_bucket
> 
> Calling get_hash_bucket() returns a valid hash value since we hash on
> high bits of the dma_addr cookie, but we will grab an unitialized
> spinlock, which typically won't crash but produce a warning, the real
> crash will however happen during the bucket list traversal because the
> list has not been initialized yet.
> 
> An obvious solution is of course to move some of the offenders to run
> after the fs_initcall level, but since this might not always be an
> option, we add a flag "dma_debug_initialized" which is set to false by
> default, and set to true once dma_debug_init() has had a chance to run.
> 
> The dma_debug_disabled() helper function previously introduced just
> needs to check for dma_debug_initialized to allow the caller to proceed
> or not.

BTW, one approach I initially took was to add an "initialized" flag to
the hash bucket structure that would be set to false by default, set to
true once we have initialized the array in dma_debug_init(). The problem
with that is that debug_dma_mapping_error() returns void, so we can't
propagate an error back to the caller: debug_dma_map_page().

debug_dma_map_page() then proceeds with creating a new entry, but since
we still have not initialized everything, in particular the free_entries
list is empty, and this triggers a fatal error that leads to setting
global_disable, not ideal, hence this approach.

> 
> Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
> ---
>  lib/dma-debug.c | 12 ++++++++++--
>  1 file changed, 10 insertions(+), 2 deletions(-)
> 
> diff --git a/lib/dma-debug.c b/lib/dma-debug.c
> index 1ac35dbaf8e0..9722bd2dbc9b 100644
> --- a/lib/dma-debug.c
> +++ b/lib/dma-debug.c
> @@ -102,9 +102,12 @@ static DEFINE_SPINLOCK(free_entries_lock);
>  /* Global disable flag - will be set in case of an error */
>  static u32 global_disable __read_mostly;
>  
> +/* Early initialization disable flag, set at the end of dma_debug_init */
> +static bool dma_debug_initialized __read_mostly;
> +
>  static inline bool dma_debug_disabled(void)
>  {
> -	return global_disable;
> +	return global_disable || !dma_debug_initialized;
>  }
>  
>  /* Global error count */
> @@ -999,7 +1002,10 @@ void dma_debug_init(u32 num_entries)
>  {
>  	int i;
>  
> -	if (dma_debug_disabled())
> +	/* Do not use dma_debug_initialized here, since we really want to be
> +	 * called to set dma_debug_initialized
> +	 */
> +	if (global_disable)
>  		return;
>  
>  	for (i = 0; i < HASH_SIZE; ++i) {
> @@ -1026,6 +1032,8 @@ void dma_debug_init(u32 num_entries)
>  
>  	nr_total_entries = num_free_entries;
>  
> +	dma_debug_initialized = true;
> +
>  	pr_info("DMA-API: debugging enabled by kernel config\n");
>  }
>  
> 

