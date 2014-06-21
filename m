Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758655AbaFUVRh (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Jun 2014 17:17:37 -0400
Received: from terminus.zytor.com ([198.137.202.10]:36059 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755610AbaFUVRe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Jun 2014 17:17:34 -0400
Date: Sat, 21 Jun 2014 14:16:28 -0700
From: tip-bot for Jiang Liu <tipbot@zytor.com>
Message-ID: <tip-795aacf63fee1bfe8b68fd5db4882576c5c0c570@git.kernel.org>
Cc: mingo@kernel.org, konrad.wilk@oracle.com, rdunlap@infradead.org,
        tony.luck@intel.com, gregkh@linuxfoundation.org, monstr@monstr.eu,
        tglx@linutronix.de, linux-kernel@vger.kernel.org, hpa@zytor.com,
        jiang.liu@linux.intel.com, grant.likely@linaro.org, yinghai@kernel.org,
        joro@8bytes.org, tony@atomide.com, rob.herring@calxeda.com,
        benh@kernel.crashing.org, bhelgaas@google.com, rjw@rjwysocki.net,
        paul.gortmaker@windriver.com
Reply-To: mingo@kernel.org, konrad.wilk@oracle.com, rdunlap@infradead.org,
        tony.luck@intel.com, gregkh@linuxfoundation.org, monstr@monstr.eu,
        tglx@linutronix.de, linux-kernel@vger.kernel.org, hpa@zytor.com,
        jiang.liu@linux.intel.com, grant.likely@linaro.org, yinghai@kernel.org,
        joro@8bytes.org, tony@atomide.com, rob.herring@calxeda.com,
        bhelgaas@google.com, benh@kernel.crashing.org, rjw@rjwysocki.net,
        paul.gortmaker@windriver.com
In-Reply-To: <1402302011-23642-34-git-send-email-jiang.liu@linux.intel.com>
References: <1402302011-23642-34-git-send-email-jiang.liu@linux.intel.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/apic] x86, irq, devicetree:
  Use common irqdomain map interface to program IOAPIC pins
Git-Commit-ID: 795aacf63fee1bfe8b68fd5db4882576c5c0c570
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

Commit-ID:  795aacf63fee1bfe8b68fd5db4882576c5c0c570
Gitweb:     http://git.kernel.org/tip/795aacf63fee1bfe8b68fd5db4882576c5c0c570
Author:     Jiang Liu <jiang.liu@linux.intel.com>
AuthorDate: Mon, 9 Jun 2014 16:20:02 +0800
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Sat, 21 Jun 2014 23:05:43 +0200

x86, irq, devicetree: Use common irqdomain map interface to program IOAPIC pins

Refine devicetree to use common irqdomain map interface to program
IOAPIC pins, so we can unify the callsite to progam IOAPIC pins.

Signed-off-by: Jiang Liu <jiang.liu@linux.intel.com>
Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Cc: Tony Luck <tony.luck@intel.com>
Cc: Joerg Roedel <joro@8bytes.org>
Cc: Paul Gortmaker <paul.gortmaker@windriver.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Grant Likely <grant.likely@linaro.org>
Cc: Rafael J. Wysocki <rjw@rjwysocki.net>
Cc: Bjorn Helgaas <bhelgaas@google.com>
Cc: Randy Dunlap <rdunlap@infradead.org>
Cc: Yinghai Lu <yinghai@kernel.org>
Cc: Rob Herring <rob.herring@calxeda.com>
Cc: Michal Simek <monstr@monstr.eu>
Cc: Tony Lindgren <tony@atomide.com>
Link: http://lkml.kernel.org/r/1402302011-23642-34-git-send-email-jiang.liu@linux.intel.com
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 arch/x86/kernel/devicetree.c | 14 +++++---------
 1 file changed, 5 insertions(+), 9 deletions(-)

diff --git a/arch/x86/kernel/devicetree.c b/arch/x86/kernel/devicetree.c
index ee26fec..f33bb43 100644
--- a/arch/x86/kernel/devicetree.c
+++ b/arch/x86/kernel/devicetree.c
@@ -201,10 +201,8 @@ static int ioapic_xlate(struct irq_domain *domain,
 			const u32 *intspec, u32 intsize,
 			irq_hw_number_t *out_hwirq, u32 *out_type)
 {
-	struct io_apic_irq_attr attr;
 	struct of_ioapic_type *it;
-	u32 line, idx;
-	int rc;
+	u32 line, idx, gsi;
 
 	if (WARN_ON(intsize < 2))
 		return -EINVAL;
@@ -217,12 +215,9 @@ static int ioapic_xlate(struct irq_domain *domain,
 	it = &of_ioapic_type[intspec[1]];
 
 	idx = (u32)(long)domain->host_data;
-	set_io_apic_irq_attr(&attr, idx, line, it->trigger, it->polarity);
-
-	rc = io_apic_setup_irq_pin_once(irq_find_mapping(domain, line),
-					cpu_to_node(0), &attr);
-	if (rc)
-		return rc;
+	gsi = mp_pin_to_gsi(idx, line);
+	if (mp_set_gsi_attr(gsi, it->trigger, it->polarity, cpu_to_node(0)))
+		return -EBUSY;
 
 	*out_hwirq = line;
 	*out_type = it->out_type;
@@ -230,6 +225,7 @@ static int ioapic_xlate(struct irq_domain *domain,
 }
 
 const struct irq_domain_ops ioapic_irq_domain_ops = {
+	.map = mp_irqdomain_map,
 	.xlate = ioapic_xlate,
 };
 
