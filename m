Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933612AbaCQOqV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Mar 2014 10:46:21 -0400
Received: from mga02.intel.com ([134.134.136.20]:15159 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933171AbaCQOqP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Mar 2014 10:46:15 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,670,1389772800"; 
   d="scan'208";a="474165519"
Date: Mon, 17 Mar 2014 10:45:51 -0400
From: Matthew Wilcox <willy@linux.intel.com>
To: "Kirill A. Shutemov" <kirill@shutemov.name>
Cc: Toshi Kani <toshi.kani@hp.com>, kirill.shutemov@linux.intel.com,
        david@fromorbit.com, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [RFC PATCH] Support map_pages() for DAX
Message-ID: <20140317144551.GG6091@linux.intel.com>
References: <1394838199-29102-1-git-send-email-toshi.kani@hp.com>
 <20140314233233.GA8310@node.dhcp.inet.fi>
 <20140316024613.GF6091@linux.intel.com>
 <20140317114321.GA30191@node.dhcp.inet.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140317114321.GA30191@node.dhcp.inet.fi>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 17, 2014 at 01:43:21PM +0200, Kirill A. Shutemov wrote:
> On Sat, Mar 15, 2014 at 10:46:13PM -0400, Matthew Wilcox wrote:
> > I'm actually working on this now.  The basic idea is to put an entry in
> > the radix tree for each page.  For zero pages, that's a pagecache page.
> > For pages that map to the media, it's an exceptional entry.  Radix tree
> > exceptional entries take two bits, leaving us with 30 or 62 bits depending
> > on sizeof(void *).  We can then take two more bits for Dirty and Lock,
> > leaving 28 or 60 bits that we can use to cache the PFN on the page,
> > meaning that we won't have to call the filesystem's get_block as often.
> 
> Sound reasonable to me. Implementation of ->map_pages should be trivial
> with this.
> 
> Few questions:
>  - why would you need Dirty for DAX?

One of the areas ignored by the original XIP code was CPU caches.  Maybe
s390 has write-through caches or something, but on x86 we need to write back
the lines from the CPU cache to the memory on an msync().  We'll also need
to do this for a write(), although that's a SMOP.

>  - are you sure that 28 bits is enough for PFN everywhere?
>    ARM with LPAE can have up to 40 physical address lines. Is there any
>    32-bit machine with more address lines?

It's clearly not enough :-)  My plan is to have a pair of functions
pfn_to_rte() and rte_to_pfn() with default implementations that work well
on 64-bit and can be overridden by address-space deficient architectures.
If rte_to_pfn() returns RTE_PFN_UNKNOWN (which is probably -1), we'll
just go off and call get_block and ->direct_access.  This will be a
well-tested codepath because it'll be the same as the codepath used the
first time we look up a block.

Architectures can use whatever fancy scheme they like to optimise
rte_to_pfn() ... I don't think suggesting that enabling DAX grows
the radix tree entries from 32 to 64 bit would be a popular idea, but
that'd be something for those architecture maintainers to figure out.
I certainly don't care much about an x86-32 kernel with DAX ... I can
see it maybe being interesting in a virtualisation environment, but
probably not.

