Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752077Ab3A2Xod (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jan 2013 18:44:33 -0500
Received: from mail-vb0-f73.google.com ([209.85.212.73]:51298 "EHLO
	mail-vb0-f73.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751326Ab3A2Xob (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jan 2013 18:44:31 -0500
Subject: [PATCH] Driver core: treat unregistered bus_types as having no devices
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
From: Bjorn Helgaas <bhelgaas@google.com>
Cc: Joonsoo Kim <js1304@gmail.com>, x86@kernel.org,
        linux-kernel@vger.kernel.org, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>
Date: Tue, 29 Jan 2013 16:44:27 -0700
Message-ID: <20130129234427.23748.83270.stgit@bhelgaas.mtv.corp.google.com>
User-Agent: StGit/0.15
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

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

Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
---
 drivers/base/bus.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/base/bus.c b/drivers/base/bus.c
index 24eb078..6856303 100644
--- a/drivers/base/bus.c
+++ b/drivers/base/bus.c
@@ -290,7 +290,7 @@ int bus_for_each_dev(struct bus_type *bus, struct device *start,
 	struct device *dev;
 	int error = 0;
 
-	if (!bus)
+	if (!bus || !bus->p)
 		return -EINVAL;
 
 	klist_iter_init_node(&bus->p->klist_devices, &i,
@@ -324,7 +324,7 @@ struct device *bus_find_device(struct bus_type *bus,
 	struct klist_iter i;
 	struct device *dev;
 
-	if (!bus)
+	if (!bus || !bus->p)
 		return NULL;
 
 	klist_iter_init_node(&bus->p->klist_devices, &i,

