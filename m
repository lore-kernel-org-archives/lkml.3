Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756276Ab3LEAyA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Dec 2013 19:54:00 -0500
Received: from mail-yh0-f49.google.com ([209.85.213.49]:49523 "EHLO
	mail-yh0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756105Ab3LEAx6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Dec 2013 19:53:58 -0500
Date: Wed, 4 Dec 2013 16:53:54 -0800 (PST)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Christoph Lameter <cl@linux.com>
cc: Andrew Morton <akpm@linux-foundation.org>, Michal Hocko <mhocko@suse.cz>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Johannes Weiner <hannes@cmpxchg.org>, Mel Gorman <mgorman@suse.de>,
        Rik van Riel <riel@redhat.com>, Pekka Enberg <penberg@kernel.org>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        cgroups@vger.kernel.org
Subject: Re: [patch 3/8] mm, mempolicy: remove per-process flag
In-Reply-To: <00000142be3633ba-2a459537-58fb-444b-a99f-33ff5e5b2aed-000000@email.amazonses.com>
Message-ID: <alpine.DEB.2.02.1312041651080.13608@chino.kir.corp.google.com>
References: <20131119131400.GC20655@dhcp22.suse.cz> <20131119134007.GD20655@dhcp22.suse.cz> <alpine.DEB.2.02.1311192352070.20752@chino.kir.corp.google.com> <20131120152251.GA18809@dhcp22.suse.cz> <alpine.DEB.2.02.1311201917520.7167@chino.kir.corp.google.com>
 <20131128115458.GK2761@dhcp22.suse.cz> <alpine.DEB.2.02.1312021504170.13465@chino.kir.corp.google.com> <alpine.DEB.2.02.1312032116440.29733@chino.kir.corp.google.com> <alpine.DEB.2.02.1312032117490.29733@chino.kir.corp.google.com>
 <00000142be3633ba-2a459537-58fb-444b-a99f-33ff5e5b2aed-000000@email.amazonses.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 4 Dec 2013, Christoph Lameter wrote:

> > PF_MEMPOLICY is an unnecessary optimization for CONFIG_SLAB users.
> > There's no significant performance degradation to checking
> > current->mempolicy rather than current->flags & PF_MEMPOLICY in the
> > allocation path, especially since this is considered unlikely().
> 
> The use of current->mempolicy increase the cache footprint since its in a
> rarely used cacheline. This performance issue would occur when memory
> policies are not used since that cacheline would then have to be touched
> regardless of memory policies be in effect or not. PF_MEMPOLICY was used
> to avoid touching the cacheline.
> 

Right, but it turns out not to matter in practice.  As one of the non-
default CONFIG_SLAB users, and PF_MEMPOLICY only does something for 
CONFIG_SLAB, this patch tested to not show any degradation for specjbb 
which stresses the allocator in terms of throughput:

	   with patch: 128761.54 SPECjbb2005 bops
	without patch: 127576.65 SPECjbb2005 bops

These per-process flags are a scarce resource so I don't think 
PF_MEMPOLICY warrants a bit when it's not shown to be advantageous in 
configurations without mempolicy usage where it's intended to optimize, 
especially for a non-default slab allocator.
