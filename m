Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755854Ab3GWIOb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jul 2013 04:14:31 -0400
Received: from mga02.intel.com ([134.134.136.20]:3747 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755321Ab3GWIKO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jul 2013 04:10:14 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.89,725,1367996400"; 
   d="scan'208";a="350032545"
From: Lv Zheng <lv.zheng@intel.com>
To: "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Len Brown <len.brown@intel.com>, Corey Minyard <minyard@acm.org>,
        Zhao Yakui <yakui.zhao@intel.com>
Cc: Lv Zheng <lv.zheng@intel.com>, <linux-kernel@vger.kernel.org>,
        linux-acpi@vger.kernel.org, openipmi-developer@lists.sourceforge.net
Subject: [PATCH 08/13] ACPI/IPMI: Cleanup several acpi_ipmi_device members
Date: Tue, 23 Jul 2013 16:10:06 +0800
Message-Id: <b70ad0fe8c19e25eae9cef6fba21dfce237051bb.1374566394.git.lv.zheng@intel.com>
X-Mailer: git-send-email 1.7.10
In-Reply-To: <cover.1374566394.git.lv.zheng@intel.com>
References: <cover.1370652213.git.lv.zheng@intel.com> <cover.1374566394.git.lv.zheng@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a trivial patch:
1. Deletes a member of the acpi_ipmi_device - smi_data which is not
   actually used.
2. Updates a member of the acpi_ipmi_device - pnp_dev which is only used
   by dev_warn() invocations, so changes it to struct device.

Signed-off-by: Lv Zheng <lv.zheng@intel.com>
Reviewed-by: Huang Ying <ying.huang@intel.com>
---
 drivers/acpi/acpi_ipmi.c |   30 ++++++++++++++----------------
 1 file changed, 14 insertions(+), 16 deletions(-)

diff --git a/drivers/acpi/acpi_ipmi.c b/drivers/acpi/acpi_ipmi.c
index 0ee1ea6..7f93ffd 100644
--- a/drivers/acpi/acpi_ipmi.c
+++ b/drivers/acpi/acpi_ipmi.c
@@ -63,11 +63,10 @@ struct acpi_ipmi_device {
 	struct list_head tx_msg_list;
 	spinlock_t	tx_msg_lock;
 	acpi_handle handle;
-	struct pnp_dev *pnp_dev;
+	struct device *dev;
 	ipmi_user_t	user_interface;
 	int ipmi_ifnum; /* IPMI interface number */
 	long curr_msgid;
-	struct ipmi_smi_info smi_data;
 	atomic_t refcnt;
 };
 
@@ -132,7 +131,7 @@ static struct ipmi_driver_data driver_data = {
 };
 
 static struct acpi_ipmi_device *
-ipmi_dev_alloc(int iface, struct ipmi_smi_info *smi_data, acpi_handle handle)
+ipmi_dev_alloc(int iface, struct device *pdev, acpi_handle handle)
 {
 	struct acpi_ipmi_device *ipmi_device;
 	int err;
@@ -148,14 +147,13 @@ ipmi_dev_alloc(int iface, struct ipmi_smi_info *smi_data, acpi_handle handle)
 	spin_lock_init(&ipmi_device->tx_msg_lock);
 
 	ipmi_device->handle = handle;
-	ipmi_device->pnp_dev = to_pnp_dev(get_device(smi_data->dev));
-	memcpy(&ipmi_device->smi_data, smi_data, sizeof(struct ipmi_smi_info));
+	ipmi_device->dev = get_device(pdev);
 	ipmi_device->ipmi_ifnum = iface;
 
 	err = ipmi_create_user(iface, &driver_data.ipmi_hndlrs,
 			       ipmi_device, &user);
 	if (err) {
-		put_device(smi_data->dev);
+		put_device(pdev);
 		kfree(ipmi_device);
 		return NULL;
 	}
@@ -175,7 +173,7 @@ acpi_ipmi_dev_get(struct acpi_ipmi_device *ipmi_device)
 static void ipmi_dev_release(struct acpi_ipmi_device *ipmi_device)
 {
 	ipmi_destroy_user(ipmi_device->user_interface);
-	put_device(ipmi_device->smi_data.dev);
+	put_device(ipmi_device->dev);
 	kfree(ipmi_device);
 }
 
@@ -263,7 +261,7 @@ static int acpi_format_ipmi_request(struct acpi_ipmi_msg *tx_msg,
 	buffer = (struct acpi_ipmi_buffer *)value;
 	/* copy the tx message data */
 	if (buffer->length > ACPI_IPMI_MAX_MSG_LENGTH) {
-		dev_WARN_ONCE(&tx_msg->device->pnp_dev->dev, true,
+		dev_WARN_ONCE(tx_msg->device->dev, true,
 			      "Unexpected request (msg len %d).\n",
 			      buffer->length);
 		return -EINVAL;
@@ -382,11 +380,11 @@ static void ipmi_msg_handler(struct ipmi_recv_msg *msg, void *user_msg_data)
 	struct acpi_ipmi_device *ipmi_device = user_msg_data;
 	int msg_found = 0;
 	struct acpi_ipmi_msg *tx_msg;
-	struct pnp_dev *pnp_dev = ipmi_device->pnp_dev;
+	struct device *dev = ipmi_device->dev;
 	unsigned long flags;
 
 	if (msg->user != ipmi_device->user_interface) {
-		dev_warn(&pnp_dev->dev,
+		dev_warn(dev,
 			 "Unexpected response is returned. returned user %p, expected user %p\n",
 			 msg->user, ipmi_device->user_interface);
 		goto out_msg;
@@ -404,7 +402,7 @@ static void ipmi_msg_handler(struct ipmi_recv_msg *msg, void *user_msg_data)
 	spin_unlock_irqrestore(&ipmi_device->tx_msg_lock, flags);
 
 	if (!msg_found) {
-		dev_warn(&pnp_dev->dev,
+		dev_warn(dev,
 			 "Unexpected response (msg id %ld) is returned.\n",
 			 msg->msgid);
 		goto out_msg;
@@ -412,7 +410,7 @@ static void ipmi_msg_handler(struct ipmi_recv_msg *msg, void *user_msg_data)
 
 	/* copy the response data to Rx_data buffer */
 	if (msg->msg.data_len > ACPI_IPMI_MAX_MSG_LENGTH) {
-		dev_WARN_ONCE(&pnp_dev->dev, true,
+		dev_WARN_ONCE(dev, true,
 			      "Unexpected response (msg len %d).\n",
 			      msg->msg.data_len);
 		goto out_comp;
@@ -431,7 +429,7 @@ out_msg:
 static void ipmi_register_bmc(int iface, struct device *dev)
 {
 	struct acpi_ipmi_device *ipmi_device, *temp;
-	struct pnp_dev *pnp_dev;
+	struct device *pdev;
 	int err;
 	struct ipmi_smi_info smi_data;
 	acpi_handle handle;
@@ -445,11 +443,11 @@ static void ipmi_register_bmc(int iface, struct device *dev)
 	handle = smi_data.addr_info.acpi_info.acpi_handle;
 	if (!handle)
 		goto err_ref;
-	pnp_dev = to_pnp_dev(smi_data.dev);
+	pdev = smi_data.dev;
 
-	ipmi_device = ipmi_dev_alloc(iface, &smi_data, handle);
+	ipmi_device = ipmi_dev_alloc(iface, pdev, handle);
 	if (!ipmi_device) {
-		dev_warn(&pnp_dev->dev, "Can't create IPMI user interface\n");
+		dev_warn(pdev, "Can't create IPMI user interface\n");
 		goto err_ref;
 	}
 
-- 
1.7.10

