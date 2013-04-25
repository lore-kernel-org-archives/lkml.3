Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759204Ab3DYTyT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Apr 2013 15:54:19 -0400
Received: from mail-vb0-f41.google.com ([209.85.212.41]:38740 "EHLO
	mail-vb0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759100Ab3DYTyR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Apr 2013 15:54:17 -0400
MIME-Version: 1.0
In-Reply-To: <1365806683-26717-1-git-send-email-yinghai@kernel.org>
References: <1365806683-26717-1-git-send-email-yinghai@kernel.org>
From: Bjorn Helgaas <bhelgaas@google.com>
Date: Thu, 25 Apr 2013 13:53:56 -0600
Message-ID: <CAErSpo7_Qt8G=cG56koefsoHO=uN3amCgA7FYJv8amZtxWKc=w@mail.gmail.com>
Subject: Re: [PATCH v4 00/29] PCI: Add for_each_pci_resource and addon_res support
To: Yinghai Lu <yinghai@kernel.org>
Cc: Ram Pai <linuxram@us.ibm.com>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 12, 2013 at 4:44 PM, Yinghai Lu <yinghai@kernel.org> wrote:
> First part is for_each_pci_resource support:
> Now pci device resource iteration is done via "for (i=0...)" open code.
> That make code hard to read esp when only bridge or sriov resources
> are involved.

The "for (i = 0; ...)" code *is* a bit ugly with the various constants
for different types of resources, but it does have the advantage that
it is very simple and easy to understand.  The new code improves the
callers, but the implementation of for_each_pci_resource() is not very
straightforward.

The diffstat (541 insertions(+), 226 deletions(-)) doesn't really
indicate that this is an overall simplification.  I know this also
adds some functionality, but even without the addon stuff, this adds
110 more lines than it removes.

> We want to replace those open code with for_each_pci_resource() to make
> the code more readable.
> Also will add addon_resource handling, and need to make addon resource
> to be treated as normal PCI resources during iteration, add
> for_each_pci_resource will make that support transition more simple.
>
> To make for_each_pci_resource more efficient. We will use preset bitmap
> of different type for searching next idx.
>
> Second part is addon_res support:
> Now there is some non normal pci resources other than standard,rom,
> sriov, bridges.
> Some could be same as standard reg, but using different position.
> Some could have own way to read/write to them.
> Kernel are using different way to hack those resources like abusing
> pci bridge resource spot on non bridge pci device.
>
> Add addon_resources list in pci_dev for those non-standard resources.
> With this patch, will treat addon-resource like standard resources with
> special ops.
>
> At last replace some quirk_io with addon_res.
>
> could get from
>         git://git.kernel.org/pub/scm/linux/kernel/git/yinghai/linux-yinghai.git for-pci-for-each-res-addon
>
> -v4: split one patch out, and remove PCI_NO_....
>
> Notes: We still need to keep _idx as we use it all the time, and drivers still
> use them to get resource.
>
> Thanks
>
> Yinghai Lu
>
>
> Ram Pai (1):
>   PCI: pci resource iterator
>
> Yinghai Lu (28):
>   PCI: Clean up quirk_io_region
>   PCI: Add pci_dev_resource_n()
>   PCI: Update pci_resource_start etc to use pci_dev_resource_n()
>   PCI: Add pci_dev_resource_idx() helper
>   PCI: Add is_pci_*_resource_idx() helpers
>   PCI, x86: Use for_each_pci_resource() with
>     pci_allocate_bridge_resources
>   PCI, x86: Use for_each_pci_resource() with pci_allocate_dev_resources
>   PCI: Use for_each_pci_resource() with IOV releated functions
>   PCI, acpiphp: Use for_each_pci_resource() helper
>   PCI, pciehp: Use for_each_pci_resource() helper
>   PCI: Use for_each_pci_resource() in pci_enable_dev
>   PCI: Use for_each_pci_resource() in pci_reassigndev
>   PCI: Use for_each_pci_resource() with pci bar reassign funcs
>   PCI: Use for_each_pci_resource() in pci_assign_resource
>   PCI, x86: Use for_each_pci_resource() with noassign_bars
>   PCI: Use for_each_pci_resource() in pci_dev_driver()
>   PCI: Use for_each_pci_resource() in pci resource release
>   PCI: Use for_each_pci_resource() in pci bases reading
>   PCI, x86: Use for_each_pci_resource() with mrst
>   PCI, xen: Use for_each_pci_resource() with xen pci
>   PCI: Add addon_resource support for pci devices
>   PCI: Treat addon res as std resources
>   PCI: Add helpers to add addon_resource
>   PCI: Update pci_resource_bar() to support addon_resource
>   PCI: Assign/update resource to addon_res
>   PCI: Make piix4 quirk to use addon_res
>   PCI: Make quirk_io_region to use addon_res
>   PCI: Use addon_fixed_resource with ati fixed resource
>
>  arch/x86/pci/common.c              |   3 +-
>  arch/x86/pci/i386.c                |  58 +++------
>  arch/x86/pci/mrst.c                |   7 +-
>  drivers/pci/hotplug/acpiphp_glue.c |   4 +-
>  drivers/pci/hotplug/pciehp_hpc.c   |   5 +-
>  drivers/pci/iov.c                  |  31 +++--
>  drivers/pci/pci-driver.c           |   7 +-
>  drivers/pci/pci.c                  |  27 ++--
>  drivers/pci/probe.c                | 176 ++++++++++++++++++++++++-
>  drivers/pci/quirks.c               | 258 ++++++++++++++++++++++---------------
>  drivers/pci/remove.c               |   5 +-
>  drivers/pci/setup-bus.c            |  28 ++--
>  drivers/pci/setup-res.c            |  38 ++++--
>  drivers/pci/xen-pcifront.c         |   4 +-
>  include/linux/pci.h                | 116 +++++++++++++++--
>  15 files changed, 541 insertions(+), 226 deletions(-)
>
> --
> 1.8.1.4
>
