Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753166AbbANHta (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jan 2015 02:49:30 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:58799 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933022AbbANHhh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jan 2015 02:37:37 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        William Unruh <unruh@physics.ubc.ca>,
        Martin Lucina <martin@lucina.net>,
        Myron Stowe <myron.stowe@redhat.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Matthew Wilcox <willy@linux.intel.com>
Subject: [PATCH 3.10 11/44] PCI: Restore detection of read-only BARs
Date: Tue, 13 Jan 2015 23:23:32 -0800
Message-Id: <20150114072228.112229204@linuxfoundation.org>
X-Mailer: git-send-email 2.2.2
In-Reply-To: <20150114072227.419663002@linuxfoundation.org>
References: <20150114072227.419663002@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/pci/probe.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/drivers/pci/probe.c
+++ b/drivers/pci/probe.c
@@ -210,14 +210,17 @@ int __pci_read_base(struct pci_dev *dev,
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
 


