Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754503AbaBLWnJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Feb 2014 17:43:09 -0500
Received: from mx1.redhat.com ([209.132.183.28]:42610 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753284AbaBLWnH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Feb 2014 17:43:07 -0500
From: Daniel Borkmann <dborkman@redhat.com>
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH akpm-next] random32: minor cleanups and kdoc fix
Date: Wed, 12 Feb 2014 23:43:02 +0100
Message-Id: <1392244982-20450-1-git-send-email-dborkman@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

These are just some very minor and misc cleanups in the PRNG.
In prandom_u32() we store the result in an unsigned long which
is unnecessary as it should be u32 instead that we get from
prandom_u32_state(). prandom_bytes_state()'s comment is in
kdoc format, so change it into such as it's done everywhere
else. random_get_entropy() results mostly into get_cycles()
which returns unsigned long whereas seed is given in u32. Last
but not least for readability, add some newlines.

Signed-off-by: Daniel Borkmann <dborkman@redhat.com>
---
 lib/random32.c | 15 +++++++++------
 1 file changed, 9 insertions(+), 6 deletions(-)

diff --git a/lib/random32.c b/lib/random32.c
index 1e5b2df..82e22a3 100644
--- a/lib/random32.c
+++ b/lib/random32.c
@@ -30,7 +30,6 @@
 
    This affects the seeding procedure by imposing the requirement
    s1 > 1, s2 > 7, s3 > 15, s4 > 127.
-
 */
 
 #include <linux/types.h>
@@ -75,15 +74,17 @@ EXPORT_SYMBOL(prandom_u32_state);
  */
 u32 prandom_u32(void)
 {
-	unsigned long r;
 	struct rnd_state *state = &get_cpu_var(net_rand_state);
-	r = prandom_u32_state(state);
+	u32 res;
+
+	res = prandom_u32_state(state);
 	put_cpu_var(state);
-	return r;
+
+	return res;
 }
 EXPORT_SYMBOL(prandom_u32);
 
-/*
+/**
  *	prandom_bytes_state - get the requested number of pseudo-random bytes
  *
  *	@state: pointer to state structure holding seeded state.
@@ -201,9 +202,10 @@ static int __init prandom_init(void)
 	for_each_possible_cpu(i) {
 		struct rnd_state *state = &per_cpu(net_rand_state,i);
 
-		prandom_seed_very_weak(state, (i + jiffies) ^ random_get_entropy());
+		prandom_seed_very_weak(state, (i + jiffies) ^ (u32)random_get_entropy());
 		prandom_warmup(state);
 	}
+
 	return 0;
 }
 core_initcall(prandom_init);
@@ -248,6 +250,7 @@ static void __prandom_reseed(bool late)
 	spin_lock_irqsave(&lock, flags);
 	if (latch && !late)
 		goto out;
+
 	latch = true;
 
 	for_each_possible_cpu(i) {
-- 
1.7.11.7

