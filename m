Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753234Ab3GGUoA (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Jul 2013 16:44:00 -0400
Received: from mail-pd0-f176.google.com ([209.85.192.176]:63273 "EHLO
	mail-pd0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753170Ab3GGUn6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Jul 2013 16:43:58 -0400
From: David Ahern <dsahern@gmail.com>
To: acme@ghostprotocols.net, linux-kernel@vger.kernel.org
Cc: David Ahern <dsahern@gmail.com>, Andi Kleen <ak@linux.intel.com>
Subject: [PATCH] perf: free original memory on realloc failure in str_append
Date: Sun,  7 Jul 2013 14:43:53 -0600
Message-Id: <1373229833-6157-1-git-send-email-dsahern@gmail.com>
X-Mailer: git-send-email 1.7.10.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

str_append was added in 578d9c6. If realloc fails orignal block is
not freed. Need to save the original pointer to handle on failure.

Signed-off-by: David Ahern <dsahern@gmail.com>
Cc: Andi Kleen <ak@linux.intel.com>
---
 tools/perf/util/string.c |    9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/tools/perf/util/string.c b/tools/perf/util/string.c
index f0b0c00..53bca50 100644
--- a/tools/perf/util/string.c
+++ b/tools/perf/util/string.c
@@ -398,13 +398,20 @@ int str_append(char **s, int *len, const char *a)
 {
 	int olen = *s ? strlen(*s) : 0;
 	int nlen = olen + strlen(a) + 1;
+	char *p;
+
 	if (*len < nlen) {
 		*len = *len * 2;
 		if (*len < nlen)
 			*len = nlen;
+
+		p = *s;
 		*s = realloc(*s, *len);
-		if (!*s)
+		if (!*s) {
+			free(p);
 			return -ENOMEM;
+		}
+
 		if (olen == 0)
 			**s = 0;
 	}
-- 
1.7.10.1

