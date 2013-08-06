Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756056Ab3HFSzq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Aug 2013 14:55:46 -0400
Received: from mo-p00-ob.rzone.de ([81.169.146.162]:9657 "EHLO
	mo-p00-ob.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755765Ab3HFSzp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Aug 2013 14:55:45 -0400
X-RZG-AUTH: :P2EQZWCpfu+qG7CngxMFH1J+yackYocTD1iAi8x+OWJwKkjb5r/WwRxDgH0=
X-RZG-CLASS-ID: mo00
From: Olaf Hering <olaf@aepfle.de>
To: kys@microsoft.com, gregkh@linuxfoundation.org
Cc: linux-kernel@vger.kernel.org, Olaf Hering <olaf@aepfle.de>
Subject: [PATCH] Tools: hv: use single send+recv buffer
Date: Tue,  6 Aug 2013 20:55:38 +0200
Message-Id: <1375815338-14916-1-git-send-email-olaf@aepfle.de>
X-Mailer: git-send-email 1.8.3.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

send_buffer is used only once during registration. To reduce runtime
memory usage reuse the recv_buffer for registration. Also use
NLMSG_LENGTH instead of NLMSG_HDRLEN to take alignment into account.

Signed-off-by: Olaf Hering <olaf@aepfle.de>
---
 tools/hv/hv_kvp_daemon.c | 10 ++++------
 tools/hv/hv_vss_daemon.c |  8 +++-----
 2 files changed, 7 insertions(+), 11 deletions(-)

diff --git a/tools/hv/hv_kvp_daemon.c b/tools/hv/hv_kvp_daemon.c
index 6a31ca0..d3bcb84 100644
--- a/tools/hv/hv_kvp_daemon.c
+++ b/tools/hv/hv_kvp_daemon.c
@@ -1439,7 +1439,6 @@ int main(void)
 	int	pool;
 	char	*if_name;
 	struct hv_kvp_ipaddr_value *kvp_ip_val;
-	char *kvp_send_buffer;
 	char *kvp_recv_buffer;
 	size_t kvp_recv_buffer_len;
 
@@ -1448,11 +1447,10 @@ int main(void)
 	openlog("KVP", 0, LOG_USER);
 	syslog(LOG_INFO, "KVP starting; pid is:%d", getpid());
 
-	kvp_recv_buffer_len = NLMSG_HDRLEN + sizeof(struct cn_msg) + sizeof(struct hv_kvp_msg);
-	kvp_send_buffer = calloc(1, kvp_recv_buffer_len);
+	kvp_recv_buffer_len = NLMSG_LENGTH(0) + sizeof(struct cn_msg) + sizeof(struct hv_kvp_msg);
 	kvp_recv_buffer = calloc(1, kvp_recv_buffer_len);
-	if (!(kvp_send_buffer && kvp_recv_buffer)) {
-		syslog(LOG_ERR, "Failed to allocate netlink buffers");
+	if (!kvp_recv_buffer) {
+		syslog(LOG_ERR, "Failed to allocate netlink buffer");
 		exit(EXIT_FAILURE);
 	}
 	/*
@@ -1494,7 +1492,7 @@ int main(void)
 	/*
 	 * Register ourselves with the kernel.
 	 */
-	message = (struct cn_msg *)kvp_send_buffer;
+	message = (struct cn_msg *)kvp_recv_buffer;
 	message->id.idx = CN_KVP_IDX;
 	message->id.val = CN_KVP_VAL;
 
diff --git a/tools/hv/hv_vss_daemon.c b/tools/hv/hv_vss_daemon.c
index 4c34675..6b4f2fa 100644
--- a/tools/hv/hv_vss_daemon.c
+++ b/tools/hv/hv_vss_daemon.c
@@ -145,7 +145,6 @@ int main(void)
 	struct cn_msg	*incoming_cn_msg;
 	int	op;
 	struct hv_vss_msg *vss_msg;
-	char *vss_send_buffer;
 	char *vss_recv_buffer;
 	size_t vss_recv_buffer_len;
 
@@ -155,10 +154,9 @@ int main(void)
 	openlog("Hyper-V VSS", 0, LOG_USER);
 	syslog(LOG_INFO, "VSS starting; pid is:%d", getpid());
 
-	vss_recv_buffer_len = NLMSG_HDRLEN + sizeof(struct cn_msg) + sizeof(struct hv_vss_msg);
-	vss_send_buffer = calloc(1, vss_recv_buffer_len);
+	vss_recv_buffer_len = NLMSG_LENGTH(0) + sizeof(struct cn_msg) + sizeof(struct hv_vss_msg);
 	vss_recv_buffer = calloc(1, vss_recv_buffer_len);
-	if (!(vss_send_buffer && vss_recv_buffer)) {
+	if (!vss_recv_buffer) {
 		syslog(LOG_ERR, "Failed to allocate netlink buffers");
 		exit(EXIT_FAILURE);
 	}
@@ -185,7 +183,7 @@ int main(void)
 	/*
 	 * Register ourselves with the kernel.
 	 */
-	message = (struct cn_msg *)vss_send_buffer;
+	message = (struct cn_msg *)vss_recv_buffer;
 	message->id.idx = CN_VSS_IDX;
 	message->id.val = CN_VSS_VAL;
 	message->ack = 0;
