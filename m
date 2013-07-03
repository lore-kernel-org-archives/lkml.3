Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964856Ab3GCTA0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Jul 2013 15:00:26 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:20493 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933627Ab3GCTAU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Jul 2013 15:00:20 -0400
X-Authority-Analysis: v=2.0 cv=Odoa/2vY c=1 sm=0 a=Sro2XwOs0tJUSHxCKfOySw==:17 a=Drc5e87SC40A:10 a=Ciwy3NGCPMMA:10 a=YBjYH16aucEA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=KGjhK52YXX0A:10 a=oDRF0Efiu60A:10 a=QyXUC8HyAAAA:8 a=VwQbUJbxAAAA:8 a=Dei6p5SHAAAA:8 a=gvl4HP8tAAAA:8 a=vmLDa1wCAAAA:8 a=e0gVtgZ23HrhdBXb4dMA:9 a=dGJ0OcVc7YAA:10 a=ZaGerQNKEe0A:10 a=OTgC_HKJBnUA:10 a=gv_BBZfBKR8A:10 a=jeBq3FmKZ4MA:10 a=Sro2XwOs0tJUSHxCKfOySw==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 67.255.60.225
Message-Id: <20130703184106.317843815@goodmis.org>
User-Agent: quilt/0.60-1
Date: Wed, 03 Jul 2013 14:40:55 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Johan Hedberg <johan.hedberg@intel.com>,
        Marcel Holtmann <marcel@holtmann.org>,
        Gustavo Padovan <gustavo.padovan@collabora.co.uk>,
        "John W. Linville" <linville@tuxdriver.com>
Subject: [118/141] Bluetooth: Fix mgmt handling of power on failures
References: <20130703183857.307196999@goodmis.org>
Content-Disposition: inline; filename=0118-Bluetooth-Fix-mgmt-handling-of-power-on-failures.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.6.11.6 stable review patch.
If anyone has any objections, please let me know.

------------------

From: Johan Hedberg <johan.hedberg@intel.com>

[ Upstream commit 96570ffcca0b872dc8626e97569d2697f374d868 ]

If hci_dev_open fails we need to ensure that the corresponding
mgmt_set_powered command gets an appropriate response. This patch fixes
the missing response by adding a new mgmt_set_powered_failed function
that's used to indicate a power on failure to mgmt. Since a situation
with the device being rfkilled may require special handling in user
space the patch uses a new dedicated mgmt status code for this.

Signed-off-by: Johan Hedberg <johan.hedberg@intel.com>
Cc: stable@vger.kernel.org
Acked-by: Marcel Holtmann <marcel@holtmann.org>
Signed-off-by: Gustavo Padovan <gustavo.padovan@collabora.co.uk>
Signed-off-by: John W. Linville <linville@tuxdriver.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 include/net/bluetooth/hci_core.h |    1 +
 include/net/bluetooth/mgmt.h     |    1 +
 net/bluetooth/hci_core.c         |    6 +++++-
 net/bluetooth/mgmt.c             |   21 +++++++++++++++++++++
 4 files changed, 28 insertions(+), 1 deletion(-)

diff --git a/include/net/bluetooth/hci_core.h b/include/net/bluetooth/hci_core.h
index 475b8c0..0f35895 100644
--- a/include/net/bluetooth/hci_core.h
+++ b/include/net/bluetooth/hci_core.h
@@ -1002,6 +1002,7 @@ void hci_sock_dev_event(struct hci_dev *hdev, int event);
 int mgmt_control(struct sock *sk, struct msghdr *msg, size_t len);
 int mgmt_index_added(struct hci_dev *hdev);
 int mgmt_index_removed(struct hci_dev *hdev);
+int mgmt_set_powered_failed(struct hci_dev *hdev, int err);
 int mgmt_powered(struct hci_dev *hdev, u8 powered);
 int mgmt_discoverable(struct hci_dev *hdev, u8 discoverable);
 int mgmt_connectable(struct hci_dev *hdev, u8 connectable);
diff --git a/include/net/bluetooth/mgmt.h b/include/net/bluetooth/mgmt.h
index 4348ee8..bd0fc7d 100644
--- a/include/net/bluetooth/mgmt.h
+++ b/include/net/bluetooth/mgmt.h
@@ -42,6 +42,7 @@
 #define MGMT_STATUS_NOT_POWERED		0x0f
 #define MGMT_STATUS_CANCELLED		0x10
 #define MGMT_STATUS_INVALID_INDEX	0x11
+#define MGMT_STATUS_RFKILLED		0x12
 
 struct mgmt_hdr {
 	__le16	opcode;
diff --git a/net/bluetooth/hci_core.c b/net/bluetooth/hci_core.c
index 0b997c8..d1636e4 100644
--- a/net/bluetooth/hci_core.c
+++ b/net/bluetooth/hci_core.c
@@ -1076,11 +1076,15 @@ static const struct rfkill_ops hci_rfkill_ops = {
 static void hci_power_on(struct work_struct *work)
 {
 	struct hci_dev *hdev = container_of(work, struct hci_dev, power_on);
+	int err;
 
 	BT_DBG("%s", hdev->name);
 
-	if (hci_dev_open(hdev->id) < 0)
+	err = hci_dev_open(hdev->id);
+	if (err < 0) {
+		mgmt_set_powered_failed(hdev, err);
 		return;
+	}
 
 	if (test_bit(HCI_AUTO_OFF, &hdev->dev_flags))
 		schedule_delayed_work(&hdev->power_off, HCI_AUTO_OFF_TIMEOUT);
diff --git a/net/bluetooth/mgmt.c b/net/bluetooth/mgmt.c
index 534250a..0fef923 100644
--- a/net/bluetooth/mgmt.c
+++ b/net/bluetooth/mgmt.c
@@ -2908,6 +2908,27 @@ int mgmt_powered(struct hci_dev *hdev, u8 powered)
 	return err;
 }
 
+int mgmt_set_powered_failed(struct hci_dev *hdev, int err)
+{
+	struct pending_cmd *cmd;
+	u8 status;
+
+	cmd = mgmt_pending_find(MGMT_OP_SET_POWERED, hdev);
+	if (!cmd)
+		return -ENOENT;
+
+	if (err == -ERFKILL)
+		status = MGMT_STATUS_RFKILLED;
+	else
+		status = MGMT_STATUS_FAILED;
+
+	err = cmd_status(cmd->sk, hdev->id, MGMT_OP_SET_POWERED, status);
+
+	mgmt_pending_remove(cmd);
+
+	return err;
+}
+
 int mgmt_discoverable(struct hci_dev *hdev, u8 discoverable)
 {
 	struct cmd_lookup match = { NULL, hdev };
-- 
1.7.10.4


