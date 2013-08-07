Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933187Ab3HGNpT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Aug 2013 09:45:19 -0400
Received: from mo-p00-ob.rzone.de ([81.169.146.161]:10466 "EHLO
	mo-p00-ob.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933046Ab3HGNpR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Aug 2013 09:45:17 -0400
X-RZG-AUTH: :P2EQZWCpfu+qG7CngxMFH1J+yackYocTD1iAi8x+OWJ8KkvZ5r/UwZ9ieg==
X-RZG-CLASS-ID: mo00
From: Olaf Hering <olaf@aepfle.de>
To: kys@microsoft.com, gregkh@linuxfoundation.org
Cc: linux-kernel@vger.kernel.org, Olaf Hering <olaf@aepfle.de>
Subject: [PATCH] Tools: hv: use full nlmsghdr in netlink_send
Date: Wed,  7 Aug 2013 15:45:12 +0200
Message-Id: <1375883112-20279-1-git-send-email-olaf@aepfle.de>
X-Mailer: git-send-email 1.8.3.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There is no need to have a nlmsghdr pointer to another temporary buffer.
Instead use a full struct nlmsghdr.

Signed-off-by: Olaf Hering <olaf@aepfle.de>
---
 tools/hv/hv_kvp_daemon.c | 15 +++++----------
 tools/hv/hv_vss_daemon.c | 15 +++++----------
 2 files changed, 10 insertions(+), 20 deletions(-)

diff --git a/tools/hv/hv_kvp_daemon.c b/tools/hv/hv_kvp_daemon.c
index 1bd1ad1..7c05f55 100644
--- a/tools/hv/hv_kvp_daemon.c
+++ b/tools/hv/hv_kvp_daemon.c
@@ -1393,23 +1393,18 @@ kvp_get_domain_name(char *buffer, int length)
 static int
 netlink_send(int fd, struct cn_msg *msg)
 {
-	struct nlmsghdr *nlh;
+	struct nlmsghdr nlh = { .nlmsg_type = NLMSG_DONE };
 	unsigned int size;
 	struct msghdr message;
-	char buffer[64];
 	struct iovec iov[2];
 
 	size = sizeof(struct cn_msg) + msg->len;
 
-	nlh = (struct nlmsghdr *)buffer;
-	nlh->nlmsg_seq = 0;
-	nlh->nlmsg_pid = getpid();
-	nlh->nlmsg_type = NLMSG_DONE;
-	nlh->nlmsg_len = NLMSG_LENGTH(size - sizeof(*nlh));
-	nlh->nlmsg_flags = 0;
+	nlh.nlmsg_pid = getpid();
+	nlh.nlmsg_len = NLMSG_LENGTH(size);
 
-	iov[0].iov_base = nlh;
-	iov[0].iov_len = sizeof(*nlh);
+	iov[0].iov_base = &nlh;
+	iov[0].iov_len = sizeof(nlh);
 
 	iov[1].iov_base = msg;
 	iov[1].iov_len = size;
diff --git a/tools/hv/hv_vss_daemon.c b/tools/hv/hv_vss_daemon.c
index 2f1f53f..8ac0ee7 100644
--- a/tools/hv/hv_vss_daemon.c
+++ b/tools/hv/hv_vss_daemon.c
@@ -105,23 +105,18 @@ static int vss_operate(int operation)
 
 static int netlink_send(int fd, struct cn_msg *msg)
 {
-	struct nlmsghdr *nlh;
+	struct nlmsghdr nlh = { .nlmsg_type = NLMSG_DONE };
 	unsigned int size;
 	struct msghdr message;
-	char buffer[64];
 	struct iovec iov[2];
 
 	size = sizeof(struct cn_msg) + msg->len;
 
-	nlh = (struct nlmsghdr *)buffer;
-	nlh->nlmsg_seq = 0;
-	nlh->nlmsg_pid = getpid();
-	nlh->nlmsg_type = NLMSG_DONE;
-	nlh->nlmsg_len = NLMSG_LENGTH(size - sizeof(*nlh));
-	nlh->nlmsg_flags = 0;
+	nlh.nlmsg_pid = getpid();
+	nlh.nlmsg_len = NLMSG_LENGTH(size);
 
-	iov[0].iov_base = nlh;
-	iov[0].iov_len = sizeof(*nlh);
+	iov[0].iov_base = &nlh;
+	iov[0].iov_len = sizeof(nlh);
 
 	iov[1].iov_base = msg;
 	iov[1].iov_len = size;
