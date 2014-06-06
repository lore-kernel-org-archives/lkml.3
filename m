Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752716AbaFFKSn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jun 2014 06:18:43 -0400
Received: from mail-ie0-f175.google.com ([209.85.223.175]:43126 "EHLO
	mail-ie0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752664AbaFFKSj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jun 2014 06:18:39 -0400
From: Kiran Kumar Raparthy <kiran.kumar@linaro.org>
To: linux-kernel@vger.kernel.org
Cc: Nick Pelly <npelly@google.com>, Marcel Holtmann <marcel@holtmann.org>,
        Gustavo Padovan <gustavo@padovan.org>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        linux-bluetooth@vger.kernel.org, netdev@vger.kernel.org,
        Android Kernel Team <kernel-team@android.com>,
        John Stultz <john.stultz@linaro.org>,
        Kiran Raparthy <kiran.kumar@linaro.org>
Subject: [RFC] Bluetooth: Add ACL MTU, available buffers and total buffers to hci_conn_info.
Date: Fri,  6 Jun 2014 15:48:00 +0530
Message-Id: <1402049880-7686-1-git-send-email-kiran.kumar@linaro.org>
X-Mailer: git-send-email 1.8.2.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Nick Pelly <npelly@google.com>

Add ACL MTU, available buffers and total buffers to hci_conn_info.

This provides userspace debugging tools access to ACL flow control state.

This is one of the number of patches from the Android AOSP common.git tree,
which is used on almost all Android devices.  so I wanted to submit it for
review to see if it should go upstream.

Cc: Marcel Holtmann <marcel@holtmann.org>
Cc: Gustavo Padovan <gustavo@padovan.org>
Cc: Johan Hedberg <johan.hedberg@gmail.com>
Cc: David S. Miller <davem@davemloft.net>
Cc: linux-bluetooth@vger.kernel.org
Cc: netdev@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Cc: Android Kernel Team <kernel-team@android.com>
Cc: John Stultz <john.stultz@linaro.org>
Signed-off-by: Nick Pelly <npelly@google.com>
[kiran: Added context to commit message]
Signed-off-by: Kiran Raparthy <kiran.kumar@linaro.org>
---
 include/net/bluetooth/hci.h |  3 +++
 net/bluetooth/hci_conn.c    | 18 ++++++++++++++++++
 2 files changed, 21 insertions(+)

diff --git a/include/net/bluetooth/hci.h b/include/net/bluetooth/hci.h
index be150cf..67dc0fb 100644
--- a/include/net/bluetooth/hci.h
+++ b/include/net/bluetooth/hci.h
@@ -1830,6 +1830,9 @@ struct hci_conn_info {
 	__u8     out;
 	__u16    state;
 	__u32    link_mode;
+	__u32    mtu;
+	__u32    cnt;
+	__u32    pkts;
 };
 
 struct hci_dev_req {
diff --git a/net/bluetooth/hci_conn.c b/net/bluetooth/hci_conn.c
index 521fd4f..c2ba0fe 100644
--- a/net/bluetooth/hci_conn.c
+++ b/net/bluetooth/hci_conn.c
@@ -1064,6 +1064,15 @@ int hci_get_conn_list(void __user *arg)
 		(ci + n)->out   = c->out;
 		(ci + n)->state = c->state;
 		(ci + n)->link_mode = c->link_mode;
+		if (c->type == SCO_LINK) {
+			(ci + n)->mtu = hdev->sco_mtu;
+			(ci + n)->cnt = hdev->sco_cnt;
+			(ci + n)->pkts = hdev->sco_pkts;
+		} else {
+			(ci + n)->mtu = hdev->acl_mtu;
+			(ci + n)->cnt = hdev->acl_cnt;
+			(ci + n)->pkts = hdev->acl_pkts;
+		}
 		if (++n >= req.conn_num)
 			break;
 	}
@@ -1100,6 +1109,15 @@ int hci_get_conn_info(struct hci_dev *hdev, void __user *arg)
 		ci.out   = conn->out;
 		ci.state = conn->state;
 		ci.link_mode = conn->link_mode;
+		if (req.type == SCO_LINK) {
+			ci.mtu = hdev->sco_mtu;
+			ci.cnt = hdev->sco_cnt;
+			ci.pkts = hdev->sco_pkts;
+		} else {
+			ci.mtu = hdev->acl_mtu;
+			ci.cnt = hdev->acl_cnt;
+			ci.pkts = hdev->acl_pkts;
+		}
 	}
 	hci_dev_unlock(hdev);
 
-- 
1.8.2.1

