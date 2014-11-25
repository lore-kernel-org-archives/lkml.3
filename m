Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751382AbaKYORM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Nov 2014 09:17:12 -0500
Received: from mta-out1.inet.fi ([62.71.2.195]:60272 "EHLO jenni2.inet.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750908AbaKYORK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Nov 2014 09:17:10 -0500
Date: Tue, 25 Nov 2014 16:17:02 +0200
From: "Kirill A. Shutemov" <kirill@shutemov.name>
To: David Rientjes <rientjes@google.com>
Cc: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>,
        akpm@linux-foundation.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH] mm/thp: Always allocate transparent hugepages on
 local node
Message-ID: <20141125141702.GB11841@node.dhcp.inet.fi>
References: <1416838791-30023-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
 <20141124150342.GA3889@node.dhcp.inet.fi>
 <alpine.DEB.2.10.1411241317430.21237@chino.kir.corp.google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.10.1411241317430.21237@chino.kir.corp.google.com>
User-Agent: Mutt/1.5.23.1 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 24, 2014 at 01:33:42PM -0800, David Rientjes wrote:
> On Mon, 24 Nov 2014, Kirill A. Shutemov wrote:
> 
> > > This make sure that we try to allocate hugepages from local node. If
> > > we can't we fallback to small page allocation based on
> > > mempolicy. This is based on the observation that allocating pages
> > > on local node is more beneficial that allocating hugepages on remote node.
> > 
> > Local node on allocation is not necessary local node for use.
> > If policy says to use a specific node[s], we should follow.
> > 
> 
> True, and the interaction between thp and mempolicies is fragile: if a 
> process has a MPOL_BIND mempolicy over a set of nodes, that does not 
> necessarily mean that we want to allocate thp remotely if it will always 
> be accessed remotely.  It's simple to benchmark and show that remote 
> access latency of a hugepage can exceed that of local pages.  MPOL_BIND 
> itself is a policy of exclusion, not inclusion, and it's difficult to 
> define when local pages and its cost of allocation is better than remote 
> thp.
> 
> For MPOL_BIND, if the local node is allowed then thp should be forced from 
> that node, if the local node is disallowed then allocate from any node in 
> the nodemask.  For MPOL_INTERLEAVE, I think we should only allocate thp 
> from the next node in order, otherwise fail the allocation and fallback to 
> small pages.  Is this what you meant as well?

Correct.

> > I think it makes sense to force local allocation if policy is interleave
> > or if current node is in preferred or bind set.
> >  
> 
> If local allocation were forced for MPOL_INTERLEAVE and all memory is 
> initially faulted by cpus on a single node, then the policy has 
> effectively become MPOL_DEFAULT, there's no interleave.

You're right. I don't have much experience with mempolicy code.

-- 
 Kirill A. Shutemov
