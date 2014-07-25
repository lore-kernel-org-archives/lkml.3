Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753342AbaGYPeW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jul 2014 11:34:22 -0400
Received: from cantor2.suse.de ([195.135.220.15]:43556 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752919AbaGYPeU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jul 2014 11:34:20 -0400
Date: Fri, 25 Jul 2014 16:34:14 +0100
From: Mel Gorman <mgorman@suse.de>
To: David Rientjes <rientjes@google.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Dave Hansen <dave.hansen@intel.com>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Vlastimil Babka <vbabka@suse.cz>, Rik van Riel <riel@redhat.com>,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
        Bob Liu <bob.liu@oracle.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: Re: [patch v4] mm, thp: only collapse hugepages to nodes with
 affinity for zone_reclaim_mode
Message-ID: <20140725153414.GJ10819@suse.de>
References: <alpine.DEB.2.02.1407141807030.8808@chino.kir.corp.google.com>
 <alpine.DEB.2.02.1407151712520.12279@chino.kir.corp.google.com>
 <53C69C7B.1010709@suse.cz>
 <alpine.DEB.2.02.1407161754000.23892@chino.kir.corp.google.com>
 <alpine.DEB.2.02.1407161757500.23892@chino.kir.corp.google.com>
 <53C7F9AC.1080007@intel.com>
 <alpine.DEB.2.02.1407171447310.9717@chino.kir.corp.google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.02.1407171447310.9717@chino.kir.corp.google.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 17, 2014 at 02:48:07PM -0700, David Rientjes wrote:
> Commit 9f1b868a13ac ("mm: thp: khugepaged: add policy for finding target 
> node") improved the previous khugepaged logic which allocated a 
> transparent hugepages from the node of the first page being collapsed.
> 
> However, it is still possible to collapse pages to remote memory which may 
> suffer from additional access latency.  With the current policy, it is 
> possible that 255 pages (with PAGE_SHIFT == 12) will be collapsed remotely 
> if the majority are allocated from that node.
> 
> When zone_reclaim_mode is enabled, it means the VM should make every attempt
> to allocate locally to prevent NUMA performance degradation.  In this case,
> we do not want to collapse hugepages to remote nodes that would suffer from
> increased access latency.  Thus, when zone_reclaim_mode is enabled, only
> allow collapsing to nodes with RECLAIM_DISTANCE or less.
> 
> There is no functional change for systems that disable zone_reclaim_mode.
> 
> Signed-off-by: David Rientjes <rientjes@google.com>

The patch looks ok for what it is intended to do so

Acked-by: Mel Gorman <mgorman@suse.de>

However, I would consider it likely that pages allocated on different nodes
within a hugepage boundary indicates that multiple threads on different nodes
are accessing those pages. I would be skeptical that reduced TLB misses
offset remote access penalties. Should we simply refuse to collapse huge
pages when the 4K pages are allocated from different nodes? If automatic
NUMA balancing is enabled and the access are really coming from one node
then the 4K pages will eventually be migrated to a local node and then
khugepaged can collapse it.

-- 
Mel Gorman
SUSE Labs
