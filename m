Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756123AbaIZO5W (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Sep 2014 10:57:22 -0400
Received: from mga14.intel.com ([192.55.52.115]:48078 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754654AbaIZO5Q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Sep 2014 10:57:16 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,604,1406617200"; 
   d="scan'208";a="597292665"
From: Jiang Liu <jiang.liu@linux.intel.com>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Randy Dunlap <rdunlap@infradead.org>, Yinghai Lu <yinghai@kernel.org>,
        Borislav Petkov <bp@alien8.de>, Grant Likely <grant.likely@linaro.org>
Cc: Jiang Liu <jiang.liu@linux.intel.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Tony Luck <tony.luck@intel.com>, Joerg Roedel <joro@8bytes.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>, x86@kernel.org,
        linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org,
        linux-acpi@vger.kernel.org
Subject: [RFC v1 24/28] x86, irq: Kill unused alloc_irq_and_cfg_at()
Date: Fri, 26 Sep 2014 22:57:54 +0800
Message-Id: <1411743478-31435-25-git-send-email-jiang.liu@linux.intel.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1411743478-31435-1-git-send-email-jiang.liu@linux.intel.com>
References: <1411743478-31435-1-git-send-email-jiang.liu@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There's no caller of alloc_irq_and_cfg_at() anymore, so kill it.

Signed-off-by: Jiang Liu <jiang.liu@linux.intel.com>
---
 arch/x86/include/asm/hw_irq.h |    1 -
 arch/x86/kernel/apic/vector.c |   21 ---------------------
 2 files changed, 22 deletions(-)

diff --git a/arch/x86/include/asm/hw_irq.h b/arch/x86/include/asm/hw_irq.h
index 4e46427f7945..9f8436fb3770 100644
--- a/arch/x86/include/asm/hw_irq.h
+++ b/arch/x86/include/asm/hw_irq.h
@@ -178,7 +178,6 @@ extern void copy_irq_alloc_info(struct irq_alloc_info *dst,
 				struct irq_alloc_info *src);
 extern struct irq_cfg *irq_cfg(unsigned int irq);
 extern struct irq_cfg *irqd_cfg(struct irq_data *irq_data);
-extern struct irq_cfg *alloc_irq_and_cfg_at(unsigned int at, int node);
 extern void lock_vector_lock(void);
 extern void unlock_vector_lock(void);
 extern int assign_irq_vector(int, struct irq_cfg *, const struct cpumask *);
diff --git a/arch/x86/kernel/apic/vector.c b/arch/x86/kernel/apic/vector.c
index 89a57f3e353c..f21820622edf 100644
--- a/arch/x86/kernel/apic/vector.c
+++ b/arch/x86/kernel/apic/vector.c
@@ -76,27 +76,6 @@ out_cfg:
 	return NULL;
 }
 
-struct irq_cfg *alloc_irq_and_cfg_at(unsigned int at, int node)
-{
-	int res = irq_alloc_desc_at(at, node);
-	struct irq_cfg *cfg;
-
-	if (res < 0) {
-		if (res != -EEXIST)
-			return NULL;
-		cfg = irq_cfg(at);
-		if (cfg)
-			return cfg;
-	}
-
-	cfg = alloc_irq_cfg(node);
-	if (cfg)
-		irq_set_chip_data(at, cfg);
-	else
-		irq_free_desc(at);
-	return cfg;
-}
-
 static void free_irq_cfg(struct irq_cfg *cfg)
 {
 	if (cfg) {
-- 
1.7.10.4

