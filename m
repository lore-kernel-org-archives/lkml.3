Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753961AbaKCVQm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Nov 2014 16:16:42 -0500
Received: from mail-bn1bbn0105.outbound.protection.outlook.com ([157.56.111.105]:44624
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752538AbaKCVQg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Nov 2014 16:16:36 -0500
X-WSS-ID: 0NEHF3G-07-TZ8-02
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
Subject: [V10 PATCH 1/2] genirq: Add irq_chip_set_type_parent function
Date: Mon, 3 Nov 2014 16:16:16 -0600
Message-ID: <1415052977-26036-2-git-send-email-suravee.suthikulpanit@amd.com>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1415052977-26036-1-git-send-email-suravee.suthikulpanit@amd.com>
References: <1415052977-26036-1-git-send-email-suravee.suthikulpanit@amd.com>
MIME-Version: 1.0
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:165.204.84.221;CTRY:US;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10019020)(6009001)(428002)(189002)(199003)(50986999)(76176999)(20776003)(47776003)(36756003)(50226001)(86362001)(89996001)(4396001)(88136002)(93916002)(77096003)(77156002)(87936001)(97736003)(87286001)(229853001)(84676001)(50466002)(44976005)(19580405001)(19580395003)(68736004)(21056001)(104166001)(102836001)(95666004)(106466001)(105586002)(2201001)(86152002)(64706001)(107046002)(31966008)(92726001)(53416004)(48376002)(33646002)(99396003)(120916001)(62966003)(92566001)(46102003)(101416001);DIR:OUT;SFP:1102;SCL:1;SRVR:BLUPR02MB195;H:atltwp01.amd.com;FPR:;MLV:sfv;PTR:InfoDomainNonexistent;MX:1;A:1;LANG:;
X-Microsoft-Antispam: UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:BLUPR02MB195;
X-Exchange-Antispam-Report-Test: UriScan:;
X-Forefront-PRVS: 0384275935
Authentication-Results: spf=none (sender IP is 165.204.84.221)
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

