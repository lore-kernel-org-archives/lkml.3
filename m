Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754896AbbAWBKb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jan 2015 20:10:31 -0500
Received: from mail-by2on0105.outbound.protection.outlook.com ([207.46.100.105]:11956
	"EHLO na01-by2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751934AbbAWBKZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jan 2015 20:10:25 -0500
X-Greylist: delayed 1719 seconds by postgrey-1.27 at vger.kernel.org; Thu, 22 Jan 2015 20:10:25 EST
Date: Thu, 22 Jan 2015 19:05:06 -0600
From: Kim Phillips <kim.phillips@freescale.com>
To: Scott Wood <scottwood@freescale.com>
CC: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Wang Dongsheng <dongsheng.wang@freescale.com>,
        Anton Blanchard <anton@samba.org>,
        "Himangi Saraogi" <himangi774@gmail.com>,
        Aaron Sierra <asierra@xes-inc.com>, <linux-kernel@vger.kernel.org>,
        <linuxppc-dev@lists.ozlabs.org>
Subject: [PATCH v2] powerpc/fsl_pci: Fix pci stack build bug with FRAME_WARN
Message-ID: <20150122190506.9364df535c5db777ac85f909@freescale.com>
In-Reply-To: <1421973825.4961.253.camel@freescale.com>
References: <20150120140349.a7a9885065c241b555b91717@freescale.com>
	<1421800292.4961.215.camel@freescale.com>
	<20150121204844.fda3d4ab23a8226b6cdfdaf6@freescale.com>
	<1421895747.4961.232.camel@freescale.com>
	<20150122182056.cc3436bd90a6cbba70da538a@freescale.com>
	<1421973825.4961.253.camel@freescale.com>
Organization: Freescale Semiconductor, Inc.
X-Mailer: Sylpheed 3.2.0 (GTK+ 2.24.13; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-EOPAttributedMessage: 0
Authentication-Results: spf=fail (sender IP is 192.88.168.50)
 smtp.mailfrom=kim.phillips@freescale.com; lists.ozlabs.org; dkim=none
 (message not signed) header.d=none;lists.ozlabs.org; dmarc=permerror
 action=none header.from=freescale.com;
X-Forefront-Antispam-Report: CIP:192.88.168.50;CTRY:US;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10019020)(6009001)(50226001)(50466002)(93886004)(104016003)(106466001)(92566002)(76176999)(105606002)(36756003)(62966003)(87936001)(86362001)(77156002)(23726002)(6806004)(19580405001)(19580395003)(85426001)(46406003)(33646002)(110136001)(229853001)(50986999)(100306002)(46102003)(77096005)(2950100001);DIR:OUT;SFP:1102;SCL:1;SRVR:BY2PR0301MB0725;H:tx30smr01.am.freescale.net;FPR:;SPF:None;MLV:sfv;LANG:en;
X-DmarcAction-Test: None
X-Microsoft-Antispam: UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:(3005004);SRVR:BY2PR0301MB0725;
X-Exchange-Antispam-Report-Test: UriScan:;
X-Exchange-Antispam-Report-CFA-Test: BCL:0;PCL:0;RULEID:(601004);SRVR:BY2PR0301MB0725;
X-Forefront-PRVS: 0465429B7F
X-Exchange-Antispam-Report-CFA-Test: BCL:0;PCL:0;RULEID:;SRVR:BY2PR0301MB0725;
X-OriginatorOrg: freescale.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Jan 2015 01:10:21.9577
 (UTC)
X-MS-Exchange-CrossTenant-Id: 710a03f5-10f6-4d38-9ff4-a80b81da590d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=710a03f5-10f6-4d38-9ff4-a80b81da590d;Ip=[192.88.168.50]
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY2PR0301MB0725
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix this:

  CC      arch/powerpc/sysdev/fsl_pci.o
arch/powerpc/sysdev/fsl_pci.c: In function 'fsl_pcie_check_link':
arch/powerpc/sysdev/fsl_pci.c:91:1: error: the frame size of 1360 bytes is larger than 1024 bytes [-Werror=frame-larger-than=]

when configuring FRAME_WARN, by refactoring indirect_read_config()
to take hose and bus number instead of the 1344-byte struct pci_bus.

Signed-off-by: Kim Phillips <kim.phillips@freescale.com>
---
v2: refactor indirect_read_config() instead of kmalloc'ing a struct
pci_bus.

Scott, I will look deeper into fake_pci_bus() later.

 arch/powerpc/include/asm/pci-bridge.h |  4 ++++
 arch/powerpc/sysdev/fsl_pci.c         | 11 ++++-------
 arch/powerpc/sysdev/indirect_pci.c    | 25 +++++++++++++++++--------
 3 files changed, 25 insertions(+), 15 deletions(-)

diff --git a/arch/powerpc/include/asm/pci-bridge.h b/arch/powerpc/include/asm/pci-bridge.h
index 725247b..546d036 100644
--- a/arch/powerpc/include/asm/pci-bridge.h
+++ b/arch/powerpc/include/asm/pci-bridge.h
@@ -119,6 +119,10 @@ extern void setup_indirect_pci(struct pci_controller* hose,
 extern int indirect_read_config(struct pci_bus *bus, unsigned int devfn,
 				int offset, int len, u32 *val);
 
+extern int __indirect_read_config(struct pci_controller *hose,
+				  unsigned char bus_number, unsigned int devfn,
+				  int offset, int len, u32 *val);
+
 extern int indirect_write_config(struct pci_bus *bus, unsigned int devfn,
 				 int offset, int len, u32 val);
 
diff --git a/arch/powerpc/sysdev/fsl_pci.c b/arch/powerpc/sysdev/fsl_pci.c
index 6455c1e..7cc215e 100644
--- a/arch/powerpc/sysdev/fsl_pci.c
+++ b/arch/powerpc/sysdev/fsl_pci.c
@@ -68,13 +68,10 @@ static int fsl_pcie_check_link(struct pci_controller *hose)
 	u32 val = 0;
 
 	if (hose->indirect_type & PPC_INDIRECT_TYPE_FSL_CFG_REG_LINK) {
-		if (hose->ops->read == fsl_indirect_read_config) {
-			struct pci_bus bus;
-			bus.number = hose->first_busno;
-			bus.sysdata = hose;
-			bus.ops = hose->ops;
-			indirect_read_config(&bus, 0, PCIE_LTSSM, 4, &val);
-		} else
+		if (hose->ops->read == fsl_indirect_read_config)
+			__indirect_read_config(hose, hose->first_busno, 0,
+					       PCIE_LTSSM, 4, &val);
+		else
 			early_read_config_dword(hose, 0, 0, PCIE_LTSSM, &val);
 		if (val < PCIE_LTSSM_L0)
 			return 1;
diff --git a/arch/powerpc/sysdev/indirect_pci.c b/arch/powerpc/sysdev/indirect_pci.c
index 1f6c570..692de9d 100644
--- a/arch/powerpc/sysdev/indirect_pci.c
+++ b/arch/powerpc/sysdev/indirect_pci.c
@@ -20,31 +20,31 @@
 #include <asm/pci-bridge.h>
 #include <asm/machdep.h>
 
-int indirect_read_config(struct pci_bus *bus, unsigned int devfn,
-			 int offset, int len, u32 *val)
+int __indirect_read_config(struct pci_controller *hose,
+			   unsigned char bus_number, unsigned int devfn,
+			   int offset, int len, u32 *val)
 {
-	struct pci_controller *hose = pci_bus_to_host(bus);
 	volatile void __iomem *cfg_data;
 	u8 cfg_type = 0;
 	u32 bus_no, reg;
 
 	if (hose->indirect_type & PPC_INDIRECT_TYPE_NO_PCIE_LINK) {
-		if (bus->number != hose->first_busno)
+		if (bus_number != hose->first_busno)
 			return PCIBIOS_DEVICE_NOT_FOUND;
 		if (devfn != 0)
 			return PCIBIOS_DEVICE_NOT_FOUND;
 	}
 
 	if (ppc_md.pci_exclude_device)
-		if (ppc_md.pci_exclude_device(hose, bus->number, devfn))
+		if (ppc_md.pci_exclude_device(hose, bus_number, devfn))
 			return PCIBIOS_DEVICE_NOT_FOUND;
 
 	if (hose->indirect_type & PPC_INDIRECT_TYPE_SET_CFG_TYPE)
-		if (bus->number != hose->first_busno)
+		if (bus_number != hose->first_busno)
 			cfg_type = 1;
 
-	bus_no = (bus->number == hose->first_busno) ?
-			hose->self_busno : bus->number;
+	bus_no = (bus_number == hose->first_busno) ?
+			hose->self_busno : bus_number;
 
 	if (hose->indirect_type & PPC_INDIRECT_TYPE_EXT_REG)
 		reg = ((offset & 0xf00) << 16) | (offset & 0xfc);
@@ -77,6 +77,15 @@ int indirect_read_config(struct pci_bus *bus, unsigned int devfn,
 	return PCIBIOS_SUCCESSFUL;
 }
 
+int indirect_read_config(struct pci_bus *bus, unsigned int devfn,
+			 int offset, int len, u32 *val)
+{
+	struct pci_controller *hose = pci_bus_to_host(bus);
+
+	return __indirect_read_config(hose, bus->number, devfn, offset, len,
+				      val);
+}
+
 int indirect_write_config(struct pci_bus *bus, unsigned int devfn,
 			  int offset, int len, u32 val)
 {
-- 
2.2.2

