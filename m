Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753663Ab3FRBkv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Jun 2013 21:40:51 -0400
Received: from mail-ye0-f176.google.com ([209.85.213.176]:62718 "EHLO
	mail-ye0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752779Ab3FRBku (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Jun 2013 21:40:50 -0400
Date: Mon, 17 Jun 2013 18:40:42 -0700
From: Tejun Heo <tj@kernel.org>
To: Tang Chen <tangchen@cn.fujitsu.com>
Cc: tglx@linutronix.de, mingo@elte.hu, hpa@zytor.com,
        akpm@linux-foundation.org, trenn@suse.de, yinghai@kernel.org,
        jiang.liu@huawei.com, wency@cn.fujitsu.com, laijs@cn.fujitsu.com,
        isimatu.yasuaki@jp.fujitsu.com, mgorman@suse.de, minchan@kernel.org,
        mina86@mina86.com, gong.chen@linux.intel.com,
        vasilis.liaskovitis@profitbricks.com, lwoodman@redhat.com,
        riel@redhat.com, jweiner@redhat.com, prarit@redhat.com, x86@kernel.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org
Subject: Re: [Part1 PATCH v5 13/22] x86, mm, numa: Use numa_meminfo to check
 node_map_pfn alignment
Message-ID: <20130618014042.GW32663@mtj.dyndns.org>
References: <1371128589-8953-1-git-send-email-tangchen@cn.fujitsu.com>
 <1371128589-8953-14-git-send-email-tangchen@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1371128589-8953-14-git-send-email-tangchen@cn.fujitsu.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 13, 2013 at 09:03:00PM +0800, Tang Chen wrote:
> From: Yinghai Lu <yinghai@kernel.org>
> 
> We could use numa_meminfo directly instead of memblock nid in
> node_map_pfn_alignment().
> 
> So we could do setting memblock nid later and only do it once
> for successful path.
> 
> -v2: according to tj, separate moving to another patch.

How about something like,

  Subject: x86, mm, NUMA: Use numa_meminfo instead of memblock in node_map_pfn_alignment()

  When sparsemem is used and page->flags doesn't have enough space to
  carry both the sparsemem section and node ID, NODE_NOT_IN_PAGE_FLAGS
  is set and the node is determined from section.  This requires that
  the NUMA nodes aren't more granular than sparsemem sections.
  node_map_pfn_alignment() is used to determine the maximum NUMA
  inter-node alignment which can distinguish all nodes to verify the
  above condition.

  The function currently assumes the NUMA node maps are populated and
  sorted and uses for_each_mem_pfn_range() to iterate memory regions.
  We want this to happen way earlier to support memory hotplug (maybe
  elaborate a bit more here).

  This patch updates node_map_pfn_alignment() so that it iterates over
  numa_meminfo instead and moves its invocation before memory regions
  are registered to memblock and node maps in numa_register_memblks().
  This will help memory hotplug (how...) and as a bonus we register
  memory regions only if the alignment check succeeds rather than
  registering and then failing.

Also, the comment on top of node_map_pfn_alignment() needs to be
updated, right?

Thanks.

-- 
tejun
