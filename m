Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753844AbaFGBr0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jun 2014 21:47:26 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:35923 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752465AbaFGBXg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jun 2014 21:23:36 -0400
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org, "Will Drewry" <wad@chromium.org>,
        "Thomas Gleixner" <tglx@linutronix.de>,
        "Darren Hart" <dvhart@linux.intel.com>,
        "Kees Cook" <keescook@chromium.org>,
        "Linus Torvalds" <torvalds@linux-foundation.org>
Date: Sat, 07 Jun 2014 02:26:29 +0100
Message-ID: <lsq.1402104389.102830035@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [PATCH 3.2 90/92] futex: Validate atomic acquisition in
 futex_lock_pi_atomic()
In-Reply-To: <lsq.1402104388.385007124@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.249
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.60-rc1 review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 kernel/futex.c | 14 +++++++++++---
 1 file changed, 11 insertions(+), 3 deletions(-)

--- a/kernel/futex.c
+++ b/kernel/futex.c
@@ -758,10 +758,18 @@ retry:
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
 

