Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754631AbaA1AoR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Jan 2014 19:44:17 -0500
Received: from smtp.outflux.net ([198.145.64.163]:34279 "EHLO smtp.outflux.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751571AbaA1AoQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Jan 2014 19:44:16 -0500
Date: Mon, 27 Jan 2014 16:39:27 -0800
From: Kees Cook <keescook@chromium.org>
To: linux-kernel@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>, Ryan Mallon <rmallon@gmail.com>,
        Jiri Kosina <jkosina@suse.cz>, Joe Perches <joe@perches.com>,
        Al Viro <viro@zeniv.linux.org.uk>, Olof Johansson <olof@lixom.net>,
        Stepan Moskovchenko <stepanm@codeaurora.org>,
        Daniel Borkmann <dborkman@redhat.com>
Subject: [PATCH] vsprintf: ignore arguments to %n
Message-ID: <20140128003927.GA27319@www.outflux.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-HELO: www.outflux.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If arguments are consumed without output when encountering %n, it
could be used to benefit or improve information leak attacks that were
exposed via a limited size buffer. Since %n is not used by the kernel,
there is no reason to make an info leak attack any easier.

Signed-off-by: Kees Cook <keescook@chromium.org>
Cc: stable@vger.kernel.org # 3.13+
---
 lib/vsprintf.c |   10 +++-------
 1 file changed, 3 insertions(+), 7 deletions(-)

diff --git a/lib/vsprintf.c b/lib/vsprintf.c
index 185b6d300ebc..9d5c48b705f9 100644
--- a/lib/vsprintf.c
+++ b/lib/vsprintf.c
@@ -1735,14 +1735,10 @@ int vsnprintf(char *buf, size_t size, const char *fmt, va_list args)
 		case FORMAT_TYPE_NRCHARS: {
 			/*
 			 * Since %n poses a greater security risk than
-			 * utility, ignore %n and skip its argument.
+			 * utility, it should not be implemented. Instead,
+			 * when encountering %n, ignore the arguments.
 			 */
-			void *skip_arg;
-
-			WARN_ONCE(1, "Please remove ignored %%n in '%s'\n",
-					old_fmt);
-
-			skip_arg = va_arg(args, void *);
+			WARN_ONCE(1, "Ignored %%n in '%s'\n", old_fmt);
 			break;
 		}
 
-- 
1.7.9.5


-- 
Kees Cook
Chrome OS Security
