Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965440Ab3CZP2v (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Mar 2013 11:28:51 -0400
Received: from mo-p00-ob.rzone.de ([81.169.146.162]:13233 "EHLO
	mo-p00-ob.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755715Ab3CZP2t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Mar 2013 11:28:49 -0400
X-RZG-AUTH: :P2EQZWCpfu+qG7CngxMFH1J+yackYocTD1iAi8x+OWJ8KkvZ5r/TwSabzUg=
X-RZG-CLASS-ID: mo00
From: Olaf Hering <olaf@aepfle.de>
To: kys@microsoft.com, gregkh@linuxfoundation.org
Cc: linux-kernel@vger.kernel.org, Olaf Hering <olaf@aepfle.de>
Subject: [PATCH 1/3] Tools: hv: fix warnings in hv_vss_daemon
Date: Tue, 26 Mar 2013 16:28:27 +0100
Message-Id: <1364311709-18228-1-git-send-email-olaf@aepfle.de>
X-Mailer: git-send-email 1.8.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

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
---
 tools/hv/hv_vss_daemon.c | 12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

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
 
