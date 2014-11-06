Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752092AbaKFRVj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Nov 2014 12:21:39 -0500
Received: from mx1.redhat.com ([209.132.183.28]:41082 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751808AbaKFRVg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Nov 2014 12:21:36 -0500
From: Vitaly Kuznetsov <vkuznets@redhat.com>
To: "K. Y. Srinivasan" <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: devel@linuxdriverproject.org, linux-kernel@vger.kernel.org
Subject: [PATCH 1/2] Drivers: hv: vss: Introduce timeout for communication with userspace
Date: Thu,  6 Nov 2014 18:21:24 +0100
Message-Id: <1415294485-23945-2-git-send-email-vkuznets@redhat.com>
In-Reply-To: <1415294485-23945-1-git-send-email-vkuznets@redhat.com>
References: <1415294485-23945-1-git-send-email-vkuznets@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In contrast with KVP there is no timeout when communicating with
userspace VSS daemon. In case it gets stuck performing freeze/thaw
operation no message will be sent to the host so it will take very
long (around 10 minutes) before backup fails. Introduce 10 second
timeout using schedule_delayed_work().

Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
---
 drivers/hv/hv_snapshot.c | 20 ++++++++++++++++++--
 1 file changed, 18 insertions(+), 2 deletions(-)

diff --git a/drivers/hv/hv_snapshot.c b/drivers/hv/hv_snapshot.c
index 34f14fd..21e51be 100644
--- a/drivers/hv/hv_snapshot.c
+++ b/drivers/hv/hv_snapshot.c
@@ -28,7 +28,7 @@
 #define VSS_MINOR  0
 #define VSS_VERSION    (VSS_MAJOR << 16 | VSS_MINOR)
 
-
+#define VSS_USERSPACE_TIMEOUT (msecs_to_jiffies(10 * 1000))
 
 /*
  * Global state maintained for transaction that is being processed.
@@ -55,12 +55,24 @@ static const char vss_name[] = "vss_kernel_module";
 static __u8 *recv_buffer;
 
 static void vss_send_op(struct work_struct *dummy);
+static void vss_timeout_func(struct work_struct *dummy);
+
+static DECLARE_DELAYED_WORK(vss_timeout_work, vss_timeout_func);
 static DECLARE_WORK(vss_send_op_work, vss_send_op);
 
 /*
  * Callback when data is received from user mode.
  */
 
+static void vss_timeout_func(struct work_struct *dummy)
+{
+	/*
+	 * Timeout waiting for userspace component to reply happened.
+	 */
+	pr_warn("VSS: timeout waiting for daemon to reply\n");
+	vss_respond_to_host(HV_E_FAIL);
+}
+
 static void
 vss_cn_callback(struct cn_msg *msg, struct netlink_skb_parms *nsp)
 {
@@ -76,7 +88,8 @@ vss_cn_callback(struct cn_msg *msg, struct netlink_skb_parms *nsp)
 		return;
 
 	}
-	vss_respond_to_host(vss_msg->error);
+	if (cancel_delayed_work_sync(&vss_timeout_work))
+		vss_respond_to_host(vss_msg->error);
 }
 
 
@@ -223,6 +236,8 @@ void hv_vss_onchannelcallback(void *context)
 			case VSS_OP_FREEZE:
 			case VSS_OP_THAW:
 				schedule_work(&vss_send_op_work);
+				schedule_delayed_work(&vss_timeout_work,
+						      VSS_USERSPACE_TIMEOUT);
 				return;
 
 			case VSS_OP_HOT_BACKUP:
@@ -277,5 +292,6 @@ hv_vss_init(struct hv_util_service *srv)
 void hv_vss_deinit(void)
 {
 	cn_del_callback(&vss_id);
+	cancel_delayed_work_sync(&vss_timeout_work);
 	cancel_work_sync(&vss_send_op_work);
 }
-- 
1.9.3

