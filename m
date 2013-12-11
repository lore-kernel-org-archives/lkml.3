Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751944Ab3LKWkk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Dec 2013 17:40:40 -0500
Received: from mga02.intel.com ([134.134.136.20]:2182 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751489Ab3LKWk3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Dec 2013 17:40:29 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.93,874,1378882800"; 
   d="scan'208";a="423198030"
Subject: [RFC][PATCH 0/3] re-shrink 'struct page' when SLUB is on.
To: linux-kernel@vger.kernel.org
Cc: linux-mm@kvack.org, cl@gentwo.org, kirill.shutemov@linux.intel.com,
        Andi Kleen <ak@linux.intel.com>, Dave Hansen <dave@sr71.net>
From: Dave Hansen <dave@sr71.net>
Date: Wed, 11 Dec 2013 14:40:22 -0800
Message-Id: <20131211224022.AA8CF0B9@viggo.jf.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

OK, here's the real reason I was digging around for exactly which
fields in 'struct page' slub uses.

SLUB depends on a 16-byte cmpxchg for an optimization.  For the
purposes of this series, I'm assuming that it is a very important
optimization that we desperately need to keep around.

In order to get guaranteed 16-byte alignment (required by the
hardware on x86), 'struct page' is padded out from 56 to 64
bytes.

Those 8-bytes matter.  We've gone to great lengths to keep
'struct page' small in the past.  It's a shame that we bloat it
now just for alignment reasons when we have extra space.  These
patches attempt _internal_ alignment instead of external
alignment for slub.

I also got a bug report from some folks running a large database
benchmark.  Their old kernel uses slab and their new one uses
slub.  They were swapping and couldn't figure out why.  It turned
out to be the 2GB of RAM that the slub padding wastes on their
system.

On my box, that 2GB cost about $200 to populate back when we
bought it.  I want my $200 back.

This is compile tested and lightly runtime tested.  I'm curious
what people think of it before we push it futher.  This is on top
of my previous patch to create a 'struct slab_page', but doesn't
really rely on it.  It could easily be done independently.
