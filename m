Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755454Ab3FLIT7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Jun 2013 04:19:59 -0400
Received: from mail-out.m-online.net ([212.18.0.10]:41686 "EHLO
	mail-out.m-online.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754369Ab3FLITk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Jun 2013 04:19:40 -0400
From: Rojhalat Ibrahim <imr@rtschenk.de>
To: Scott Wood <scottwood@freescale.com>
Cc: Michael Guntsche <michael.guntsche@it-loops.com>,
        linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org
Subject: Re: [BUG] PCI related panic on powerpc based board with 3.10-rcX
Date: Wed, 12 Jun 2013 10:19:30 +0200
Message-ID: <34279395.MbRViMjbAR@pcimr>
User-Agent: KMail/4.10.3 (Linux/3.4.26; KDE/4.10.3; x86_64; ; )
In-Reply-To: <1370971739.18413.27@snotra>
References: <1370971739.18413.27@snotra>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 11 June 2013 12:28:59 Scott Wood wrote:
> On 06/11/2013 12:09:42 PM, Michael Guntsche wrote:
> > On Tue, Jun 11, 2013 at 7:00 PM, Scott Wood <scottwood@freescale.com>
> > 
> > wrote:
> > > On 06/11/2013 02:24:28 AM, Rojhalat Ibrahim wrote:
> > >> On Monday 10 June 2013 17:52:33 Scott Wood wrote:
> > >> > On 06/10/2013 12:07:43 PM, Michael Guntsche wrote:
> > >> > > Good evening,
> > >> > > 
> > >> > > This patch does not fix the problem, during boot the kernel
> > 
> > still
> > 
> > >> > > panics. I had a closer look at the commit and the following
> > 
> > patch
> > 
> > >> > > fixes it for me....
> > >> > > 
> > >> > > diff --git a/arch/powerpc/sysdev/fsl_pci.c
> > >> > > b/arch/powerpc/sysdev/fsl_pci.c
> > >> > > index 028ac1f..21b687f 100644
> > >> > > --- a/arch/powerpc/sysdev/fsl_pci.c
> > >> > > +++ b/arch/powerpc/sysdev/fsl_pci.c
> > >> > > @@ -814,7 +814,7 @@ int __init mpc83xx_add_bridge(struct
> > 
> > device_node
> > 
> > >> > > *dev)
> > >> > > 
> > >> > >                 if (ret)
> > >> > >                 
> > >> > >                         goto err0;
> > >> > >         
> > >> > >         } else {
> > >> > > 
> > >> > > -               fsl_setup_indirect_pci(hose, rsrc_cfg.start,
> > >> > > +               setup_indirect_pci(hose, rsrc_cfg.start,
> > >> > > 
> > >> > >                                        rsrc_cfg.start + 4, 0);
> > >> > >         
> > >> > >         }
> > >> > 
> > >> > The only difference here is that you're not setting hose->ops to
> > >> > fsl_indirect_pci_ops.  Do you know why that is helping, and what
> > >> > hose->ops is set to instead?
> > >> > 
> > >> > -Scott
> > >> 
> > >> The difference is only the read function in hose->ops, which is
> > 
> > set to
> > 
> > >> indirect_read_config instead of fsl_indirect_read_config.
> > >> 
> > >> fsl_indirect_read_config calls fsl_pcie_check_link, which is where
> > 
> > the
> > 
> > >> Oops
> > >> occurs.
> > > 
> > > Why is fsl_pcie_check_link being called for non-PCIe buses?
> > > 
> > >> Mike, can you find out where exactly in fsl_pcie_check_link the
> > 
> > bad access
> > 
> > >> happens? Enabling CONFIG_DEBUG_BUGVERBOSE might help.
> > > 
> > > Why does it matter?  You shouldn't be calling that function at all.
> > > 
> > > -Scott
> > 
> > For the record BUGVERBOSE is already set with this build so this is
> > the most detailed trace I get. And regarding Scott's remark, maybe I
> > was not clear enough in my first report. This is a PCI only board so I
> > also wondered about the call to fsl_pcie_check_link in the first
> > place.
> 
> Yes, I figured it was non-PCIe because the code change that you said
> helped was on the non-PCIe branch of the if/else.  Generally it's good
> to explicitly mention the chip you're using, though.
> 
> fsl_setup_indirect_pci should be renamed to fsl_setup_indirect_pcie.
> Your patch above should be applied, and fsl_setup_indirect_pcie should
> be moved into the booke/86xx ifdef to avoid an unused function warning.
> 
> -Scott

How about this patch? It uses setup_indirect_pci for the PCI case in 
mpc83xx_add_bridge. Additionally it adds a check in fsl_setup_indirect_pci
to only use the modified read function in case of PCIe.

   Rojhalat


diff --git a/arch/powerpc/sysdev/fsl_pci.c b/arch/powerpc/sysdev/fsl_pci.c
index 028ac1f..45670df 100644
--- a/arch/powerpc/sysdev/fsl_pci.c
+++ b/arch/powerpc/sysdev/fsl_pci.c
@@ -97,22 +97,23 @@ static int fsl_indirect_read_config(struct pci_bus *bus, unsigned int devfn,
 	return indirect_read_config(bus, devfn, offset, len, val);
 }
 
-static struct pci_ops fsl_indirect_pci_ops =
+static struct pci_ops fsl_indirect_pcie_ops =
 {
 	.read = fsl_indirect_read_config,
 	.write = indirect_write_config,
 };
 
+#if defined(CONFIG_FSL_SOC_BOOKE) || defined(CONFIG_PPC_86xx)
+
 static void __init fsl_setup_indirect_pci(struct pci_controller* hose,
 					  resource_size_t cfg_addr,
 					  resource_size_t cfg_data, u32 flags)
 {
 	setup_indirect_pci(hose, cfg_addr, cfg_data, flags);
-	hose->ops = &fsl_indirect_pci_ops;
+	if (early_find_capability(hose, 0, 0, PCI_CAP_ID_EXP))  /* PCIe */
+		hose->ops = &fsl_indirect_pcie_ops;
 }
 
-#if defined(CONFIG_FSL_SOC_BOOKE) || defined(CONFIG_PPC_86xx)
-
 #define MAX_PHYS_ADDR_BITS	40
 static u64 pci64_dma_offset = 1ull << MAX_PHYS_ADDR_BITS;
 
@@ -814,8 +815,8 @@ int __init mpc83xx_add_bridge(struct device_node *dev)
 		if (ret)
 			goto err0;
 	} else {
-		fsl_setup_indirect_pci(hose, rsrc_cfg.start,
-				       rsrc_cfg.start + 4, 0);
+		setup_indirect_pci(hose, rsrc_cfg.start,
+				   rsrc_cfg.start + 4, 0);
 	}
 
 	printk(KERN_INFO "Found FSL PCI host bridge at 0x%016llx. "


