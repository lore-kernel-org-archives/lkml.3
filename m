Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966323AbaFQVtF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jun 2014 17:49:05 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:54109 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966283AbaFQVtA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jun 2014 17:49:00 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Darren Hart <dvhart@linux.intel.com>, Kees Cook <keescook@chromium.org>,
        Will Drewry <wad@chromium.org>, Thomas Gleixner <tglx@linutronix.de>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.13 207/212] futex: Validate atomic acquisition in futex_lock_pi_atomic()
Date: Tue, 17 Jun 2014 14:45:01 -0700
Message-Id: <1403041506-13646-208-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1403041506-13646-1-git-send-email-kamal@canonical.com>
References: <1403041506-13646-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.13
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13.11.4 -stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 kernel/futex.c | 14 +++++++++++---
 1 file changed, 11 insertions(+), 3 deletions(-)

diff --git a/kernel/futex.c b/kernel/futex.c
index c861191..9c6b0e1 100644
--- a/kernel/futex.c
+++ b/kernel/futex.c
@@ -764,10 +764,18 @@ retry:
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

