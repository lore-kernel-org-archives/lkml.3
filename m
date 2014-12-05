Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751342AbaLEGWa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Dec 2014 01:22:30 -0500
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:42547 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750909AbaLEGW3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Dec 2014 01:22:29 -0500
X-SecurityPolicyCheck: OK by SHieldMailChecker v2.0.1
X-SHieldMailCheckerPolicyVersion: FJ-ISEC-20120718-3
Message-ID: <54814EFC.5020904@jp.fujitsu.com>
Date: Fri, 5 Dec 2014 15:21:48 +0900
From: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: "K. Y. Srinivasan" <kys@microsoft.com>
CC: <linux-kernel@vger.kernel.org>, <olaf@aepfle.de>, <apw@canonical.com>,
        <linux-mm@kvack.org>
Subject: Re: [PATCH 1/1] mm: Fix a deadlock in the hotplug code
References: <1417553218-12339-1-git-send-email-kys@microsoft.com>
In-Reply-To: <1417553218-12339-1-git-send-email-kys@microsoft.com>
Content-Type: text/plain; charset="ISO-2022-JP"
Content-Transfer-Encoding: 7bit
X-SecurityPolicyCheck-GC: OK by FENCE-Mail
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2014/12/03 5:46), K. Y. Srinivasan wrote:
> Andy Whitcroft <apw@canonical.com> initially saw this deadlock. We have
> seen this as well. Here is the original description of the problem (and a
> potential solution) from Andy:
> 
> https://lkml.org/lkml/2014/3/14/451
> 
> Here is an excerpt from that mail:
> 
> "We are seeing machines lockup with what appears to be an ABBA deadlock in
> the memory hotplug system.  These are from the 3.13.6 based Ubuntu kernels.
> The hv_balloon driver is adding memory using add_memory() which takes the
> hotplug lock, and then emits a udev event, and then attempts to lock the
> sysfs device.  In response to the udev event udev opens the sysfs device
> and locks it, then attempts to grab the hotplug lock to online the memory.
> This seems to be inverted nesting in the two cases, leading to the hangs below:
> 
> [  240.608612] INFO: task kworker/0:2:861 blocked for more than 120 seconds.
> [  240.608705] INFO: task systemd-udevd:1906 blocked for more than 120 seconds.
> 
> I note that the device hotplug locking allows complete retries (via
> ERESTARTSYS) and if we could detect this at the online stage it
> could be used to get us out.  But before I go down this road I wanted
> to make sure I am reading this right.  Or indeed if the hv_balloon driver
> is just doing this wrong."
> 
> This patch is based on Andy's analysis and suggestion.

How about use lock_device_hotplug() before calling add_memory() in hv_mem_hot_add()?
Commit 0f1cfe9d0d06 (mm/hotplug: remove stop_machine() from try_offline_node()) said:

  ---
    lock_device_hotplug() serializes hotplug & online/offline operations.  The
    lock is held in common sysfs online/offline interfaces and ACPI hotplug
    code paths.

    And here are the code paths:

    - CPU & Mem online/offline via sysfs online
        store_online()->lock_device_hotplug()

    - Mem online via sysfs state:
        store_mem_state()->lock_device_hotplug()

    - ACPI CPU & Mem hot-add:
        acpi_scan_bus_device_check()->lock_device_hotplug()

    - ACPI CPU & Mem hot-delete:
        acpi_scan_hot_remove()->lock_device_hotplug()
  ---

CPU & Memory online/offline/hotplug are serialized by lock_device_hotplug().
So using lock_device_hotplug() solves the ABBA issue.

Thanks,
Yasuaki Ishimatsu

> 
> Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
> ---
>   mm/memory_hotplug.c |   24 +++++++++++++++++-------
>   1 files changed, 17 insertions(+), 7 deletions(-)
> 
> diff --git a/mm/memory_hotplug.c b/mm/memory_hotplug.c
> index 9fab107..e195269 100644
> --- a/mm/memory_hotplug.c
> +++ b/mm/memory_hotplug.c
> @@ -104,19 +104,27 @@ void put_online_mems(void)
>   
>   }
>   
> -static void mem_hotplug_begin(void)
> +static int mem_hotplug_begin(bool trylock)
>   {
>   	mem_hotplug.active_writer = current;
>   
>   	memhp_lock_acquire();
>   	for (;;) {
> -		mutex_lock(&mem_hotplug.lock);
> +		if (trylock) {
> +			if (!mutex_trylock(&mem_hotplug.lock)) {
> +				mem_hotplug.active_writer = NULL;
> +				return -ERESTARTSYS;
> +			}
> +		} else {
> +			mutex_lock(&mem_hotplug.lock);
> +		}
>   		if (likely(!mem_hotplug.refcount))
>   			break;
>   		__set_current_state(TASK_UNINTERRUPTIBLE);
>   		mutex_unlock(&mem_hotplug.lock);
>   		schedule();
>   	}
> +	return 0;
>   }
>   
>   static void mem_hotplug_done(void)
> @@ -969,7 +977,9 @@ int __ref online_pages(unsigned long pfn, unsigned long nr_pages, int online_typ
>   	int ret;
>   	struct memory_notify arg;
>   
> -	mem_hotplug_begin();
> +	ret = mem_hotplug_begin(true);
> +	if (ret)
> +		return ret;
>   	/*
>   	 * This doesn't need a lock to do pfn_to_page().
>   	 * The section can't be removed here because of the
> @@ -1146,7 +1156,7 @@ int try_online_node(int nid)
>   	if (node_online(nid))
>   		return 0;
>   
> -	mem_hotplug_begin();
> +	mem_hotplug_begin(false);
>   	pgdat = hotadd_new_pgdat(nid, 0);
>   	if (!pgdat) {
>   		pr_err("Cannot online node %d due to NULL pgdat\n", nid);
> @@ -1236,7 +1246,7 @@ int __ref add_memory(int nid, u64 start, u64 size)
>   		new_pgdat = !p;
>   	}
>   
> -	mem_hotplug_begin();
> +	mem_hotplug_begin(false);
>   
>   	new_node = !node_online(nid);
>   	if (new_node) {
> @@ -1684,7 +1694,7 @@ static int __ref __offline_pages(unsigned long start_pfn,
>   	if (!test_pages_in_a_zone(start_pfn, end_pfn))
>   		return -EINVAL;
>   
> -	mem_hotplug_begin();
> +	mem_hotplug_begin(false);
>   
>   	zone = page_zone(pfn_to_page(start_pfn));
>   	node = zone_to_nid(zone);
> @@ -2002,7 +2012,7 @@ void __ref remove_memory(int nid, u64 start, u64 size)
>   
>   	BUG_ON(check_hotplug_memory_range(start, size));
>   
> -	mem_hotplug_begin();
> +	mem_hotplug_begin(false);
>   
>   	/*
>   	 * All memory blocks must be offlined before removing memory.  Check
> 


