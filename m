Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933262AbaLDVbd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Dec 2014 16:31:33 -0500
Received: from 251.110.2.81.in-addr.arpa ([81.2.110.251]:58614 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932236AbaLDVbc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Dec 2014 16:31:32 -0500
Subject: [PATCH 5/5] pcmcia: add a new resource manager for non ISA systems
From: Alan Cox <alan@linux.intel.com>
To: linux-kernel@vger.kernel.org, linux-pcmica@lists.infradead.org
Date: Thu, 04 Dec 2014 21:31:22 +0000
Message-ID: <20141204213108.1351.2478.stgit@localhost.localdomain>
In-Reply-To: <20141204212746.1351.89165.stgit@localhost.localdomain>
References: <20141204212746.1351.89165.stgit@localhost.localdomain>
User-Agent: StGit/0.17-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On a pure PCI platform we don't actually need all the complexity of the
rsrc_nonstatic manager, in fact we can just work directly with the pci
allocators and avoid all the complexity (and code bloat).

Signed-off-by: Alan Cox <alan@linux.intel.com>
---
 drivers/pcmcia/Kconfig    |   12 ++-
 drivers/pcmcia/Makefile   |    1 
 drivers/pcmcia/rsrc_pci.c |  172 +++++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 182 insertions(+), 3 deletions(-)
 create mode 100644 drivers/pcmcia/rsrc_pci.c

diff --git a/drivers/pcmcia/Kconfig b/drivers/pcmcia/Kconfig
index b0ce7cd..2bd21a6 100644
--- a/drivers/pcmcia/Kconfig
+++ b/drivers/pcmcia/Kconfig
@@ -69,7 +69,8 @@ config YENTA
 	tristate "CardBus yenta-compatible bridge support"
 	depends on PCI
 	select CARDBUS if !EXPERT
-	select PCCARD_NONSTATIC if PCMCIA != n
+	select PCCARD_NONSTATIC if PCMCIA != n && ISA
+	select PCCARD_PCI if PCMCIA !=n && !ISA
 	---help---
 	  This option enables support for CardBus host bridges.  Virtually
 	  all modern PCMCIA bridges are CardBus compatible.  A "bridge" is
@@ -109,7 +110,8 @@ config YENTA_TOSHIBA
 config PD6729
 	tristate "Cirrus PD6729 compatible bridge support"
 	depends on PCMCIA && PCI
-	select PCCARD_NONSTATIC
+	select PCCARD_NONSTATIC if PCMCIA != n && ISA
+	select PCCARD_PCI if PCMCIA !=n && !ISA
 	help
 	  This provides support for the Cirrus PD6729 PCI-to-PCMCIA bridge
 	  device, found in some older laptops and PCMCIA card readers.
@@ -117,7 +119,8 @@ config PD6729
 config I82092
 	tristate "i82092 compatible bridge support"
 	depends on PCMCIA && PCI
-	select PCCARD_NONSTATIC
+	select PCCARD_NONSTATIC if PCMCIA != n && ISA
+	select PCCARD_PCI if PCMCIA !=n && !ISA
 	help
 	  This provides support for the Intel I82092AA PCI-to-PCMCIA bridge device,
 	  found in some older laptops and more commonly in evaluation boards for the
@@ -289,6 +292,9 @@ config ELECTRA_CF
 	  Say Y here to support the CompactFlash controller on the
 	  PA Semi Electra eval board.
 
+config PCCARD_PCI
+	bool
+
 config PCCARD_NONSTATIC
 	bool
 
diff --git a/drivers/pcmcia/Makefile b/drivers/pcmcia/Makefile
index 27e94b3..f1a7ca0 100644
--- a/drivers/pcmcia/Makefile
+++ b/drivers/pcmcia/Makefile
@@ -12,6 +12,7 @@ obj-$(CONFIG_PCMCIA)				+= pcmcia.o
 pcmcia_rsrc-y					+= rsrc_mgr.o
 pcmcia_rsrc-$(CONFIG_PCCARD_NONSTATIC)		+= rsrc_nonstatic.o
 pcmcia_rsrc-$(CONFIG_PCCARD_IODYN)		+= rsrc_iodyn.o
+pcmcia_rsrc-$(CONFIG_PCCARD_PCI)		+= rsrc_pci.o
 obj-$(CONFIG_PCCARD)				+= pcmcia_rsrc.o
 
 
diff --git a/drivers/pcmcia/rsrc_pci.c b/drivers/pcmcia/rsrc_pci.c
new file mode 100644
index 0000000..8934d3c
--- /dev/null
+++ b/drivers/pcmcia/rsrc_pci.c
@@ -0,0 +1,172 @@
+#include <linux/slab.h>
+#include <linux/module.h>
+#include <linux/kernel.h>
+
+#include <pcmcia/ss.h>
+#include <pcmcia/cistpl.h>
+#include "cs_internal.h"
+
+
+struct pcmcia_align_data {
+	unsigned long	mask;
+	unsigned long	offset;
+};
+
+static resource_size_t pcmcia_align(void *align_data,
+				const struct resource *res,
+				resource_size_t size, resource_size_t align)
+{
+	struct pcmcia_align_data *data = align_data;
+	resource_size_t start;
+
+	start = (res->start & ~data->mask) + data->offset;
+	if (start < res->start)
+		start += data->mask + 1;
+	return start;
+}
+
+static struct resource *find_io_region(struct pcmcia_socket *s,
+					unsigned long base, int num,
+					unsigned long align)
+{
+	struct resource *res = pcmcia_make_resource(0, num, IORESOURCE_IO,
+						dev_name(&s->dev));
+	struct pcmcia_align_data data;
+	int ret;
+
+	data.mask = align - 1;
+	data.offset = base & data.mask;
+
+	ret = pci_bus_alloc_resource(s->cb_dev->bus, res, num, 1,
+					     base, 0, pcmcia_align, &data);
+	if (ret != 0) {
+		kfree(res);
+		res = NULL;
+	}
+	return res;
+}
+
+static int res_pci_find_io(struct pcmcia_socket *s, unsigned int attr,
+			unsigned int *base, unsigned int num,
+			unsigned int align, struct resource **parent)
+{
+	int i, ret = 0;
+
+	/* Check for an already-allocated window that must conflict with
+	 * what was asked for.  It is a hack because it does not catch all
+	 * potential conflicts, just the most obvious ones.
+	 */
+	for (i = 0; i < MAX_IO_WIN; i++) {
+		if (!s->io[i].res)
+			continue;
+
+		if (!*base)
+			continue;
+
+		if ((s->io[i].res->start & (align-1)) == *base)
+			return -EBUSY;
+	}
+
+	for (i = 0; i < MAX_IO_WIN; i++) {
+		struct resource *res = s->io[i].res;
+		unsigned int try;
+
+		if (res && (res->flags & IORESOURCE_BITS) !=
+			(attr & IORESOURCE_BITS))
+			continue;
+
+		if (!res) {
+			if (align == 0)
+				align = 0x10000;
+
+			res = s->io[i].res = find_io_region(s, *base, num,
+								align);
+			if (!res)
+				return -EINVAL;
+
+			*base = res->start;
+			s->io[i].res->flags =
+				((res->flags & ~IORESOURCE_BITS) |
+					(attr & IORESOURCE_BITS));
+			s->io[i].InUse = num;
+			*parent = res;
+			return 0;
+		}
+
+		/* Try to extend top of window */
+		try = res->end + 1;
+		if ((*base == 0) || (*base == try)) {
+			ret = adjust_resource(s->io[i].res, res->start,
+					      resource_size(res) + num);
+			if (ret)
+				continue;
+			*base = try;
+			s->io[i].InUse += num;
+			*parent = res;
+			return 0;
+		}
+
+		/* Try to extend bottom of window */
+		try = res->start - num;
+		if ((*base == 0) || (*base == try)) {
+			ret = adjust_resource(s->io[i].res,
+					      res->start - num,
+					      resource_size(res) + num);
+			if (ret)
+				continue;
+			*base = try;
+			s->io[i].InUse += num;
+			*parent = res;
+			return 0;
+		}
+	}
+	return -EINVAL;
+}
+
+static struct resource *res_pci_find_mem(u_long base, u_long num,
+		u_long align, int low, struct pcmcia_socket *s)
+{
+	struct resource *res = pcmcia_make_resource(0, num, IORESOURCE_MEM,
+						dev_name(&s->dev));
+	struct pcmcia_align_data data;
+	unsigned long min;
+	int ret;
+
+	if (align < 0x20000)
+		align = 0x20000;
+	data.mask = align - 1;
+	data.offset = base & data.mask;
+
+	min = 0;
+	if (!low)
+		min = 0x100000UL;
+
+	ret = pci_bus_alloc_resource(s->cb_dev->bus,
+			res, num, 1, min, 0,
+			pcmcia_align, &data);
+
+	if (ret != 0) {
+		kfree(res);
+		res = NULL;
+	}
+	return res;
+}
+
+
+static int res_pci_init(struct pcmcia_socket *s)
+{
+	if (!s->cb_dev || (!s->features & SS_CAP_PAGE_REGS)) {
+		dev_err(&s->dev, "not supported by res_pci\n");
+		return -EOPNOTSUPP;
+	}
+	return 0;
+}
+
+struct pccard_resource_ops pccard_nonstatic_ops = {
+	.validate_mem = NULL,
+	.find_io = res_pci_find_io,
+	.find_mem = res_pci_find_mem,
+	.init = res_pci_init,
+	.exit = NULL,
+};
+EXPORT_SYMBOL(pccard_nonstatic_ops);

