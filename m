Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753789AbaCZRMy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Mar 2014 13:12:54 -0400
Received: from aserp1040.oracle.com ([141.146.126.69]:28922 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750792AbaCZRMx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Mar 2014 13:12:53 -0400
From: Sasha Levin <sasha.levin@oracle.com>
To: davem@davemloft.net
Cc: hannes@stressinduktion.org, dborkman@redhat.com, tytso@mit.edu,
        linux-kernel@vger.kernel.org, eric.dumazet@gmail.com,
        Sasha Levin <sasha.levin@oracle.com>
Subject: [PATCH] random32: avoid attempt to late reseed if in the middle of seeding
Date: Wed, 26 Mar 2014 13:12:38 -0400
Message-Id: <1395853958-5083-1-git-send-email-sasha.levin@oracle.com>
X-Mailer: git-send-email 1.8.3.2
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit 4af712e8df ("random32: add prandom_reseed_late() and call when
nonblocking pool becomes initialized") has added a late reseed stage
that happens as soon as the nonblocking pool is marked as initialized.

This fails in the case that the nonblocking pool gets initialized
during __prandom_reseed()'s call to get_random_bytes(). In that case
we'd double back into __prandom_reseed() in an attempt to do a late
reseed - deadlocking on 'lock' early on in the boot process.

Instead, just avoid even waiting to do a reseed if a reseed is already
occuring.

Signed-off-by: Sasha Levin <sasha.levin@oracle.com>
---
 lib/random32.c | 16 +++++++++++++++-
 1 file changed, 15 insertions(+), 1 deletion(-)

diff --git a/lib/random32.c b/lib/random32.c
index 1e5b2df..b59da12 100644
--- a/lib/random32.c
+++ b/lib/random32.c
@@ -241,14 +241,27 @@ static void __prandom_reseed(bool late)
 {
 	int i;
 	unsigned long flags;
-	static bool latch = false;
+	static bool latch = false, reseeding = false;
 	static DEFINE_SPINLOCK(lock);
 
+	/*
+	 * Asking for random bytes might result in bytes getting
+	 * moved into the nonblocking pool and thus marking it
+	 * as initialized. In this case we would double back into
+	 * this function and attempt to do a late reseed.
+	 * Ignore the pointless attempt to reseed again if we're
+	 * already waiting for bytes when the nonblocking pool
+	 * got initialized
+	 */
+	if (reseeding)
+		return;
+
 	/* only allow initial seeding (late == false) once */
 	spin_lock_irqsave(&lock, flags);
 	if (latch && !late)
 		goto out;
 	latch = true;
+	reseeding = true;
 
 	for_each_possible_cpu(i) {
 		struct rnd_state *state = &per_cpu(net_rand_state,i);
@@ -263,6 +276,7 @@ static void __prandom_reseed(bool late)
 		prandom_warmup(state);
 	}
 out:
+	reseeding = false;
 	spin_unlock_irqrestore(&lock, flags);
 }
 
-- 
1.8.3.2

