Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755351Ab3FKR3O (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Jun 2013 13:29:14 -0400
Received: from co1ehsobe001.messaging.microsoft.com ([216.32.180.184]:49742
	"EHLO co1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753666Ab3FKR3L convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Jun 2013 13:29:11 -0400
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: -4
X-BigFish: VS-4(zzbb2dI98dI9371I1432Izz1f42h1ee6h1de0h1fdah1202h1e76h1d1ah1d2ah1fc6hzz8275bhz2dh2a8h668h839h944hd2bhf0ah1288h12a5h12a9h12bdh137ah139eh13b6h1441h1504h1537h162dh1631h16a6h1758h1898h18e1h1946h19b5h1ad9h1b0ah1d0ch1d2eh1d3fh1dc1h1dfeh1dffh1e23h1155h)
Date: Tue, 11 Jun 2013 12:28:59 -0500
From: Scott Wood <scottwood@freescale.com>
Subject: Re: [BUG] PCI related panic on powerpc based board with 3.10-rcX
To: Michael Guntsche <michael.guntsche@it-loops.com>
CC: Rojhalat Ibrahim <imr@rtschenk.de>, <linuxppc-dev@lists.ozlabs.org>,
        <linux-kernel@vger.kernel.org>
In-Reply-To: <CALG0vJumuRobQtHdWAuWtbC3oS3_CMpDim=dtSNECCO25SgJUA@mail.gmail.com> (from
	michael.guntsche@it-loops.com on Tue Jun 11 12:09:42 2013)
X-Mailer: Balsa 2.4.12
Message-ID: <1370971739.18413.27@snotra>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"; delsp=Yes; format=Flowed
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/11/2013 12:09:42 PM, Michael Guntsche wrote:
> On Tue, Jun 11, 2013 at 7:00 PM, Scott Wood <scottwood@freescale.com>  
> wrote:
> > On 06/11/2013 02:24:28 AM, Rojhalat Ibrahim wrote:
> >>
> >> On Monday 10 June 2013 17:52:33 Scott Wood wrote:
> >> > On 06/10/2013 12:07:43 PM, Michael Guntsche wrote:
> >> > > Good evening,
> >> > >
> >> > > This patch does not fix the problem, during boot the kernel  
> still
> >> > > panics. I had a closer look at the commit and the following  
> patch
> >> > > fixes it for me....
> >> > >
> >> > > diff --git a/arch/powerpc/sysdev/fsl_pci.c
> >> > > b/arch/powerpc/sysdev/fsl_pci.c
> >> > > index 028ac1f..21b687f 100644
> >> > > --- a/arch/powerpc/sysdev/fsl_pci.c
> >> > > +++ b/arch/powerpc/sysdev/fsl_pci.c
> >> > > @@ -814,7 +814,7 @@ int __init mpc83xx_add_bridge(struct  
> device_node
> >> > > *dev)
> >> > >
> >> > >                 if (ret)
> >> > >
> >> > >                         goto err0;
> >> > >
> >> > >         } else {
> >> > >
> >> > > -               fsl_setup_indirect_pci(hose, rsrc_cfg.start,
> >> > > +               setup_indirect_pci(hose, rsrc_cfg.start,
> >> > >
> >> > >                                        rsrc_cfg.start + 4, 0);
> >> > >
> >> > >         }
> >> >
> >> > The only difference here is that you're not setting hose->ops to
> >> > fsl_indirect_pci_ops.  Do you know why that is helping, and what
> >> > hose->ops is set to instead?
> >> >
> >> > -Scott
> >>
> >> The difference is only the read function in hose->ops, which is  
> set to
> >> indirect_read_config instead of fsl_indirect_read_config.
> >>
> >> fsl_indirect_read_config calls fsl_pcie_check_link, which is where  
> the
> >> Oops
> >> occurs.
> >
> >
> > Why is fsl_pcie_check_link being called for non-PCIe buses?
> >
> >
> >> Mike, can you find out where exactly in fsl_pcie_check_link the  
> bad access
> >> happens? Enabling CONFIG_DEBUG_BUGVERBOSE might help.
> >
> >
> > Why does it matter?  You shouldn't be calling that function at all.
> >
> > -Scott
> 
> For the record BUGVERBOSE is already set with this build so this is
> the most detailed trace I get. And regarding Scott's remark, maybe I
> was not clear enough in my first report. This is a PCI only board so I
> also wondered about the call to fsl_pcie_check_link in the first
> place.

Yes, I figured it was non-PCIe because the code change that you said  
helped was on the non-PCIe branch of the if/else.  Generally it's good  
to explicitly mention the chip you're using, though.

fsl_setup_indirect_pci should be renamed to fsl_setup_indirect_pcie.   
Your patch above should be applied, and fsl_setup_indirect_pcie should  
be moved into the booke/86xx ifdef to avoid an unused function warning.

-Scott
