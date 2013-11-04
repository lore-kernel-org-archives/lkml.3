Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752707Ab3KDKVa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Nov 2013 05:21:30 -0500
Received: from mail-ea0-f175.google.com ([209.85.215.175]:44667 "EHLO
	mail-ea0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750829Ab3KDKV2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Nov 2013 05:21:28 -0500
From: Michal Nazarewicz <mpn@google.com>
To: Kees Cook <keescook@chromium.org>, Jiri Kosina <jkosina@suse.cz>,
        Jesper Juhl <jj@codesealer.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
        Michal Nazarewicz <mina86@mina86.com>
Subject: [PATCH] gen_init_cpio: avoid NULL pointer dereference and rework env expanding
Date: Mon,  4 Nov 2013 11:21:20 +0100
Message-Id: <1383560481-9046-1-git-send-email-mpn@google.com>
X-Mailer: git-send-email 1.8.4.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Michal Nazarewicz <mina86@mina86.com>

genenv functian may return NULL if given environment variable does not
exist which leads to NULL dereference when calling strncat.

Besides that, the environment variable name was copied to a temporary
env_var buffer, but this copying can be avoided by simply using the
input string.

Lastly, the whole loop can be greatly simplified by using the snprintf
function instead of the playing with strncat.

Signed-off-by: Michal Nazarewicz <mina86@mina86.com>
---
 By the way, the current implementation allows a recursive variable
 expansion, as in:

   $ echo 'out ${A} out ' | A='a ${B} a' B=b /tmp/a
   out a b a out 

 I'm assuming this is just a side effect and not a concious decision
 (especially as this may lead to infinite loop), but I didn't want to
 change this behaviour without consulting.

 If the current behaviour is deamed incorrect, I'll be happy to send
 a patch without recursive processing.

 usr/gen_init_cpio.c | 27 +++++++++------------------
 1 file changed, 9 insertions(+), 18 deletions(-)

diff --git a/usr/gen_init_cpio.c b/usr/gen_init_cpio.c
index af8c925..225ad24 100644
--- a/usr/gen_init_cpio.c
+++ b/usr/gen_init_cpio.c
@@ -382,24 +382,15 @@ error:
 static char *cpio_replace_env(char *new_location)
 {
 	char expanded[PATH_MAX + 1];
-	char env_var[PATH_MAX + 1];
-	char *start;
-	char *end;
-
-	for (start = NULL; (start = strstr(new_location, "${")); ) {
-		end = strchr(start, '}');
-		if (start < end) {
-			*env_var = *expanded = '\0';
-			strncat(env_var, start + 2, end - start - 2);
-			strncat(expanded, new_location, start - new_location);
-			strncat(expanded, getenv(env_var),
-				PATH_MAX - strlen(expanded));
-			strncat(expanded, end + 1,
-				PATH_MAX - strlen(expanded));
-			strncpy(new_location, expanded, PATH_MAX);
-			new_location[PATH_MAX] = 0;
-		} else
-			break;
+	char *start, *end, *var;
+
+	while ((start = strstr(new_location, "${")) &&
+	       (end = strchr(start + 2, '}'))) {
+		*start = *end = 0;
+		var = getenv(start + 2);
+		snprintf(expanded, sizeof expanded, "%s%s%s",
+			 new_location, var ? var : "", end + 1);
+		strcpy(new_location, expanded);
 	}
 
 	return new_location;
-- 
1.8.4.1

