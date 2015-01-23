Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754542AbbAWBAh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jan 2015 20:00:37 -0500
Received: from mail-bn1bon0140.outbound.protection.outlook.com ([157.56.111.140]:14256
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752235AbbAWBAe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jan 2015 20:00:34 -0500
Date: Thu, 22 Jan 2015 18:20:56 -0600
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
Subject: Re: [PATCH] powerpc/fsl_pci: Fix pci stack build bug with
 FRAME_WARN
Message-ID: <20150122182056.cc3436bd90a6cbba70da538a@freescale.com>
In-Reply-To: <1421895747.4961.232.camel@freescale.com>
References: <20150120140349.a7a9885065c241b555b91717@freescale.com>
	<1421800292.4961.215.camel@freescale.com>
	<20150121204844.fda3d4ab23a8226b6cdfdaf6@freescale.com>
	<1421895747.4961.232.camel@freescale.com>
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
X-Forefront-Antispam-Report: CIP:192.88.168.50;CTRY:US;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10019020)(6009001)(51704005)(377424004)(24454002)(164054003)(54094003)(105606002)(86362001)(19580405001)(92566002)(106466001)(47776003)(19580395003)(6806004)(100306002)(33646002)(575784001)(23726002)(85426001)(77156002)(62966003)(93886004)(76176999)(50986999)(36756003)(46102003)(50466002)(2950100001)(46406003)(87936001)(110136001)(50226001)(77096005)(104016003);DIR:OUT;SFP:1102;SCL:1;SRVR:BY2PR03MB191;H:tx30smr01.am.freescale.net;FPR:;SPF:None;MLV:sfv;LANG:en;
X-DmarcAction-Test: None
X-Microsoft-Antispam: UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:(3005004);SRVR:BY2PR03MB191;
X-Exchange-Antispam-Report-Test: UriScan:;
X-Exchange-Antispam-Report-CFA-Test: BCL:0;PCL:0;RULEID:(601004);SRVR:BY2PR03MB191;
X-Forefront-PRVS: 0465429B7F
X-Exchange-Antispam-Report-CFA-Test: BCL:0;PCL:0;RULEID:;SRVR:BY2PR03MB191;
X-OriginatorOrg: freescale.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Jan 2015 00:26:13.2408
 (UTC)
X-MS-Exchange-CrossTenant-Id: 710a03f5-10f6-4d38-9ff4-a80b81da590d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=710a03f5-10f6-4d38-9ff4-a80b81da590d;Ip=[192.88.168.50]
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY2PR03MB191
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 21 Jan 2015 21:02:27 -0600
Scott Wood <scottwood@freescale.com> wrote:

> On Wed, 2015-01-21 at 20:48 -0600, Kim Phillips wrote:
> > On Tue, 20 Jan 2015 18:31:32 -0600
> > Scott Wood <scottwood@freescale.com> wrote:
> > 
> > > On Tue, 2015-01-20 at 14:03 -0600, Kim Phillips wrote:
> > > > Fix this:
> > > > 
> > > >   CC      arch/powerpc/sysdev/fsl_pci.o
> > > > arch/powerpc/sysdev/fsl_pci.c: In function 'fsl_pcie_check_link':
> > > > arch/powerpc/sysdev/fsl_pci.c:91:1: error: the frame size of 1360 bytes is larger than 1024 bytes [-Werror=frame-larger-than=]
> > > > 
> > > > when configuring FRAME_WARN, by converting the allocation from the
> > > > stack to the heap.  We use GFP_ATOMIC since this function can be
> > > > called with interrupts disabled.
> > > > 
> > > > Signed-off-by: Kim Phillips <kim.phillips@freescale.com>
> > > > ---
> > > >  arch/powerpc/sysdev/fsl_pci.c | 12 +++++++-----
> > > >  1 file changed, 7 insertions(+), 5 deletions(-)
> > > > 
> > > > diff --git a/arch/powerpc/sysdev/fsl_pci.c b/arch/powerpc/sysdev/fsl_pci.c
> > > > index 6455c1e..635d743 100644
> > > > --- a/arch/powerpc/sysdev/fsl_pci.c
> > > > +++ b/arch/powerpc/sysdev/fsl_pci.c
> > > > @@ -69,11 +69,13 @@ static int fsl_pcie_check_link(struct pci_controller *hose)
> > > >  
> > > >  	if (hose->indirect_type & PPC_INDIRECT_TYPE_FSL_CFG_REG_LINK) {
> > > >  		if (hose->ops->read == fsl_indirect_read_config) {
> > > > -			struct pci_bus bus;
> > > > -			bus.number = hose->first_busno;
> > > > -			bus.sysdata = hose;
> > > > -			bus.ops = hose->ops;
> > > > -			indirect_read_config(&bus, 0, PCIE_LTSSM, 4, &val);
> > > > +			struct pci_bus *bus;
> > > > +			bus = kmalloc(sizeof(*bus), GFP_ATOMIC);
> > > > +			bus->number = hose->first_busno;
> > > 
> > > Missing check for allocation failure.
> > 
> > thanks.
> > 
> > > Do we not have a real struct pci_bus we can use here?  Or refactor
> > > indirect_read_config() to take hose and bus number instead?
> > 
> > indirect_read_config() can't be refactored because it is also used
> > in the generic struct pci_ops.  Unless you mean making an
> > __indirect_read_config that the original would call, 
> 
> Yes, that's what I mean.
> 
> > but that doesn't look that trivial given it calls pci_exclude_device with a
> > struct pci_controller hose.
> 
> Check for excluded devices in indirect_read_config(), not
> __indirect_read_config().

turns out it wasn't an issue; see below for a v2.

> > > If putting a pci_bus struct on the stack is no longer OK, then
> > > fake_pci_bus() should be fixed as well.  I wonder if GCC is allocating
> > > separate pci_bus structs on the stack for this one and the one that
> > > early_read_config_dword() uses...
> > 
> > fake_pci_bus()' version is static, so it's not on the stack.
> > 
> > given that, maybe fsl_pcie_check_link()'s should be static too?
> 
> Oh.  How would you ensure that it's only called once at a time?  It
> doesn't look like this is only called during early boot.
> fsl_pcie_check_link() is called every time we do any config read through
> the normal interface.  This is also a concern for the call to
> early_read_config_dword().

I really don't know how that works: that code has been there since
before linux was maintained in git.

Below is the v2.

Thanks,

Kim.

>From aac5aa245949ea3dadae9ea913d67c456f558a0c Mon Sep 17 00:00:00 2001
From: Kim Phillips <kim.phillips@freescale.com>
Date: Tue, 20 Jan 2015 14:03:49 -0600
Subject: [PATCH v2] powerpc/fsl_pci: Fix pci stack build bug with FRAME_WARN

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
