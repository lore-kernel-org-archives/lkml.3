Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755188Ab3HAMee (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Aug 2013 08:34:34 -0400
Received: from mo-p00-ob.rzone.de ([81.169.146.160]:35212 "EHLO
	mo-p00-ob.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754630Ab3HAMed (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Aug 2013 08:34:33 -0400
X-RZG-AUTH: :P2EQZWCpfu+qG7CngxMFH1J+yackYocTD1iAi8x+OWJ8KkvZ5rHdwZi2MQ==
X-RZG-CLASS-ID: mo00
From: Olaf Hering <olaf@aepfle.de>
To: kys@microsoft.com, gregkh@linuxfoundation.org
Cc: linux-kernel@vger.kernel.org, Olaf Hering <olaf@aepfle.de>
Subject: [PATCH] Tools: hv: fix send/recv buffer allocation
Date: Thu,  1 Aug 2013 14:34:26 +0200
Message-Id: <1375360466-11366-1-git-send-email-olaf@aepfle.de>
X-Mailer: git-send-email 1.8.3.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

hv_kvp_daemon fails to start in current openSuSE 13.1 snapshots because
the kvp_send_buffer is too small to hold cn_msg+hv_kvp_msg, the very
first sendmsg returns with EFAULT. In addition it fixes the Network info
tab in Windows Server 2012R2 in SLES11.

Adjust the code in kvp and vss daemon to allocate the needed buffers at
runtime. To keep the code simple, the buffer_len includes also the
nlmsghdr, although only the recv_buffer needs this extra space.

Signed-off-by: Olaf Hering <olaf@aepfle.de>
---
 tools/hv/hv_kvp_daemon.c | 15 ++++++++++++---
 tools/hv/hv_vss_daemon.c | 15 ++++++++++++---
 2 files changed, 24 insertions(+), 6 deletions(-)

diff --git a/tools/hv/hv_kvp_daemon.c b/tools/hv/hv_kvp_daemon.c
index 07819bf..657c1d2 100644
--- a/tools/hv/hv_kvp_daemon.c
+++ b/tools/hv/hv_kvp_daemon.c
@@ -79,8 +79,6 @@ enum {
 	DNS
 };
 
-static char kvp_send_buffer[4096];
-static char kvp_recv_buffer[4096 * 2];
 static struct sockaddr_nl addr;
 static int in_hand_shake = 1;
 
@@ -1437,10 +1435,21 @@ int main(void)
 	int	pool;
 	char	*if_name;
 	struct hv_kvp_ipaddr_value *kvp_ip_val;
+	char *kvp_send_buffer;
+	char *kvp_recv_buffer;
+	size_t kvp_recv_buffer_len;
 
 	daemon(1, 0);
 	openlog("KVP", 0, LOG_USER);
 	syslog(LOG_INFO, "KVP starting; pid is:%d", getpid());
+
+	kvp_recv_buffer_len = NLMSG_HDRLEN + sizeof(struct cn_msg) + sizeof(struct hv_kvp_msg);
+	kvp_send_buffer = calloc(1, kvp_recv_buffer_len);
+	kvp_recv_buffer = calloc(1, kvp_recv_buffer_len);
+	if (!(kvp_send_buffer && kvp_recv_buffer)) {
+		syslog(LOG_ERR, "Failed to allocate netlink buffers");
+		exit(EXIT_FAILURE);
+	}
 	/*
 	 * Retrieve OS release information.
 	 */
@@ -1514,7 +1523,7 @@ int main(void)
 				continue;
 		}
 
-		len = recvfrom(fd, kvp_recv_buffer, sizeof(kvp_recv_buffer), 0,
+		len = recvfrom(fd, kvp_recv_buffer, kvp_recv_buffer_len, 0,
 				addr_p, &addr_l);
 
 		if (len < 0) {
diff --git a/tools/hv/hv_vss_daemon.c b/tools/hv/hv_vss_daemon.c
index fea03a3..4c34675 100644
--- a/tools/hv/hv_vss_daemon.c
+++ b/tools/hv/hv_vss_daemon.c
@@ -38,8 +38,6 @@
 #include <linux/netlink.h>
 #include <syslog.h>
 
-static char vss_recv_buffer[4096];
-static char vss_send_buffer[4096];
 static struct sockaddr_nl addr;
 
 #ifndef SOL_NETLINK
@@ -147,6 +145,9 @@ int main(void)
 	struct cn_msg	*incoming_cn_msg;
 	int	op;
 	struct hv_vss_msg *vss_msg;
+	char *vss_send_buffer;
+	char *vss_recv_buffer;
+	size_t vss_recv_buffer_len;
 
 	if (daemon(1, 0))
 		return 1;
@@ -154,6 +155,14 @@ int main(void)
 	openlog("Hyper-V VSS", 0, LOG_USER);
 	syslog(LOG_INFO, "VSS starting; pid is:%d", getpid());
 
+	vss_recv_buffer_len = NLMSG_HDRLEN + sizeof(struct cn_msg) + sizeof(struct hv_vss_msg);
+	vss_send_buffer = calloc(1, vss_recv_buffer_len);
+	vss_recv_buffer = calloc(1, vss_recv_buffer_len);
+	if (!(vss_send_buffer && vss_recv_buffer)) {
+		syslog(LOG_ERR, "Failed to allocate netlink buffers");
+		exit(EXIT_FAILURE);
+	}
+
 	fd = socket(AF_NETLINK, SOCK_DGRAM, NETLINK_CONNECTOR);
 	if (fd < 0) {
 		syslog(LOG_ERR, "netlink socket creation failed; error:%d", fd);
@@ -201,7 +210,7 @@ int main(void)
 		pfd.revents = 0;
 		poll(&pfd, 1, -1);
 
-		len = recvfrom(fd, vss_recv_buffer, sizeof(vss_recv_buffer), 0,
+		len = recvfrom(fd, vss_recv_buffer, vss_recv_buffer_len, 0,
 				addr_p, &addr_l);
 
 		if (len < 0) {
