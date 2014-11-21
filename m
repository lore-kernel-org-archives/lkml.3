Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750774AbaKURbQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Nov 2014 12:31:16 -0500
Received: from mail-ig0-f173.google.com ([209.85.213.173]:64749 "EHLO
	mail-ig0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750699AbaKURbO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Nov 2014 12:31:14 -0500
Date: Fri, 21 Nov 2014 10:31:10 -0700
From: Bjorn Helgaas <bhelgaas@google.com>
To: Yijing Wang <wangyijing@huawei.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, Marc Zyngier <marc.zyngier@arm.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        linux-pci@vger.kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Jiang Liu <jiang.liu@linux.intel.com>,
        Will Deacon <will.deacon@arm.com>,
        Catalin Marinas <catalin.marinas@arm.com>
Subject: Re: Removal of bus->msi assignment breaks MSI with stacked domains
Message-ID: <20141121173110.GB6578@google.com>
References: <546E1771.4030201@arm.com>
 <20141120215353.GA7987@google.com>
 <alpine.DEB.2.11.1411202355060.6439@nanos>
 <546E9B60.9070706@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <546E9B60.9070706@huawei.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 21, 2014 at 09:54:40AM +0800, Yijing Wang wrote:
> >> Thomas, let me know if you want to do that.  I suppose we could add a new
> >> patch to add it back, but that would leave bisection broken for the
> >> interval between c167caf8d174 and the patch that adds it back.
> > 
> > Fortunately my irq/irqdomain branch is not immutable yet. So we have
> > no problem at that point. I can rebase on your branch until tomorrow
> > night. Or just rebase on mainline and we sort out the merge conflicts
> > later, i.e. delegate them to Linus so his job of pulling stuff gets
> > not completely boring.
> 
> Hi Thomas, sorry for my introducing the broken.
> 
> > 
> > What I'm more worried about is whether this intended change is going
> > to inflict a problem on Jiangs intention to deduce the MSI irq domain
> > from the device, which we really need for making DMAR work w/o going
> > through loops and hoops.
> > 
> > I have limited knowledge about the actual scope of iommu (DMAR) units
> > versus device/bus/host-controllers, so I would appreciate a proper
> > explanation for that from you or Jiang or both.
> 
> In my personal opinion, if it's not necessary, we should not put stuff
> into pci_dev or pci_bus. If we plan to save msi_controller in pci_bus or
> pci_dev.
> I have a proposal, I would be appreciated if you could give some comments.
> First we refactor pci_host_bridge to make a generic
> pci_host_bridge, then we could save pci domain in it to eliminate
> arch specific functions. I aslo wanted to save msi_controller as
> pci domain, but now Jiang refactor hierarchy irq domain, and
> pci devices under the same pci host bridge may need to associate
> to different msi_controllers.

I think this is getting ahead of ourselves.  Let's make small steps.

We currently have the msi_controller pointer in struct pci_bus.  That was
there even before your series.  Your series added pci_msi_controller(),
and I reworked it so it looks like this:

    static struct msi_controller *pci_msi_controller(struct pci_dev *dev)
    {
	   struct msi_controller *msi_ctrl = dev->bus->msi;

	   if (msi_ctrl)
		   return msi_ctrl;

	   return pcibios_msi_controller(dev);
    }

So now your series basically just removes the ARM add_bus() and
remove_bus() methods and gets the MSI controller info from the ARM
pci_sys_data struct instead of from pci_bus.  Of course, that assumes that
on ARM, all devices under a host bridge have the same MSI controller.  That
seems like an unwarranted assumption, but if you want to do it for ARM,
that's fine with me.

> So I want to associate a msi_controller finding ops with generic pci_host_bridge,
> then every pci device could find its msi_controller/irq_domain by a
> common function
> 
> E.g
> 
> struct msi_controller *pci_msi_controller(struct pci_dev *pdev)
> {
> 	struct msi_controller *ctrl;
> 	struct pci_host_bridge *host = find_pci_host_bridge(pdev->bus);
> 	if (host && host->pci_get_msi_controller)
> 		ctrl = pci_host_bridge->pci_get_msi_controller(struct pci_dev *pdev);
> 
> 	return ctrl;	
> }

You can do this for ARM if you want (and your series already accomplishes
the same effect, though implemented differently).  But I don't think this
is appropriate for the PCI core.

For anybody who is on this thread but not the original, I reworked the
series slightly, see [1].

Bjorn

[1] http://lkml.kernel.org/r/20141121172018.GA6578@google.com
