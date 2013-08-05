Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753452Ab3HEN7w (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Aug 2013 09:59:52 -0400
Received: from hydra.sisk.pl ([212.160.235.94]:56605 "EHLO hydra.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752645Ab3HEN7v (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Aug 2013 09:59:51 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: ACPI Devel Maling List <linux-acpi@vger.kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Linux PM list <linux-pm@vger.kernel.org>
Subject: [PATCH] ACPI / PM: Walk physical_node_list under physical_node_lock
Date: Mon, 05 Aug 2013 16:10:08 +0200
Message-ID: <4934962.0gqQfGrEzP@vostro.rjw.lan>
User-Agent: KMail/4.9.5 (Linux/3.11.0-rc4+; KDE/4.9.5; x86_64; ; )
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>

The list of physical devices corresponding to an ACPI device
object is walked by acpi_system_wakeup_device_seq_show() and
physical_device_enable_wakeup() without taking that object's
physical_node_lock mutex.  Since each of those functions may be
run at any time as a result of a user space action, the lack of
appropriate locking in them may lead to a kernel crash if that
happens during device hot-add or hot-remove involving the device
object in question.

Fix the issue by modifying acpi_system_wakeup_device_seq_show() and
physical_device_enable_wakeup() to use physical_node_lock as
appropriate.

Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Cc: All <stable@vger.kernel.org>
---

This is urgent stuff, so if anyone has any objections against this or sees
any problems with it, please let me know immediately.

Thanks,
Rafael

---
 drivers/acpi/proc.c |    8 ++++++++
 1 file changed, 8 insertions(+)

Index: linux-pm/drivers/acpi/proc.c
===================================================================
--- linux-pm.orig/drivers/acpi/proc.c
+++ linux-pm/drivers/acpi/proc.c
@@ -311,6 +311,8 @@ acpi_system_wakeup_device_seq_show(struc
 			   dev->pnp.bus_id,
 			   (u32) dev->wakeup.sleep_state);
 
+		mutex_lock(&dev->physical_node_lock);
+
 		if (!dev->physical_node_count) {
 			seq_printf(seq, "%c%-8s\n",
 				dev->wakeup.flags.run_wake ? '*' : ' ',
@@ -338,6 +340,8 @@ acpi_system_wakeup_device_seq_show(struc
 				put_device(ldev);
 			}
 		}
+
+		mutex_unlock(&dev->physical_node_lock);
 	}
 	mutex_unlock(&acpi_device_lock);
 	return 0;
@@ -347,12 +351,16 @@ static void physical_device_enable_wakeu
 {
 	struct acpi_device_physical_node *entry;
 
+	mutex_lock(&adev->physical_node_lock);
+
 	list_for_each_entry(entry,
 		&adev->physical_node_list, node)
 		if (entry->dev && device_can_wakeup(entry->dev)) {
 			bool enable = !device_may_wakeup(entry->dev);
 			device_set_wakeup_enable(entry->dev, enable);
 		}
+
+	mutex_unlock(&adev->physical_node_lock);
 }
 
 static ssize_t

