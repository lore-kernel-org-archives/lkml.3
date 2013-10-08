Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753469Ab3JHC5V (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Oct 2013 22:57:21 -0400
Received: from smtp.outflux.net ([198.145.64.163]:48985 "EHLO smtp.outflux.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751431Ab3JHC5T (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Oct 2013 22:57:19 -0400
From: Kees Cook <keescook@chromium.org>
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org,
        Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>, joe@perches.com,
        keescook@chromium.org
Subject: [PATCH 3/3] vsprintf: ignore %n again
Date: Mon,  7 Oct 2013 19:56:51 -0700
Message-Id: <1381201011-4230-3-git-send-email-keescook@chromium.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1381201011-4230-1-git-send-email-keescook@chromium.org>
References: <1381201011-4230-1-git-send-email-keescook@chromium.org>
X-HELO: www.outflux.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This ignores %n in printf again, as was originally documented. Implementing
%n poses a greater security risk than utility, so it should stay ignored.
To help anyone attempting to use %n, a warning will be emitted if it is
encountered.

Based on earlier patch by Joe Perches.

Signed-off-by: Kees Cook <keescook@chromium.org>
Cc: Joe Perches <joe@perches.com>
---
 lib/vsprintf.c |   20 +++++++++-----------
 1 file changed, 9 insertions(+), 11 deletions(-)

diff --git a/lib/vsprintf.c b/lib/vsprintf.c
index 26559bd..478c30e 100644
--- a/lib/vsprintf.c
+++ b/lib/vsprintf.c
@@ -1683,18 +1683,16 @@ int vsnprintf(char *buf, size_t size, const char *fmt, va_list args)
 			break;
 
 		case FORMAT_TYPE_NRCHARS: {
-			u8 qualifier = spec.qualifier;
+			/*
+			 * Since %n poses a greater security risk than
+			 * utility, ignore %n and skip its argument.
+			 */
+			void *skip_arg;
 
-			if (qualifier == 'l') {
-				long *ip = va_arg(args, long *);
-				*ip = (str - buf);
-			} else if (_tolower(qualifier) == 'z') {
-				size_t *ip = va_arg(args, size_t *);
-				*ip = (str - buf);
-			} else {
-				int *ip = va_arg(args, int *);
-				*ip = (str - buf);
-			}
+			WARN_ONCE(1, "Please remove ignored %%n in '%s'\n",
+					old_fmt);
+
+			skip_arg = va_arg(args, void *);
 			break;
 		}
 
-- 
1.7.9.5

