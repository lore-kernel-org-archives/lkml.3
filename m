Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932950AbaHEJT4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Aug 2014 05:19:56 -0400
Received: from mail-la0-f44.google.com ([209.85.215.44]:63296 "EHLO
	mail-la0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932935AbaHEJTy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Aug 2014 05:19:54 -0400
From: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org,
        Grant Likely <grant.likely@linaro.org>, Rob Herring <robh@kernel.org>,
        Michal Simek <monstr@monstr.eu>, Tony Lindgren <tony@atomide.com>,
        linux-kernel@vger.kernel.org
Cc: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
Subject: [PATCH] x86/devicetree: Fix compile warnings on AMD64
Date: Tue,  5 Aug 2014 11:19:48 +0200
Message-Id: <1407230388-14211-1-git-send-email-ricardo.ribalda@gmail.com>
X-Mailer: git-send-email 2.0.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

arch/x86/kernel/devicetree.c: In function ‘ioapic_xlate’:
arch/x86/kernel/devicetree.c:294:8: warning: cast from pointer to integer of different size [-Wpointer-to-int-cast]
  idx = (__force u32) domain->host_data;
        ^
arch/x86/kernel/devicetree.c: In function ‘dt_add_ioapic_domain’:
arch/x86/kernel/devicetree.c:323:4: warning: cast to pointer from integer of different size [-Wint-to-pointer-cast]
    (void *)ioapic_num);

Signed-off-by: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
---
 arch/x86/kernel/devicetree.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kernel/devicetree.c b/arch/x86/kernel/devicetree.c
index 7db54b5..a481d1b 100644
--- a/arch/x86/kernel/devicetree.c
+++ b/arch/x86/kernel/devicetree.c
@@ -278,7 +278,8 @@ static int ioapic_xlate(struct irq_domain *domain,
 {
 	struct io_apic_irq_attr attr;
 	struct of_ioapic_type *it;
-	u32 line, idx;
+	u32 line;
+	unsigned long idx;
 	int rc;
 
 	if (WARN_ON(intsize < 2))
@@ -291,7 +292,7 @@ static int ioapic_xlate(struct irq_domain *domain,
 
 	it = &of_ioapic_type[intspec[1]];
 
-	idx = (u32) domain->host_data;
+	idx = (unsigned long) domain->host_data;
 	set_io_apic_irq_attr(&attr, idx, line, it->trigger, it->polarity);
 
 	rc = io_apic_setup_irq_pin_once(irq_find_mapping(domain, line),
@@ -320,7 +321,7 @@ static void dt_add_ioapic_domain(unsigned int ioapic_num,
 	num = gsi_cfg->gsi_end - gsi_cfg->gsi_base + 1;
 
 	id = irq_domain_add_linear(np, num, &ioapic_irq_domain_ops,
-			(void *)ioapic_num);
+			(void *)((unsigned long)ioapic_num));
 	BUG_ON(!id);
 	if (gsi_cfg->gsi_base == 0) {
 		/*
-- 
2.0.1

