Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764190AbbA2DXq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2015 22:23:46 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:46935 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964869AbbA2Cfh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jan 2015 21:35:37 -0500
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Myron Stowe <myron.stowe@redhat.com>, Bjorn Helgaas <bhelgaas@google.com>,
        Matthew Wilcox <willy@linux.intel.com>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.13.y-ckt 032/139] PCI: Restore detection of read-only BARs
Date: Wed, 28 Jan 2015 14:19:35 -0800
Message-Id: <1422483682-15393-33-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1422483682-15393-1-git-send-email-kamal@canonical.com>
References: <1422483682-15393-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.13
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13.11-ckt15 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Myron Stowe <myron.stowe@redhat.com>

commit 36e8164882ca6d3c41cb91e6f09a3ed236841f80 upstream.

Commit 6ac665c63dca ("PCI: rewrite PCI BAR reading code") masked off
low-order bits from 'l', but not from 'sz'.  Both are passed to pci_size(),
which compares 'base == maxbase' to check for read-only BARs.  The masking
of 'l' means that comparison will never be 'true', so the check for
read-only BARs no longer works.

Resolve this by also masking off the low-order bits of 'sz' before passing
it into pci_size() as 'maxbase'.  With this change, pci_size() will once
again catch the problems that have been encountered to date:

  - AGP aperture BAR of AMD-7xx host bridges: if the AGP window is
    disabled, this BAR is read-only and read as 0x00000008 [1]

  - BARs 0-4 of ALi IDE controllers can be non-zero and read-only [1]

  - Intel Sandy Bridge - Thermal Management Controller [8086:0103];
    BAR 0 returning 0xfed98004 [2]

  - Intel Xeon E5 v3/Core i7 Power Control Unit [8086:2fc0];
    Bar 0 returning 0x00001a [3]

Link: [1] https://git.kernel.org/cgit/linux/kernel/git/tglx/history.git/commit/drivers/pci/probe.c?id=1307ef6621991f1c4bc3cec1b5a4ebd6fd3d66b9 ("PCI: probing read-only BARs" (pre-git))
Link: [2] https://bugzilla.kernel.org/show_bug.cgi?id=43331
Link: [3] https://bugzilla.kernel.org/show_bug.cgi?id=85991
Reported-by: William Unruh <unruh@physics.ubc.ca>
Reported-by: Martin Lucina <martin@lucina.net>
Signed-off-by: Myron Stowe <myron.stowe@redhat.com>
Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
CC: Matthew Wilcox <willy@linux.intel.com>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/pci/probe.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/pci/probe.c b/drivers/pci/probe.c
index 38e403d..ef18351 100644
--- a/drivers/pci/probe.c
+++ b/drivers/pci/probe.c
@@ -214,14 +214,17 @@ int __pci_read_base(struct pci_dev *dev, enum pci_bar_type type,
 		res->flags |= IORESOURCE_SIZEALIGN;
 		if (res->flags & IORESOURCE_IO) {
 			l &= PCI_BASE_ADDRESS_IO_MASK;
+			sz &= PCI_BASE_ADDRESS_IO_MASK;
 			mask = PCI_BASE_ADDRESS_IO_MASK & (u32) IO_SPACE_LIMIT;
 		} else {
 			l &= PCI_BASE_ADDRESS_MEM_MASK;
+			sz &= PCI_BASE_ADDRESS_MEM_MASK;
 			mask = (u32)PCI_BASE_ADDRESS_MEM_MASK;
 		}
 	} else {
 		res->flags |= (l & IORESOURCE_ROM_ENABLE);
 		l &= PCI_ROM_ADDRESS_MASK;
+		sz &= PCI_ROM_ADDRESS_MASK;
 		mask = (u32)PCI_ROM_ADDRESS_MASK;
 	}
 
-- 
1.9.1

