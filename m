Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756796Ab3DWUve (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Apr 2013 16:51:34 -0400
Received: from p3plsmtps2ded01.prod.phx3.secureserver.net ([208.109.80.58]:51622
	"EHLO p3plsmtps2ded01.prod.phx3.secureserver.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755293Ab3DWUvd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Apr 2013 16:51:33 -0400
x-originating-ip: 72.167.245.219
From: "K. Y. Srinivasan" <kys@microsoft.com>
To: gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org,
        devel@linuxdriverproject.org, olaf@aepfle.de, apw@canonical.com,
        jasowang@redhat.com
Cc: "K. Y. Srinivasan" <kys@microsoft.com>
Subject: [PATCH 1/5] Tools: hv: fix warnings in hv_vss_daemon
Date: Tue, 23 Apr 2013 14:23:57 -0700
Message-Id: <1366752241-357-1-git-send-email-kys@microsoft.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1366752210-318-1-git-send-email-kys@microsoft.com>
References: <1366752210-318-1-git-send-email-kys@microsoft.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Olaf Hering <olaf@aepfle.de>

This change fixes a few compile errors:

hv_vss_daemon.c:64:15: warning: unknown escape sequence '\/'
hv_vss_daemon.c:64:15: warning: unknown escape sequence '\/'
hv_vss_daemon.c: In function 'vss_operate':
hv_vss_daemon.c:66: warning: 'return' with no value, in function returning non-void
hv_vss_daemon.c: In function 'main':
hv_vss_daemon.c:130: warning: ignoring return value of 'daemon', declared with attribute warn_unused_result
hv_vss_daemon.c: In function 'vss_operate':
hv_vss_daemon.c:47: warning: 'fs_op' may be used uninitialized in this function

Signed-off-by: Olaf Hering <olaf@aepfle.de>
Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
---
 tools/hv/hv_vss_daemon.c |   12 ++++++++----
 1 files changed, 8 insertions(+), 4 deletions(-)

diff --git a/tools/hv/hv_vss_daemon.c b/tools/hv/hv_vss_daemon.c
index 9526995..2a03d0b 100644
--- a/tools/hv/hv_vss_daemon.c
+++ b/tools/hv/hv_vss_daemon.c
@@ -51,7 +51,7 @@ static int vss_operate(int operation)
 	FILE *file;
 	char *p;
 	char *x;
-	int error;
+	int error = 0;
 
 	switch (operation) {
 	case VSS_OP_FREEZE:
@@ -60,11 +60,13 @@ static int vss_operate(int operation)
 	case VSS_OP_THAW:
 		fs_op = "-u ";
 		break;
+	default:
+		return -1;
 	}
 
-	file = popen("mount | awk '/^\/dev\// { print $3}'", "r");
+	file = popen("mount | awk '/^\\/dev\\// { print $3}'", "r");
 	if (file == NULL)
-		return;
+		return -1;
 
 	while ((p = fgets(buf, sizeof(buf), file)) != NULL) {
 		x = strchr(p, '\n');
@@ -128,7 +130,9 @@ int main(void)
 	int	op;
 	struct hv_vss_msg *vss_msg;
 
-	daemon(1, 0);
+	if (daemon(1, 0))
+		return 1;
+
 	openlog("Hyper-V VSS", 0, LOG_USER);
 	syslog(LOG_INFO, "VSS starting; pid is:%d", getpid());
 
-- 
1.7.4.1

