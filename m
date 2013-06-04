Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752072Ab3FDWlE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Jun 2013 18:41:04 -0400
Received: from 1wt.eu ([62.212.114.60]:35135 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751728Ab3FDWkl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Jun 2013 18:40:41 -0400
Message-Id: <20130604172131.553536735@1wt.eu>
User-Agent: quilt/0.48-1
Date: Tue, 04 Jun 2013 19:22:00 +0200
From: Willy Tarreau <w@1wt.eu>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Bjorn Helgaas <bhelgaas@google.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Willy Tarreau <w@1wt.eu>
Subject: [ 030/184] Driver core: treat unregistered bus_types as having
In-Reply-To: <58df134a4b98edf5b0073e2e1e988fe6@local>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-longterm review patch.  If anyone has any objections, please let me know.

------------------
 no devices

From: Bjorn Helgaas <bhelgaas@google.com>

commit 4fa3e78be7e985ca814ce2aa0c09cbee404efcf7 upstream.

A bus_type has a list of devices (klist_devices), but the list and the
subsys_private structure that contains it are not initialized until the
bus_type is registered with bus_register().

The panic/reboot path has fixups that look up devices in pci_bus_type.  If
we panic before registering pci_bus_type, the bus_type exists but the list
does not, so mach_reboot_fixups() trips over a null pointer and panics
again:

    mach_reboot_fixups
      pci_get_device
        ..
          bus_find_device(&pci_bus_type, ...)
            bus->p is NULL

Joonsoo reported a problem when panicking before PCI was initialized.
I think this patch should be sufficient to replace the patch he posted
here: https://lkml.org/lkml/2012/12/28/75 ("[PATCH] x86, reboot: skip
reboot_fixups in early boot phase")

Reported-by: Joonsoo Kim <js1304@gmail.com>
Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Willy Tarreau <w@1wt.eu>
---
 drivers/base/bus.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/base/bus.c b/drivers/base/bus.c
index 63c143e..6f1ba10 100644
--- a/drivers/base/bus.c
+++ b/drivers/base/bus.c
@@ -289,7 +289,7 @@ int bus_for_each_dev(struct bus_type *bus, struct device *start,
 	struct device *dev;
 	int error = 0;
 
-	if (!bus)
+	if (!bus || !bus->p)
 		return -EINVAL;
 
 	klist_iter_init_node(&bus->p->klist_devices, &i,
@@ -323,7 +323,7 @@ struct device *bus_find_device(struct bus_type *bus,
 	struct klist_iter i;
 	struct device *dev;
 
-	if (!bus)
+	if (!bus || !bus->p)
 		return NULL;
 
 	klist_iter_init_node(&bus->p->klist_devices, &i,
-- 
1.7.12.2.21.g234cd45.dirty



