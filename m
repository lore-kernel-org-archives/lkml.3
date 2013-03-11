Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751818Ab3CKFrR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Mar 2013 01:47:17 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:57087 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751002Ab3CKFrQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Mar 2013 01:47:16 -0400
X-IronPort-AV: E=Sophos;i="4.84,821,1355068800"; 
   d="scan'208";a="6848831"
Message-ID: <513D7078.9080507@cn.fujitsu.com>
Date: Mon, 11 Mar 2013 13:49:44 +0800
From: Tang Chen <tangchen@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
To: Yinghai Lu <yinghai@kernel.org>
CC: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Andrew Morton <akpm@linux-foundation.org>, Tejun Heo <tj@kernel.org>,
        Thomas Renninger <trenn@suse.de>, linux-kernel@vger.kernel.org,
        Pekka Enberg <penberg@kernel.org>, Jacob Shin <jacob.shin@amd.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Subject: Re: [PATCH v2 20/20] x86, mm, numa: Put pagetable on local node ram
 for 64bit
References: <1362897887-30808-1-git-send-email-yinghai@kernel.org> <1362897887-30808-21-git-send-email-yinghai@kernel.org>
In-Reply-To: <1362897887-30808-21-git-send-email-yinghai@kernel.org>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/03/11 13:46:02,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/03/11 13:46:03,
	Serialize complete at 2013/03/11 13:46:03
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Yinghai,

Please see below. :)

On 03/10/2013 02:44 PM, Yinghai Lu wrote:
> If node with ram is hotplugable, local node mem for page table and vmemmap
> should be on that node ram.
>
> This patch is some kind of refreshment of
> | commit 1411e0ec3123ae4c4ead6bfc9fe3ee5a3ae5c327
> | Date:   Mon Dec 27 16:48:17 2010 -0800
> |
> |    x86-64, numa: Put pgtable to local node memory
> That was reverted before.
>
> We have reason to reintroduce it to make memory hotplug work.
>
> Calling init_mem_mapping in early_initmem_init for every node.
> alloc_low_pages will alloc page table in following order:
> 	BRK, local node, low range
> So page table will be on low range or local nodes.
>
> Signed-off-by: Yinghai Lu<yinghai@kernel.org>
> Cc: Pekka Enberg<penberg@kernel.org>
> Cc: Jacob Shin<jacob.shin@amd.com>
> Cc: Konrad Rzeszutek Wilk<konrad.wilk@oracle.com>
> ---
>   arch/x86/mm/numa.c |   34 +++++++++++++++++++++++++++++++++-
>   1 file changed, 33 insertions(+), 1 deletion(-)
>
> diff --git a/arch/x86/mm/numa.c b/arch/x86/mm/numa.c
> index d3eb0c9..11acdf6 100644
> --- a/arch/x86/mm/numa.c
> +++ b/arch/x86/mm/numa.c
> @@ -673,7 +673,39 @@ static void __init early_x86_numa_init(void)
>   #ifdef CONFIG_X86_64
>   static void __init early_x86_numa_init_mapping(void)
>   {
> -	init_mem_mapping(0, max_pfn<<  PAGE_SHIFT);
> +	unsigned long last_start = 0, last_end = 0;
> +	struct numa_meminfo *mi =&numa_meminfo;
> +	unsigned long start, end;
> +	int last_nid = -1;
> +	int i, nid;
> +
> +	for (i = 0; i<  mi->nr_blks; i++) {
> +		nid   = mi->blk[i].nid;
> +		start = mi->blk[i].start;
> +		end   = mi->blk[i].end;
> +
> +		if (last_nid == nid) {
> +			last_end = end;
> +			continue;
> +		}
> +
> +		/* other nid now */
> +		if (last_nid>= 0) {
> +			printk(KERN_DEBUG "Node %d: [mem %#016lx-%#016lx]\n",
> +					last_nid, last_start, last_end - 1);
> +			init_mem_mapping(last_start, last_end);

IIUC, we call init_mem_mapping() for each node ranges. In the first time,
         local_max_pfn_mapped = begin >> PAGE_SHIFT;
         local_min_pfn_mapped = real_end >> PAGE_SHIFT;
which means
	local_min_pfn_mapped >= local_max_pfn_mapped
right ?

So, the first page allocated by alloc_low_pages() is not on local node, 
right ?
Furthermore, the first page of pagetable is not on local node, right ?

BTW, I'm reading your code, and doing necessary hot-add and hot-remove 
changes now.

Thanks. :)

> +		}
> +
> +		/* for next nid */
> +		last_nid   = nid;
> +		last_start = start;
> +		last_end   = end;
> +	}
> +	/* last one */
> +	printk(KERN_DEBUG "Node %d: [mem %#016lx-%#016lx]\n",
> +			last_nid, last_start, last_end - 1);
> +	init_mem_mapping(last_start, last_end);
> +
>   	if (max_pfn>  max_low_pfn)
>   		max_low_pfn = max_pfn;
>   }
