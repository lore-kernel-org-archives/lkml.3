Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752084Ab3EMJEc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 May 2013 05:04:32 -0400
Received: from mx1.redhat.com ([209.132.183.28]:14448 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750951Ab3EMJEb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 May 2013 05:04:31 -0400
Date: Mon, 13 May 2013 11:05:48 +0200
From: Alexander Gordeev <agordeev@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: x86@kernel.org, linux-pci@vger.kernel.org,
        Suresh Siddha <suresh.b.siddha@intel.com>,
        Yinghai Lu <yinghai@kernel.org>, Joerg Roedel <joro@8bytes.org>,
        Jan Beulich <JBeulich@suse.com>, Ingo Molnar <mingo@redhat.com>,
        Bjorn Helgaas <bhelgaas@google.com>
Subject: [PATCH v3 -tip x86/apic 1/2] PCI/MSI: Allocate as many multiple-MSIs
 as requested
Message-ID: <8575dc590b819892f366852fe50835efaf579f4f.1368431413.git.agordeev@redhat.com>
References: <cover.1368431413.git.agordeev@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1368431413.git.agordeev@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When multiple MSIs are enabled with pci_enable_msi_block(), the
requested number of interrupts 'nvec' is rounded up to the nearest
power-of-two value. The result is then used for setting up the
number of MSI messages in the PCI device and allocation of
interrupt resources in the operating system (i.e. vector numbers).
Thus, in cases when a device driver requests some number of MSIs
and this number is not a power-of-two value, the extra operating
system resources (allocated as the result of rounding) are wasted.

This fix introduces 'msi_desc::nvec' field to address the above
issue. When non-zero, it will report the actual number of MSIs the
device will send, as requested by the device driver. This value
should be used by architectures to properly set up and tear down
associated interrupt resources.

Note, although the existing 'msi_desc::multiple' field might seem
redundant, in fact in does not. In general case the number of MSIs a
PCI device is initialized with is not necessarily the closest power-
of-two value of the number of MSIs the device will send. Thus, in
theory it would not be always possible to derive the former from the
latter and we need to keep them both, to stress this corner case.
Besides, since 'msi_desc::multiple' is a bitfield, throwing it out
would not save us any space.

Signed-off-by: Alexander Gordeev <agordeev@redhat.com>
---
 drivers/pci/msi.c   |   10 ++++++++--
 include/linux/msi.h |    1 +
 2 files changed, 9 insertions(+), 2 deletions(-)

diff --git a/drivers/pci/msi.c b/drivers/pci/msi.c
index 00cc78c7..014b9d5 100644
--- a/drivers/pci/msi.c
+++ b/drivers/pci/msi.c
@@ -79,7 +79,10 @@ void default_teardown_msi_irqs(struct pci_dev *dev)
 		int i, nvec;
 		if (entry->irq == 0)
 			continue;
-		nvec = 1 << entry->msi_attrib.multiple;
+		if (entry->nvec)
+			nvec = entry->nvec;
+		else
+			nvec = 1 << entry->msi_attrib.multiple;
 		for (i = 0; i < nvec; i++)
 			arch_teardown_msi_irq(entry->irq + i);
 	}
@@ -340,7 +343,10 @@ static void free_msi_irqs(struct pci_dev *dev)
 		int i, nvec;
 		if (!entry->irq)
 			continue;
-		nvec = 1 << entry->msi_attrib.multiple;
+		if (entry->nvec)
+			nvec = entry->nvec;
+		else
+			nvec = 1 << entry->msi_attrib.multiple;
 #ifdef CONFIG_GENERIC_HARDIRQS
 		for (i = 0; i < nvec; i++)
 			BUG_ON(irq_has_action(entry->irq + i));
diff --git a/include/linux/msi.h b/include/linux/msi.h
index ce93a34..0e20dfc 100644
--- a/include/linux/msi.h
+++ b/include/linux/msi.h
@@ -35,6 +35,7 @@ struct msi_desc {
 
 	u32 masked;			/* mask bits */
 	unsigned int irq;
+	unsigned int nvec;		/* number of messages */
 	struct list_head list;
 
 	union {
-- 
1.7.7.6


-- 
Regards,
Alexander Gordeev
agordeev@redhat.com
