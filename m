Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752458AbaDAEPB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Apr 2014 00:15:01 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:53888 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751095AbaDAEPA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Apr 2014 00:15:00 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Sasha Levin <sasha.levin@oracle.com>,
        Hannes Frederic Sowa <hannes@stressinduktion.org>,
        Daniel Borkmann <dborkman@redhat.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 3.13 15/22] random32: avoid attempt to late reseed if in the middle of seeding
Date: Mon, 31 Mar 2014 21:08:45 -0700
Message-Id: <20140401040706.799542067@linuxfoundation.org>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <20140401040703.045139933@linuxfoundation.org>
References: <20140401040703.045139933@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sasha Levin <sasha.levin@oracle.com>

commit 05efa8c943b1d5d90fa8c8147571837573338bb6 upstream.

Commit 4af712e8df ("random32: add prandom_reseed_late() and call when
nonblocking pool becomes initialized") has added a late reseed stage
that happens as soon as the nonblocking pool is marked as initialized.

This fails in the case that the nonblocking pool gets initialized
during __prandom_reseed()'s call to get_random_bytes(). In that case
we'd double back into __prandom_reseed() in an attempt to do a late
reseed - deadlocking on 'lock' early on in the boot process.

Instead, just avoid even waiting to do a reseed if a reseed is already
occuring.

Fixes: 4af712e8df99 ("random32: add prandom_reseed_late() and call when nonblocking pool becomes initialized")
Signed-off-by: Sasha Levin <sasha.levin@oracle.com>
Acked-by: Hannes Frederic Sowa <hannes@stressinduktion.org>
Signed-off-by: Daniel Borkmann <dborkman@redhat.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 lib/random32.c |   13 ++++++++++++-
 1 file changed, 12 insertions(+), 1 deletion(-)

--- a/lib/random32.c
+++ b/lib/random32.c
@@ -244,8 +244,19 @@ static void __prandom_reseed(bool late)
 	static bool latch = false;
 	static DEFINE_SPINLOCK(lock);
 
+	/* Asking for random bytes might result in bytes getting
+	 * moved into the nonblocking pool and thus marking it
+	 * as initialized. In this case we would double back into
+	 * this function and attempt to do a late reseed.
+	 * Ignore the pointless attempt to reseed again if we're
+	 * already waiting for bytes when the nonblocking pool
+	 * got initialized.
+	 */
+
 	/* only allow initial seeding (late == false) once */
-	spin_lock_irqsave(&lock, flags);
+	if (!spin_trylock_irqsave(&lock, flags))
+		return;
+
 	if (latch && !late)
 		goto out;
 	latch = true;


