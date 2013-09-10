Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752574Ab3IJDcR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Sep 2013 23:32:17 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:57729 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751210Ab3IJDcQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Sep 2013 23:32:16 -0400
X-SecurityPolicyCheck: OK by SHieldMailChecker v2.0.1
X-SHieldMailCheckerPolicyVersion: FJ-ISEC-20120718-3
Message-ID: <522E92A0.80502@jp.fujitsu.com>
Date: Tue, 10 Sep 2013 12:31:44 +0900
From: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:17.0) Gecko/20130801 Thunderbird/17.0.8
MIME-Version: 1.0
To: Toshi Kani <toshi.kani@hp.com>
CC: <akpm@linux-foundation.org>, <linux-mm@kvack.org>,
        <linux-kernel@vger.kernel.org>, <rjw@sisk.pl>,
        <kosaki.motohiro@jp.fujitsu.com>, <kamezawa.hiroyu@jp.fujitsu.com>
Subject: Re: [PATCH] cpu/mem hotplug: Add try_online_node() for cpu_up()
References: <1378772671-27280-1-git-send-email-toshi.kani@hp.com>
In-Reply-To: <1378772671-27280-1-git-send-email-toshi.kani@hp.com>
Content-Type: text/plain; charset="ISO-2022-JP"
Content-Transfer-Encoding: 7bit
X-SecurityPolicyCheck-GC: OK by FENCE-Mail
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2013/09/10 9:24), Toshi Kani wrote:
> cpu_up() has #ifdef CONFIG_MEMORY_HOTPLUG code blocks, which
> call mem_online_node() to put its node online if offlined and
> then call build_all_zonelists() to initialize the zone list.
> These steps are specific to memory hotplug, and should be
> managed in mm/memory_hotplug.c.  lock_memory_hotplug() should
> also be held for the whole steps.
> 
> For this reason, this patch replaces mem_online_node() with
> try_online_node(), which performs the whole steps with
> lock_memory_hotplug() held.  try_online_node() is named after
> try_offline_node() as they have similar purpose.
> 
> There is no functional change in this patch.
> 
> Signed-off-by: Toshi Kani <toshi.kani@hp.com>
> ---
>   include/linux/memory_hotplug.h |    8 +++++++-
>   kernel/cpu.c                   |   29 +++--------------------------
>   mm/memory_hotplug.c            |   15 +++++++++++++--
>   3 files changed, 23 insertions(+), 29 deletions(-)
> 
> diff --git a/include/linux/memory_hotplug.h b/include/linux/memory_hotplug.h
> index dd38e62..22203c2 100644
> --- a/include/linux/memory_hotplug.h
> +++ b/include/linux/memory_hotplug.h
> @@ -94,6 +94,8 @@ extern void __online_page_set_limits(struct page *page);
>   extern void __online_page_increment_counters(struct page *page);
>   extern void __online_page_free(struct page *page);
>   
> +extern int try_online_node(int nid);
> +
>   #ifdef CONFIG_MEMORY_HOTREMOVE
>   extern bool is_pageblock_removable_nolock(struct page *page);
>   extern int arch_remove_memory(u64 start, u64 size);
> @@ -225,6 +227,11 @@ static inline void register_page_bootmem_info_node(struct pglist_data *pgdat)
>   {
>   }
>   
> +static inline int try_online_node(int nid)
> +{
> +	return 0;
> +}
> +
>   static inline void lock_memory_hotplug(void) {}
>   static inline void unlock_memory_hotplug(void) {}
>   
> @@ -256,7 +263,6 @@ static inline void remove_memory(int nid, u64 start, u64 size) {}
>   
>   extern int walk_memory_range(unsigned long start_pfn, unsigned long end_pfn,
>   		void *arg, int (*func)(struct memory_block *, void *));
> -extern int mem_online_node(int nid);
>   extern int add_memory(int nid, u64 start, u64 size);
>   extern int arch_add_memory(int nid, u64 start, u64 size);
>   extern int offline_pages(unsigned long start_pfn, unsigned long nr_pages);
> diff --git a/kernel/cpu.c b/kernel/cpu.c
> index d7f07a2..c10b285 100644
> --- a/kernel/cpu.c
> +++ b/kernel/cpu.c
> @@ -420,11 +420,6 @@ int cpu_up(unsigned int cpu)
>   {
>   	int err = 0;
>   
> -#ifdef	CONFIG_MEMORY_HOTPLUG
> -	int nid;
> -	pg_data_t	*pgdat;
> -#endif
> -
>   	if (!cpu_possible(cpu)) {
>   		printk(KERN_ERR "can't online cpu %d because it is not "
>   			"configured as may-hotadd at boot time\n", cpu);
> @@ -435,27 +430,9 @@ int cpu_up(unsigned int cpu)
>   		return -EINVAL;
>   	}
>   
> -#ifdef	CONFIG_MEMORY_HOTPLUG
> -	nid = cpu_to_node(cpu);
> -	if (!node_online(nid)) {
> -		err = mem_online_node(nid);
> -		if (err)
> -			return err;
> -	}
> -
> -	pgdat = NODE_DATA(nid);
> -	if (!pgdat) {

> -		printk(KERN_ERR
> -			"Can't online cpu %d due to NULL pgdat\n", cpu);

Please move this comments into try_online_node() too.

Thanks,
Yasuaki Ishimatsu

> -		return -ENOMEM;
> -	}
> -
> -	if (pgdat->node_zonelists->_zonerefs->zone == NULL) {
> -		mutex_lock(&zonelists_mutex);
> -		build_all_zonelists(NULL, NULL);
> -		mutex_unlock(&zonelists_mutex);
> -	}
> -#endif
> +	err = try_online_node(cpu_to_node(cpu));
> +	if (err)
> +		return err;
>   
>   	cpu_maps_update_begin();
>   
> diff --git a/mm/memory_hotplug.c b/mm/memory_hotplug.c
> index ed85fe3..c326bdf 100644
> --- a/mm/memory_hotplug.c
> +++ b/mm/memory_hotplug.c
> @@ -1044,14 +1044,19 @@ static void rollback_node_hotadd(int nid, pg_data_t *pgdat)
>   }
>   
>   
> -/*
> +/**
> + * try_online_node - online a node if offlined
> + *
>    * called by cpu_up() to online a node without onlined memory.
>    */
> -int mem_online_node(int nid)
> +int try_online_node(int nid)
>   {
>   	pg_data_t	*pgdat;
>   	int	ret;
>   
> +	if (node_online(nid))
> +		return 0;
> +
>   	lock_memory_hotplug();
>   	pgdat = hotadd_new_pgdat(nid, 0);
>   	if (!pgdat) {
> @@ -1062,6 +1067,12 @@ int mem_online_node(int nid)
>   	ret = register_one_node(nid);
>   	BUG_ON(ret);
>   
> +	if (pgdat->node_zonelists->_zonerefs->zone == NULL) {
> +		mutex_lock(&zonelists_mutex);
> +		build_all_zonelists(NULL, NULL);
> +		mutex_unlock(&zonelists_mutex);
> +	}
> +
>   out:
>   	unlock_memory_hotplug();
>   	return ret;
> 
> --
> To unsubscribe, send a message with 'unsubscribe linux-mm' in
> the body to majordomo@kvack.org.  For more info on Linux MM,
> see: http://www.linux-mm.org/ .
> Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
> 


