Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754650AbaKZXVg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Nov 2014 18:21:36 -0500
Received: from terminus.zytor.com ([198.137.202.10]:59150 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754082AbaKZXVd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Nov 2014 18:21:33 -0500
Date: Wed, 26 Nov 2014 15:20:40 -0800
From: tip-bot for Jiang Liu <tipbot@zytor.com>
Message-ID: <tip-fef49a5184b8b0afea2f440393c23734a15064b7@git.kernel.org>
Cc: jroedel@suse.de, hpa@zytor.com, gregkh@linuxfoundation.org,
        konrad.wilk@oracle.com, tony.luck@intel.com, rjw@rjwysocki.net,
        tglx@linutronix.de, bhelgaas@google.com, benh@kernel.crashing.org,
        rdunlap@infradead.org, bp@alien8.de, linux-kernel@vger.kernel.org,
        joro@8bytes.org, jiang.liu@linux.intel.com, yinghai@kernel.org,
        mingo@kernel.org
Reply-To: hpa@zytor.com, konrad.wilk@oracle.com, gregkh@linuxfoundation.org,
        jroedel@suse.de, tony.luck@intel.com, rjw@rjwysocki.net,
        tglx@linutronix.de, bhelgaas@google.com, rdunlap@infradead.org,
        benh@kernel.crashing.org, linux-kernel@vger.kernel.org, bp@alien8.de,
        jiang.liu@linux.intel.com, joro@8bytes.org, mingo@kernel.org,
        yinghai@kernel.org
In-Reply-To: <1416901802-24211-31-git-send-email-jiang.liu@linux.intel.com>
References: <1416901802-24211-31-git-send-email-jiang.liu@linux.intel.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/apic] x86, irq: Kill unused alloc_irq_and_cfg_at()
Git-Commit-ID: fef49a5184b8b0afea2f440393c23734a15064b7
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  fef49a5184b8b0afea2f440393c23734a15064b7
Gitweb:     http://git.kernel.org/tip/fef49a5184b8b0afea2f440393c23734a15064b7
Author:     Jiang Liu <jiang.liu@linux.intel.com>
AuthorDate: Tue, 25 Nov 2014 15:49:54 +0800
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Wed, 26 Nov 2014 23:52:49 +0100

x86, irq: Kill unused alloc_irq_and_cfg_at()

There's no caller of alloc_irq_and_cfg_at() anymore, so kill it.

Signed-off-by: Jiang Liu <jiang.liu@linux.intel.com>
Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Cc: Tony Luck <tony.luck@intel.com>
Cc: Joerg Roedel <joro@8bytes.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Bjorn Helgaas <bhelgaas@google.com>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Rafael J. Wysocki <rjw@rjwysocki.net>
Cc: Randy Dunlap <rdunlap@infradead.org>
Cc: Yinghai Lu <yinghai@kernel.org>
Cc: Borislav Petkov <bp@alien8.de>
Link: http://lkml.kernel.org/r/1416901802-24211-31-git-send-email-jiang.liu@linux.intel.com
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Tested-by: Joerg Roedel <jroedel@suse.de>
---
 arch/x86/include/asm/hw_irq.h |  1 -
 arch/x86/kernel/apic/vector.c | 21 ---------------------
 2 files changed, 22 deletions(-)

diff --git a/arch/x86/include/asm/hw_irq.h b/arch/x86/include/asm/hw_irq.h
index 1ce5f81..a88f5b3 100644
--- a/arch/x86/include/asm/hw_irq.h
+++ b/arch/x86/include/asm/hw_irq.h
@@ -186,7 +186,6 @@ extern void copy_irq_alloc_info(struct irq_alloc_info *dst,
 				struct irq_alloc_info *src);
 extern struct irq_cfg *irq_cfg(unsigned int irq);
 extern struct irq_cfg *irqd_cfg(struct irq_data *irq_data);
-extern struct irq_cfg *alloc_irq_and_cfg_at(unsigned int at, int node);
 extern void lock_vector_lock(void);
 extern void unlock_vector_lock(void);
 extern int assign_irq_vector(int, struct irq_cfg *, const struct cpumask *);
diff --git a/arch/x86/kernel/apic/vector.c b/arch/x86/kernel/apic/vector.c
index 91a8950..8467ca4 100644
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
