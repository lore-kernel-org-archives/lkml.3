Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752585AbbANL5S (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jan 2015 06:57:18 -0500
Received: from mail-by2on0143.outbound.protection.outlook.com ([207.46.100.143]:26592
	"EHLO na01-by2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751789AbbANL5R (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jan 2015 06:57:17 -0500
From: Bogdan Purcareata <bogdan.purcareata@freescale.com>
To: <benh@kernel.crashing.org>
CC: <linuxppc-dev@lists.ozlabs.org>, <linux-kernel@vger.kernel.org>,
        "Bogdan Purcareata" <bogdan.purcareata@freescale.com>,
        Scott Wood <scottwood@freescale.com>
Subject: [PATCH] powerpc/mpic: Add DT option to skip readback after EOI
Date: Wed, 14 Jan 2015 11:57:02 +0000
Message-ID: <1421236622-29366-1-git-send-email-bogdan.purcareata@freescale.com>
X-Mailer: git-send-email 2.1.4
X-EOPAttributedMessage: 0
Authentication-Results: spf=fail (sender IP is 192.88.158.2)
 smtp.mailfrom=B43198@freescale.com; 
X-Forefront-Antispam-Report: CIP:192.88.158.2;CTRY:US;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10019020)(6009001)(339900001)(199003)(189002)(50986999)(97736003)(106466001)(81156004)(50466002)(48376002)(36756003)(46102003)(77156002)(62966003)(87936001)(92566002)(6806004)(47776003)(64706001)(19580395003)(105606002)(85426001)(19580405001)(69596002)(77096005)(110136001)(68736005)(229853001)(33646002)(2351001)(104016003)(50226001);DIR:OUT;SFP:1102;SCL:1;SRVR:BY2PR0301MB0725;H:az84smr01.freescale.net;FPR:;SPF:Fail;MLV:sfv;PTR:InfoDomainNonexistent;A:1;MX:1;LANG:en;
MIME-Version: 1.0
Content-Type: text/plain
X-DmarcAction-Test: None
X-Microsoft-Antispam: UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:(3005003);SRVR:BY2PR0301MB0725;
X-Exchange-Antispam-Report-Test: UriScan:;
X-Exchange-Antispam-Report-CFA-Test: BCL:0;PCL:0;RULEID:(601004);SRVR:BY2PR0301MB0725;
X-Forefront-PRVS: 04569283F9
X-Exchange-Antispam-Report-CFA-Test: BCL:0;PCL:0;RULEID:;SRVR:BY2PR0301MB0725;
X-OriginatorOrg: freescale.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Jan 2015 11:57:12.7151
 (UTC)
X-MS-Exchange-CrossTenant-Id: 710a03f5-10f6-4d38-9ff4-a80b81da590d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=710a03f5-10f6-4d38-9ff4-a80b81da590d;Ip=[192.88.158.2]
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY2PR0301MB0725
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The readback is necessary in order to handle PCI posted
writes, or when the MPIC is handling interrupts in a loop
(ppc_md.get_irq). Newer MPIC versions don't require this
readback. Leave the option configurable using a device
tree entry.

This saves a MMIO trap per interrupt.

Signed-off-by: Scott Wood <scottwood@freescale.com>
Signed-off-by: Bogdan Purcareata <bogdan.purcareata@freescale.com>
---
 Documentation/devicetree/bindings/powerpc/fsl/mpic.txt | 13 +++++++++++++
 arch/powerpc/include/asm/mpic.h                        |  2 ++
 arch/powerpc/sysdev/mpic.c                             |  8 +++++++-
 3 files changed, 22 insertions(+), 1 deletion(-)

diff --git a/Documentation/devicetree/bindings/powerpc/fsl/mpic.txt b/Documentation/devicetree/bindings/powerpc/fsl/mpic.txt
index dc57446..9789094 100644
--- a/Documentation/devicetree/bindings/powerpc/fsl/mpic.txt
+++ b/Documentation/devicetree/bindings/powerpc/fsl/mpic.txt
@@ -77,6 +77,19 @@ PROPERTIES
           in the global feature registers.  If specified, this field will
           override the value read from MPIC_GREG_FEATURE_LAST_SRC.
 
+  - mpic-eoi-no-readback
+      Usage: optional
+      Value type: <empty>
+      Definition: The presence of this property specifies that the
+          MPIC will not issue a readback when delivering the EOI for an
+          external interrupt. The readback operation is done by reading
+          the CPU WHOAMI register after writing to the CPU EOI register.
+          Originally, this was required due to the fact that the MPIC
+          operates at lower frequencies, or in scenarios where the MPIC
+          is connected through PCI with write posting. This is not the
+          case in an emulated environment (e.g. KVM guest), or in scenarios
+          where interrupts are not handled in a loop of get_irq() calls.
+
 INTERRUPT SPECIFIER DEFINITION
 
   Interrupt specifiers consists of 4 cells encoded as
diff --git a/arch/powerpc/include/asm/mpic.h b/arch/powerpc/include/asm/mpic.h
index 754f93d..e2a4146 100644
--- a/arch/powerpc/include/asm/mpic.h
+++ b/arch/powerpc/include/asm/mpic.h
@@ -386,6 +386,8 @@ extern struct bus_type mpic_subsys;
  * from the BRR1 register).
 */
 #define MPIC_FSL_HAS_EIMR		0x00010000
+/* Dont bother with readback after MPIC EOI */
+#define MPIC_EOI_NO_READBACK	0x00020000
 
 /* MPIC HW modification ID */
 #define MPIC_REGSET_MASK		0xf0000000
diff --git a/arch/powerpc/sysdev/mpic.c b/arch/powerpc/sysdev/mpic.c
index f3e8624..431f68e 100644
--- a/arch/powerpc/sysdev/mpic.c
+++ b/arch/powerpc/sysdev/mpic.c
@@ -656,7 +656,9 @@ static inline struct mpic * mpic_from_irq_data(struct irq_data *d)
 static inline void mpic_eoi(struct mpic *mpic)
 {
 	mpic_cpu_write(MPIC_INFO(CPU_EOI), 0);
-	(void)mpic_cpu_read(MPIC_INFO(CPU_WHOAMI));
+
+	if (!(mpic->flags & MPIC_EOI_NO_READBACK))
+		(void)mpic_cpu_read(MPIC_INFO(CPU_WHOAMI));
 }
 
 /*
@@ -1290,6 +1292,10 @@ struct mpic * __init mpic_alloc(struct device_node *node,
 		flags |= MPIC_SINGLE_DEST_CPU;
 	if (of_device_is_compatible(node, "fsl,mpic"))
 		flags |= MPIC_FSL | MPIC_LARGE_VECTORS;
+	if (of_get_property(node, "mpic-eoi-no-readback", NULL)) {
+		pr_debug("mpic: no readback activated");
+		flags |= MPIC_EOI_NO_READBACK;
+	}
 
 	mpic = kzalloc(sizeof(struct mpic), GFP_KERNEL);
 	if (mpic == NULL)
-- 
2.1.3

