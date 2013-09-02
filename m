Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758811Ab3IBOzy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Sep 2013 10:55:54 -0400
Received: from mx1.redhat.com ([209.132.183.28]:43900 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758652Ab3IBOzw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Sep 2013 10:55:52 -0400
From: Tony Camuso <tcamuso@redhat.com>
To: linux-kernel@vger.kernel.org, minyard@acm.org,
        devicetree-discuss@lists.ozlabs.org, tcamuso@redhat.com
Cc: dzickus@redhat.com
Subject: [PATCH 1/1] drivers/acpi: acpi_ipmi.c replace mutex with spin_lock_irqsave
Date: Mon,  2 Sep 2013 11:00:53 -0400
Message-Id: <1378130298-23681-1-git-send-email-tcamuso@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: tcamuso@redhat.com

From: Tony Camuso <tcamuso@redhat.com>

We were getting occasional "Scheduling while atomic" call traces
during boot on some systems. Problem was first seen on a Cisco C210
but we were able to reproduce it on a Cisco c220m3. Setting
CONFIG_LOCKDEP and LOCKDEP_SUPPORT to 'y' exposed a lockdep around
tx_msg_lock in acpi_ipmi.c struct acpi_ipmi_device.

=================================
[ INFO: inconsistent lock state ]
2.6.32-415.el6.x86_64-debug-splck #1
---------------------------------
inconsistent {SOFTIRQ-ON-W} -> {IN-SOFTIRQ-W} usage.
ksoftirqd/3/17 [HC0[0]:SC1[1]:HE1:SE0] takes:
 (&ipmi_device->tx_msg_lock){+.?...}, at: [<ffffffff81337a27>] ipmi_msg_handler+0x71/0x126
{SOFTIRQ-ON-W} state was registered at:
  [<ffffffff810ba11c>] __lock_acquire+0x63c/0x1570
  [<ffffffff810bb0f4>] lock_acquire+0xa4/0x120
  [<ffffffff815581cc>] __mutex_lock_common+0x4c/0x400
  [<ffffffff815586ea>] mutex_lock_nested+0x4a/0x60
  [<ffffffff8133789d>] acpi_ipmi_space_handler+0x11b/0x234
  [<ffffffff81321c62>] acpi_ev_address_space_dispatch+0x170/0x1be

The ipmi_msg_handler() function in drivers/acpi/acpi_ipmi was taking
a mutex_lock after ultimately being called from a call chain initiated
by function smi_rcv_tasklet() in drivers/char/ipmi/ipmi_msghandler.c.

Documentation/mutex-design.txt on lines 93 and 94 says, "mutexes may
not be used in hardware or software interrupt contexts such as
tasklets and timers."

The patch changes the mutex member tx_msg_lock in acpi_ipmi.c struct
acpi_ipmi_device to a spinlock_t and replaces mutex_lock/unlock pairs
with spin_lock_irqsave/unlock_irqrestore around tx_msg_lock for
accesses to that struct.

Tested the patch in a boot loop with lockdep debug enabled and never
saw the problem in over 400 reboots.

Signed-off-by: Tony Camuso <tcamuso@redhat.com>

---
 drivers/acpi/acpi_ipmi.c |   24 ++++++++++++++----------
 1 files changed, 14 insertions(+), 10 deletions(-)

diff --git a/drivers/acpi/acpi_ipmi.c b/drivers/acpi/acpi_ipmi.c
index f40acef..a4b428d 100644
--- a/drivers/acpi/acpi_ipmi.c
+++ b/drivers/acpi/acpi_ipmi.c
@@ -57,7 +57,7 @@ struct acpi_ipmi_device {
 	struct list_head head;
 	/* the IPMI request message list */
 	struct list_head tx_msg_list;
-	struct mutex	tx_msg_lock;
+	spinlock_t tx_msg_lock;
 	acpi_handle handle;
 	struct pnp_dev *pnp_dev;
 	ipmi_user_t	user_interface;
@@ -147,6 +147,7 @@ static void acpi_format_ipmi_msg(struct acpi_ipmi_msg *tx_msg,
 	struct kernel_ipmi_msg *msg;
 	struct acpi_ipmi_buffer *buffer;
 	struct acpi_ipmi_device *device;
+	unsigned long flags;
 
 	msg = &tx_msg->tx_message;
 	/*
@@ -177,10 +178,10 @@ static void acpi_format_ipmi_msg(struct acpi_ipmi_msg *tx_msg,
 
 	/* Get the msgid */
 	device = tx_msg->device;
-	mutex_lock(&device->tx_msg_lock);
+	spin_lock_irqsave(&device->tx_msg_lock, flags);
 	device->curr_msgid++;
 	tx_msg->tx_msgid = device->curr_msgid;
-	mutex_unlock(&device->tx_msg_lock);
+	spin_unlock_irqrestore(&device->tx_msg_lock, flags);
 }
 
 static void acpi_format_ipmi_response(struct acpi_ipmi_msg *msg,
@@ -242,6 +243,7 @@ static void ipmi_msg_handler(struct ipmi_recv_msg *msg, void *user_msg_data)
 	int msg_found = 0;
 	struct acpi_ipmi_msg *tx_msg;
 	struct pnp_dev *pnp_dev = ipmi_device->pnp_dev;
+	unsigned long flags;
 
 	if (msg->user != ipmi_device->user_interface) {
 		dev_warn(&pnp_dev->dev, "Unexpected response is returned. "
@@ -250,7 +252,7 @@ static void ipmi_msg_handler(struct ipmi_recv_msg *msg, void *user_msg_data)
 		ipmi_free_recv_msg(msg);
 		return;
 	}
-	mutex_lock(&ipmi_device->tx_msg_lock);
+	spin_lock_irqsave(&ipmi_device->tx_msg_lock, flags);
 	list_for_each_entry(tx_msg, &ipmi_device->tx_msg_list, head) {
 		if (msg->msgid == tx_msg->tx_msgid) {
 			msg_found = 1;
@@ -258,7 +260,7 @@ static void ipmi_msg_handler(struct ipmi_recv_msg *msg, void *user_msg_data)
 		}
 	}
 
-	mutex_unlock(&ipmi_device->tx_msg_lock);
+	spin_unlock_irqrestore(&ipmi_device->tx_msg_lock, flags);
 	if (!msg_found) {
 		dev_warn(&pnp_dev->dev, "Unexpected response (msg id %ld) is "
 			"returned.\n", msg->msgid);
@@ -378,6 +380,8 @@ acpi_ipmi_space_handler(u32 function, acpi_physical_address address,
 	struct acpi_ipmi_device *ipmi_device = handler_context;
 	int err, rem_time;
 	acpi_status status;
+	unsigned long flags;
+
 	/*
 	 * IPMI opregion message.
 	 * IPMI message is firstly written to the BMC and system software
@@ -395,9 +399,9 @@ acpi_ipmi_space_handler(u32 function, acpi_physical_address address,
 		return AE_NO_MEMORY;
 
 	acpi_format_ipmi_msg(tx_msg, address, value);
-	mutex_lock(&ipmi_device->tx_msg_lock);
+	spin_lock_irqsave(&ipmi_device->tx_msg_lock, flags);
 	list_add_tail(&tx_msg->head, &ipmi_device->tx_msg_list);
-	mutex_unlock(&ipmi_device->tx_msg_lock);
+	spin_unlock_irqrestore(&ipmi_device->tx_msg_lock, flags);
 	err = ipmi_request_settime(ipmi_device->user_interface,
 					&tx_msg->addr,
 					tx_msg->tx_msgid,
@@ -413,9 +417,9 @@ acpi_ipmi_space_handler(u32 function, acpi_physical_address address,
 	status = AE_OK;
 
 end_label:
-	mutex_lock(&ipmi_device->tx_msg_lock);
+	spin_lock_irqsave(&ipmi_device->tx_msg_lock, flags);
 	list_del(&tx_msg->head);
-	mutex_unlock(&ipmi_device->tx_msg_lock);
+	spin_unlock_irqrestore(&ipmi_device->tx_msg_lock, flags);
 	kfree(tx_msg);
 	return status;
 }
@@ -457,7 +461,7 @@ static void acpi_add_ipmi_device(struct acpi_ipmi_device *ipmi_device)
 
 	INIT_LIST_HEAD(&ipmi_device->head);
 
-	mutex_init(&ipmi_device->tx_msg_lock);
+	spin_lock_init(&ipmi_device->tx_msg_lock);
 	INIT_LIST_HEAD(&ipmi_device->tx_msg_list);
 	ipmi_install_space_handler(ipmi_device);
 
-- 
1.7.1

