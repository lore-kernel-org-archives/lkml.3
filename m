Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757382AbbA0DHo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Jan 2015 22:07:44 -0500
Received: from mail-pd0-f171.google.com ([209.85.192.171]:36597 "EHLO
	mail-pd0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751998AbbA0DHn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Jan 2015 22:07:43 -0500
From: Chen Baozi <baozich@gmail.com>
To: linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org, Marc Zyngier <marc.zyngier@arm.com>,
        Chen Baozi <chenbaozi@kylinos.com.cn>
Subject: [PATCH] irqchip: GICv3: ITS: Allocate enough memory for the full range of DeviceID
Date: Tue, 27 Jan 2015 03:06:01 +0000
Message-Id: <1422327961-19733-1-git-send-email-baozich@gmail.com>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The ITS table allocator is only allocating a single page per table.
This works fine for most things, but leads to silent lack of
interrupt delivery if we end-up with a device that has an ID that is
out of the range defined by a single page of memory. Even worse, depending
on the page size, behaviour changes, which is not a very good experience.

A solution is actually to allocate memory for the full range of ID that
the ITS supports. A massive waste memory wise, but at least a safe bet.

This patch has been tested on the Phytium SoC.

Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
Signed-off-by: Chen Baozi <chenbaozi@kylinos.com.cn>
---
 drivers/irqchip/irq-gic-v3-its.c   | 25 +++++++++++++++++++++----
 include/linux/irqchip/arm-gic-v3.h |  2 ++
 2 files changed, 23 insertions(+), 4 deletions(-)

diff --git a/drivers/irqchip/irq-gic-v3-its.c b/drivers/irqchip/irq-gic-v3-its.c
index 86e4684..d7a3d36 100644
--- a/drivers/irqchip/irq-gic-v3-its.c
+++ b/drivers/irqchip/irq-gic-v3-its.c
@@ -806,14 +806,31 @@ static int its_alloc_tables(struct its_node *its)
 		u64 val = readq_relaxed(its->base + GITS_BASER + i * 8);
 		u64 type = GITS_BASER_TYPE(val);
 		u64 entry_size = GITS_BASER_ENTRY_SIZE(val);
+		int order = 0;
+		int alloc_size;
 		u64 tmp;
 		void *base;
 
 		if (type == GITS_BASER_TYPE_NONE)
 			continue;
 
-		/* We're lazy and only allocate a single page for now */
-		base = (void *)get_zeroed_page(GFP_KERNEL);
+		/*
+		 * Allocate as many entries as required to fit the
+		 * range of device IDs that the ITS can grok... The ID
+		 * space being incredibly sparse, this results in a
+		 * massive waste of memory.
+		 *
+		 * For other tables, only allocate a single page.
+		 */
+		if (type == GITS_BASER_TYPE_DEVICE) {
+			u64 typer = readq_relaxed(its->base + GITS_TYPER);
+			u32 ids = GITS_TYPER_DEVBITS(typer);
+
+			order = get_order((1UL << ids) * entry_size);
+		}
+
+		alloc_size = (1 << order) * PAGE_SIZE;
+		base = (void *)__get_free_pages(GFP_KERNEL | __GFP_ZERO, order);
 		if (!base) {
 			err = -ENOMEM;
 			goto out_free;
@@ -841,7 +858,7 @@ retry_baser:
 			break;
 		}
 
-		val |= (PAGE_SIZE / psz) - 1;
+		val |= (alloc_size / psz) - 1;
 
 		writeq_relaxed(val, its->base + GITS_BASER + i * 8);
 		tmp = readq_relaxed(its->base + GITS_BASER + i * 8);
@@ -882,7 +899,7 @@ retry_baser:
 		}
 
 		pr_info("ITS: allocated %d %s @%lx (psz %dK, shr %d)\n",
-			(int)(PAGE_SIZE / entry_size),
+			(int)(alloc_size / entry_size),
 			its_base_type_string[type],
 			(unsigned long)virt_to_phys(base),
 			psz / SZ_1K, (int)shr >> GITS_BASER_SHAREABILITY_SHIFT);
diff --git a/include/linux/irqchip/arm-gic-v3.h b/include/linux/irqchip/arm-gic-v3.h
index 1e8b0cf..7cf8d40 100644
--- a/include/linux/irqchip/arm-gic-v3.h
+++ b/include/linux/irqchip/arm-gic-v3.h
@@ -132,6 +132,8 @@
 #define GITS_BASER			0x0100
 #define GITS_PIDR2			GICR_PIDR2
 
+#define GITS_TYPER_DEVBITS_SHIFT	13
+#define GITS_TYPER_DEVBITS(r)		((((r) >> GITS_TYPER_DEVBITS_SHIFT) & 0x1f) + 1)
 #define GITS_TRANSLATER			0x10040
 
 #define GITS_TYPER_PTA			(1UL << 19)
-- 
2.1.4

