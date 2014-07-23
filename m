Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758309AbaGWXFl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jul 2014 19:05:41 -0400
Received: from mail-ie0-f173.google.com ([209.85.223.173]:53450 "EHLO
	mail-ie0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751241AbaGWXFk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jul 2014 19:05:40 -0400
Date: Wed, 23 Jul 2014 16:05:36 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Alex Thorlton <athorlton@sgi.com>
cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        akpm@linux-foundation.org, mgorman@suse.de, riel@redhat.com,
        kirill.shutemov@linux.intel.com, mingo@kernel.org, hughd@google.com,
        lliubbo@gmail.com, hannes@cmpxchg.org,
        srivatsa.bhat@linux.vnet.ibm.com, dave.hansen@linux.intel.com,
        dfults@sgi.com, hedi@sgi.com
Subject: Re: [BUG] THP allocations escape cpuset when defrag is off
In-Reply-To: <20140723225742.GU8578@sgi.com>
Message-ID: <alpine.DEB.2.02.1407231600110.1389@chino.kir.corp.google.com>
References: <20140723220538.GT8578@sgi.com> <alpine.DEB.2.02.1407231516570.23495@chino.kir.corp.google.com> <20140723225742.GU8578@sgi.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 23 Jul 2014, Alex Thorlton wrote:

> > It's also been a long-standing issue that cpusets and mempolicies are 
> > ignored by khugepaged that allows memory to be migrated remotely to nodes 
> > that are not allowed by a cpuset's mems or a mempolicy's nodemask.  Even 
> > with this issue fixed, you may find that some memory is migrated remotely, 
> > although it may be negligible, by khugepaged.
> 
> A bit here and there is manageable.  There is, of course, some work to
> be done there, but for now we're mainly concerned with a job that's
> supposed to be confined to a cpuset spilling out and soaking up all the
> memory on a machine.
> 

You may find my patch[*] in -mm to be helpful if you enable 
zone_reclaim_mode.  It changes khugepaged so that it is not allowed to 
migrate any memory to a remote node where the distance between the nodes 
is greater than RECLAIM_DISTANCE.

These issues are still pending and we've encountered a couple of them in 
the past weeks ourselves.  The definition of RECLAIM_DISTANCE, currently 
at 30 for x86, is relying on the SLIT to define when remote access is 
costly and there are cases where people need to alter the BIOS to 
workaround this definition.

We can hope that NUMA balancing will solve a lot of these problems for us, 
but there's always a chance that the VM does something totally wrong which 
you've undoubtedly encountered already.

 [*] http://ozlabs.org/~akpm/mmots/broken-out/mm-thp-only-collapse-hugepages-to-nodes-with-affinity-for-zone_reclaim_mode.patch
