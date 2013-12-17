Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751906Ab3LQXnh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Dec 2013 18:43:37 -0500
Received: from mx1.redhat.com ([209.132.183.28]:13239 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751090Ab3LQXnf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Dec 2013 18:43:35 -0500
Subject: [PATCH v2 0/4] pci: virtual channel save/restore support
From: Alex Williamson <alex.williamson@redhat.com>
To: bhelgaas@google.com, linux-pci@vger.kernel.org
Cc: ddutile@redhat.com, linux-kernel@vger.kernel.org
Date: Tue, 17 Dec 2013 16:43:33 -0700
Message-ID: <20131217233741.2310.78334.stgit@bling.home>
User-Agent: StGit/0.17-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

v1->v2:

Address Bjorn's comments
 - split code out to vc.c
 - #defines for everything
 - rename VC defines
 - fix word access to PCI_VC_PORT_CTRL

It ended up getting a little bigger since I added function description
comments, header, includes and misc lines here and there.

v1:

Turns out that even though we don't do much with virtual channel, we
still need to save/restore it around reset.  The case where this comes
into play currently is a card with a switch and multiple devices, all
supporting VC (Nvidia GRID).  On some platforms the system firmware
will leave all the virtual channel capabilities in their default
state, where the VC0 TC/VC map is 0xff (TC0-7 enabled over VC0).
Other systems decide to restrict the available traffic classes and
configure 0x01 (only TC0 over VC0).  At handoff, everything works, but
as soon as we do a device reset, especially if done via bus reset, the
endpoint can be returned to the spec defined default rather than the
platform default.  If such a device is then assigned to a guest, the
guest driver sees multiple TCs enabled, attempts to use them, and it
fails.  The failure mode depends on the platform, ranging from the
driver in the guest failing to work to host panic from an unsupported
transaction.

This series attempts to implement full save/restore support for all
types of virtual channel (VC, MFVC, and VC9).  The buffer sizing code
will execute for any device with these capabilities, but of couse the
actual save/restore is only done if a reset is requested for the
device, which typically means assignment to a VM.  Thanks,

Alex

---

Alex Williamson (4):
      pci: Generalize wait loop
      pci: Add support for save/restore of extended capabilities
      pci: Add Virtual Channel to save/restore support
      pci: Rename PCI_VC_PORT_REG1/2 to PCI_VC_PORT_CAP1/2


 drivers/pci/Makefile               |    2 
 drivers/pci/pci.c                  |  102 ++++++--
 drivers/pci/vc.c                   |  434 ++++++++++++++++++++++++++++++++++++
 drivers/vfio/pci/vfio_pci_config.c |   12 -
 include/linux/pci.h                |   15 +
 include/uapi/linux/pci_regs.h      |   29 ++
 6 files changed, 549 insertions(+), 45 deletions(-)
 create mode 100644 drivers/pci/vc.c
