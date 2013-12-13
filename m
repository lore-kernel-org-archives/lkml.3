Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753430Ab3LMX7P (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Dec 2013 18:59:15 -0500
Received: from mga09.intel.com ([134.134.136.24]:56752 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751609Ab3LMX7M (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Dec 2013 18:59:12 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.95,482,1384329600"; 
   d="scan'208";a="452112360"
Subject: [RFC][PATCH 0/7] re-shrink 'struct page' when SLUB is on.
To: linux-kernel@vger.kernel.org
Cc: linux-mm@kvack.org, Pravin B Shelar <pshelar@nicira.com>,
        Christoph Lameter <cl@linux-foundation.org>,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
        Andi Kleen <ak@linux.intel.com>, Dave Hansen <dave@sr71.net>
From: Dave Hansen <dave@sr71.net>
Date: Fri, 13 Dec 2013 15:59:03 -0800
Message-Id: <20131213235903.8236C539@viggo.jf.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

SLUB depends on a 16-byte cmpxchg for an optimization.  For the
purposes of this series, I'm assuming that it is a very important
optimization that we desperately need to keep around.

In order to get guaranteed 16-byte alignment (required by the
hardware on x86), 'struct page' is padded out from 56 to 64
bytes.

Those 8-bytes matter.  We've gone to great lengths to keep
'struct page' small in the past.  It's a shame that we bloat it
now just for alignment reasons when we have extra space.  Plus,
bloating such a commonly-touched structure *HAS* to have cache
footprint implications.

These patches attempt _internal_ alignment instead of external
alignment for slub.

I also got a bug report from some folks running a large database
benchmark.  Their old kernel uses slab and their new one uses
slub.  They were swapping and couldn't figure out why.  It turned
out to be the 2GB of RAM that the slub padding wastes on their
system.

On my box, that 2GB cost about $200 to populate back when we
bought it.  I want my $200 back.

This set takes me from 16909584K of reserved memory at boot
down to 14814472K, so almost *exactly* 2GB of savings!  It also
helps performance, presumably because it touches 14% fewer
struct page cachelines.  A 30GB dd to a ramfs file:

        dd if=/dev/zero of=bigfile bs=$((1<<30)) count=30

is sped up by about 4.4% in my testing.

This is compile tested and lightly runtime tested.  I'm curious
what people think of it before we push it futher.  I believe this
gets rid of the concerns Christoph had about adding additional
branches in the fast path, although I still disagree that this
has any benefit in practice.

I also wrote up a document describing 'struct page's layout:

	http://tinyurl.com/n6kmedz

