Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756938AbaIRJ7Z (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Sep 2014 05:59:25 -0400
Received: from gw-1.arm.linux.org.uk ([78.32.30.217]:33012 "EHLO
	pandora.arm.linux.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1756152AbaIRJ7Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Sep 2014 05:59:24 -0400
Date: Thu, 18 Sep 2014 10:59:14 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: "Wang, Yalin" <Yalin.Wang@sonymobile.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <Will.Deacon@arm.com>,
        "'linux-mm@kvack.org'" <linux-mm@kvack.org>,
        "'linux-kernel@vger.kernel.org'" <linux-kernel@vger.kernel.org>,
        "'linux-arm-kernel@lists.infradead.org'" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH] arm64:free_initrd_mem should also free the memblock
Message-ID: <20140918095914.GB5182@n2100.arm.linux.org.uk>
References: <35FD53F367049845BC99AC72306C23D103CDBFBFB029@CNBJMBX05.corpusers.net> <20140915183334.GA30737@arm.com> <20140915184023.GF12361@n2100.arm.linux.org.uk> <20140915185027.GC30737@arm.com> <35FD53F367049845BC99AC72306C23D103D6DB49160C@CNBJMBX05.corpusers.net> <20140917162822.GB15261@e104818-lin.cambridge.arm.com> <20140917181254.GW12361@n2100.arm.linux.org.uk> <35FD53F367049845BC99AC72306C23D103D6DB49161B@CNBJMBX05.corpusers.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <35FD53F367049845BC99AC72306C23D103D6DB49161B@CNBJMBX05.corpusers.net>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 18, 2014 at 05:38:54PM +0800, Wang, Yalin wrote:
> Hi Russell,
> 
> mm..
> I see your meaning,
> But how to debug reserved memory,
> I mean how to know which physical memory are reserved in kernel if 
> Not use /sys/kernel/debug/memblock/reserved  debug file ?

What are you trying to do when you say "debug reserved memory" ?
Let's first sort out what you mean by "reserved memory".

We have pages which are allocated on demand, which are then marked with
the PG_reserved flag to indicate that they are something special.  These
get counted in the statistics as "reserved" pages.  These pages may be
freed at a later time.  These never appear in memblock.

We have pages which cover the kernel text/data.  These are never freed
once the system is running.  Memblock records a chunk of memory reserved
at boot time for the kernel, so that memblock does not try to allocate
from that region.

We also have pages which cover the DT and initrd images.  Again, we need
to mark them reserved in memblock so that it doesn't try to allocate from
those regions while we're bringing the kernel up.  However, once the
kernel is running, these areas are freed into the normal memory kernel
memory allocators, but they remain in memblock.

So, even if you solve the third case, your picture of reserved memory
from memblock is still very much incomplete, and adding memblock calls
to all the sites which allocate and then reserve the pages is (a) going
to add unnecessary overhead, and (b) is going to add quite a bit of
complexity all over the kernel.

Let me re-iterate.  memblock is a stepping stone for bringing the kernel
up.  It is used early in boot to provide trivial memory allocation, and
once the main kernel memory allocators are initialised (using allocations
from memblock), memblock becomes mostly redundant - memblocks idea of
reserved areas becomes completely redundant and unnecessary since that
information is now tracked by the main kernel allocators.

It's useful to leave memblock reserved memory in place, because then you
have a picture at early kernel boot which you can then compare with the
page arrays, and see what's changed between early boot and the current
kernels state.  Yes, there is no code to dump out the page array - when
you realise that dumping the page array (which is 262144 entries per
gigabyte of memory) in some generic way becomes quite cumbersome.  The
array itself is around 8MB per gigabyte of memory.

If you want this information, it's probably best to write a custom debugfs
entry which scans the page array, and dumps the regions of reserved memory
(in other words, detects where the PG_reserved flag changes state between
two consecutive pages.)

With such a dump, you can then compare it with the memblock reserved
debugfs file, and check whether the initrd was properly freed, etc.  If
you dump it in the same format as the memblock reserved debugfs, you
can compare the two using diff(1).

The other advantage of this approach is that you're not asking lots of
places in the kernel to gain additional calls to change the state of
something that is never otherwise used.

-- 
FTTC broadband for 0.8mile line: currently at 9.5Mbps down 400kbps up
according to speedtest.net.
