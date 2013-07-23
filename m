Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755524Ab3GWIKA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jul 2013 04:10:00 -0400
Received: from mga11.intel.com ([192.55.52.93]:44454 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754918Ab3GWIJO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jul 2013 04:09:14 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.89,725,1367996400"; 
   d="scan'208";a="374543172"
From: Lv Zheng <lv.zheng@intel.com>
To: "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Len Brown <len.brown@intel.com>, Corey Minyard <minyard@acm.org>,
        Zhao Yakui <yakui.zhao@intel.com>
Cc: Lv Zheng <lv.zheng@intel.com>, <linux-kernel@vger.kernel.org>,
        <stable@vger.kernel.org>, linux-acpi@vger.kernel.org,
        openipmi-developer@lists.sourceforge.net
Subject: [PATCH 02/13] ACPI/IPMI: Fix atomic context requirement of ipmi_msg_handler()
Date: Tue, 23 Jul 2013 16:09:08 +0800
Message-Id: <8a21a77c2672cc91d8de13bb33c51104dc42affa.1374566394.git.lv.zheng@intel.com>
X-Mailer: git-send-email 1.7.10
In-Reply-To: <cover.1374566394.git.lv.zheng@intel.com>
References: <cover.1370652213.git.lv.zheng@intel.com> <cover.1374566394.git.lv.zheng@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch quick fixes the issues indicated by the test results that
ipmi_msg_handler() is invoked in atomic context.

BUG: scheduling while atomic: kipmi0/18933/0x10000100
Modules linked in: ipmi_si acpi_ipmi ...
CPU: 3 PID: 18933 Comm: kipmi0 Tainted: G       AW    3.10.0-rc7+ #2
Hardware name: QCI QSSC-S4R/QSSC-S4R, BIOS QSSC-S4R.QCI.01.00.0027.070120100606 07/01/2010
 ffff8838245eea00 ffff88103fc63c98 ffffffff814c4a1e ffff88103fc63ca8
 ffffffff814bfbab ffff88103fc63d28 ffffffff814c73e0 ffff88103933cbd4
 0000000000000096 ffff88103fc63ce8 ffff88102f618000 ffff881035c01fd8
Call Trace:
 <IRQ>  [<ffffffff814c4a1e>] dump_stack+0x19/0x1b
 [<ffffffff814bfbab>] __schedule_bug+0x46/0x54
 [<ffffffff814c73e0>] __schedule+0x83/0x59c
 [<ffffffff81058853>] __cond_resched+0x22/0x2d
 [<ffffffff814c794b>] _cond_resched+0x14/0x1d
 [<ffffffff814c6d82>] mutex_lock+0x11/0x32
 [<ffffffff8101e1e9>] ? __default_send_IPI_dest_field.constprop.0+0x53/0x58
 [<ffffffffa09e3f9c>] ipmi_msg_handler+0x23/0x166 [ipmi_si]
 [<ffffffff812bf6e4>] deliver_response+0x55/0x5a
 [<ffffffff812c0fd4>] handle_new_recv_msgs+0xb67/0xc65
 [<ffffffff81007ad1>] ? read_tsc+0x9/0x19
 [<ffffffff814c8620>] ? _raw_spin_lock_irq+0xa/0xc
 [<ffffffffa09e1128>] ipmi_thread+0x5c/0x146 [ipmi_si]
 ...

Known issues:
- Replacing tx_msg_lock with spinlock is not performance friendly
  Current solution works but does not have the best performance because it
  is better to make atomic context run as fast as possible.  Given there
  are no many IPMI messages created by ACPI, performance of current
  solution may be OK.  It can be better via linking ipmi_recv_msg into an
  RX message queue and process it in other contexts.

Signed-off-by: Lv Zheng <lv.zheng@intel.com>
Reviewed-by: Huang Ying <ying.huang@intel.com>
---
 drivers/acpi/acpi_ipmi.c |   24 ++++++++++++++----------
 1 file changed, 14 insertions(+), 10 deletions(-)

diff --git a/drivers/acpi/acpi_ipmi.c b/drivers/acpi/acpi_ipmi.c
index 28e2b4c..b37c189 100644
--- a/drivers/acpi/acpi_ipmi.c
+++ b/drivers/acpi/acpi_ipmi.c
@@ -39,6 +39,7 @@
 #include <linux/ipmi.h>
 #include <linux/device.h>
 #include <linux/pnp.h>
+#include <linux/spinlock.h>
 
 MODULE_AUTHOR("Zhao Yakui");
 MODULE_DESCRIPTION("ACPI IPMI Opregion driver");
@@ -58,7 +59,7 @@ struct acpi_ipmi_device {
 	struct list_head head;
 	/* the IPMI request message list */
 	struct list_head tx_msg_list;
-	struct mutex	tx_msg_lock;
+	spinlock_t	tx_msg_lock;
 	acpi_handle handle;
 	struct pnp_dev *pnp_dev;
 	ipmi_user_t	user_interface;
@@ -146,6 +147,7 @@ static int acpi_format_ipmi_request(struct acpi_ipmi_msg *tx_msg,
 	struct kernel_ipmi_msg *msg;
 	struct acpi_ipmi_buffer *buffer;
 	struct acpi_ipmi_device *device;
+	unsigned long flags;
 
 	msg = &tx_msg->tx_message;
 	/*
@@ -182,10 +184,10 @@ static int acpi_format_ipmi_request(struct acpi_ipmi_msg *tx_msg,
 
 	/* Get the msgid */
 	device = tx_msg->device;
-	mutex_lock(&device->tx_msg_lock);
+	spin_lock_irqsave(&device->tx_msg_lock, flags);
 	device->curr_msgid++;
 	tx_msg->tx_msgid = device->curr_msgid;
-	mutex_unlock(&device->tx_msg_lock);
+	spin_unlock_irqrestore(&device->tx_msg_lock, flags);
 
 	return 0;
 }
@@ -250,6 +252,7 @@ static void ipmi_msg_handler(struct ipmi_recv_msg *msg, void *user_msg_data)
 	int msg_found = 0;
 	struct acpi_ipmi_msg *tx_msg;
 	struct pnp_dev *pnp_dev = ipmi_device->pnp_dev;
+	unsigned long flags;
 
 	if (msg->user != ipmi_device->user_interface) {
 		dev_warn(&pnp_dev->dev,
@@ -258,14 +261,14 @@ static void ipmi_msg_handler(struct ipmi_recv_msg *msg, void *user_msg_data)
 		goto out_msg;
 	}
 
-	mutex_lock(&ipmi_device->tx_msg_lock);
+	spin_lock_irqsave(&ipmi_device->tx_msg_lock, flags);
 	list_for_each_entry(tx_msg, &ipmi_device->tx_msg_list, head) {
 		if (msg->msgid == tx_msg->tx_msgid) {
 			msg_found = 1;
 			break;
 		}
 	}
-	mutex_unlock(&ipmi_device->tx_msg_lock);
+	spin_unlock_irqrestore(&ipmi_device->tx_msg_lock, flags);
 
 	if (!msg_found) {
 		dev_warn(&pnp_dev->dev,
@@ -394,6 +397,7 @@ acpi_ipmi_space_handler(u32 function, acpi_physical_address address,
 	struct acpi_ipmi_device *ipmi_device = handler_context;
 	int err, rem_time;
 	acpi_status status;
+	unsigned long flags;
 
 	/*
 	 * IPMI opregion message.
@@ -416,9 +420,9 @@ acpi_ipmi_space_handler(u32 function, acpi_physical_address address,
 		goto out_msg;
 	}
 
-	mutex_lock(&ipmi_device->tx_msg_lock);
+	spin_lock_irqsave(&ipmi_device->tx_msg_lock, flags);
 	list_add_tail(&tx_msg->head, &ipmi_device->tx_msg_list);
-	mutex_unlock(&ipmi_device->tx_msg_lock);
+	spin_unlock_irqrestore(&ipmi_device->tx_msg_lock, flags);
 	err = ipmi_request_settime(ipmi_device->user_interface,
 				   &tx_msg->addr,
 				   tx_msg->tx_msgid,
@@ -434,9 +438,9 @@ acpi_ipmi_space_handler(u32 function, acpi_physical_address address,
 	status = AE_OK;
 
 out_list:
-	mutex_lock(&ipmi_device->tx_msg_lock);
+	spin_lock_irqsave(&ipmi_device->tx_msg_lock, flags);
 	list_del(&tx_msg->head);
-	mutex_unlock(&ipmi_device->tx_msg_lock);
+	spin_unlock_irqrestore(&ipmi_device->tx_msg_lock, flags);
 out_msg:
 	kfree(tx_msg);
 	return status;
@@ -479,7 +483,7 @@ static void acpi_add_ipmi_device(struct acpi_ipmi_device *ipmi_device)
 
 	INIT_LIST_HEAD(&ipmi_device->head);
 
-	mutex_init(&ipmi_device->tx_msg_lock);
+	spin_lock_init(&ipmi_device->tx_msg_lock);
 	INIT_LIST_HEAD(&ipmi_device->tx_msg_list);
 	ipmi_install_space_handler(ipmi_device);
 
-- 
1.7.10

