Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758094Ab3ANSnN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jan 2013 13:43:13 -0500
Received: from cantor2.suse.de ([195.135.220.15]:40743 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758031Ab3ANSnL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jan 2013 13:43:11 -0500
Date: Mon, 14 Jan 2013 19:43:08 +0100
From: Michal Hocko <mhocko@suse.cz>
To: Lin Feng <linfeng@cn.fujitsu.com>
Cc: akpm@linux-foundation.org, linux-mm@kvack.org, wency@cn.fujitsu.com,
        jiang.liu@huawei.com, laijs@cn.fujitsu.com,
        isimatu.yasuaki@jp.fujitsu.com, linux-kernel@vger.kernel.org,
        tangchen@cn.fujitsu.com
Subject: Re: [PATCH] memory-hotplug: revert register_page_bootmem_info_node()
 to empty when platform related code is not implemented
Message-ID: <20130114184308.GD5126@dhcp22.suse.cz>
References: <1358160835-30617-1-git-send-email-linfeng@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1358160835-30617-1-git-send-email-linfeng@cn.fujitsu.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon 14-01-13 18:53:55, Lin Feng wrote:
> Memory-hotplug codes for x86_64 have been implemented by patchset:
> https://lkml.org/lkml/2013/1/9/124
> While other platforms haven't been completely implemented yet.
> 
> If we enable both CONFIG_MEMORY_HOTPLUG_SPARSE and CONFIG_SPARSEMEM_VMEMMAP,
> register_page_bootmem_info_node() may be buggy, which is a hotplug generic
> function but falling back to call platform related function
> register_page_bootmem_memmap().
> 
> Other platforms such as powerpc it's not implemented, so on such platforms,
> revert them as empty as they were before.
> 
> Reported-by: Michal Hocko <mhocko@suse.cz>
> Signed-off-by: Lin Feng <linfeng@cn.fujitsu.com>
> ---
>  mm/memory_hotplug.c |    9 +++++++++
>  1 files changed, 9 insertions(+), 0 deletions(-)
> 
> diff --git a/mm/memory_hotplug.c b/mm/memory_hotplug.c
> index 8aa2b56..bd93c2e 100644
> --- a/mm/memory_hotplug.c
> +++ b/mm/memory_hotplug.c
> @@ -189,6 +189,7 @@ static void register_page_bootmem_info_section(unsigned long start_pfn)
>  }
>  #endif
>  
> +#ifdef CONFIG_X86_64
>  void register_page_bootmem_info_node(struct pglist_data *pgdat)
>  {
>  	unsigned long i, pfn, end_pfn, nr_pages;
> @@ -230,6 +231,14 @@ void register_page_bootmem_info_node(struct pglist_data *pgdat)
>  			register_page_bootmem_info_section(pfn);
>  	}
>  }
> +#else
> +static inline void register_page_bootmem_info_node(struct pglist_data *pgdat)
> +{
> +	/*
> +	 * Todo: platforms other than X86_64 haven't been implemented yet.
> +	 */
> +}
> +#endif

This is just ugly. Could you please add something like HAVE_BOOTMEM_INFO_NODE
or something with a bettern name and let CONFIG_MEMORY_HOTPLUG select it
for supported architectures and configurations (e.g.
CONFIG_SPARSEMEM_VMEMMAP doesn't need a special arch support, right?).
These Todo things are just too messy.
-- 
Michal Hocko
SUSE Labs
