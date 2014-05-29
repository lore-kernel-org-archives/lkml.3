Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753310AbaE2Wkg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 May 2014 18:40:36 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:45911 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751413AbaE2Wkf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 May 2014 18:40:35 -0400
Date: Thu, 29 May 2014 15:40:33 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Marcelo Tosatti <mtosatti@redhat.com>
Cc: Li Zefan <lizefan@huawei.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, Lai Jiangshan <laijs@cn.fujitsu.com>,
        Mel Gorman <mgorman@suse.de>, Tejun Heo <tj@kernel.org>,
        Christoph Lameter <cl@linux.com>, David Rientjes <rientjes@google.com>
Subject: Re: [PATCH] page_alloc: skip cpuset enforcement for lower zone
 allocations (v4)
Message-Id: <20140529154033.f8d159b909794d71e2754489@linux-foundation.org>
In-Reply-To: <20140529184303.GA20571@amt.cnet>
References: <20140523193706.GA22854@amt.cnet>
	<20140526185344.GA19976@amt.cnet>
	<53858A06.8080507@huawei.com>
	<20140528224324.GA1132@amt.cnet>
	<20140529184303.GA20571@amt.cnet>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 29 May 2014 15:43:03 -0300 Marcelo Tosatti <mtosatti@redhat.com> wrote:

> 
> Zone specific allocations, such as GFP_DMA32, should not be restricted
> to cpusets allowed node list: the zones which such allocations demand
> might be contained in particular nodes outside the cpuset node list.
> 
> Necessary for the following usecase:
> - driver which requires zone specific memory (such as KVM, which
> requires root pagetable at paddr < 4GB).
> - user wants to limit allocations of application to nodeX, and nodeX has
> no memory < 4GB.
> 
> --- a/kernel/cpuset.c
> +++ b/kernel/cpuset.c
> @@ -2392,6 +2393,10 @@ int __cpuset_node_allowed_softwall(int node, gfp_t gfp_mask)
>  
>  	if (in_interrupt() || (gfp_mask & __GFP_THISNODE))
>  		return 1;
> +#ifdef CONFIG_NUMA
> +	if (gfp_zone(gfp_mask) < policy_zone)
> +		return 1;
> +#endif

It's not very obvious why this code is doing what it does, so I'm
thinking a comment is needed.  And that changelog text looks good, so

--- a/kernel/cpuset.c~page_alloc-skip-cpuset-enforcement-for-lower-zone-allocations-v4-fix
+++ a/kernel/cpuset.c
@@ -2388,6 +2388,11 @@ int __cpuset_node_allowed_softwall(int n
 	if (in_interrupt() || (gfp_mask & __GFP_THISNODE))
 		return 1;
 #ifdef CONFIG_NUMA
+	/*
+	 * Zone specific allocations such as GFP_DMA32 should not be restricted
+	 * to cpusets allowed node list: the zones which such allocations
+	 * demand be contained in particular nodes outside the cpuset node list
+	 */
 	if (gfp_zone(gfp_mask) < policy_zone)
 		return 1;
 #endif
--- a/mm/page_alloc.c~page_alloc-skip-cpuset-enforcement-for-lower-zone-allocations-v4-fix
+++ a/mm/page_alloc.c
@@ -2742,6 +2742,11 @@ retry_cpuset:
 	cpuset_mems_cookie = read_mems_allowed_begin();
 
 #ifdef CONFIG_NUMA
+	/*
+	 * Zone specific allocations such as GFP_DMA32 should not be restricted
+	 * to cpusets allowed node list: the zones which such allocations
+	 * demand be contained in particular nodes outside the cpuset node list
+	 */
 	if (gfp_zone(gfp_mask) < policy_zone)
 		nodemask = &node_states[N_ONLINE];
 #endif



However perhaps it would be nicer to do



#ifdef CONFIG_NUMA
/*
 * Zone specific allocations such as GFP_DMA32 should not be restricted to
 * cpusets allowed node list: the zones which such allocations demand be
 * contained in particular nodes outside the cpuset node list
 */
static inline bool i_cant_think_of_a_name(gfp_t mask)
{
	return gfp_zone(gfp_mask) < policy_zone;
}
#else
static inline bool i_cant_think_of_a_name(gfp_t mask)
{
	return false;
}
#endif

This encapsulates it all in a single place and zaps those ifdefs?
