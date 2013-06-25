Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751082Ab3FYLaW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Jun 2013 07:30:22 -0400
Received: from service87.mimecast.com ([91.220.42.44]:53167 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750771Ab3FYLaU convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Jun 2013 07:30:20 -0400
Message-ID: <51C97F40.5030101@arm.com>
Date: Tue, 25 Jun 2013 12:30:08 +0100
From: Jonathan Austin <jonathan.austin@arm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130308 Thunderbird/17.0.4
MIME-Version: 1.0
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
CC: Vinod Koul <vinod.koul@intel.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Steve Capper <Steve.Capper@arm.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will.deacon@arm.com>, linus.walleij@linaro.org,
        Al Viro <viro@zeniv.linux.org.uk>
Subject: amba-pl08x and 'get_signal' namespace collision/build error
X-OriginalArrivalTime: 25 Jun 2013 11:30:15.0754 (UTC) FILETIME=[5D2CCAA0:01CE7197]
X-MC-Unique: 113062512301800201
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

There's a patch making its way to mainline via Russell's tree
(8d96250700: ARM: mm: Transparent huge page support for LPAE systems)
that breaks the build of the amba-pl08x driver (drivers/dma/amba-pl08x.c) 
because the 'get_signal' macro from include/linux/signal.h is now in the
driver's scope and it clobbers a (previously) valid function call.

The error:
drivers/dma/amba-pl08x.c: In function ‘pl08x_request_mux’:
drivers/dma/amba-pl08x.c:303:13: error: expected identifier before ‘(’ token

Here's the problematic include:
In file included from include/linux/sched.h:32:0,
--new include--> from /data/build/a32/linux/arch/arm/include/asm/tlbflush.h:204,
                 from /data/build/a32/linux/arch/arm/include/asm/pgtable.h:28,
                 from include/linux/mm.h:44,
                 from include/linux/scatterlist.h:6,
                 from include/linux/dmaengine.h:27,
                 from include/linux/amba/pl08x.h:21,
                 from drivers/dma/amba-pl08x.c:74:
include/linux/signal.h:298:2: error: #error get_signal defined here

Below is a 'fix' that *doesn't* require any renaming of either the
get_signal function or macro, but there's nothing to say that driver
shouldn't be able to use the pl08x_platform_data struct *and* do
scheduling so this doesn't seem like the best fix really.

So can we do something better?

Al: the commit where you add the get_signal() helper suggests you want
to make it a function not a macro in the future - what needs to be done
before that can happen? I think that would be the best/easiest fix.


Jonny

----------8<-----------
diff --git a/arch/arm/include/asm/tlbflush.h b/arch/arm/include/asm/tlbflush.h
index c78efbc..ce1185c 100644
--- a/arch/arm/include/asm/tlbflush.h
+++ b/arch/arm/include/asm/tlbflush.h
@@ -201,7 +201,10 @@
 
 #ifndef __ASSEMBLY__
 
-#include <linux/sched.h>
+#include <linux/smp.h>
+#include <linux/mm_types.h>
+
+#include <asm/barrier.h>
 
 struct cpu_tlb_fns {
        void (*flush_user_range)(unsigned long, unsigned long, struct vm_area_struct *);
diff --git a/arch/arm/kernel/suspend.c b/arch/arm/kernel/suspend.c
index 38a5067..3100983 100644
--- a/arch/arm/kernel/suspend.c
+++ b/arch/arm/kernel/suspend.c
@@ -1,4 +1,5 @@
 #include <linux/init.h>
+#include <linux/sched.h>
 
 #include <asm/idmap.h>
 #include <asm/pgalloc.h>
diff --git a/arch/arm/mm/idmap.c b/arch/arm/mm/idmap.c
index 83cb3ac..304e8ce 100644
--- a/arch/arm/mm/idmap.c
+++ b/arch/arm/mm/idmap.c
@@ -1,6 +1,7 @@
 #include <linux/module.h>
 #include <linux/kernel.h>
 #include <linux/slab.h>
+#include <linux/sched.h>
 
 #include <asm/cputype.h>
 #include <asm/idmap.h>
diff --git a/arch/arm/mm/mm.h b/arch/arm/mm/mm.h
index d5a4e9a..6eeaf3d 100644
--- a/arch/arm/mm/mm.h
+++ b/arch/arm/mm/mm.h
@@ -1,6 +1,7 @@
 #ifdef CONFIG_MMU
 #include <linux/list.h>
 #include <linux/vmalloc.h>
+#include <linux/sched.h>
 
 /* the upper-most page table pointer */
 extern pmd_t *top_pmd;



