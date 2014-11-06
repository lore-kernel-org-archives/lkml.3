Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752128AbaKFKmr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Nov 2014 05:42:47 -0500
Received: from www.linutronix.de ([62.245.132.108]:41904 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751234AbaKFKmm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Nov 2014 05:42:42 -0500
Date: Thu, 6 Nov 2014 11:42:32 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Suravee Suthikulanit <suravee.suthikulpanit@amd.com>
cc: Jiang Liu <jiang.liu@linux.intel.com>, marc.zyngier@arm.com,
        mark.rutland@arm.com, jason@lakedaemon.net, Catalin.Marinas@arm.com,
        Will.Deacon@arm.com, liviu.dudau@arm.com,
        Harish.Kasiviswanathan@amd.com, linux-arm-kernel@lists.infradead.org,
        linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-doc@vger.kernel.org, devicetree@vger.kernel.org
Subject: Re: [V10 PATCH 2/2] irqchip: gicv2m: Add supports for ARM GICv2m
 MSI(-X)
In-Reply-To: <alpine.DEB.2.11.1411060146050.24960@nanos>
Message-ID: <alpine.DEB.2.11.1411061131330.24960@nanos>
References: <1415052977-26036-1-git-send-email-suravee.suthikulpanit@amd.com> <1415052977-26036-3-git-send-email-suravee.suthikulpanit@amd.com> <5458CE31.3040404@linux.intel.com> <545ABB4C.8010103@amd.com> <545ABF6C.1000308@amd.com>
 <alpine.DEB.2.11.1411060146050.24960@nanos>
User-Agent: Alpine 2.11 (DEB 23 2013-08-11)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 6 Nov 2014, Thomas Gleixner wrote:
> On Wed, 5 Nov 2014, Suravee Suthikulanit wrote:
> > On 11/5/2014 6:05 PM, Suravee Suthikulanit wrote:
> > > - Overall, it seems that msi_domain_alloc() could be quite different
> > > across architectures. Would it be possible to declare this function as
> > > weak, and allow arch to override (similar to arch_setup_msi_irq)?
> > 
> > Actually, declaring "msi_domain_ops" as non-static, and allow other code to
> > override the .alloc and .free?
> 
> Why do you want to do that?

I know why. Because you want to spare a level of hierarchy. But thats
wrong simply because MSI itself is an interrupt chip at the device
level.

[ MSI ] ---> [ GIC-MSI ] ---> [ GIC ]

So the MSI level only cares about the allocation of the virq
space. GIC-MSI allocates out of the bitmap which handles the hard
wired range of MSI capable GIC interrupts and GIC handles the
underlying functionality.

And this makes a lot of sense, if you think about interrupt
remapping. If ARM ever grows that you simply insert it into the chain:

[ MSI ] ---> [ Remap] ---> [ GIC-MSI ] ---> [ GIC ]

If you look at Jiangs x86 implementation it does exactly that.

[ MSI ] ---> [ Vector ]

[ MSI ] ---> [ Remap ] ---> [ Vector ]

And because ARM has this intermediate layer of GIC-MSI you need to
represent it in the hierarchy whether you like it or not. If you'd try
to bolt the GIC-MSI magic into the MSI layer itself, then interrupt
remapping would never work.

Thanks,

	tglx


