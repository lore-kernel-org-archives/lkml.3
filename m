Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754773AbaBEUGF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Feb 2014 15:06:05 -0500
Received: from mail1.windriver.com ([147.11.146.13]:48179 "EHLO
	mail1.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754588AbaBEUFm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Feb 2014 15:05:42 -0500
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: <stable@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC: Kees Cook <keescook@chromium.org>, Michal Marek <mmarek@suse.cz>,
        Brad Spengler <spender@grsecurity.net>,
        PaX Team <pageexec@freemail.hu>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: [v2.6.34-stable 084/213] gen_init_cpio: avoid stack overflow when expanding
Date: Wed, 5 Feb 2014 15:00:39 -0500
Message-ID: <1391630568-49251-85-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.8.5.2
In-Reply-To: <1391630568-49251-1-git-send-email-paul.gortmaker@windriver.com>
References: <1391630568-49251-1-git-send-email-paul.gortmaker@windriver.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Kees Cook <keescook@chromium.org>

                   -------------------
    This is a commit scheduled for the next v2.6.34 longterm release.
    http://git.kernel.org/?p=linux/kernel/git/paulg/longterm-queue-2.6.34.git
    If you see a problem with using this for longterm, please comment.
                   -------------------

commit 20f1de659b77364d55d4e7fad2ef657e7730323f upstream.

Fix possible overflow of the buffer used for expanding environment
variables when building file list.

In the extremely unlikely case of an attacker having control over the
environment variables visible to gen_init_cpio, control over the
contents of the file gen_init_cpio parses, and gen_init_cpio was built
without compiler hardening, the attacker can gain arbitrary execution
control via a stack buffer overflow.

  $ cat usr/crash.list
  file foo ${BIG}${BIG}${BIG}${BIG}${BIG}${BIG} 0755 0 0
  $ BIG=$(perl -e 'print "A" x 4096;') ./usr/gen_init_cpio usr/crash.list
  *** buffer overflow detected ***: ./usr/gen_init_cpio terminated

This also replaces the space-indenting with tabs.

Patch based on existing fix extracted from grsecurity.

Signed-off-by: Kees Cook <keescook@chromium.org>
Cc: Michal Marek <mmarek@suse.cz>
Cc: Brad Spengler <spender@grsecurity.net>
Cc: PaX Team <pageexec@freemail.hu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 usr/gen_init_cpio.c | 43 +++++++++++++++++++++++--------------------
 1 file changed, 23 insertions(+), 20 deletions(-)

diff --git a/usr/gen_init_cpio.c b/usr/gen_init_cpio.c
index b2b3c2d1cf8b..0478657c15bc 100644
--- a/usr/gen_init_cpio.c
+++ b/usr/gen_init_cpio.c
@@ -299,7 +299,7 @@ static int cpio_mkfile(const char *name, const char *location,
 	int retval;
 	int rc = -1;
 	int namesize;
-	int i;
+	unsigned int i;
 
 	mode |= S_IFREG;
 
@@ -375,25 +375,28 @@ error:
 
 static char *cpio_replace_env(char *new_location)
 {
-       char expanded[PATH_MAX + 1];
-       char env_var[PATH_MAX + 1];
-       char *start;
-       char *end;
-
-       for (start = NULL; (start = strstr(new_location, "${")); ) {
-               end = strchr(start, '}');
-               if (start < end) {
-                       *env_var = *expanded = '\0';
-                       strncat(env_var, start + 2, end - start - 2);
-                       strncat(expanded, new_location, start - new_location);
-                       strncat(expanded, getenv(env_var), PATH_MAX);
-                       strncat(expanded, end + 1, PATH_MAX);
-                       strncpy(new_location, expanded, PATH_MAX);
-               } else
-                       break;
-       }
-
-       return new_location;
+	char expanded[PATH_MAX + 1];
+	char env_var[PATH_MAX + 1];
+	char *start;
+	char *end;
+
+	for (start = NULL; (start = strstr(new_location, "${")); ) {
+		end = strchr(start, '}');
+		if (start < end) {
+			*env_var = *expanded = '\0';
+			strncat(env_var, start + 2, end - start - 2);
+			strncat(expanded, new_location, start - new_location);
+			strncat(expanded, getenv(env_var),
+				PATH_MAX - strlen(expanded));
+			strncat(expanded, end + 1,
+				PATH_MAX - strlen(expanded));
+			strncpy(new_location, expanded, PATH_MAX);
+			new_location[PATH_MAX] = 0;
+		} else
+			break;
+	}
+
+	return new_location;
 }
 
 
-- 
1.8.5.2

