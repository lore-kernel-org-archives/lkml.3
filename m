Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756376Ab3GCOCJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Jul 2013 10:02:09 -0400
Received: from mga09.intel.com ([134.134.136.24]:7914 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754158Ab3GCOCF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Jul 2013 10:02:05 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,988,1363158000"; 
   d="scan'208";a="359952427"
From: Mika Westerberg <mika.westerberg@linux.intel.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Bjorn Helgaas <bhelgaas@google.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>, Yinghai Lu <yinghai@kernel.org>,
        john.ronciak@intel.com, miles.j.penner@intel.com,
        bruce.w.allan@intel.com,
        Heikki Krogerus <heikki.krogerus@linux.intel.com>,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org,
        linux-pci@vger.kernel.org, x86@kernel.org
Subject: [PATCH v2 2/8] PCI: acpiphp: do not check for SLOT_ENABLED in enable_device()
Date: Wed,  3 Jul 2013 17:04:49 +0300
Message-Id: <1372860295-8306-3-git-send-email-mika.westerberg@linux.intel.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1372860295-8306-1-git-send-email-mika.westerberg@linux.intel.com>
References: <1372860295-8306-1-git-send-email-mika.westerberg@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>

With Thunderbolt you can chain devices: connect a new devices to plugged
one. In this case the slot is already enabled, but we still want to look
for new devices behind it.

We're going to reuse enable_device() for rescan for new devices on the
enabled slot. Let's push the check up by stack.

Signed-off-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Signed-off-by: Mika Westerberg <mika.westerberg@linux.intel.com>
---
 drivers/pci/hotplug/acpiphp_glue.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/pci/hotplug/acpiphp_glue.c b/drivers/pci/hotplug/acpiphp_glue.c
index 59df857..b983e29 100644
--- a/drivers/pci/hotplug/acpiphp_glue.c
+++ b/drivers/pci/hotplug/acpiphp_glue.c
@@ -688,9 +688,6 @@ static int __ref enable_device(struct acpiphp_slot *slot)
 	int num, max, pass;
 	LIST_HEAD(add_list);
 
-	if (slot->flags & SLOT_ENABLED)
-		goto err_exit;
-
 	list_for_each_entry(func, &slot->funcs, sibling)
 		acpiphp_bus_add(func);
 
@@ -1242,6 +1239,8 @@ int acpiphp_enable_slot(struct acpiphp_slot *slot)
 		goto err_exit;
 
 	if (get_slot_status(slot) == ACPI_STA_ALL) {
+		if (slot->flags & SLOT_ENABLED)
+			goto err_exit;
 		/* configure all functions */
 		retval = enable_device(slot);
 		if (retval)
-- 
1.8.3.2

