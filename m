Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755941Ab3EHC5h (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 May 2013 22:57:37 -0400
Received: from mx1.redhat.com ([209.132.183.28]:9472 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754791Ab3EHC5g (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 May 2013 22:57:36 -0400
Subject: [PATCH v2 0/8] pci: bus and slot reset interface
To: bhelgaas@google.com, linux-pci@vger.kernel.org
From: Alex Williamson <alex.williamson@redhat.com>
Cc: linux-kernel@vger.kernel.org
Date: Tue, 07 May 2013 20:57:34 -0600
Message-ID: <20130508025339.30771.61937.stgit@bling.home>
User-Agent: StGit/0.16
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

v2: Sorry, v1 somehow didn't cc linux-pci.  No code change

We currently support reset of individual functions via the
pci_reset_function() interface.  If a device supports one of the FLR
mechanisms, this works great.  If not, things get a little shady.  We
can do a D3hot->D0 PM reset if the device claims that does a soft
reset, but the definition of a soft reset seems to be left to
interpretation.  We can do a secondary bus reset if the device is
behind a bridge, but this is a function level reset interface, so if
there's anything else on that bus, we're out of luck.  Speaking of out
of luck, guess what happens when we do a secondary bus reset on a port
that supports pciehp surprise removal... we tickle the presence
detection logic and start a hot remove, but the device is locked, so
it doesn't get removed, then it gets added again, but it already
exists... ugh, what a mess.

That seems like an indication that we want to create an interface for
hotplug controllers to participate in a bus reset and prevent such
craziness.  But we don't hotplug a bus, we hotplug a slot.  A bus can
support multiple slots, so depending on the hotplug controller
capabilities, we can potentially do a reset on a slot granularity and
we can avoid spurious hotplug events.  Thus, pci_reset_slot.

We're not always going to have a hotplug controller, in fact pciehp is
the only one I know how to implement a reset_slot interface for (and
it actually has a 1:1 slot:bus interface), so we can try pci_reset_slot
and fall through to pci_reset_bus if needed.

Once we have these we can export them to drivers, because sometimes
those shady parts of pci_reset_function just aren't good enough and we
understand that a reset can affect multiple devices.  VFIO is a driver
that can take advantage of such an interface.  A VFIO user can be in
control of multiple devices.  If they control all of the devices on a
bus or a slot, a bus or slot reset mechanism should be available.
Where we particularly need this is for exposing VGA devices to
userspace.  These fall into the shady area where they claim to support
a PM function reset, but it doesn't actually do anything.  They're
also often not alone on the bus as they support a separate function
for the audio controller.  With this series we can expose a bus reset
interface and get repeatability.

Comments welcome.  Thanks,
Alex

---

Alex Williamson (8):
      pci: Create pci_reset_bridge_secondary_bus()
      pci: Add hotplug_slot_ops.reset_slot()
      pci: Add pci_hp_reset_slot
      pci: Implement reset_slot for pciehp
      pci: Add reset_slot option to pci_dev_reset
      pci: Split out pci_dev lock/unlock and save/restore
      pci: Add slot and bus reset interfaces
      pci: Wake-up devices before save for reset


 drivers/pci/hotplug/pci_hotplug_core.c |   24 ++
 drivers/pci/hotplug/pciehp.h           |    1 
 drivers/pci/hotplug/pciehp_core.c      |   12 +
 drivers/pci/hotplug/pciehp_hpc.c       |   31 +++
 drivers/pci/pci.c                      |  313 +++++++++++++++++++++++++++++---
 include/linux/pci.h                    |    3 
 include/linux/pci_hotplug.h            |   12 +
 7 files changed, 370 insertions(+), 26 deletions(-)
