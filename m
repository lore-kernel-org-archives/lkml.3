Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756642Ab3GKX6x (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Jul 2013 19:58:53 -0400
Received: from hydra.sisk.pl ([212.160.235.94]:38999 "EHLO hydra.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756574Ab3GKX6v (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Jul 2013 19:58:51 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: ACPI Devel Maling List <linux-acpi@vger.kernel.org>
Cc: Bjorn Helgaas <bhelgaas@google.com>, LKML <linux-kernel@vger.kernel.org>,
        Linux PCI <linux-pci@vger.kernel.org>, Yinghai Lu <yinghai@kernel.org>,
        Jiang Liu <liuj97@gmail.com>,
        Mika Westerberg <mika.westerberg@linux.intel.com>
Subject: [RFC][PATCH 24/30] ACPI / hotplug / PCI: Do not check SLOT_ENABLED in enable_device()
Date: Fri, 12 Jul 2013 02:02:23 +0200
Message-ID: <2002219.smES9ylgeU@vostro.rjw.lan>
User-Agent: KMail/4.9.5 (Linux/3.10.0+; KDE/4.9.5; x86_64; ; )
In-Reply-To: <3718119.FLASu5DBx8@vostro.rjw.lan>
References: <26431283.HJCKsss0rt@vostro.rjw.lan> <3718119.FLASu5DBx8@vostro.rjw.lan>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>

With Thunderbolt you can daisy chain devices: connect new devices to
an already plugged one.  In that case the "hotplug slot" is already
enabled, but we still want to look for new PCI devices behind it.

Reuse enable_device() to scan for new PCI devices on enabled slots
and push the SLOT_ENABLED check up into acpiphp_enable_slot().

[rjw: Rebased, modified the changelog]
Signed-off-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Signed-off-by: Mika Westerberg <mika.westerberg@linux.intel.com>
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
---
drivers/pci/hotplug/acpiphp_glue.c | 5 ++---
 drivers/pci/hotplug/acpiphp_glue.c |   10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

Index: linux-pm/drivers/pci/hotplug/acpiphp_glue.c
===================================================================
--- linux-pm.orig/drivers/pci/hotplug/acpiphp_glue.c
+++ linux-pm/drivers/pci/hotplug/acpiphp_glue.c
@@ -557,9 +557,6 @@ static int __ref enable_device(struct ac
 	int num, max, pass;
 	LIST_HEAD(add_list);
 
-	if (slot->flags & SLOT_ENABLED)
-		goto err_exit;
-
 	list_for_each_entry(func, &slot->funcs, sibling)
 		acpiphp_bus_add(func_to_handle(func));
 
@@ -1036,11 +1033,14 @@ void acpiphp_remove_slots(struct pci_bus
  */
 int acpiphp_enable_slot(struct acpiphp_slot *slot)
 {
-	int retval;
+	int retval = 0;
 
 	mutex_lock(&slot->crit_sect);
+
 	/* configure all functions */
-	retval = enable_device(slot);
+	if (!(slot->flags & SLOT_ENABLED))
+		retval = enable_device(slot);
+
 	mutex_unlock(&slot->crit_sect);
 	return retval;
 }

