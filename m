Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754675AbbAFIYK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jan 2015 03:24:10 -0500
Received: from mail-lb0-f202.google.com ([209.85.217.202]:35043 "EHLO
	mail-lb0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754371AbbAFIYF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jan 2015 03:24:05 -0500
X-Greylist: delayed 75430 seconds by postgrey-1.27 at vger.kernel.org; Tue, 06 Jan 2015 03:24:05 EST
From: David Drysdale <drysdale@google.com>
To: linux-kernel@vger.kernel.org, Geert Uytterhoeven <geert@linux-m68k.org>,
        Shuah Khan <shuahkh@osg.samsung.com>
Cc: Andreas Schwab <schwab@linux-m68k.org>,
        Andrew Morton <akpm@linux-foundation.org>, linux-m68k@vger.kernel.org,
        linux-api@vger.kernel.org, David Drysdale <drysdale@google.com>
Subject: [PATCHv2] selftests/exec: allow shell return code of 126
Date: Tue,  6 Jan 2015 08:23:56 +0000
Message-Id: <1420532636-7317-1-git-send-email-drysdale@google.com>
X-Mailer: git-send-email 2.2.0.rc0.207.ga3a616c
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When the shell fails to invoke a script because its path name
is too long (ENAMETOOLONG), most shells return 127 to indicate
command not found.  However, some systems report 126 (which POSIX
suggests should indicate a non-executable file) for this case,
so allow that too.

Reported-by: Geert Uytterhoeven <geert@linux-m68k.org>
Signed-off-by: David Drysdale <drysdale@google.com>
Tested-by: Geert Uytterhoeven <geert@linux-m68k.org>
---
 tools/testing/selftests/exec/execveat.c | 19 +++++++++++++------
 1 file changed, 13 insertions(+), 6 deletions(-)

diff --git a/tools/testing/selftests/exec/execveat.c b/tools/testing/selftests/exec/execveat.c
index d273624c93a6..e238c9559caf 100644
--- a/tools/testing/selftests/exec/execveat.c
+++ b/tools/testing/selftests/exec/execveat.c
@@ -62,7 +62,7 @@ static int _check_execveat_fail(int fd, const char *path, int flags,
 }
 
 static int check_execveat_invoked_rc(int fd, const char *path, int flags,
-				     int expected_rc)
+				     int expected_rc, int expected_rc2)
 {
 	int status;
 	int rc;
@@ -98,9 +98,10 @@ static int check_execveat_invoked_rc(int fd, const char *path, int flags,
 			child, status);
 		return 1;
 	}
-	if (WEXITSTATUS(status) != expected_rc) {
-		printf("[FAIL] (child %d exited with %d not %d)\n",
-			child, WEXITSTATUS(status), expected_rc);
+	if ((WEXITSTATUS(status) != expected_rc) &&
+	    (WEXITSTATUS(status) != expected_rc2)) {
+		printf("[FAIL] (child %d exited with %d not %d nor %d)\n",
+			child, WEXITSTATUS(status), expected_rc, expected_rc2);
 		return 1;
 	}
 	printf("[OK]\n");
@@ -109,7 +110,7 @@ static int check_execveat_invoked_rc(int fd, const char *path, int flags,
 
 static int check_execveat(int fd, const char *path, int flags)
 {
-	return check_execveat_invoked_rc(fd, path, flags, 99);
+	return check_execveat_invoked_rc(fd, path, flags, 99, 99);
 }
 
 static char *concat(const char *left, const char *right)
@@ -192,9 +193,15 @@ static int check_execveat_pathmax(int dot_dfd, const char *src, int is_script)
 	 * Execute as a long pathname relative to ".".  If this is a script,
 	 * the interpreter will launch but fail to open the script because its
 	 * name ("/dev/fd/5/xxx....") is bigger than PATH_MAX.
+	 *
+	 * The failure code is usually 127 (POSIX: "If a command is not found,
+	 * the exit status shall be 127."), but some systems give 126 (POSIX:
+	 * "If the command name is found, but it is not an executable utility,
+	 * the exit status shall be 126."), so allow either.
 	 */
 	if (is_script)
-		fail += check_execveat_invoked_rc(dot_dfd, longpath, 0, 127);
+		fail += check_execveat_invoked_rc(dot_dfd, longpath, 0,
+						  127, 126);
 	else
 		fail += check_execveat(dot_dfd, longpath, 0);
 
-- 
2.2.0.rc0.207.ga3a616c

