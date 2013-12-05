Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752283Ab3LETMl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Dec 2013 14:12:41 -0500
Received: from a9-113.smtp-out.amazonses.com ([54.240.9.113]:44010 "EHLO
	a9-113.smtp-out.amazonses.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752006Ab3LETMj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Dec 2013 14:12:39 -0500
X-Greylist: delayed 417 seconds by postgrey-1.27 at vger.kernel.org; Thu, 05 Dec 2013 14:12:39 EST
Date: Thu, 5 Dec 2013 19:05:41 +0000
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@gentwo.org
To: David Rientjes <rientjes@google.com>
cc: Andrew Morton <akpm@linux-foundation.org>, Michal Hocko <mhocko@suse.cz>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Johannes Weiner <hannes@cmpxchg.org>, Mel Gorman <mgorman@suse.de>,
        Rik van Riel <riel@redhat.com>, Pekka Enberg <penberg@kernel.org>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        cgroups@vger.kernel.org
Subject: Re: [patch 3/8] mm, mempolicy: remove per-process flag
In-Reply-To: <alpine.DEB.2.02.1312041651080.13608@chino.kir.corp.google.com>
Message-ID: <00000142c426b81a-45e6815b-bde4-483c-975e-ce1eea42a753-000000@email.amazonses.com>
References: <20131119131400.GC20655@dhcp22.suse.cz> <20131119134007.GD20655@dhcp22.suse.cz> <alpine.DEB.2.02.1311192352070.20752@chino.kir.corp.google.com> <20131120152251.GA18809@dhcp22.suse.cz> <alpine.DEB.2.02.1311201917520.7167@chino.kir.corp.google.com>
 <20131128115458.GK2761@dhcp22.suse.cz> <alpine.DEB.2.02.1312021504170.13465@chino.kir.corp.google.com> <alpine.DEB.2.02.1312032116440.29733@chino.kir.corp.google.com> <alpine.DEB.2.02.1312032117490.29733@chino.kir.corp.google.com>
 <00000142be3633ba-2a459537-58fb-444b-a99f-33ff5e5b2aed-000000@email.amazonses.com> <alpine.DEB.2.02.1312041651080.13608@chino.kir.corp.google.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-SES-Outgoing: 2013.12.05-54.240.9.113
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 4 Dec 2013, David Rientjes wrote:

>
> Right, but it turns out not to matter in practice.  As one of the non-
> default CONFIG_SLAB users, and PF_MEMPOLICY only does something for
> CONFIG_SLAB, this patch tested to not show any degradation for specjbb
> which stresses the allocator in terms of throughput:
>
> 	   with patch: 128761.54 SPECjbb2005 bops
> 	without patch: 127576.65 SPECjbb2005 bops

Specjbb? What does Java have to do with this?
Can you run the synthetic in kernel slab benchmark.

Like this one https://lkml.org/lkml/2009/10/13/459

> These per-process flags are a scarce resource so I don't think
> PF_MEMPOLICY warrants a bit when it's not shown to be advantageous in
> configurations without mempolicy usage where it's intended to optimize,
> especially for a non-default slab allocator.

PF_MEMPOLICY was advantageous when Paul Jackson introduced and benchmarked
it.

SLUB supports mempolicies through allocate_pages but it will allocate all
objects out of one slab pages before retrieving another page following the
policy. Thats why PF_MEMPOLICY and the other per object handling can be
avoided in its fastpath. Thus PF_MEMPOLICY is not that important there.

However, SLAB is still the allocator in use for RHEL which puts some
importance on still supporting SLAB.

