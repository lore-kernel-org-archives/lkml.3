Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933236AbbAIKuS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Jan 2015 05:50:18 -0500
Received: from ip4-83-240-67-251.cust.nbox.cz ([83.240.67.251]:44559 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1757452AbbAIKc3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Jan 2015 05:32:29 -0500
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, "Eric W. Biederman" <ebiederm@xmission.com>,
        Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 66/78] userns: Unbreak the unprivileged remount tests
Date: Fri,  9 Jan 2015 11:32:15 +0100
Message-Id: <dc7a80cc0095cd6d8a69d79eace72b2c6ed48364.1420799385.git.jslaby@suse.cz>
X-Mailer: git-send-email 2.2.1
In-Reply-To: <72002f1f248c28d1715d10454190e209d5a20fe1.1420799385.git.jslaby@suse.cz>
References: <72002f1f248c28d1715d10454190e209d5a20fe1.1420799385.git.jslaby@suse.cz>
In-Reply-To: <cover.1420799385.git.jslaby@suse.cz>
References: <cover.1420799385.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Eric W. Biederman" <ebiederm@xmission.com>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

commit db86da7cb76f797a1a8b445166a15cb922c6ff85 upstream.

A security fix in caused the way the unprivileged remount tests were
using user namespaces to break.  Tweak the way user namespaces are
being used so the test works again.

Signed-off-by: "Eric W. Biederman" <ebiederm@xmission.com>
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 .../selftests/mount/unprivileged-remount-test.c    | 32 ++++++++++++++++------
 1 file changed, 24 insertions(+), 8 deletions(-)

diff --git a/tools/testing/selftests/mount/unprivileged-remount-test.c b/tools/testing/selftests/mount/unprivileged-remount-test.c
index 9669d375625a..517785052f1c 100644
--- a/tools/testing/selftests/mount/unprivileged-remount-test.c
+++ b/tools/testing/selftests/mount/unprivileged-remount-test.c
@@ -53,17 +53,14 @@ static void die(char *fmt, ...)
 	exit(EXIT_FAILURE);
 }
 
-static void write_file(char *filename, char *fmt, ...)
+static void vmaybe_write_file(bool enoent_ok, char *filename, char *fmt, va_list ap)
 {
 	char buf[4096];
 	int fd;
 	ssize_t written;
 	int buf_len;
-	va_list ap;
 
-	va_start(ap, fmt);
 	buf_len = vsnprintf(buf, sizeof(buf), fmt, ap);
-	va_end(ap);
 	if (buf_len < 0) {
 		die("vsnprintf failed: %s\n",
 		    strerror(errno));
@@ -74,6 +71,8 @@ static void write_file(char *filename, char *fmt, ...)
 
 	fd = open(filename, O_WRONLY);
 	if (fd < 0) {
+		if ((errno == ENOENT) && enoent_ok)
+			return;
 		die("open of %s failed: %s\n",
 		    filename, strerror(errno));
 	}
@@ -92,6 +91,26 @@ static void write_file(char *filename, char *fmt, ...)
 	}
 }
 
+static void maybe_write_file(char *filename, char *fmt, ...)
+{
+	va_list ap;
+
+	va_start(ap, fmt);
+	vmaybe_write_file(true, filename, fmt, ap);
+	va_end(ap);
+
+}
+
+static void write_file(char *filename, char *fmt, ...)
+{
+	va_list ap;
+
+	va_start(ap, fmt);
+	vmaybe_write_file(false, filename, fmt, ap);
+	va_end(ap);
+
+}
+
 static int read_mnt_flags(const char *path)
 {
 	int ret;
@@ -144,13 +163,10 @@ static void create_and_enter_userns(void)
 			strerror(errno));
 	}
 
+	maybe_write_file("/proc/self/setgroups", "deny");
 	write_file("/proc/self/uid_map", "0 %d 1", uid);
 	write_file("/proc/self/gid_map", "0 %d 1", gid);
 
-	if (setgroups(0, NULL) != 0) {
-		die("setgroups failed: %s\n",
-			strerror(errno));
-	}
 	if (setgid(0) != 0) {
 		die ("setgid(0) failed %s\n",
 			strerror(errno));
-- 
2.2.1

