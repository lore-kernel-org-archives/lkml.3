Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758577AbaFUVQA (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Jun 2014 17:16:00 -0400
Received: from terminus.zytor.com ([198.137.202.10]:35933 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758542AbaFUVP6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Jun 2014 17:15:58 -0400
Date: Sat, 21 Jun 2014 14:14:58 -0700
From: tip-bot for Jiang Liu <tipbot@zytor.com>
Message-ID: <tip-74501edcd846830bec86bfa06c47c25083e70ffc@git.kernel.org>
Cc: mingo@kernel.org, konrad.wilk@oracle.com, rdunlap@infradead.org,
        tony.luck@intel.com, gregkh@linuxfoundation.org, tglx@linutronix.de,
        hpa@zytor.com, jiang.liu@linux.intel.com, grant.likely@linaro.org,
        linux-kernel@vger.kernel.org, yinghai@kernel.org, joro@8bytes.org,
        benh@kernel.crashing.org, bhelgaas@google.com, rjw@rjwysocki.net,
        paul.gortmaker@windriver.com
Reply-To: mingo@kernel.org, konrad.wilk@oracle.com, rdunlap@infradead.org,
        tony.luck@intel.com, gregkh@linuxfoundation.org, tglx@linutronix.de,
        hpa@zytor.com, jiang.liu@linux.intel.com, grant.likely@linaro.org,
        linux-kernel@vger.kernel.org, yinghai@kernel.org, joro@8bytes.org,
        benh@kernel.crashing.org, bhelgaas@google.com, rjw@rjwysocki.net,
        paul.gortmaker@windriver.com
In-Reply-To: <1402302011-23642-27-git-send-email-jiang.liu@linux.intel.com>
References: <1402302011-23642-27-git-send-email-jiang.liu@linux.intel.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/apic] x86, mpparse, irq: Provide basic irqdomain support
Git-Commit-ID: 74501edcd846830bec86bfa06c47c25083e70ffc
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

Commit-ID:  74501edcd846830bec86bfa06c47c25083e70ffc
Gitweb:     http://git.kernel.org/tip/74501edcd846830bec86bfa06c47c25083e70ffc
Author:     Jiang Liu <jiang.liu@linux.intel.com>
AuthorDate: Mon, 9 Jun 2014 16:19:55 +0800
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Sat, 21 Jun 2014 23:05:43 +0200

x86, mpparse, irq: Provide basic irqdomain support

Enhance mpparse to provide basic support of irqdomain.

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
Link: http://lkml.kernel.org/r/1402302011-23642-27-git-send-email-jiang.liu@linux.intel.com
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 arch/x86/kernel/mpparse.c | 10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kernel/mpparse.c b/arch/x86/kernel/mpparse.c
index ea8595e..13c8e1f 100644
--- a/arch/x86/kernel/mpparse.c
+++ b/arch/x86/kernel/mpparse.c
@@ -19,6 +19,7 @@
 #include <linux/module.h>
 #include <linux/smp.h>
 #include <linux/pci.h>
+#include <linux/irqdomain.h>
 
 #include <asm/mtrr.h>
 #include <asm/mpspec.h>
@@ -112,10 +113,17 @@ static void __init MP_bus_info(struct mpc_bus *m)
 		pr_warn("Unknown bustype %s - ignoring\n", str);
 }
 
+static struct irq_domain_ops mp_ioapic_irqdomain_ops;
+
 static void __init MP_ioapic_info(struct mpc_ioapic *m)
 {
+	struct ioapic_domain_cfg cfg = {
+		.type = IOAPIC_DOMAIN_LEGACY,
+		.ops = &mp_ioapic_irqdomain_ops,
+	};
+
 	if (m->flags & MPC_APIC_USABLE)
-		mp_register_ioapic(m->apicid, m->apicaddr, gsi_top, NULL);
+		mp_register_ioapic(m->apicid, m->apicaddr, gsi_top, &cfg);
 }
 
 static void __init print_mp_irq_info(struct mpc_intsrc *mp_irq)
