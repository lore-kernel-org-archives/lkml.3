Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752478Ab3FKHYf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Jun 2013 03:24:35 -0400
Received: from mail-out.m-online.net ([212.18.0.10]:47270 "EHLO
	mail-out.m-online.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751877Ab3FKHYe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Jun 2013 03:24:34 -0400
From: Rojhalat Ibrahim <imr@rtschenk.de>
To: Scott Wood <scottwood@freescale.com>,
        Michael Guntsche <michael.guntsche@it-loops.com>
Cc: linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org
Subject: Re: [BUG] PCI related panic on powerpc based board with 3.10-rcX
Date: Tue, 11 Jun 2013 09:24:28 +0200
Message-ID: <10631172.HfDeIDHqX3@pcimr>
User-Agent: KMail/4.10.3 (Linux/3.4.26; KDE/4.10.3; x86_64; ; )
In-Reply-To: <1370904753.18413.19@snotra>
References: <CALG0vJu9-640D=Q-2RoSOnWtR=sERwj0fSCibK+ijprcf-T6Ag@mail.gmail.com> <CALG0vJtjS2wP_s=-iyG1ABKw_ct=B9OdNXY9YCrnkhAnpaN1Zw@mail.gmail.com> <1370904753.18413.19@snotra>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 10 June 2013 17:52:33 Scott Wood wrote:
> On 06/10/2013 12:07:43 PM, Michael Guntsche wrote:
> > Good evening,
> > 
> > On Mon, Jun 10, 2013 at 1:41 PM, Rojhalat Ibrahim <imr@rtschenk.de>
> > 
> > wrote:
> > > Hi Mike,
> > > 
> > > could you please try this patch:
> > > https://lists.ozlabs.org/pipermail/linuxppc-dev/2013-May/106624.html
> > > http://patchwork.ozlabs.org/patch/244515/
> > > 
> > >    Rojhalat
> > > 
> > > On Saturday 08 June 2013 21:39:37 Michael Guntsche wrote:
> > >> After bisecting I found the responsible commit.
> > >> 
> > >> 50d8f87d2b3: powerpc/fsl-pci Make PCIe hotplug work with Freescale
> > >> PCIe controllers
> > >> 
> > >> Reverting this commit allowed my board to boot again.
> > >> 
> > >> @Rojhalat: Please have a look at
> > >> http://marc.info/?l=linux-kernel&m=137071294204858&w=2
> > >> for my initial bugreport.
> > >> 
> > >> What I do not understand at all is why this is affecting my
> > 
> > platform.
> > 
> > >> AFAIK there is no PCIe hardware on it AND I completely disabled
> > 
> > PCIe
> > 
> > >> support in config.
> > >> 
> > >> Kind regards,
> > >> Mike
> > 
> > This patch does not fix the problem, during boot the kernel still
> > panics. I had a closer look at the commit and the following patch
> > fixes it for me....
> > 
> > diff --git a/arch/powerpc/sysdev/fsl_pci.c
> > b/arch/powerpc/sysdev/fsl_pci.c
> > index 028ac1f..21b687f 100644
> > --- a/arch/powerpc/sysdev/fsl_pci.c
> > +++ b/arch/powerpc/sysdev/fsl_pci.c
> > @@ -814,7 +814,7 @@ int __init mpc83xx_add_bridge(struct device_node
> > *dev)
> > 
> >                 if (ret)
> >                 
> >                         goto err0;
> >         
> >         } else {
> > 
> > -               fsl_setup_indirect_pci(hose, rsrc_cfg.start,
> > +               setup_indirect_pci(hose, rsrc_cfg.start,
> > 
> >                                        rsrc_cfg.start + 4, 0);
> >         
> >         }
> 
> The only difference here is that you're not setting hose->ops to
> fsl_indirect_pci_ops.  Do you know why that is helping, and what
> hose->ops is set to instead?
> 
> -Scott

The difference is only the read function in hose->ops, which is set to 
indirect_read_config instead of fsl_indirect_read_config.

fsl_indirect_read_config calls fsl_pcie_check_link, which is where the Oops 
occurs. 

Mike, can you find out where exactly in fsl_pcie_check_link the bad access 
happens? Enabling CONFIG_DEBUG_BUGVERBOSE might help.

   Rojhalat


