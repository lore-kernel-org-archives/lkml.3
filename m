Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751947AbaKFRWX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Nov 2014 12:22:23 -0500
Received: from mx1.redhat.com ([209.132.183.28]:41096 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751954AbaKFRVi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Nov 2014 12:21:38 -0500
From: Vitaly Kuznetsov <vkuznets@redhat.com>
To: "K. Y. Srinivasan" <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: devel@linuxdriverproject.org, linux-kernel@vger.kernel.org
Subject: [PATCH 2/2] Drivers: hv: kvp,vss: Fast propagation of userspace communication failure
Date: Thu,  6 Nov 2014 18:21:25 +0100
Message-Id: <1415294485-23945-3-git-send-email-vkuznets@redhat.com>
In-Reply-To: <1415294485-23945-1-git-send-email-vkuznets@redhat.com>
References: <1415294485-23945-1-git-send-email-vkuznets@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If we fail to send a message to userspace daemon with cn_netlink_send()
there is no need to wait for userspace to reply as it is not going to
happen. This happens when kvp or vss daemon is stopped after a successful
handshake. Report HV_E_FAIL immediately and cancel the timeout job so
host won't receive two failures.
Use pr_warn() for VSS and pr_debug() for KVP deliberately as VSS request
are rare and result in a failed backup. KVP requests are much more frequent
after a successful handshake so avoid flooding logs. It would be nice to
have an ability to de-negotiate with the host in case userspace daemon gets
disconnected so we won't receive new requests. But I'm not sure it is
possible.

Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
---
 drivers/hv/hv_kvp.c      | 9 ++++++++-
 drivers/hv/hv_snapshot.c | 8 +++++++-
 2 files changed, 15 insertions(+), 2 deletions(-)

diff --git a/drivers/hv/hv_kvp.c b/drivers/hv/hv_kvp.c
index 521c146..beb8105 100644
--- a/drivers/hv/hv_kvp.c
+++ b/drivers/hv/hv_kvp.c
@@ -350,6 +350,7 @@ kvp_send_key(struct work_struct *dummy)
 	__u8 pool = kvp_transaction.kvp_msg->kvp_hdr.pool;
 	__u32 val32;
 	__u64 val64;
+	int rc;
 
 	msg = kzalloc(sizeof(*msg) + sizeof(struct hv_kvp_msg) , GFP_ATOMIC);
 	if (!msg)
@@ -446,7 +447,13 @@ kvp_send_key(struct work_struct *dummy)
 	}
 
 	msg->len = sizeof(struct hv_kvp_msg);
-	cn_netlink_send(msg, 0, 0, GFP_ATOMIC);
+	rc = cn_netlink_send(msg, 0, 0, GFP_ATOMIC);
+	if (rc) {
+		pr_debug("KVP: failed to communicate to the daemon: %d\n", rc);
+		if (cancel_delayed_work_sync(&kvp_work))
+			kvp_respond_to_host(message, HV_E_FAIL);
+	}
+
 	kfree(msg);
 
 	return;
diff --git a/drivers/hv/hv_snapshot.c b/drivers/hv/hv_snapshot.c
index 21e51be..9d5e0d1 100644
--- a/drivers/hv/hv_snapshot.c
+++ b/drivers/hv/hv_snapshot.c
@@ -96,6 +96,7 @@ vss_cn_callback(struct cn_msg *msg, struct netlink_skb_parms *nsp)
 static void vss_send_op(struct work_struct *dummy)
 {
 	int op = vss_transaction.msg->vss_hdr.operation;
+	int rc;
 	struct cn_msg *msg;
 	struct hv_vss_msg *vss_msg;
 
@@ -111,7 +112,12 @@ static void vss_send_op(struct work_struct *dummy)
 	vss_msg->vss_hdr.operation = op;
 	msg->len = sizeof(struct hv_vss_msg);
 
-	cn_netlink_send(msg, 0, 0, GFP_ATOMIC);
+	rc = cn_netlink_send(msg, 0, 0, GFP_ATOMIC);
+	if (rc) {
+		pr_warn("VSS: failed to communicate to the daemon: %d\n", rc);
+		if (cancel_delayed_work_sync(&vss_timeout_work))
+			vss_respond_to_host(HV_E_FAIL);
+	}
 	kfree(msg);
 
 	return;
-- 
1.9.3

