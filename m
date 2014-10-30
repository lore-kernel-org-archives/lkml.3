Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760523AbaJ3R4h (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Oct 2014 13:56:37 -0400
Received: from mx1.redhat.com ([209.132.183.28]:60303 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757832AbaJ3R4g (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Oct 2014 13:56:36 -0400
Subject: [PATCH 1/3] PCI: Restore detection of read-only BARs
From: Myron Stowe <myron.stowe@redhat.com>
To: bhelgaas@google.com, linux-pci@vger.kernel.org
Cc: willy@linux.intel.com, unruh@physics.ubc.ca, linux-kernel@vger.kernel.org,
        martin@lucina.net
Date: Thu, 30 Oct 2014 11:54:37 -0600
Message-ID: <20141030175437.22238.47243.stgit@amt.stowe>
In-Reply-To: <20141030175430.22238.47671.stgit@amt.stowe>
References: <20141030175430.22238.47671.stgit@amt.stowe>
User-Agent: StGit/0.17-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit 6ac665c63dca ("PCI: rewrite PCI BAR reading code") altered
__pci_read_base's local variable 'l', masking off its lower non-addressing
related bits, prior to it being passed in as the 'base' parameter to
pci_size().  This masking broke pci_size's r/o BAR detection logic's
comparison check for r/o BARs that have lower order bits set.  For such
occurrences, the 'base == maxbase' check will no longer ever be "true".

This patch resolves this issue by also masking off the non-addressing
related bits of 'sz' before passing it into pci_size() as the 'maxbase'
parameter.  With this change the r/o detection logic of pci_size() will
once again catch known occurrences that have been encountered to date:
  - AGP aperture BAR of AMD-7xx host bridges; if the AGP window
    disabled, this BAR is read-only and read as 0x00000008 [1]
  - BAR0-4 of ALi IDE controllers can be non-zero and read-only [1]
  - Intel Sandy Bridge - Thermal Management Controller [8086:0103];
    BAR 0 returning 0xfed98004 [2]
  - Intel Xeon E5 v3/Core i7 Power Control Unit [8086:2fc0];
    Bar 0 returning 0x00001a [3]


[1] From Thomas Gleixner's "Linux kernel history" repository:
    https://git.kernel.org/cgit/linux/kernel/git/tglx/history.git/commit/drivers/pci/probe.c?id=1307ef6621991f1c4bc3cec1b5a4ebd6fd3d66b9
    pre-git commit 1307ef662199  "PCI: probing read-only Bars"
[2] https://bugzilla.kernel.org/show_bug.cgi?id=43331
[3] https://bugzilla.kernel.org/show_bug.cgi?id=85991


Reported-by: William Unruh <unruh@physics.ubc.ca>
Reported-by: Martin Lucina <martin@lucina.net>
Signed-off-by: Myron Stowe <myron.stowe@redhat.com>
Cc: Matthew Wilcox <willy@linux.intel.com>
---
 drivers/pci/probe.c |    3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/pci/probe.c b/drivers/pci/probe.c
index 5ed9930..19dc247 100644
--- a/drivers/pci/probe.c
+++ b/drivers/pci/probe.c
@@ -216,14 +216,17 @@ int __pci_read_base(struct pci_dev *dev, enum pci_bar_type type,
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
 

