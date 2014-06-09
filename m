Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936311AbaFIJ1a (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jun 2014 05:27:30 -0400
Received: from ip4-83-240-18-248.cust.nbox.cz ([83.240.18.248]:59137 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S936309AbaFIJ1T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jun 2014 05:27:19 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        Darren Hart <dvhart@linux.intel.com>,
        Kees Cook <keescook@chromium.org>, Will Drewry <wad@chromium.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 144/146] futex: Validate atomic acquisition in futex_lock_pi_atomic()
Date: Mon,  9 Jun 2014 10:51:19 +0200
Message-Id: <499ec935613f913522aa096f17349a790e6cdac6.1402303821.git.jslaby@suse.cz>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <ebe219e45dcf94c1a34281167427cff4d742faef.1402303820.git.jslaby@suse.cz>
References: <ebe219e45dcf94c1a34281167427cff4d742faef.1402303820.git.jslaby@suse.cz>
In-Reply-To: <cover.1402303820.git.jslaby@suse.cz>
References: <cover.1402303820.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Thomas Gleixner <tglx@linutronix.de>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

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
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 kernel/futex.c | 14 +++++++++++---
 1 file changed, 11 insertions(+), 3 deletions(-)

diff --git a/kernel/futex.c b/kernel/futex.c
index ab207d65c55f..2f48beac4969 100644
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
1.9.3

