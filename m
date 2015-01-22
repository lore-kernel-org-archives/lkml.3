Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753746AbbAVDCr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jan 2015 22:02:47 -0500
Received: from mail-bn1bon0147.outbound.protection.outlook.com ([157.56.111.147]:22944
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752358AbbAVDCi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jan 2015 22:02:38 -0500
Message-ID: <1421895747.4961.232.camel@freescale.com>
Subject: Re: [PATCH] powerpc/fsl_pci: Fix pci stack build bug with FRAME_WARN
From: Scott Wood <scottwood@freescale.com>
To: Kim Phillips <kim.phillips@freescale.com>
CC: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Wang Dongsheng <dongsheng.wang@freescale.com>,
        Anton Blanchard <anton@samba.org>,
        "Himangi Saraogi" <himangi774@gmail.com>,
        Aaron Sierra <asierra@xes-inc.com>, <linux-kernel@vger.kernel.org>,
        <linuxppc-dev@lists.ozlabs.org>
Date: Wed, 21 Jan 2015 21:02:27 -0600
In-Reply-To: <20150121204844.fda3d4ab23a8226b6cdfdaf6@freescale.com>
References: <20150120140349.a7a9885065c241b555b91717@freescale.com>
	 <1421800292.4961.215.camel@freescale.com>
	 <20150121204844.fda3d4ab23a8226b6cdfdaf6@freescale.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.12.7-0ubuntu1 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Originating-IP: [2601:2:5800:3f7:12bf:48ff:fe84:c9a0]
X-ClientProxiedBy: BN1PR08CA0050.namprd08.prod.outlook.com (10.242.217.178) To
 BY2PR0301MB0726.namprd03.prod.outlook.com (25.160.63.16)
Authentication-Results: spf=none (sender IP is )
 smtp.mailfrom=scottwood@freescale.com; 
X-DmarcAction-Test: None
X-Microsoft-Antispam: UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:(3005004);SRVR:BY2PR0301MB0726;
X-Exchange-Antispam-Report-Test: UriScan:;
X-Exchange-Antispam-Report-CFA-Test: BCL:0;PCL:0;RULEID:(601004);SRVR:BY2PR0301MB0726;
X-Forefront-PRVS: 0464DBBBC4
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10019020)(6009001)(189002)(199003)(377424004)(54094003)(51704005)(24454002)(110136001)(101416001)(87976001)(19580405001)(50986999)(106356001)(50466002)(33646002)(42186005)(68736005)(86362001)(19580395003)(105586002)(103116003)(76176999)(92566002)(2950100001)(122386002)(50226001)(97736003)(47776003)(40100003)(64706001)(36756003)(23676002)(46102003)(77156002)(3826002);DIR:OUT;SFP:1102;SCL:1;SRVR:BY2PR0301MB0726;H:[IPv6:2601:2:5800:3f7:12bf:48ff:fe84:c9a0];FPR:;SPF:None;MLV:sfv;PTR:InfoNoRecords;MX:1;A:1;LANG:en;
X-Exchange-Antispam-Report-CFA-Test: BCL:0;PCL:0;RULEID:;SRVR:BY2PR0301MB0726;
X-OriginatorOrg: freescale.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Jan 2015 03:02:33.6370
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY2PR0301MB0726
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2015-01-21 at 20:48 -0600, Kim Phillips wrote:
> On Tue, 20 Jan 2015 18:31:32 -0600
> Scott Wood <scottwood@freescale.com> wrote:
> 
> > On Tue, 2015-01-20 at 14:03 -0600, Kim Phillips wrote:
> > > Fix this:
> > > 
> > >   CC      arch/powerpc/sysdev/fsl_pci.o
> > > arch/powerpc/sysdev/fsl_pci.c: In function 'fsl_pcie_check_link':
> > > arch/powerpc/sysdev/fsl_pci.c:91:1: error: the frame size of 1360 bytes is larger than 1024 bytes [-Werror=frame-larger-than=]
> > > 
> > > when configuring FRAME_WARN, by converting the allocation from the
> > > stack to the heap.  We use GFP_ATOMIC since this function can be
> > > called with interrupts disabled.
> > > 
> > > Signed-off-by: Kim Phillips <kim.phillips@freescale.com>
> > > ---
> > >  arch/powerpc/sysdev/fsl_pci.c | 12 +++++++-----
> > >  1 file changed, 7 insertions(+), 5 deletions(-)
> > > 
> > > diff --git a/arch/powerpc/sysdev/fsl_pci.c b/arch/powerpc/sysdev/fsl_pci.c
> > > index 6455c1e..635d743 100644
> > > --- a/arch/powerpc/sysdev/fsl_pci.c
> > > +++ b/arch/powerpc/sysdev/fsl_pci.c
> > > @@ -69,11 +69,13 @@ static int fsl_pcie_check_link(struct pci_controller *hose)
> > >  
> > >  	if (hose->indirect_type & PPC_INDIRECT_TYPE_FSL_CFG_REG_LINK) {
> > >  		if (hose->ops->read == fsl_indirect_read_config) {
> > > -			struct pci_bus bus;
> > > -			bus.number = hose->first_busno;
> > > -			bus.sysdata = hose;
> > > -			bus.ops = hose->ops;
> > > -			indirect_read_config(&bus, 0, PCIE_LTSSM, 4, &val);
> > > +			struct pci_bus *bus;
> > > +			bus = kmalloc(sizeof(*bus), GFP_ATOMIC);
> > > +			bus->number = hose->first_busno;
> > 
> > Missing check for allocation failure.
> 
> thanks.
> 
> > Do we not have a real struct pci_bus we can use here?  Or refactor
> > indirect_read_config() to take hose and bus number instead?
> 
> indirect_read_config() can't be refactored because it is also used
> in the generic struct pci_ops.  Unless you mean making an
> __indirect_read_config that the original would call, 

Yes, that's what I mean.

> but that doesn't look that trivial given it calls pci_exclude_device with a
> struct pci_controller hose.

Check for excluded devices in indirect_read_config(), not
__indirect_read_config().

> > If putting a pci_bus struct on the stack is no longer OK, then
> > fake_pci_bus() should be fixed as well.  I wonder if GCC is allocating
> > separate pci_bus structs on the stack for this one and the one that
> > early_read_config_dword() uses...
> 
> fake_pci_bus()' version is static, so it's not on the stack.
> 
> given that, maybe fsl_pcie_check_link()'s should be static too?

Oh.  How would you ensure that it's only called once at a time?  It
doesn't look like this is only called during early boot.
fsl_pcie_check_link() is called every time we do any config read through
the normal interface.  This is also a concern for the call to
early_read_config_dword().

-Scott


