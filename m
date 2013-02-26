Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760192Ab3B0BOj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Feb 2013 20:14:39 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:41802 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760050Ab3BZX5T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Feb 2013 18:57:19 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Joonsoo Kim <js1304@gmail.com>, Bjorn Helgaas <bhelgaas@google.com>
Subject: [ 031/150] Driver core: treat unregistered bus_types as having no devices
Date: Tue, 26 Feb 2013 15:54:48 -0800
Message-Id: <20130226235527.447606734@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.rc1.5.g7e0651a
In-Reply-To: <20130226235523.930663721@linuxfoundation.org>
References: <20130226235523.930663721@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8-stable review patch.  If anyone has any objections, please let me know.

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

---
 drivers/base/bus.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/base/bus.c
+++ b/drivers/base/bus.c
@@ -290,7 +290,7 @@ int bus_for_each_dev(struct bus_type *bu
 	struct device *dev;
 	int error = 0;
 
-	if (!bus)
+	if (!bus || !bus->p)
 		return -EINVAL;
 
 	klist_iter_init_node(&bus->p->klist_devices, &i,
@@ -324,7 +324,7 @@ struct device *bus_find_device(struct bu
 	struct klist_iter i;
 	struct device *dev;
 
-	if (!bus)
+	if (!bus || !bus->p)
 		return NULL;
 
 	klist_iter_init_node(&bus->p->klist_devices, &i,


