Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965469Ab3CZP26 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Mar 2013 11:28:58 -0400
Received: from mo-p00-ob.rzone.de ([81.169.146.162]:61802 "EHLO
	mo-p00-ob.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965452Ab3CZP24 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Mar 2013 11:28:56 -0400
X-RZG-AUTH: :P2EQZWCpfu+qG7CngxMFH1J+yackYocTD1iAi8x+OWJ8KkvZ5r/TwSabzUg=
X-RZG-CLASS-ID: mo00
From: Olaf Hering <olaf@aepfle.de>
To: kys@microsoft.com, gregkh@linuxfoundation.org
Cc: linux-kernel@vger.kernel.org, Olaf Hering <olaf@aepfle.de>
Subject: [PATCH 2/3] tools: hv: fix checks for origin of netlink message in hv_vss_daemon
Date: Tue, 26 Mar 2013 16:28:28 +0100
Message-Id: <1364311709-18228-2-git-send-email-olaf@aepfle.de>
X-Mailer: git-send-email 1.8.2
In-Reply-To: <1364311709-18228-1-git-send-email-olaf@aepfle.de>
References: <1364311709-18228-1-git-send-email-olaf@aepfle.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Similar to what commit 95a69adab9acfc3981c504737a2b6578e4d846ef ("tools:
hv: Netlink source address validation allows DoS") does in
hv_kvp_daemon, improve checks for origin of netlink connector message.

Signed-off-by: Olaf Hering <olaf@aepfle.de>
---
 tools/hv/hv_vss_daemon.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/tools/hv/hv_vss_daemon.c b/tools/hv/hv_vss_daemon.c
index 2a03d0b..dc3eb1e 100644
--- a/tools/hv/hv_vss_daemon.c
+++ b/tools/hv/hv_vss_daemon.c
@@ -186,13 +186,19 @@ int main(void)
 		len = recvfrom(fd, vss_recv_buffer, sizeof(vss_recv_buffer), 0,
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
 		incoming_msg = (struct nlmsghdr *)vss_recv_buffer;
 
 		if (incoming_msg->nlmsg_type != NLMSG_DONE)
