Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754240AbaFYTly (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jun 2014 15:41:54 -0400
Received: from fujitsu25.fnanic.fujitsu.com ([192.240.6.15]:44992 "EHLO
	fujitsu25.fnanic.fujitsu.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752899AbaFYTlx convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jun 2014 15:41:53 -0400
From: Motohiro Kosaki <Motohiro.Kosaki@us.fujitsu.com>
To: Rafael Aquini <aquini@redhat.com>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>
CC: Andrew Morton <akpm@linux-foundation.org>, Rik van Riel <riel@redhat.com>,
        Mel Gorman <mgorman@suse.de>, Johannes Weiner <hannes@cmpxchg.org>,
        Motohiro Kosaki JP <kosaki.motohiro@jp.fujitsu.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Wed, 25 Jun 2014 12:41:17 -0700
Subject: RE: [PATCH] mm: export NR_SHMEM via sysinfo(2) / si_meminfo()
 interfaces
Thread-Topic: [PATCH] mm: export NR_SHMEM via sysinfo(2) / si_meminfo()
 interfaces
Thread-Index: Ac+QpPZIB3FMYlBhQmm7ZoLTrYEHeAAAOTqw
Message-ID: <6B2BA408B38BA1478B473C31C3D2074E341D585464@SV-EXCHANGE1.Corp.FC.LOCAL>
References: <4b46c5b21263c446923caf3da3f0dca6febc7b55.1403709665.git.aquini@redhat.com>
In-Reply-To: <4b46c5b21263c446923caf3da3f0dca6febc7b55.1403709665.git.aquini@redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.12.52,1.0.14,0.0.0000
 definitions=2014-06-25_06:2014-06-25,2014-06-25,1970-01-01 signatures=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



> -----Original Message-----
> From: Rafael Aquini [mailto:aquini@redhat.com]
> Sent: Wednesday, June 25, 2014 2:40 PM
> To: linux-mm@kvack.org
> Cc: Andrew Morton; Rik van Riel; Mel Gorman; Johannes Weiner; Motohiro Kosaki JP; linux-kernel@vger.kernel.org
> Subject: [PATCH] mm: export NR_SHMEM via sysinfo(2) / si_meminfo() interfaces
> 
> This patch leverages the addition of explicit accounting for pages used by shmem/tmpfs -- "4b02108 mm: oom analysis: add shmem
> vmstat" -- in order to make the users of sysinfo(2) and si_meminfo*() friends aware of that vmstat entry consistently across the
> interfaces.

Why?
Traditionally sysinfo.sharedram was not used for shmem. It was totally strange semantics and completely outdated feature. 
So, we may reuse it for another purpose. But I'm not sure its benefit. 

Why don't you use /proc/meminfo?
I'm afraid userland programs get a confusion. 


> 
> Signed-off-by: Rafael Aquini <aquini@redhat.com>
> ---
>  drivers/base/node.c | 2 +-
>  fs/proc/meminfo.c   | 2 +-
>  mm/page_alloc.c     | 3 ++-
>  3 files changed, 4 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/base/node.c b/drivers/base/node.c index 8f7ed99..c6d3ae0 100644
> --- a/drivers/base/node.c
> +++ b/drivers/base/node.c
> @@ -126,7 +126,7 @@ static ssize_t node_read_meminfo(struct device *dev,
>  		       nid, K(node_page_state(nid, NR_FILE_PAGES)),
>  		       nid, K(node_page_state(nid, NR_FILE_MAPPED)),
>  		       nid, K(node_page_state(nid, NR_ANON_PAGES)),
> -		       nid, K(node_page_state(nid, NR_SHMEM)),
> +		       nid, K(i.sharedram),
>  		       nid, node_page_state(nid, NR_KERNEL_STACK) *
>  				THREAD_SIZE / 1024,
>  		       nid, K(node_page_state(nid, NR_PAGETABLE)), diff --git a/fs/proc/meminfo.c b/fs/proc/meminfo.c index
> 7445af0..aa1eee0 100644
> --- a/fs/proc/meminfo.c
> +++ b/fs/proc/meminfo.c
> @@ -168,7 +168,7 @@ static int meminfo_proc_show(struct seq_file *m, void *v)
>  		K(global_page_state(NR_WRITEBACK)),
>  		K(global_page_state(NR_ANON_PAGES)),
>  		K(global_page_state(NR_FILE_MAPPED)),
> -		K(global_page_state(NR_SHMEM)),
> +		K(i.sharedram),
>  		K(global_page_state(NR_SLAB_RECLAIMABLE) +
>  				global_page_state(NR_SLAB_UNRECLAIMABLE)),
>  		K(global_page_state(NR_SLAB_RECLAIMABLE)),
> diff --git a/mm/page_alloc.c b/mm/page_alloc.c index 20d17f8..f72ea38 100644
> --- a/mm/page_alloc.c
> +++ b/mm/page_alloc.c
> @@ -3040,7 +3040,7 @@ static inline void show_node(struct zone *zone)  void si_meminfo(struct sysinfo *val)  {
>  	val->totalram = totalram_pages;
> -	val->sharedram = 0;
> +	val->sharedram = global_page_state(NR_SHMEM);
>  	val->freeram = global_page_state(NR_FREE_PAGES);
>  	val->bufferram = nr_blockdev_pages();
>  	val->totalhigh = totalhigh_pages;
> @@ -3060,6 +3060,7 @@ void si_meminfo_node(struct sysinfo *val, int nid)
>  	for (zone_type = 0; zone_type < MAX_NR_ZONES; zone_type++)
>  		managed_pages += pgdat->node_zones[zone_type].managed_pages;
>  	val->totalram = managed_pages;
> +	val->sharedram = node_page_state(nid, NR_SHMEM);
>  	val->freeram = node_page_state(nid, NR_FREE_PAGES);  #ifdef CONFIG_HIGHMEM
>  	val->totalhigh = pgdat->node_zones[ZONE_HIGHMEM].managed_pages;
> --
> 1.9.3

