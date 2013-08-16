Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757112Ab3HPWkw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Aug 2013 18:40:52 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:51800 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757023Ab3HPWk2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Aug 2013 18:40:28 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 099/133] ACPI / PM: Walk physical_node_list under physical_node_lock
Date: Fri, 16 Aug 2013 15:34:01 -0700
Message-Id: <1376692475-28413-100-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1376692475-28413-1-git-send-email-kamal@canonical.com>
References: <1376692475-28413-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.7 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>

commit 623cf33cb055b1e81fa47e4fc16789b2c129e31e upstream.

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
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/acpi/proc.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/drivers/acpi/proc.c b/drivers/acpi/proc.c
index 52ce767..8fa2d08 100644
--- a/drivers/acpi/proc.c
+++ b/drivers/acpi/proc.c
@@ -311,6 +311,8 @@ acpi_system_wakeup_device_seq_show(struct seq_file *seq, void *offset)
 			   dev->pnp.bus_id,
 			   (u32) dev->wakeup.sleep_state);
 
+		mutex_lock(&dev->physical_node_lock);
+
 		if (!dev->physical_node_count) {
 			seq_printf(seq, "%c%-8s\n",
 				dev->wakeup.flags.run_wake ? '*' : ' ',
@@ -338,6 +340,8 @@ acpi_system_wakeup_device_seq_show(struct seq_file *seq, void *offset)
 				put_device(ldev);
 			}
 		}
+
+		mutex_unlock(&dev->physical_node_lock);
 	}
 	mutex_unlock(&acpi_device_lock);
 	return 0;
@@ -347,12 +351,16 @@ static void physical_device_enable_wakeup(struct acpi_device *adev)
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
-- 
1.8.1.2

