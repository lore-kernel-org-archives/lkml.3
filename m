Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755549Ab3CDDmo (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Mar 2013 22:42:44 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:60806 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755504Ab3CDDmm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Mar 2013 22:42:42 -0500
Message-Id: <20130304033709.432302392@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Mon, 04 Mar 2013 03:37:26 +0000
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: akpm@linux-foundation.org, Dave Hansen <dave@linux.vnet.ibm.com>,
        "H. Peter Anvin" <hpa@linux.intel.com>
Subject: [ 019/153] x86-32, mm: Rip out x86_32 NUMA remapping code
In-Reply-To: <20130304033707.648729212@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:a11:96ff:fec6:70c4
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dave Hansen <dave@linux.vnet.ibm.com>

commit f03574f2d5b2d6229dcdf2d322848065f72953c7 upstream.

This code was an optimization for 32-bit NUMA systems.

It has probably been the cause of a number of subtle bugs over
the years, although the conditions to excite them would have
been hard to trigger.  Essentially, we remap part of the kernel
linear mapping area, and then sometimes part of that area gets
freed back in to the bootmem allocator.  If those pages get
used by kernel data structures (say mem_map[] or a dentry),
there's no big deal.  But, if anyone ever tried to use the
linear mapping for these pages _and_ cared about their physical
address, bad things happen.

For instance, say you passed __GFP_ZERO to the page allocator
and then happened to get handed one of these pages, it zero the
remapped page, but it would make a pte to the _old_ page.
There are probably a hundred other ways that it could screw
with things.

We don't need to hang on to performance optimizations for
these old boxes any more.  All my 32-bit NUMA systems are long
dead and buried, and I probably had access to more than most
people.

This code is causing real things to break today:

	https://lkml.org/lkml/2013/1/9/376

I looked in to actually fixing this, but it requires surgery
to way too much brittle code, as well as stuff like
per_cpu_ptr_to_phys().

[ hpa: Cc: this for -stable, since it is a memory corruption issue.
  However, an alternative is to simply mark NUMA as depends BROKEN
  rather than EXPERIMENTAL in the X86_32 subclause... ]

Link: http://lkml.kernel.org/r/20130131005616.1C79F411@kernel.stglabs.ibm.com
Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
[bwh: For 3.2, using the suggested alternative]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---

--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -1150,7 +1150,7 @@ config DIRECT_GBPAGES
 config NUMA
 	bool "Numa Memory Allocation and Scheduler Support"
 	depends on SMP
-	depends on X86_64 || (X86_32 && HIGHMEM64G && (X86_NUMAQ || X86_BIGSMP || X86_SUMMIT && ACPI) && EXPERIMENTAL)
+	depends on X86_64 || (X86_32 && HIGHMEM64G && (X86_NUMAQ || X86_BIGSMP || X86_SUMMIT && ACPI) && BROKEN)
 	default y if (X86_NUMAQ || X86_SUMMIT || X86_BIGSMP)
 	---help---
 	  Enable NUMA (Non Uniform Memory Access) support.


