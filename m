Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754074AbaE2XM4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 May 2014 19:12:56 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:46245 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751577AbaE2XMz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 May 2014 19:12:55 -0400
Date: Thu, 29 May 2014 16:12:53 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: David Rientjes <rientjes@google.com>
Cc: Marcelo Tosatti <mtosatti@redhat.com>, Li Zefan <lizefan@huawei.com>,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        Lai Jiangshan <laijs@cn.fujitsu.com>, Mel Gorman <mgorman@suse.de>,
        Tejun Heo <tj@kernel.org>, Christoph Lameter <cl@linux.com>
Subject: Re: [PATCH] page_alloc: skip cpuset enforcement for lower zone
 allocations (v4)
Message-Id: <20140529161253.73ff978f723972f503123fe8@linux-foundation.org>
In-Reply-To: <alpine.DEB.2.02.1405291555120.9336@chino.kir.corp.google.com>
References: <20140523193706.GA22854@amt.cnet>
	<20140526185344.GA19976@amt.cnet>
	<53858A06.8080507@huawei.com>
	<20140528224324.GA1132@amt.cnet>
	<20140529184303.GA20571@amt.cnet>
	<alpine.DEB.2.02.1405291555120.9336@chino.kir.corp.google.com>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 29 May 2014 16:01:55 -0700 (PDT) David Rientjes <rientjes@google.com> wrote:

> There are still three issues with this, two of which are only minor and 
> one that needs more thought:
> 
>  (1) this doesn't affect only cpusets which the changelog indicates, it 
>      also bypasses mempolicies for GFP_DMA and GFP_DMA32 allocations since
>      the nodemask != NULL in the page allocator when there is an effective
>      mempolicy.  That may be precisely what you're trying to do (do the
>      same for mempolicies as you're doing for cpusets), but the comment 
>      now in the code specifically refers to cpusets.  Can you make a case
>      for the mempolicies exception as well?  Otherwise, we'll need to do
> 
> 	if (!nodemask && gfp_zone(gfp_mask) < policy_zone)
> 		nodemask = &node_states[N_ONLINE];
> 
> And the two minors:
> 
>  (2) this should be &node_states[N_MEMORY], not &node_states[N_ONLINE] 
>      since memoryless nodes should not be included.  Note that
>      guarantee_online_mems() looks at N_MEMORY and
>      cpuset_current_mems_allowed is defined for N_MEMORY without
>      cpusets.
> 
>  (3) it's unnecessary for this to be after the "retry_cpuset" label and
>      check the gfp mask again if we need to relook at the allowed cpuset
>      mask.

OK, thanks, I made the patch go away for now.
