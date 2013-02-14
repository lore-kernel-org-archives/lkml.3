Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933916Ab3BNKmM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Feb 2013 05:42:12 -0500
Received: from g5t0007.atlanta.hp.com ([15.192.0.44]:17306 "EHLO
	g5t0007.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752757Ab3BNKmK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Feb 2013 05:42:10 -0500
From: Vijay Mohan Pandarathil <vijaymohan.pandarathil@hp.com>
To: alex.williamson@redhat.com, gleb@redhat.com, bhelgaas@google.com,
        blauwirbel@gmail.com, lance.oritz@hp.com, kvm@vger.kernel.org,
        qemu-devel@nongnu.org, linux-pci@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v4 0/3] AER-KVM: Error containment of VFIO devices assigned to KVM guests
Date: Thu, 14 Feb 2013 04:41:52 -0600
Message-Id: <1360838515-17558-1-git-send-email-vijaymohan.pandarathil@hp.com>
X-Mailer: git-send-email 1.7.11.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add support for error containment when a VFIO device assigned to a KVM
guest encounters an error. This is for PCIe devices/drivers that support AER
functionality. When the host OS is notified of an error in a device either
through the firmware first approach or through an interrupt handled by the AER
root port driver, the error handler registered by the vfio-pci driver gets
invoked. The qemu process is signaled through an eventfd registered per
VFIO device by the qemu process. In the eventfd handler, qemu decides on
what action to take. In this implementation, guest is brought down to
contain the error.


v4:
 - Stop the guest instead of terminating
 - Remove unwanted returns from functions
 - Incorporate other feedback
v3:
 - Removed PCI_AER* flags from device info ioctl.
 - Incorporated feedback
v2:
 - Rebased to latest upstream stable bits
 - Changed the new ioctl to be part of VFIO_SET_IRQs ioctl
 - Added a new patch to get/put reference to a vfio device from struct device
 - Incorporated all other feedback.

---

Vijay Mohan Pandarathil(3):

[PATCH 1/3] VFIO: Wrapper to get reference to vfio_device from device 
[PATCH 2/3] VFIO-AER: Vfio-pci driver changes for supporting AER
[PATCH 3/3] QEMU-AER: Qemu changes to support AER for VFIO-PCI devices

Kernel files changed

 drivers/vfio/vfio.c  | 47 ++++++++++++++++++++++++++++++++++-------------
 include/linux/vfio.h |  3 +++
 2 files changed, 37 insertions(+), 13 deletions(-)

 drivers/vfio/pci/vfio_pci.c         | 44 +++++++++++++++++++++++++++++++++-
 drivers/vfio/pci/vfio_pci_intrs.c   | 47 +++++++++++++++++++++++++++++++++++++
 drivers/vfio/pci/vfio_pci_private.h |  1 +
 include/uapi/linux/vfio.h           |  1 +
 4 files changed, 92 insertions(+), 1 deletion(-)

Qemu files changed

 hw/vfio_pci.c              | 112 +++++++++++++++++++++++++++++++++++++++++++++
 linux-headers/linux/vfio.h |   1 +
 2 files changed, 113 insertions(+)
