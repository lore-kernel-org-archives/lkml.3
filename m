Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751962AbaKUSYH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Nov 2014 13:24:07 -0500
Received: from mx1.redhat.com ([209.132.183.28]:53629 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751169AbaKUSYF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Nov 2014 13:24:05 -0500
From: Alex Williamson <alex.williamson@redhat.com>
Subject: [PATCH 0/4] PCI: Reset exclusions
To: bhelgaas@google.com
Cc: linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Fri, 21 Nov 2014 11:24:02 -0700
Message-ID: <20141121180322.26669.65689.stgit@gimli.home>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is really 2 sets of 2 patches, but they both add bits to
dev_flags so are included together.

This fixes two problems we've seen with resets.  The first is for
devices that advertise a PM reset mechanism, but it doesn't appear to
do anything.  We add a quirk and flags bit to indicate the PM reset
mechanism isn't viable.  This happens on some AMD GPUs and causes
vfio-pci to assume the PM reset was successful when it really did
nothing and we should have escalated to a PCI bus reset.  Alex
Deucher confirms that PM reset isn't used by graphics drivers.  The
exclusion here is for users of pci_reset_function(), which mostly
only includes pci-sysfs and drivers like legacy KVM device assignment
and VFIO.

The second issue is a problem identified with an Atheros wifi chip
where in performing a bus reset of the device, we not only permanently
lose access to the device, but it introduces host stability issues if
we try to access it.  I've been unsuccessful in finding any way to
make the device behave or in finding anyone with access to hardware
documentation and errata for this device, so it seems like the most
appropriate path is to blacklist bus resets for topologies including
this device.  The second two patches add infrastructure and quirks to
do this.  Thanks,

Alex

---

Alex Williamson (4):
      PCI: quirk Atheros AR93xx to avoid bus reset
      PCI: Allow device quirks to exclude bus reset
      PCI: quirk AMD/ATI VGA cards to avoid PM reset
      PCI: Allow device quirks to exclude D3->D0 PM reset


 drivers/pci/pci.c    |   42 +++++++++++++++++++++++++++++++++++++-----
 drivers/pci/quirks.c |   35 +++++++++++++++++++++++++++++++++++
 include/linux/pci.h  |    4 ++++
 3 files changed, 76 insertions(+), 5 deletions(-)
