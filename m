Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754837AbaFWNFQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jun 2014 09:05:16 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:37183 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754812AbaFWNFN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jun 2014 09:05:13 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Darren Hart <dvhart@linux.intel.com>, Kees Cook <keescook@chromium.org>,
        Will Drewry <wad@chromium.org>, Thomas Gleixner <tglx@linutronix.de>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 69/93] futex: Validate atomic acquisition in futex_lock_pi_atomic()
Date: Mon, 23 Jun 2014 14:02:48 +0100
Message-Id: <1403528592-2163-70-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1403528592-2163-1-git-send-email-luis.henriques@canonical.com>
References: <1403528592-2163-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11.10.12 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Thomas Gleixner <tglx@linutronix.de>

commit b3eaa9fc5cd0a4d74b18f6b8dc617aeaf1873270 upstream.

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
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 kernel/futex.c | 14 +++++++++++---
 1 file changed, 11 insertions(+), 3 deletions(-)

diff --git a/kernel/futex.c b/kernel/futex.c
index 83b44e9c26c3..d467b4972470 100644
--- a/kernel/futex.c
+++ b/kernel/futex.c
@@ -763,10 +763,18 @@ retry:
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
1.9.1

