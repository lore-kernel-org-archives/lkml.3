Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965109Ab3CZPyG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Mar 2013 11:54:06 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:53759 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965027Ab3CZPWe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Mar 2013 11:22:34 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Tomas Hozza <thozza@redhat.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 060/150] tools: hv: Netlink source address validation allows DoS
Date: Tue, 26 Mar 2013 15:19:19 +0000
Message-Id: <1364311249-14454-61-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1364311249-14454-1-git-send-email-luis.henriques@canonical.com>
References: <1364311249-14454-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.9 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tomas Hozza <thozza@redhat.com>

commit 95a69adab9acfc3981c504737a2b6578e4d846ef upstream.

The source code without this patch caused hypervkvpd to exit when it processed
a spoofed Netlink packet which has been sent from an untrusted local user.
Now Netlink messages with a non-zero nl_pid source address are ignored
and a warning is printed into the syslog.

Signed-off-by: Tomas Hozza <thozza@redhat.com>
Acked-by:  K. Y. Srinivasan <kys@microsoft.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 tools/hv/hv_kvp_daemon.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/tools/hv/hv_kvp_daemon.c b/tools/hv/hv_kvp_daemon.c
index 2984ffb..60a8e29 100644
--- a/tools/hv/hv_kvp_daemon.c
+++ b/tools/hv/hv_kvp_daemon.c
@@ -727,13 +727,19 @@ int main(void)
 		len = recvfrom(fd, kvp_recv_buffer, sizeof(kvp_recv_buffer), 0,
 				addr_p, &addr_l);
 
-		if (len < 0 || addr.nl_pid) {
+		if (len < 0) {
 			syslog(LOG_ERR, "recvfrom failed; pid:%u error:%d %s",
 					addr.nl_pid, errno, strerror(errno));
 			close(fd);
 			return -1;
 		}
 
+		if (addr.nl_pid) {
+			syslog(LOG_WARNING, "Received packet from untrusted pid:%u",
+					addr.nl_pid);
+			continue;
+		}
+
 		incoming_msg = (struct nlmsghdr *)kvp_recv_buffer;
 		incoming_cn_msg = (struct cn_msg *)NLMSG_DATA(incoming_msg);
 		hv_msg = (struct hv_kvp_msg *)incoming_cn_msg->data;
-- 
1.8.1.2

