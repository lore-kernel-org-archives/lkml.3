Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756736AbaJaI2r (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Oct 2014 04:28:47 -0400
Received: from [65.55.169.124] ([65.55.169.124]:50320 "EHLO
	na01-bl2-obe.outbound.protection.outlook.com"
	rhost-flags-FAIL-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751409AbaJaI2p (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Oct 2014 04:28:45 -0400
X-WSS-ID: 0NEAVGL-08-2HD-02
X-M-MSG: 
From: <suravee.suthikulpanit@amd.com>
To: <marc.zyngier@arm.com>, <mark.rutland@arm.com>, <jason@lakedaemon.net>,
        <tglx@linutronix.de>
CC: <Catalin.Marinas@arm.com>, <Will.Deacon@arm.com>, <liviu.dudau@arm.com>,
        <Harish.Kasiviswanathan@amd.com>,
        <linux-arm-kernel@lists.infradead.org>, <linux-pci@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-doc@vger.kernel.org>,
        <devicetree@vger.kernel.org>,
        "Suravee Suthikulpanit" <Suravee.Suthikulpanit@amd.com>,
        Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
Subject: [V9 PATCH 1/2] genirq: Add irq_chip_set_type_parent function
Date: Fri, 31 Oct 2014 03:26:29 -0500
Message-ID: <1414743990-28421-2-git-send-email-suravee.suthikulpanit@amd.com>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1414743990-28421-1-git-send-email-suravee.suthikulpanit@amd.com>
References: <1414743990-28421-1-git-send-email-suravee.suthikulpanit@amd.com>
MIME-Version: 1.0
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:165.204.84.222;CTRY:US;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10019020)(6009001)(428002)(199003)(189002)(33646002)(88136002)(89996001)(76176999)(50986999)(76482002)(85306004)(92726001)(102836001)(85852003)(101416001)(50226001)(87936001)(87286001)(50466002)(31966008)(48376002)(36756003)(106466001)(229853001)(105586002)(46102003)(20776003)(95666004)(99396003)(64706001)(47776003)(80022003)(120916001)(53416004)(107046002)(77156001)(68736004)(97736003)(84676001)(4396001)(2201001)(104166001)(92566001)(62966002)(86152002)(19580405001)(19580395003)(44976005)(21056001)(86362001)(93916002)(77096002);DIR:OUT;SFP:1102;SCL:1;SRVR:BN1PR02MB197;H:atltwp02.amd.com;FPR:;MLV:sfv;PTR:InfoDomainNonexistent;A:1;MX:1;LANG:;
X-Microsoft-Antispam: UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:BN1PR02MB197;
X-Forefront-PRVS: 03818C953D
Authentication-Results: spf=none (sender IP is 165.204.84.222)
 smtp.mailfrom=Suravee.Suthikulpanit@amd.com; 
X-OriginatorOrg: amd4.onmicrosoft.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Suravee Suthikulpanit <Suravee.Suthikulpanit@amd.com>

Add a helper function to set irq type in parent irq domain.

Signed-off-by: Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
---
 include/linux/irq.h |  1 +
 kernel/irq/chip.c   | 10 ++++++++++
 2 files changed, 11 insertions(+)

diff --git a/include/linux/irq.h b/include/linux/irq.h
index 6159256..e3952fa 100644
--- a/include/linux/irq.h
+++ b/include/linux/irq.h
@@ -440,6 +440,7 @@ extern void irq_chip_ack_parent(struct irq_data *data);
 extern void irq_chip_mask_parent(struct irq_data *data);
 extern void irq_chip_unmask_parent(struct irq_data *data);
 extern void irq_chip_eoi_parent(struct irq_data *data);
+extern int irq_chip_set_type_parent(struct irq_data *data, unsigned int type);
 extern int irq_chip_set_affinity_parent(struct irq_data *data,
 				const struct cpumask *dest, bool force);
 extern int irq_chip_retrigger_hierarchy(struct irq_data *data);
diff --git a/kernel/irq/chip.c b/kernel/irq/chip.c
index 0ecc270..b24eca3 100644
--- a/kernel/irq/chip.c
+++ b/kernel/irq/chip.c
@@ -847,6 +847,16 @@ void irq_chip_eoi_parent(struct irq_data *data)
 	data->chip->irq_eoi(data);
 }
 
+int irq_chip_set_type_parent(struct irq_data *data, unsigned int type)
+{
+	data = data->parent_data;
+
+	if (data->chip && data->chip->irq_set_type)
+		return data->chip->irq_set_type(data, type);
+
+	return -ENOSYS;
+}
+
 int irq_chip_set_affinity_parent(struct irq_data *data,
 				 const struct cpumask *dest, bool force)
 {
-- 
1.9.3

