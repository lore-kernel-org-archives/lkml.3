Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965530AbbA2C4L (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2015 21:56:11 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:47024 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965438AbbA2CiL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jan 2015 21:38:11 -0500
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: "Eric W. Biederman" <ebiederm@xmission.com>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.13.y-ckt 113/139] userns: Unbreak the unprivileged remount tests
Date: Wed, 28 Jan 2015 14:20:56 -0800
Message-Id: <1422483682-15393-114-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1422483682-15393-1-git-send-email-kamal@canonical.com>
References: <1422483682-15393-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.13
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13.11-ckt15 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: "Eric W. Biederman" <ebiederm@xmission.com>

commit db86da7cb76f797a1a8b445166a15cb922c6ff85 upstream.

A security fix in caused the way the unprivileged remount tests were
using user namespaces to break.  Tweak the way user namespaces are
being used so the test works again.

Signed-off-by: "Eric W. Biederman" <ebiederm@xmission.com>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 .../selftests/mount/unprivileged-remount-test.c    | 32 ++++++++++++++++------
 1 file changed, 24 insertions(+), 8 deletions(-)

diff --git a/tools/testing/selftests/mount/unprivileged-remount-test.c b/tools/testing/selftests/mount/unprivileged-remount-test.c
index 9669d37..5177850 100644
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
1.9.1

