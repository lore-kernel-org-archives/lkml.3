Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932134AbbAHMPB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Jan 2015 07:15:01 -0500
Received: from mail-lb0-f173.google.com ([209.85.217.173]:33252 "EHLO
	mail-lb0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756632AbbAHMO6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Jan 2015 07:14:58 -0500
From: Rasmus Villemoes <linux@rasmusvillemoes.dk>
To: Andrew Morton <akpm@linux-foundation.org>, Jiri Kosina <jkosina@suse.cz>,
        Randy Dunlap <rdunlap@infradead.org>
Cc: Rasmus Villemoes <linux@rasmusvillemoes.dk>, linux-kernel@vger.kernel.org
Subject: [PATCH 3/4] lib/vsprintf.c: Don't try to fix pointer wrap-around
Date: Thu,  8 Jan 2015 13:14:46 +0100
Message-Id: <1420719287-10222-3-git-send-email-linux@rasmusvillemoes.dk>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <1420719287-10222-1-git-send-email-linux@rasmusvillemoes.dk>
References: <1420719287-10222-1-git-send-email-linux@rasmusvillemoes.dk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Actual kernel buffers can't wrap into the user address space. If
someone manages to pass a buf/size combination that wraps, it is most
likely due to a bug in the caller. Instead of trying to fix it by
using a smaller part of the buffer, bail out.

Signed-off-by: Rasmus Villemoes <linux@rasmusvillemoes.dk>
---
 lib/vsprintf.c | 8 +++-----
 1 file changed, 3 insertions(+), 5 deletions(-)

diff --git a/lib/vsprintf.c b/lib/vsprintf.c
index cf12ba86205c..1ec6a78f169b 100644
--- a/lib/vsprintf.c
+++ b/lib/vsprintf.c
@@ -1733,11 +1733,9 @@ int vsnprintf(char *buf, size_t size, const char *fmt, va_list args)
 	str = buf;
 	end = buf + size;
 
-	/* Make sure end is always >= buf */
-	if (end < buf) {
-		end = ((void *)-1);
-		size = end - buf;
-	}
+	/* Also bail out if buf+size wraps */
+	if (WARN_ON_ONCE(end < buf))
+		return 0;
 
 	while (*fmt) {
 		const char *old_fmt = fmt;
-- 
2.1.3

