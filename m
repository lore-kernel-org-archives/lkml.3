Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757098AbaKUBCp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Nov 2014 20:02:45 -0500
Received: from mail-bl2on0145.outbound.protection.outlook.com ([65.55.169.145]:15434
	"EHLO na01-bl2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756487AbaKUBCn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Nov 2014 20:02:43 -0500
X-WSS-ID: 0NFD6WD-07-QQW-02
X-M-MSG: 
From: <suravee.suthikulpanit@amd.com>
To: <jiang.liu@linux.intel.com>, <tglx@linutronix.de>
CC: <marc.zyngier@arm.com>, <linux-arm-kernel@lists.infradead.org>,
        <linux-pci@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        "Suravee Suthikulpanit" <Suravee.Suthikulpanit@amd.com>
Subject: [PATCH] irqdomain: Fix NULL pointer dererence in irq_domain_free_irqs_parent
Date: Thu, 20 Nov 2014 19:02:25 -0600
Message-ID: <1416531745-24661-1-git-send-email-suravee.suthikulpanit@amd.com>
X-Mailer: git-send-email 1.9.3
MIME-Version: 1.0
Content-Type: text/plain
X-EOPAttributedMessage: 0
Authentication-Results: spf=none (sender IP is 165.204.84.221)
 smtp.mailfrom=Suravee.Suthikulpanit@amd.com; 
X-Forefront-Antispam-Report: CIP:165.204.84.221;CTRY:US;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10019020)(6009001)(428002)(199003)(189002)(46102003)(95666004)(106466001)(120916001)(33646002)(97736003)(62966003)(77096003)(53416004)(64706001)(105586002)(77156002)(93916002)(107046002)(4396001)(20776003)(86362001)(50226001)(87286001)(92726001)(229853001)(47776003)(36756003)(99396003)(21056001)(84676001)(50986999)(88136002)(89996001)(68736004)(50466002)(86152002)(92566001)(101416001)(19580405001)(102836001)(104166001)(44976005)(19580395003)(48376002)(87936001)(31966008);DIR:OUT;SFP:1102;SCL:1;SRVR:BY2PR02MB201;H:atltwp01.amd.com;FPR:;MLV:sfv;PTR:InfoDomainNonexistent;A:1;MX:1;LANG:en;
X-Microsoft-Antispam: UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:BY2PR02MB201;
X-Exchange-Antispam-Report-Test: UriScan:;
X-Exchange-Antispam-Report-CFA-Test: BCL:0;PCL:0;RULEID:;SRVR:BY2PR02MB201;
X-Forefront-PRVS: 0402872DA1
X-Exchange-Antispam-Report-CFA-Test: BCL:0;PCL:0;RULEID:;SRVR:BY2PR02MB201;
X-OriginatorOrg: amd4.onmicrosoft.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Suravee Suthikulpanit <Suravee.Suthikulpanit@amd.com>

This patch checks if the parent domain is NULL before recursively freeing
irqs in the parent domains.

In this case, GICv2m is freeing irqs in parent (GIC), which calls
irq_domain_free_irqs_top. This fixes the crash below:

Unble to handle kernel NULL pointer dereference at virtual address 00000018
pgd = fffffe03c78c0000
[00000018] *pgd=00000083c8700003, *pud=00000083c8700003, *pmd=00000083c8700003, *pte=0000000000000000
Internal error: Oops: 96000007 [#1] SMP
Modules linked in: mlx4_core(-) rtc_efi efivarfs [last unloaded: mlx4_en]
CPU: 5 PID: 985 Comm: modprobe Not tainted 3.18.0-rc4-marc-v2m+ #223
task: fffffe03c20c0000 ti: fffffe03c1fb8000 task.ti: fffffe03c1fb8000
PC is at irq_domain_free_irqs_recursive+0x10/0x84
LR is at irq_domain_free_irqs_common+0x8c/0xa0
pc : [<fffffe00000efb2c>] lr : [<fffffe00000f028c>] pstate: 60000145
sp : fffffe03c1fbb9a0
x29: fffffe03c1fbb9a0 x28: fffffe03c1fb8000
x27: fffffe000092f000 x26: fffffe03c10eba00
...
Call trace:
[<fffffe00000efb2c>] irq_domain_free_irqs_recursive+0x10/0x84
[<fffffe00000f0288>] irq_domain_free_irqs_common+0x88/0xa0
[<fffffe00000f030c>] irq_domain_free_irqs_top+0x6c/0x84
[<fffffe00000efb40>] irq_domain_free_irqs_recursive+0x24/0x84
[<fffffe00000f0954>] irq_domain_free_irqs_parent+0x14/0x20
[<fffffe000042c4fc>] gicv2m_irq_domain_free+0x48/0x88
[<fffffe00000efb40>] irq_domain_free_irqs_recursive+0x24/0x84
[<fffffe00000f0288>] irq_domain_free_irqs_common+0x88/0xa0
[<fffffe00000f030c>] irq_domain_free_irqs_top+0x6c/0x84
[<fffffe00000f1a38>] msi_domain_free+0x74/0x8c
[<fffffe00000efb40>] irq_domain_free_irqs_recursive+0x24/0x84
[<fffffe00000f0898>] irq_domain_free_irqs+0x110/0x184
[<fffffe00000f2124>] msi_domain_free_irqs+0x28/0x4c
[<fffffe0000448194>] free_msi_irqs+0x90/0x1d8
[<fffffe0000449278>] pci_disable_msix+0x40/0x50

Signed-off-by: Suravee Suthikulpanit <Suravee.Suthikulpanit@amd.com>
---
 kernel/irq/irqdomain.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/kernel/irq/irqdomain.c b/kernel/irq/irqdomain.c
index 029acf1..4390eb8 100644
--- a/kernel/irq/irqdomain.c
+++ b/kernel/irq/irqdomain.c
@@ -1166,6 +1166,9 @@ int irq_domain_alloc_irqs_parent(struct irq_domain *domain,
 void irq_domain_free_irqs_parent(struct irq_domain *domain,
 				 unsigned int irq_base, unsigned int nr_irqs)
 {
+	if (!domain->parent)
+		return;
+
 	/* irq_domain_free_irqs_recursive() will call parent's free */
 	if (!irq_domain_is_auto_recursive(domain))
 		irq_domain_free_irqs_recursive(domain->parent, irq_base,
-- 
1.9.3

