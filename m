Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756059Ab3DWM0B (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Apr 2013 08:26:01 -0400
Received: from p3plsmtps2ded03.prod.phx3.secureserver.net ([208.109.80.60]:57723
	"EHLO p3plsmtps2ded03.prod.phx3.secureserver.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755850Ab3DWMZ5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Apr 2013 08:25:57 -0400
x-originating-ip: 72.167.245.219
From: "K. Y. Srinivasan" <kys@microsoft.com>
To: gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org,
        devel@linuxdriverproject.org, olaf@aepfle.de, apw@canonical.com,
        jasowang@redhat.com
Cc: Olaf Hering <"[mailto:olaf@aepfle.de]"@linuxonhyperv.com>,
        "K. Y. Srinivasan" <kys@microsoft.com>
Subject: [PATCH 2/5] [PATCH 2/3] tools: hv: fix checks for origin of netlink message in hv_vss_daemon
Date: Tue, 23 Apr 2013 05:58:20 -0700
Message-Id: <1366721903-31494-2-git-send-email-kys@microsoft.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1366721903-31494-1-git-send-email-kys@microsoft.com>
References: <1366721852-31453-1-git-send-email-kys@microsoft.com>
 <1366721903-31494-1-git-send-email-kys@microsoft.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Olaf Hering <[mailto:olaf@aepfle.de]>

Similar to what commit 95a69adab9acfc3981c504737a2b6578e4d846ef ("tools:
hv: Netlink source address validation allows DoS") does in
hv_kvp_daemon, improve checks for origin of netlink connector message.

Signed-off-by: Olaf Hering <olaf@aepfle.de>
Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
---
 tools/hv/hv_vss_daemon.c |    8 +++++++-
 1 files changed, 7 insertions(+), 1 deletions(-)

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
-- 
1.7.4.1

