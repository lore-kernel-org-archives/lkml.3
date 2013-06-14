Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753898Ab3FNUdH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Jun 2013 16:33:07 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:50861 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753633Ab3FNUdD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Jun 2013 16:33:03 -0400
From: Stephen Boyd <sboyd@codeaurora.org>
To: Russell King <linux@arm.linux.org.uk>
Cc: linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Rob Herring <rob.herring@calxeda.com>
Subject: [PATCH v2 2/2] ARM: mmu: Introduce iotable_init_caller()
Date: Fri, 14 Jun 2013 13:32:58 -0700
Message-Id: <1371241978-6224-2-git-send-email-sboyd@codeaurora.org>
X-Mailer: git-send-email 1.8.3.1.378.g9926f66
In-Reply-To: <1371241978-6224-1-git-send-email-sboyd@codeaurora.org>
References: <1371241978-6224-1-git-send-email-sboyd@codeaurora.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Now that debug_ll_io_init() maps memory via iotable_init() we
don't get much information in vmallocinfo about what the mapping
corresponds to. Introduce iotable_init_caller() that does the
same thing as iotable_init() except that it allows us to specify
the function that should appear in vmallocinfo. This allows us to
differentiate the debug_ll mapping from the other iotable_init()
mappings.

Cc: Rob Herring <rob.herring@calxeda.com>
Signed-off-by: Stephen Boyd <sboyd@codeaurora.org>
---

I'm ok without this patch. Using __builtin_return_address(0) seems
to do alright on framepointer builds but fails on unwind table
builds so I went with this approach.

 arch/arm/mm/mmu.c | 18 ++++++++++++------
 1 file changed, 12 insertions(+), 6 deletions(-)

diff --git a/arch/arm/mm/mmu.c b/arch/arm/mm/mmu.c
index 18b8aeb..0699bee 100644
--- a/arch/arm/mm/mmu.c
+++ b/arch/arm/mm/mmu.c
@@ -811,10 +811,8 @@ static void __init create_mapping(struct map_desc *md)
 	} while (pgd++, addr != end);
 }
 
-/*
- * Create the architecture specific mappings
- */
-void __init iotable_init(struct map_desc *io_desc, int nr)
+static void __init
+iotable_init_caller(struct map_desc *io_desc, int nr, void *caller)
 {
 	struct map_desc *md;
 	struct vm_struct *vm;
@@ -834,11 +832,19 @@ void __init iotable_init(struct map_desc *io_desc, int nr)
 		vm->phys_addr = __pfn_to_phys(md->pfn);
 		vm->flags = VM_IOREMAP | VM_ARM_STATIC_MAPPING;
 		vm->flags |= VM_ARM_MTYPE(md->type);
-		vm->caller = iotable_init;
+		vm->caller = caller;
 		add_static_vm_early(svm++);
 	}
 }
 
+/*
+ * Create the architecture specific mappings
+ */
+void __init iotable_init(struct map_desc *io_desc, int nr)
+{
+	iotable_init_caller(io_desc, nr, iotable_init);
+}
+
 void __init vm_reserve_area_early(unsigned long addr, unsigned long size,
 				  void *caller)
 {
@@ -947,7 +953,7 @@ void __init debug_ll_io_init(void)
 	map.virtual &= PAGE_MASK;
 	map.length = PAGE_SIZE;
 	map.type = MT_DEVICE;
-	iotable_init(&map, 1);
+	iotable_init_caller(&map, 1, debug_ll_io_init);
 }
 #endif
 
-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
hosted by The Linux Foundation

