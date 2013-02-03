Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753515Ab3BCOVM (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Feb 2013 09:21:12 -0500
Received: from g2t1383g.austin.hp.com ([15.217.136.92]:55732 "EHLO
	g2t1383g.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753226Ab3BCOVB convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Feb 2013 09:21:01 -0500
From: "Pandarathil, Vijaymohan R" <vijaymohan.pandarathil@hp.com>
To: Alex Williamson <alex.williamson@redhat.com>,
        Gleb Natapov <gleb@redhat.com>, Bjorn Helgaas <bhelgaas@google.com>,
        Blue Swirl <blauwirbel@gmail.com>,
        "Ortiz, Lance E" <lance.oritz@hp.com>
CC: "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "qemu-devel@nongnu.org" <qemu-devel@nongnu.org>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [PATCH v3 0/3] AER-KVM: Error containment of VFIO devices assigned
 to KVM guests
Thread-Topic: [PATCH v3 0/3] AER-KVM: Error containment of VFIO devices
 assigned to KVM guests
Thread-Index: AQHOAhgsb3nnz+tiIESFVGV51YRRHQ==
Date: Sun, 3 Feb 2013 14:10:08 +0000
Message-ID: <F9E001219150CB45BEDC82A650F360C9014AAEF8@G9W0717.americas.hpqcorp.net>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [15.201.58.27]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
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

[PATCH 1/3] VFIO: Wrapper for getting reference to vfio_device from device 
[PATCH 2/3] VFIO-AER: Vfio-pci driver changes for supporting AER
[PATCH 3/3] QEMU-AER: Qemu changes to support AER for VFIO-PCI devices

Kernel files changed

 drivers/vfio/vfio.c  | 41 ++++++++++++++++++++++++++++++++---------
 include/linux/vfio.h |  3 +++
 2 files changed, 35 insertions(+), 9 deletions(-)

 drivers/vfio/pci/vfio_pci.c         | 43 ++++++++++++++++++++++++++++++++++++-
 drivers/vfio/pci/vfio_pci_intrs.c   | 30 ++++++++++++++++++++++++++
 drivers/vfio/pci/vfio_pci_private.h |  1 +
 include/uapi/linux/vfio.h           |  1 +
 4 files changed, 74 insertions(+), 1 deletion(-)

Qemu files changed

 hw/vfio_pci.c              | 105 +++++++++++++++++++++++++++++++++++++++++++++
 linux-headers/linux/vfio.h |   1 +
 2 files changed, 106 insertions(+)
