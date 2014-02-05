Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755945AbaBEUxn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Feb 2014 15:53:43 -0500
Received: from mail.windriver.com ([147.11.1.11]:54892 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754676AbaBEUFt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Feb 2014 15:05:49 -0500
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: <stable@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC: Bjorn Helgaas <bhelgaas@google.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: [v2.6.34-stable 093/213] Driver core: treat unregistered bus_types as having no devices
Date: Wed, 5 Feb 2014 15:00:48 -0500
Message-ID: <1391630568-49251-94-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.8.5.2
In-Reply-To: <1391630568-49251-1-git-send-email-paul.gortmaker@windriver.com>
References: <1391630568-49251-1-git-send-email-paul.gortmaker@windriver.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Bjorn Helgaas <bhelgaas@google.com>

                   -------------------
    This is a commit scheduled for the next v2.6.34 longterm release.
    http://git.kernel.org/?p=linux/kernel/git/paulg/longterm-queue-2.6.34.git
    If you see a problem with using this for longterm, please comment.
                   -------------------

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
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 drivers/base/bus.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/base/bus.c b/drivers/base/bus.c
index 12eec3f633b1..1913e74ee582 100644
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
-- 
1.8.5.2

