Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757845AbaKTXKZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Nov 2014 18:10:25 -0500
Received: from www.linutronix.de ([62.245.132.108]:53617 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756779AbaKTXKU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Nov 2014 18:10:20 -0500
Date: Fri, 21 Nov 2014 00:10:13 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Bjorn Helgaas <bhelgaas@google.com>
cc: Marc Zyngier <marc.zyngier@arm.com>, Yijing Wang <wangyijing@huawei.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        linux-pci@vger.kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Jiang Liu <jiang.liu@linux.intel.com>,
        Will Deacon <will.deacon@arm.com>,
        Catalin Marinas <catalin.marinas@arm.com>
Subject: Re: Removal of bus->msi assignment breaks MSI with stacked domains
In-Reply-To: <20141120215353.GA7987@google.com>
Message-ID: <alpine.DEB.2.11.1411202355060.6439@nanos>
References: <546E1771.4030201@arm.com> <20141120215353.GA7987@google.com>
User-Agent: Alpine 2.11 (DEB 23 2013-08-11)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 20 Nov 2014, Bjorn Helgaas wrote:
> On Thu, Nov 20, 2014 at 04:31:45PM +0000, Marc Zyngier wrote:
> > Bjorn, Yijing,
> > 
> > I've just realized that patch c167caf8d174 (PCI/MSI: Remove useless
> > bus->msi assignment) completely breaks MSI on arm64 when using the new
> > MSI stacked domain:
> > 
> > This patch relies on architectures to implement either
> > pcibios_msi_controller() or arch_setup_msi_irq(). It turns out that with
> > stacked domains, none of this is actually necessary, as long as you can
> > access to the msi_controller.
> > 
> > And everything was fine until this patch came around (and managed to
> > test on a system where the PCI devices are not directly attached to the
> > root bus). Of course, everything now breaks, as we cannot get to the MSI
> > controller (which contains the domain we allocate the MSIs from).
> > 
> > In short, this patch breaks an important feature on which arm64 relies,
> > and I believe this patch should be reverted ASAP.
> 
> I'm happy to revert it from pci/msi, but I think Thomas has already pulled
> it into his branch, so he'd have to drop it, too.
> 
> Thomas, let me know if you want to do that.  I suppose we could add a new
> patch to add it back, but that would leave bisection broken for the
> interval between c167caf8d174 and the patch that adds it back.

Fortunately my irq/irqdomain branch is not immutable yet. So we have
no problem at that point. I can rebase on your branch until tomorrow
night. Or just rebase on mainline and we sort out the merge conflicts
later, i.e. delegate them to Linus so his job of pulling stuff gets
not completely boring.

What I'm more worried about is whether this intended change is going
to inflict a problem on Jiangs intention to deduce the MSI irq domain
from the device, which we really need for making DMAR work w/o going
through loops and hoops.

I have limited knowledge about the actual scope of iommu (DMAR) units
versus device/bus/host-controllers, so I would appreciate a proper
explanation for that from you or Jiang or both.

My guts feeling tells me that anything less granular than the bus
level is wrong and according to my limited knowledge Intel even has
DMARs which are assigned to a single device it's even more wrong. So
the proper change would be not to push it from bus to something above
the bus, but instead make it a per device property.

But my knowledge there is limited, so I rely on the PCI/architecture
experts to sort that out.

Let me know ASAP.

Thanks,

	tglx
