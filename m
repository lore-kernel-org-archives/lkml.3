Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751574Ab3HOUsz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Aug 2013 16:48:55 -0400
Received: from mail-ie0-f174.google.com ([209.85.223.174]:41678 "EHLO
	mail-ie0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750920Ab3HOUsw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Aug 2013 16:48:52 -0400
MIME-Version: 1.0
In-Reply-To: <20130808200444.2932.17381.stgit@bling.home>
References: <20130808200444.2932.17381.stgit@bling.home>
From: Bjorn Helgaas <bhelgaas@google.com>
Date: Thu, 15 Aug 2013 14:48:31 -0600
Message-ID: <CAErSpo6v2sKuHnLweh_o1GtV+A-3ckoMG10rhOEwMXHLMTMsgg@mail.gmail.com>
Subject: Re: [PATCH v5 0/9] pci: bus and slot reset interfaces
To: Alex Williamson <alex.williamson@redhat.com>
Cc: "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        Alex Duyck <alexander.h.duyck@intel.com>,
        Don Dutile <ddutile@redhat.com>,
        Takao Indoh <indou.takao@jp.fujitsu.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 8, 2013 at 2:09 PM, Alex Williamson
<alex.williamson@redhat.com> wrote:
> v5: Increase length of time we assert reset in the final common
>     secondary bus reset function to 2ms and document that this is
>     to ensure that reset on the bus is seen for at least a full
>     1ms (per converstation with Alex Duyck)
>
> Thanks,
> Alex
>
> This series adds PCI bus and slot reset interfaces to the already
> existing function reset interface.  I need this for two reasons, the
> first is that not all devices support function level reset.  Even
> some of those that we detect as supporting a PM reset on D3hot->D0
> transition actually don't do any reset.  Others have no reset
> capability at all.  We currently implement a secondary bus reset
> escalation from the function reset path, but only when there is a
> single devfn on the bus.  Drivers like vfio can have ownership of
> all of the devices on a bus and should therefore have a path to
> initiate a secondary bus reset with multiple devices.  This is
> particularly required for use of GPUs by userspace, where none of
> the predominant GPUs implement a useful function level reset.
>
> The second reason is that even the current function reset escalating
> to a secondary bus reset can cause problems with hotplug controllers.
> If a root port supports PCIe HP with suprise removal, a bus reset
> can trigger a presence detection change, which results in an attempt
> to remove the struct device.  By having a slot reset interface, we
> can involve the hotplug controllers to allow for a controlled bus
> reset and avoid this spurious removal attempt.
>
> ---
>
> Alex Williamson (9):
>       pci: Create pci_reset_bridge_secondary_bus()
>       pci: Add hotplug_slot_ops.reset_slot()
>       pci: Implement reset_slot for pciehp
>       pci: Add slot reset option to pci_dev_reset
>       pci: Split out pci_dev lock/unlock and save/restore
>       pci: Add slot and bus reset interfaces
>       pci: Wake-up devices before save for reset
>       pci: Tune secondary bus reset timing
>       pci: Remove aer_do_secondary_bus_reset()
>
>
>  drivers/pci/hotplug/pciehp.h       |    1
>  drivers/pci/hotplug/pciehp_core.c  |   12 +
>  drivers/pci/hotplug/pciehp_hpc.c   |   31 +++
>  drivers/pci/pci.c                  |  349 +++++++++++++++++++++++++++++++++---
>  drivers/pci/pcie/aer/aerdrv.c      |    2
>  drivers/pci/pcie/aer/aerdrv.h      |    1
>  drivers/pci/pcie/aer/aerdrv_core.c |   35 ----
>  include/linux/pci.h                |    3
>  include/linux/pci_hotplug.h        |    4
>  9 files changed, 376 insertions(+), 62 deletions(-)

Merged to the PCI "next" branch for v3.12, thanks!
