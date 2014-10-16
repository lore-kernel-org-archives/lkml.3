Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751289AbaJPDXF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Oct 2014 23:23:05 -0400
Received: from ozlabs.org ([103.22.144.67]:34064 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750838AbaJPDXD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Oct 2014 23:23:03 -0400
From: Michael Ellerman <mpe@ellerman.id.au>
To: <linuxppc-dev@ozlabs.org>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        <linux-kernel@vger.kernel.org>, Liviu.Dudau@arm.com,
        bhelgaas@google.com, linus.walleij@linaro.org
Subject: [PATCH] powerpc/pci: Fix IO space breakage after of_pci_range_to_resource() change
Date: Thu, 16 Oct 2014 14:22:55 +1100
Message-Id: <1413429775-716-1-git-send-email-mpe@ellerman.id.au>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit 0b0b0893d49b "of/pci: Fix the conversion of IO ranges into IO
resources" changed the behaviour of of_pci_range_to_resource().

Previously it simply populated the resource based on the arguments. Now
it calls pci_register_io_range() and pci_address_to_pio(). These both
have two implementations depending on whether PCI_IOBASE is defined,
which it is not for powerpc.

Further complicating matters, both routines are weak, and powerpc
implements it's own version of one - pci_address_to_pio(). However
powerpc's implementation depends on other initialisations which are done
later in boot.

The end result is incorrectly initialised IO space. Often we can get
away with that, because we don't make much use of IO space. However
virtio requires it, so we see eg:

  pci_bus 0000:00: root bus resource [io  0xffff] (bus address [0xffffffffffffffff-0xffffffffffffffff])
  PCI: Cannot allocate resource region 0 of device 0000:00:01.0, will remap
  virtio-pci 0000:00:01.0: can't enable device: BAR 0 [io  size 0x0020] not assigned

The simplest fix for now is to just stop using of_pci_range_to_resource(),
and open-code the original implementation, that's all we want it to do.

Fixes: 0b0b0893d49b ("of/pci: Fix the conversion of IO ranges into IO resources")
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
---
 arch/powerpc/kernel/pci-common.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/arch/powerpc/kernel/pci-common.c b/arch/powerpc/kernel/pci-common.c
index bd70a51d5747..e5dad9a9edc0 100644
--- a/arch/powerpc/kernel/pci-common.c
+++ b/arch/powerpc/kernel/pci-common.c
@@ -747,7 +747,11 @@ void pci_process_bridge_OF_ranges(struct pci_controller *hose,
 			break;
 		}
 		if (res != NULL) {
-			of_pci_range_to_resource(&range, dev, res);
+			res->name = dev->full_name;
+			res->flags = range.flags;
+			res->start = range.cpu_addr;
+			res->end = range.cpu_addr + range.size - 1;
+			res->parent = res->child = res->sibling = NULL;
 		}
 	}
 }
-- 
1.9.1

