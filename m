Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755397Ab3JYBFz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Oct 2013 21:05:55 -0400
Received: from smtp.outflux.net ([198.145.64.163]:46122 "EHLO smtp.outflux.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755314Ab3JYBFx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Oct 2013 21:05:53 -0400
Date: Thu, 24 Oct 2013 18:05:42 -0700
From: Kees Cook <keescook@chromium.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH] lkdtm: isolate stack corruption test
Message-ID: <20131025010542.GA10689@www.outflux.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-HELO: www.outflux.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When tests were added to lkdtm that grew the stack frame, the stack
corruption test stopped working. This isolates the test in its own
function, and forces it not to be inlined.

Signed-off-by: Kees Cook <keescook@chromium.org>
Fixes: cc33c537c12f ("lkdtm: add "EXEC_*" triggers")
---
This bug was introduced in 3.12, so it'd be nice to get it fixed there too.
But if misses it, I'm likely the only person to notice. And in that case,
it should go into stable for 3.12.
---
 drivers/misc/lkdtm.c |   16 ++++++++++------
 1 file changed, 10 insertions(+), 6 deletions(-)

diff --git a/drivers/misc/lkdtm.c b/drivers/misc/lkdtm.c
index 2fc0586ce3bb..9cbd0370ca44 100644
--- a/drivers/misc/lkdtm.c
+++ b/drivers/misc/lkdtm.c
@@ -297,6 +297,14 @@ static void do_nothing(void)
 	return;
 }
 
+static noinline void corrupt_stack(void)
+{
+	/* Use default char array length that triggers stack protection. */
+	char data[8];
+
+	memset((void *)data, 0, 64);
+}
+
 static void execute_location(void *dst)
 {
 	void (*func)(void) = dst;
@@ -327,13 +335,9 @@ static void lkdtm_do_action(enum ctype which)
 	case CT_OVERFLOW:
 		(void) recursive_loop(0);
 		break;
-	case CT_CORRUPT_STACK: {
-		/* Make sure the compiler creates and uses an 8 char array. */
-		volatile char data[8];
-
-		memset((void *)data, 0, 64);
+	case CT_CORRUPT_STACK:
+		corrupt_stack();
 		break;
-	}
 	case CT_UNALIGNED_LOAD_STORE_WRITE: {
 		static u8 data[5] __attribute__((aligned(4))) = {1, 2,
 				3, 4, 5};
-- 
1.7.9.5


-- 
Kees Cook
Chrome OS Security
