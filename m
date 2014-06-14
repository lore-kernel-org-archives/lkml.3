Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754097AbaFNUoZ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Jun 2014 16:44:25 -0400
Received: from 1wt.eu ([62.212.114.60]:42888 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751922AbaFNUoW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Jun 2014 16:44:22 -0400
Message-Id: <20140614191250.335238209@1wt.eu>
User-Agent: quilt/0.48-1
Date: Sat, 14 Jun 2014 21:12:55 +0200
From: Willy Tarreau <w@1wt.eu>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Darren Hart <dvhart@linux.intel.com>, Kees Cook <keescook@chromium.org>,
        Will Drewry <wad@chromium.org>, Thomas Gleixner <tglx@linutronix.de>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Willy Tarreau <w@1wt.eu>
Subject: [ 5/9] futex: Validate atomic acquisition in
In-Reply-To: <57d1129d02f4fc14423dd66474950cb7@local>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-longterm review patch.  If anyone has any objections, please let me know.

------------------
 futex_lock_pi_atomic()

From: Thomas Gleixner <tglx@linutronix.de>

We need to protect the atomic acquisition in the kernel against rogue
user space which sets the user space futex to 0, so the kernel side
acquisition succeeds while there is existing state in the kernel
associated to the real owner.

Verify whether the futex has waiters associated with kernel state.  If
it has, return -EINVAL.  The state is corrupted already, so no point in
cleaning it up.  Subsequent calls will fail as well.  Not our problem.

[ tglx: Use futex_top_waiter() and explain why we do not need to try
  	restoring the already corrupted user space state. ]

Signed-off-by: Darren Hart <dvhart@linux.intel.com>
Cc: Kees Cook <keescook@chromium.org>
Cc: Will Drewry <wad@chromium.org>
Cc: stable@vger.kernel.org
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
(cherry picked from commit b3eaa9fc5cd0a4d74b18f6b8dc617aeaf1873270)
Signed-off-by: Willy Tarreau <w@1wt.eu>
---
 kernel/futex.c | 14 +++++++++++---
 1 file changed, 11 insertions(+), 3 deletions(-)

diff --git a/kernel/futex.c b/kernel/futex.c
index c894eab..f77a945 100644
--- a/kernel/futex.c
+++ b/kernel/futex.c
@@ -708,10 +708,18 @@ retry:
 		return -EDEADLK;
 
 	/*
-	 * Surprise - we got the lock. Just return to userspace:
+	 * Surprise - we got the lock, but we do not trust user space at all.
 	 */
-	if (unlikely(!curval))
-		return 1;
+	if (unlikely(!curval)) {
+		/*
+		 * We verify whether there is kernel state for this
+		 * futex. If not, we can safely assume, that the 0 ->
+		 * TID transition is correct. If state exists, we do
+		 * not bother to fixup the user space state as it was
+		 * corrupted already.
+		 */
+		return futex_top_waiter(hb, key) ? -EINVAL : 1;
+	}
 
 	uval = curval;
 
-- 
1.7.12.2.21.g234cd45.dirty



