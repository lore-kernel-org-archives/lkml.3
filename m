Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932664AbaBEU3e (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Feb 2014 15:29:34 -0500
Received: from mail-pd0-f169.google.com ([209.85.192.169]:57211 "EHLO
	mail-pd0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751951AbaBEU33 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Feb 2014 15:29:29 -0500
Date: Wed, 5 Feb 2014 12:29:27 -0800 (PST)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Nathan Zimmer <nzimmer@sgi.com>
cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Tang Chen <tangchen@cn.fujitsu.com>,
        Wen Congyang <wency@cn.fujitsu.com>, Toshi Kani <toshi.kani@hp.com>,
        Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>,
        Xishi Qiu <qiuxishi@huawei.com>,
        Cody P Schafer <cody@linux.vnet.ibm.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Jiang Liu <liuj97@gmail.com>, Hedi Berriche <hedi@sgi.com>,
        Mike Travis <travis@sgi.com>
Subject: Re: [RFC] Move the memory_notifier out of the memory_hotplug lock
In-Reply-To: <1391617743-150518-1-git-send-email-nzimmer@sgi.com>
Message-ID: <alpine.DEB.2.02.1402051217520.5616@chino.kir.corp.google.com>
References: <1391617743-150518-1-git-send-email-nzimmer@sgi.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 5 Feb 2014, Nathan Zimmer wrote:

> diff --git a/mm/memory_hotplug.c b/mm/memory_hotplug.c
> index 62a0cd1..a3cbd14 100644
> --- a/mm/memory_hotplug.c
> +++ b/mm/memory_hotplug.c
> @@ -985,12 +985,12 @@ int __ref online_pages(unsigned long pfn, unsigned long nr_pages, int online_typ
>  		if (need_zonelists_rebuild)
>  			zone_pcp_reset(zone);
>  		mutex_unlock(&zonelists_mutex);
> +		unlock_memory_hotplug();
>  		printk(KERN_DEBUG "online_pages [mem %#010llx-%#010llx] failed\n",
>  		       (unsigned long long) pfn << PAGE_SHIFT,
>  		       (((unsigned long long) pfn + nr_pages)
>  			    << PAGE_SHIFT) - 1);
>  		memory_notify(MEM_CANCEL_ONLINE, &arg);
> -		unlock_memory_hotplug();
>  		return ret;
>  	}
>  
> @@ -1016,9 +1016,10 @@ int __ref online_pages(unsigned long pfn, unsigned long nr_pages, int online_typ
>  
>  	writeback_set_ratelimit();
>  
> +	unlock_memory_hotplug();
> +
>  	if (onlined_pages)
>  		memory_notify(MEM_ONLINE, &arg);
> -	unlock_memory_hotplug();
>  
>  	return 0;
>  }

That looks a little problematic, what happens if a nid is being brought 
online and a registered callback does something like allocate resources 
for the arg->status_change_nid and the above two hunks of this patch end 
up racing?

Before, a registered callback would be guaranteed to see either a 
MEMORY_CANCEL_ONLINE or MEMORY_ONLINE after it has already done 
MEMORY_GOING_ONLINE.

With your patch, we could race and see one cpu doing MEMORY_GOING_ONLINE, 
another cpu doing MEMORY_GOING_ONLINE, and then MEMORY_ONLINE and 
MEMORY_CANCEL_ONLINE in either order.

So I think this patch will break most registered callbacks that actually 
depend on lock_memory_hotplug(), it's a coarse lock for that reason.
