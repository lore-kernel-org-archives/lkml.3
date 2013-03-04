Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757594Ab3CDDpC (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Mar 2013 22:45:02 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:33207 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757474Ab3CDDo6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Mar 2013 22:44:58 -0500
Message-Id: <20130304033709.832263379@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Mon, 04 Mar 2013 03:37:30 +0000
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: akpm@linux-foundation.org, Bjorn Helgaas <bhelgaas@google.com>,
        Joonsoo Kim <js1304@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [ 023/153] Driver core: treat unregistered bus_types as having no devices
In-Reply-To: <20130304033707.648729212@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:a11:96ff:fec6:70c4
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

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
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/base/bus.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/base/bus.c
+++ b/drivers/base/bus.c
@@ -289,7 +289,7 @@ int bus_for_each_dev(struct bus_type *bu
 	struct device *dev;
 	int error = 0;
 
-	if (!bus)
+	if (!bus || !bus->p)
 		return -EINVAL;
 
 	klist_iter_init_node(&bus->p->klist_devices, &i,
@@ -323,7 +323,7 @@ struct device *bus_find_device(struct bu
 	struct klist_iter i;
 	struct device *dev;
 
-	if (!bus)
+	if (!bus || !bus->p)
 		return NULL;
 
 	klist_iter_init_node(&bus->p->klist_devices, &i,


