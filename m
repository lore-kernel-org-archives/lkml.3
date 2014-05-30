Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755819AbaE3Nsq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 May 2014 09:48:46 -0400
Received: from qmta02.emeryville.ca.mail.comcast.net ([76.96.30.24]:37289 "EHLO
	qmta02.emeryville.ca.mail.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753393AbaE3Nso (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 May 2014 09:48:44 -0400
Date: Fri, 30 May 2014 08:48:41 -0500 (CDT)
From: Christoph Lameter <cl@gentwo.org>
To: Andrew Morton <akpm@linux-foundation.org>
cc: David Rientjes <rientjes@google.com>,
        Marcelo Tosatti <mtosatti@redhat.com>, Li Zefan <lizefan@huawei.com>,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        Lai Jiangshan <laijs@cn.fujitsu.com>, Mel Gorman <mgorman@suse.de>,
        Tejun Heo <tj@kernel.org>, Andi Kleen <andi@firstfloor.org>
Subject: Re: [PATCH] page_alloc: skip cpuset enforcement for lower zone
 allocations (v4)
In-Reply-To: <20140529161253.73ff978f723972f503123fe8@linux-foundation.org>
Message-ID: <alpine.DEB.2.10.1405300841390.8240@gentwo.org>
References: <20140523193706.GA22854@amt.cnet> <20140526185344.GA19976@amt.cnet> <53858A06.8080507@huawei.com> <20140528224324.GA1132@amt.cnet> <20140529184303.GA20571@amt.cnet> <alpine.DEB.2.02.1405291555120.9336@chino.kir.corp.google.com>
 <20140529161253.73ff978f723972f503123fe8@linux-foundation.org>
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 29 May 2014, Andrew Morton wrote:

> >
> > 	if (!nodemask && gfp_zone(gfp_mask) < policy_zone)
> > 		nodemask = &node_states[N_ONLINE];
>
> OK, thanks, I made the patch go away for now.
>

And another issue is that the policy_zone may be highmem on 32 bit
platforms which will result in ZONE_NORMAL to be exempted.

policy zone can actually even be ZONE_DMA for some platforms. The
check would not be useful at all on those.

Ignoring the containing cpuset only makes sense for GFP_DMA32 on
64 bit platforms and for GFP_DMA on platforms where there is an actual
difference in the address spaces supported by GFP_DMA (such as x86).

Generally I think this is only useful for platforms that attempt to
support legacy devices only able to DMA to a portion of the memory address
space and that at the same time support NUMA for large address spaces.
This is a contradiction on the one hand this is a high end system and on
the other hand it attempts to support crippled DMA devices?

