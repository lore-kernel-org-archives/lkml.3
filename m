Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755797Ab3FKRJq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Jun 2013 13:09:46 -0400
Received: from mail-vb0-f54.google.com ([209.85.212.54]:48967 "EHLO
	mail-vb0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755773Ab3FKRJn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Jun 2013 13:09:43 -0400
MIME-Version: 1.0
X-Originating-IP: [84.115.78.137]
In-Reply-To: <1370970051.18413.24@snotra>
References: <10631172.HfDeIDHqX3@pcimr>
	<1370970051.18413.24@snotra>
Date: Tue, 11 Jun 2013 19:09:42 +0200
Message-ID: <CALG0vJumuRobQtHdWAuWtbC3oS3_CMpDim=dtSNECCO25SgJUA@mail.gmail.com>
Subject: Re: [BUG] PCI related panic on powerpc based board with 3.10-rcX
From: Michael Guntsche <michael.guntsche@it-loops.com>
To: Scott Wood <scottwood@freescale.com>
Cc: Rojhalat Ibrahim <imr@rtschenk.de>, linuxppc-dev@lists.ozlabs.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 11, 2013 at 7:00 PM, Scott Wood <scottwood@freescale.com> wrote:
> On 06/11/2013 02:24:28 AM, Rojhalat Ibrahim wrote:
>>
>> On Monday 10 June 2013 17:52:33 Scott Wood wrote:
>> > On 06/10/2013 12:07:43 PM, Michael Guntsche wrote:
>> > > Good evening,
>> > >
>> > > This patch does not fix the problem, during boot the kernel still
>> > > panics. I had a closer look at the commit and the following patch
>> > > fixes it for me....
>> > >
>> > > diff --git a/arch/powerpc/sysdev/fsl_pci.c
>> > > b/arch/powerpc/sysdev/fsl_pci.c
>> > > index 028ac1f..21b687f 100644
>> > > --- a/arch/powerpc/sysdev/fsl_pci.c
>> > > +++ b/arch/powerpc/sysdev/fsl_pci.c
>> > > @@ -814,7 +814,7 @@ int __init mpc83xx_add_bridge(struct device_node
>> > > *dev)
>> > >
>> > >                 if (ret)
>> > >
>> > >                         goto err0;
>> > >
>> > >         } else {
>> > >
>> > > -               fsl_setup_indirect_pci(hose, rsrc_cfg.start,
>> > > +               setup_indirect_pci(hose, rsrc_cfg.start,
>> > >
>> > >                                        rsrc_cfg.start + 4, 0);
>> > >
>> > >         }
>> >
>> > The only difference here is that you're not setting hose->ops to
>> > fsl_indirect_pci_ops.  Do you know why that is helping, and what
>> > hose->ops is set to instead?
>> >
>> > -Scott
>>
>> The difference is only the read function in hose->ops, which is set to
>> indirect_read_config instead of fsl_indirect_read_config.
>>
>> fsl_indirect_read_config calls fsl_pcie_check_link, which is where the
>> Oops
>> occurs.
>
>
> Why is fsl_pcie_check_link being called for non-PCIe buses?
>
>
>> Mike, can you find out where exactly in fsl_pcie_check_link the bad access
>> happens? Enabling CONFIG_DEBUG_BUGVERBOSE might help.
>
>
> Why does it matter?  You shouldn't be calling that function at all.
>
> -Scott

For the record BUGVERBOSE is already set with this build so this is
the most detailed trace I get. And regarding Scott's remark, maybe I
was not clear enough in my first report. This is a PCI only board so I
also wondered about the call to fsl_pcie_check_link in the first
place. Since apparently the 83xx related add bridge code already has a
case for boards with PCIe support. So I think the change should really
happen somewhere in this code and not in the PCI only path.

/Mike
