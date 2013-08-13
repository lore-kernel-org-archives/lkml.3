Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757926Ab3HMGzv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Aug 2013 02:55:51 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:60499 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756324Ab3HMGdN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Aug 2013 02:33:13 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
Subject: [ 21/60] ACPI / PM: Walk physical_node_list under physical_node_lock
Date: Mon, 12 Aug 2013 23:33:48 -0700
Message-Id: <20130813063334.984600825@linuxfoundation.org>
X-Mailer: git-send-email 1.8.3.3.825.g36032ce.dirty
In-Reply-To: <20130813063331.950321483@linuxfoundation.org>
References: <20130813063331.950321483@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/acpi/proc.c |    8 ++++++++
 1 file changed, 8 insertions(+)

--- a/drivers/acpi/proc.c
+++ b/drivers/acpi/proc.c
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


