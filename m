Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752320AbaFMNqc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jun 2014 09:46:32 -0400
Received: from mail-wi0-f202.google.com ([209.85.212.202]:38643 "EHLO
	mail-wi0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751025AbaFMNqb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jun 2014 09:46:31 -0400
X-Greylist: delayed 498 seconds by postgrey-1.27 at vger.kernel.org; Fri, 13 Jun 2014 09:46:31 EDT
From: Michal Nazarewicz <mina86@mina86.com>
To: Andi Kleen <ak@linux.intel.com>
Cc: Rusty Russell <rusty@rustcorp.com.au>, linux-kernel@vger.kernel.org,
        Michal Nazarewicz <mina86@mina86.com>
Subject: [PATCH] scripts: modpost: fix compilation warning
Date: Fri, 13 Jun 2014 15:39:14 +0200
Message-Id: <1402666754-5325-1-git-send-email-mina86@mina86.com>
X-Mailer: git-send-email 2.0.0.526.g5318336
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The scripts/mod/modpost.c triggers the following warning:

scripts/mod/modpost.c: In function ‘remove_dot’:
scripts/mod/modpost.c:1710:10: warning: ignoring return value of ‘strtoul’, declared with attribute warn_unused_result [-Wunused-result]

The remove_dot function that calls strtoul does not care about the
numeric value of the string that is parsed but only looks for the
end of the numeric sequence.  As such, it's equivalent to just skip
over all digits.

Signed-off-by: Michal Nazarewicz <mina86@mina86.com>
---
 scripts/mod/modpost.c | 9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

diff --git a/scripts/mod/modpost.c b/scripts/mod/modpost.c
index 0663556..c710651 100644
--- a/scripts/mod/modpost.c
+++ b/scripts/mod/modpost.c
@@ -1703,12 +1703,11 @@ static void check_sec_ref(struct module *mod, const char *modname,
 
 static char *remove_dot(char *s)
 {
-	char *end;
-	int n = strcspn(s, ".");
+	size_t n = strcspn(s, ".");
 
-	if (n > 0 && s[n] != 0) {
-		strtoul(s + n + 1, &end, 10);
-		if  (end > s + n + 1 && (*end == '.' || *end == 0))
+	if (n && s[n]) {
+		size_t m = strspn(s + n + 1, "0123456789");
+		if (m && (s[n + m] == '.' || s[n + m] == 0))
 			s[n] = 0;
 	}
 	return s;
-- 
2.0.0.526.g5318336

