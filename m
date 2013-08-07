Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932939Ab3HGNH2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Aug 2013 09:07:28 -0400
Received: from mo-p00-ob.rzone.de ([81.169.146.161]:8364 "EHLO
	mo-p00-ob.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932908Ab3HGNH1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Aug 2013 09:07:27 -0400
X-RZG-AUTH: :P2EQZWCpfu+qG7CngxMFH1J+yackYocTD1iAi8x+OWJ8KkvZ5r/UwZ9ieg==
X-RZG-CLASS-ID: mo00
From: Olaf Hering <olaf@aepfle.de>
To: kys@microsoft.com, gregkh@linuxfoundation.org
Cc: linux-kernel@vger.kernel.org, Olaf Hering <olaf@aepfle.de>
Subject: [PATCH] Tools: hv: correct payload size in netlink_send
Date: Wed,  7 Aug 2013 15:07:21 +0200
Message-Id: <1375880841-12959-1-git-send-email-olaf@aepfle.de>
X-Mailer: git-send-email 1.8.3.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

netlink_send is supposed to send just the cn_msg+hv_kvp_msg via netlink.
Currently it sets an incorrect iovec size, as reported by valgrind.

In the case of registering with the kernel the allocated buffer is large
enough to hold nlmsghdr+cn_msg+hv_kvp_msg, no overrun happens. In the
case of responding to the kernel the cn_msg is located in the middle of
recv_buffer, after the nlmsghdr. Currently the code in netlink_send adds
also the size of nlmsghdr to the payload. But nlmsghdr is a separate
iovec. This leads to an (harmless) out-of-bounds access when the kernel
processes the iovec. Correct the iovec size of the cn_msg to be just
cn_msg + its payload.

Signed-off-by: Olaf Hering <olaf@aepfle.de>
---
 tools/hv/hv_kvp_daemon.c | 2 +-
 tools/hv/hv_vss_daemon.c | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/tools/hv/hv_kvp_daemon.c b/tools/hv/hv_kvp_daemon.c
index d3bcb84..1bd1ad1 100644
--- a/tools/hv/hv_kvp_daemon.c
+++ b/tools/hv/hv_kvp_daemon.c
@@ -1399,7 +1399,7 @@ netlink_send(int fd, struct cn_msg *msg)
 	char buffer[64];
 	struct iovec iov[2];
 
-	size = NLMSG_SPACE(sizeof(struct cn_msg) + msg->len);
+	size = sizeof(struct cn_msg) + msg->len;
 
 	nlh = (struct nlmsghdr *)buffer;
 	nlh->nlmsg_seq = 0;
diff --git a/tools/hv/hv_vss_daemon.c b/tools/hv/hv_vss_daemon.c
index 6b4f2fa..2f1f53f 100644
--- a/tools/hv/hv_vss_daemon.c
+++ b/tools/hv/hv_vss_daemon.c
@@ -111,7 +111,7 @@ static int netlink_send(int fd, struct cn_msg *msg)
 	char buffer[64];
 	struct iovec iov[2];
 
-	size = NLMSG_SPACE(sizeof(struct cn_msg) + msg->len);
+	size = sizeof(struct cn_msg) + msg->len;
 
 	nlh = (struct nlmsghdr *)buffer;
 	nlh->nlmsg_seq = 0;
