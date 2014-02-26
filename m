Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752028AbaBZKCx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Feb 2014 05:02:53 -0500
Received: from relay6-d.mail.gandi.net ([217.70.183.198]:34646 "EHLO
	relay6-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750814AbaBZKCu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Feb 2014 05:02:50 -0500
X-Originating-IP: 50.43.14.201
Date: Wed, 26 Feb 2014 02:02:34 -0800
From: Josh Triplett <josh@joshtriplett.org>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: linux-next: build failure after merge of the final tree
 (akpm-current tree related)
Message-ID: <20140226100234.GA23064@thin>
References: <20140226191627.9adf3c8e1548e2016c16557c@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140226191627.9adf3c8e1548e2016c16557c@canb.auug.org.au>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 26, 2014 at 07:16:27PM +1100, Stephen Rothwell wrote:
> Hi all,
> 
> After merging the final tree, today's linux-next build (powerpc64
> allnoconfig) failed like this:
> 
> arch/powerpc/kernel/built-in.o: In function `.machine_check_queue_event':
> (.text+0x11260): undefined reference to `.irq_work_queue'
> 
> Caused (or exposed) (along with a lot of warnings) by commit 3dd6115cd60b
> ("kconfig: make allnoconfig disable options behind EMBEDDED and EXPERT")
> from the apm-current tree.

Pre-existing, just now triggerable with just "make allnoconfig" rather
than manually turning off other options (like PRINTK) that select
IRQ_WORK.  (One of the goals of that commit: get those options more
widely used and build-tested.)

The following (untested) patch *should* fix this:
----- 8< -----
>From 36a5b6c87292b6c5eeb390ed6dc6acbb8f0a3767 Mon Sep 17 00:00:00 2001
From: Josh Triplett <josh@joshtriplett.org>
Date: Wed, 26 Feb 2014 01:58:02 -0800
Subject: [PATCH] ppc: Make PPC_BOOK3S_64 select IRQ_WORK

arch/powerpc/kernel/mce.c, compiled in for PPC_BOOK3S_64, calls
functions only built when IRQ_WORK, so select it.  Fixes the following
build error:

arch/powerpc/kernel/built-in.o: In function `.machine_check_queue_event':
(.text+0x11260): undefined reference to `.irq_work_queue'

Reported-by: Stephen Rothwell <sfr@canb.auug.org.au>
Signed-off-by: Josh Triplett <josh@joshtriplett.org>
---
 arch/powerpc/platforms/Kconfig.cputype | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/powerpc/platforms/Kconfig.cputype b/arch/powerpc/platforms/Kconfig.cputype
index 434fda3..d9e2b19 100644
--- a/arch/powerpc/platforms/Kconfig.cputype
+++ b/arch/powerpc/platforms/Kconfig.cputype
@@ -73,6 +73,7 @@ config PPC_BOOK3S_64
 	select SYS_SUPPORTS_HUGETLBFS
 	select HAVE_ARCH_TRANSPARENT_HUGEPAGE if PPC_64K_PAGES
 	select ARCH_SUPPORTS_NUMA_BALANCING
+	select IRQ_WORK
 
 config PPC_BOOK3E_64
 	bool "Embedded processors"
-- 
1.9.0
