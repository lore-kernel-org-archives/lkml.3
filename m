Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932511Ab3HGKV5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Aug 2013 06:21:57 -0400
Received: from mail2.gnudd.com ([213.203.150.91]:56224 "EHLO mail.gnudd.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932454Ab3HGKVy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Aug 2013 06:21:54 -0400
Date: Wed, 7 Aug 2013 12:21:31 +0200
From: Davide Ciminaghi <ciminaghi@gnudd.com>
To: linux-kernel@vger.kernel.org
Cc: rubini@gnudd.com, Giancarlo Asnaghi <giancarlo.asnaghi@st.com>,
        x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
        Ingo Molnar <mingo@redhat.com>, Russell King <linux@arm.linux.org.uk>,
        Thomas Gleixner <tglx@linutronix.de>, devicetree@vger.kernel.org
Subject: [PATCH 23/26] AMBA: pci-amba bridge: export function creating
 pci-amba device names
Message-ID: <25c849c312f08d161b91a1c7b7ea56e1c7207789.1375867291.git.rubini@gnudd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Organization: GnuDD, Device Drivers, Embedded Systems, Courses
References: <cover.1375867291.git.rubini@gnudd.com>
In-Reply-To: <cover.1375867291.git.rubini@gnudd.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

pci_amba_get_dev_name() will be used by the sta2x11 common clock framework
to register clkdevs with the same name as the corresponding amba or
platform device.

Signed-off-by: Davide Ciminaghi <ciminaghi@gnudd.com>
Acked-by: Giancarlo Asnaghi <giancarlo.asnaghi@st.com>
---
 drivers/amba/pci-amba.c  |   14 ++++++++++++++
 include/linux/pci-amba.h |   42 ++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 56 insertions(+), 0 deletions(-)
 create mode 100644 include/linux/pci-amba.h

diff --git a/drivers/amba/pci-amba.c b/drivers/amba/pci-amba.c
index f272d38..1beeefd 100644
--- a/drivers/amba/pci-amba.c
+++ b/drivers/amba/pci-amba.c
@@ -9,6 +9,7 @@
 #include <linux/amba/bus.h>
 #include <linux/pci.h>
 #include <linux/pci_ids.h>
+#include <linux/pci-amba.h>
 #include <linux/slab.h>
 #include <linux/irq.h>
 #include <linux/sizes.h>
@@ -25,6 +26,8 @@
 */
 #define IMAP_ROW_LEN (1 + 1 + 1 + 1 + 1)
 
+static const struct pci_device_id pci_amba_table[];
+
 static inline int resource_fits(struct resource *r1, struct resource *r2)
 {
 	return (r1->start >= r2->start) && (r1->end <= r2->end);
@@ -63,6 +66,17 @@ static int get_dev_name(char **name, struct pci_dev *pdev, int index)
 	return 0;
 }
 
+int pci_amba_get_dev_name(char **name, struct pci_dev *pdev, int index)
+{
+	/* Check whether the device is a pci-amba one */
+	if (!pci_match_id(pci_amba_table, pdev))
+		return -ENODEV;
+	if (!name)
+		return -EINVAL;
+	return get_dev_name(name, pdev, index);
+}
+EXPORT_SYMBOL(pci_amba_get_dev_name);
+
 static int fixup_irq(struct device_node *node,
 		     struct device_node *amba_bus,
 		     struct pci_dev *pdev)
diff --git a/include/linux/pci-amba.h b/include/linux/pci-amba.h
new file mode 100644
index 0000000..913624e
--- /dev/null
+++ b/include/linux/pci-amba.h
@@ -0,0 +1,42 @@
+/*
+ * PCI-AMBA Helpers
+ *
+ * Copyright 2012 ST Microelectronics (Alessandro Rubini, Davide Ciminaghi)
+ *
+ * All rights reserved.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or (at
+ * your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful, but
+ * WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY OR FITNESS FOR A PARTICULAR PURPOSE, GOOD TITLE or
+ * NON INFRINGEMENT.  See the GNU General Public License for more
+ * details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
+ *
+ */
+#ifndef _PCI_AMBA_H
+#define _PCI_AMBA_H
+
+#include <linux/of.h>
+
+/*
+ * pci_amba_get_dev_name: allocate and fill in a buffer with a suitable
+ * name for a pci-amba device.
+ *
+ * @name: pointer to a location where the address of the allocated buffer
+ * shall be stored.
+ * @pdev: pointer to the corresponding pci device.
+ * @index: index of device (in case of more than one amba/platform device
+ * per pci device).
+ *
+ */
+extern int pci_amba_get_dev_name(char **name, struct pci_dev *pdev, int index);
+
+#endif /* _PCI_AMBA_H */
-- 
1.7.7.2
