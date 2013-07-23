Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934206Ab3GWUJj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jul 2013 16:09:39 -0400
Received: from mail-ye0-f173.google.com ([209.85.213.173]:45200 "EHLO
	mail-ye0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757655Ab3GWUJf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jul 2013 16:09:35 -0400
Date: Tue, 23 Jul 2013 16:09:24 -0400
From: Tejun Heo <tj@kernel.org>
To: Tang Chen <tangchen@cn.fujitsu.com>
Cc: tglx@linutronix.de, mingo@elte.hu, hpa@zytor.com,
        akpm@linux-foundation.org, trenn@suse.de, yinghai@kernel.org,
        jiang.liu@huawei.com, wency@cn.fujitsu.com, laijs@cn.fujitsu.com,
        isimatu.yasuaki@jp.fujitsu.com, izumi.taku@jp.fujitsu.com,
        mgorman@suse.de, minchan@kernel.org, mina86@mina86.com,
        gong.chen@linux.intel.com, vasilis.liaskovitis@profitbricks.com,
        lwoodman@redhat.com, riel@redhat.com, jweiner@redhat.com,
        prarit@redhat.com, zhangyanfei@cn.fujitsu.com, yanghy@cn.fujitsu.com,
        x86@kernel.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        linux-acpi@vger.kernel.org
Subject: Re: [PATCH 11/21] x86: get pg_data_t's memory from other node
Message-ID: <20130723200924.GP21100@mtj.dyndns.org>
References: <1374220774-29974-1-git-send-email-tangchen@cn.fujitsu.com>
 <1374220774-29974-12-git-send-email-tangchen@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1374220774-29974-12-git-send-email-tangchen@cn.fujitsu.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 19, 2013 at 03:59:24PM +0800, Tang Chen wrote:
> From: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>
> 
> If system can create movable node which all memory of the
> node is allocated as ZONE_MOVABLE, setup_node_data() cannot
> allocate memory for the node's pg_data_t.
> So, use memblock_alloc_try_nid() instead of memblock_alloc_nid()
> to retry when the first allocation fails. Otherwise, the system
> could failed to boot.
> 
> Signed-off-by: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>
> Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
> Signed-off-by: Tang Chen <tangchen@cn.fujitsu.com>
> Signed-off-by: Jiang Liu <jiang.liu@huawei.com>
> Reviewed-by: Wanpeng Li <liwanp@linux.vnet.ibm.com>
> ---
>  arch/x86/mm/numa.c |    5 ++---
>  1 files changed, 2 insertions(+), 3 deletions(-)
> 
> diff --git a/arch/x86/mm/numa.c b/arch/x86/mm/numa.c
> index a71c4e2..5013583 100644
> --- a/arch/x86/mm/numa.c
> +++ b/arch/x86/mm/numa.c
> @@ -209,10 +209,9 @@ static void __init setup_node_data(int nid, u64 start, u64 end)
>  	 * Allocate node data.  Try node-local memory and then any node.
>  	 * Never allocate in DMA zone.
>  	 */
> -	nd_pa = memblock_alloc_nid(nd_size, SMP_CACHE_BYTES, nid);
> +	nd_pa = memblock_alloc_try_nid(nd_size, SMP_CACHE_BYTES, nid);
>  	if (!nd_pa) {
> -		pr_err("Cannot find %zu bytes in node %d\n",
> -		       nd_size, nid);
> +		pr_err("Cannot find %zu bytes in any node\n", nd_size);

Hmm... we want the node data to be colocated on the same node and I
don't think being hotpluggable necessarily requires the node data to
be allocated on a different node.  Does node data of a hotpluggable
node need to stay around after hotunplug?

I don't think it's a huge issue but it'd be great if we can clarify
where the restriction is coming from.

Thanks.

-- 
tejun
