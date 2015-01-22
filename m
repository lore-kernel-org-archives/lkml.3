Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752978AbbAVCyR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jan 2015 21:54:17 -0500
Received: from mail-bl2on0130.outbound.protection.outlook.com ([65.55.169.130]:46400
	"EHLO na01-bl2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752171AbbAVCyD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jan 2015 21:54:03 -0500
Date: Wed, 21 Jan 2015 20:48:44 -0600
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
Message-ID: <20150121204844.fda3d4ab23a8226b6cdfdaf6@freescale.com>
In-Reply-To: <1421800292.4961.215.camel@freescale.com>
References: <20150120140349.a7a9885065c241b555b91717@freescale.com>
	<1421800292.4961.215.camel@freescale.com>
Organization: Freescale Semiconductor, Inc.
X-Mailer: Sylpheed 3.2.0 (GTK+ 2.24.13; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-EOPAttributedMessage: 0
Authentication-Results: spf=fail (sender IP is 192.88.168.50)
 smtp.mailfrom=Kim.Phillips@freescale.com; 
X-Forefront-Antispam-Report: CIP:192.88.168.50;CTRY:US;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10019020)(6009001)(339900001)(24454002)(189002)(51704005)(199003)(377424004)(54094003)(110136001)(2950100001)(106466001)(36756003)(87936001)(50986999)(50226001)(105606002)(77156002)(76176999)(19580395003)(85426001)(6806004)(68736005)(19580405001)(77096005)(47776003)(33646002)(64706001)(92566002)(86362001)(97736003)(46406003)(23726002)(100306002)(46102003)(50466002)(104016003);DIR:OUT;SFP:1102;SCL:1;SRVR:BLUPR03MB182;H:tx30smr01.am.freescale.net;FPR:;SPF:Fail;MLV:sfv;PTR:InfoDomainNonexistent;MX:1;A:1;LANG:en;
X-DmarcAction-Test: None
X-Microsoft-Antispam: UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:(3005004);SRVR:BLUPR03MB182;
X-Exchange-Antispam-Report-Test: UriScan:;
X-Exchange-Antispam-Report-CFA-Test: BCL:0;PCL:0;RULEID:(601004);SRVR:BLUPR03MB182;
X-Forefront-PRVS: 0464DBBBC4
X-Exchange-Antispam-Report-CFA-Test: BCL:0;PCL:0;RULEID:;SRVR:BLUPR03MB182;
X-OriginatorOrg: freescale.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Jan 2015 02:54:00.1131
 (UTC)
X-MS-Exchange-CrossTenant-Id: 710a03f5-10f6-4d38-9ff4-a80b81da590d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=710a03f5-10f6-4d38-9ff4-a80b81da590d;Ip=[192.88.168.50]
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BLUPR03MB182
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 20 Jan 2015 18:31:32 -0600
Scott Wood <scottwood@freescale.com> wrote:

> On Tue, 2015-01-20 at 14:03 -0600, Kim Phillips wrote:
> > Fix this:
> > 
> >   CC      arch/powerpc/sysdev/fsl_pci.o
> > arch/powerpc/sysdev/fsl_pci.c: In function 'fsl_pcie_check_link':
> > arch/powerpc/sysdev/fsl_pci.c:91:1: error: the frame size of 1360 bytes is larger than 1024 bytes [-Werror=frame-larger-than=]
> > 
> > when configuring FRAME_WARN, by converting the allocation from the
> > stack to the heap.  We use GFP_ATOMIC since this function can be
> > called with interrupts disabled.
> > 
> > Signed-off-by: Kim Phillips <kim.phillips@freescale.com>
> > ---
> >  arch/powerpc/sysdev/fsl_pci.c | 12 +++++++-----
> >  1 file changed, 7 insertions(+), 5 deletions(-)
> > 
> > diff --git a/arch/powerpc/sysdev/fsl_pci.c b/arch/powerpc/sysdev/fsl_pci.c
> > index 6455c1e..635d743 100644
> > --- a/arch/powerpc/sysdev/fsl_pci.c
> > +++ b/arch/powerpc/sysdev/fsl_pci.c
> > @@ -69,11 +69,13 @@ static int fsl_pcie_check_link(struct pci_controller *hose)
> >  
> >  	if (hose->indirect_type & PPC_INDIRECT_TYPE_FSL_CFG_REG_LINK) {
> >  		if (hose->ops->read == fsl_indirect_read_config) {
> > -			struct pci_bus bus;
> > -			bus.number = hose->first_busno;
> > -			bus.sysdata = hose;
> > -			bus.ops = hose->ops;
> > -			indirect_read_config(&bus, 0, PCIE_LTSSM, 4, &val);
> > +			struct pci_bus *bus;
> > +			bus = kmalloc(sizeof(*bus), GFP_ATOMIC);
> > +			bus->number = hose->first_busno;
> 
> Missing check for allocation failure.

thanks.

> Do we not have a real struct pci_bus we can use here?  Or refactor
> indirect_read_config() to take hose and bus number instead?

indirect_read_config() can't be refactored because it is also used
in the generic struct pci_ops.  Unless you mean making an
__indirect_read_config that the original would call, but that
doesn't look that trivial given it calls pci_exclude_device with a
struct pci_controller hose.

> If putting a pci_bus struct on the stack is no longer OK, then
> fake_pci_bus() should be fixed as well.  I wonder if GCC is allocating
> separate pci_bus structs on the stack for this one and the one that
> early_read_config_dword() uses...

fake_pci_bus()' version is static, so it's not on the stack.

given that, maybe fsl_pcie_check_link()'s should be static too?

Kim
