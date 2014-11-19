Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754952AbaKSJl5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Nov 2014 04:41:57 -0500
Received: from p3plsmtps2ded03.prod.phx3.secureserver.net ([208.109.80.60]:54696
	"EHLO p3plsmtps2ded03.prod.phx3.secureserver.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751265AbaKSJlz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Nov 2014 04:41:55 -0500
x-originating-ip: 72.167.245.219
From: Dexuan Cui <decui@microsoft.com>
To: gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org,
        driverdev-devel@linuxdriverproject.org, olaf@aepfle.de,
        apw@canonical.com, jasowang@redhat.com
Cc: kys@microsoft.com, haiyangz@microsoft.com
Subject: [PATCH] tools: hv: ignore ENOBUFS in the KVP daemon
Date: Wed, 19 Nov 2014 02:50:45 -0800
Message-Id: <1416394245-31717-1-git-send-email-decui@microsoft.com>
X-Mailer: git-send-email 1.7.4.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Under high memory pressure and very high KVP R/W test pressure, the netlink
recvfrom() may transiently return ENOBUFS to the daemon -- we found this
during a 2-week stress test.

We'd better not terminate the daemon on this failure, because a typical KVP
user can re-try the R/W and hopefully it will succeed next time.

Cc: K. Y. Srinivasan <kys@microsoft.com>
Signed-off-by: Dexuan Cui <decui@microsoft.com>
---
 tools/hv/hv_kvp_daemon.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/tools/hv/hv_kvp_daemon.c b/tools/hv/hv_kvp_daemon.c
index 22b0764..9f4b303 100644
--- a/tools/hv/hv_kvp_daemon.c
+++ b/tools/hv/hv_kvp_daemon.c
@@ -1559,8 +1559,15 @@ int main(int argc, char *argv[])
 				addr_p, &addr_l);
 
 		if (len < 0) {
+			int saved_errno = errno;
 			syslog(LOG_ERR, "recvfrom failed; pid:%u error:%d %s",
 					addr.nl_pid, errno, strerror(errno));
+
+			if (saved_errno == ENOBUFS) {
+				syslog(LOG_ERR, "error = ENOBUFS: ignored");
+				continue;
+			}
+
 			close(fd);
 			return -1;
 		}
-- 
1.9.1

