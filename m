Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753003AbaFGIU7 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Jun 2014 04:20:59 -0400
Received: from ns.horizon.com ([71.41.210.147]:37458 "HELO ns.horizon.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1752979AbaFGIU5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Jun 2014 04:20:57 -0400
Date: 7 Jun 2014 04:20:56 -0400
Message-ID: <20140607082056.9751.qmail@ns.horizon.com>
From: "George Spelvin" <linux@horizon.com>
To: davem@davemloft.net, dborkman@redhat.com, linux@horizon.com,
        shemminger@osdl.org, tytso@mit.edu
Subject: [PATCH 2/7] lib/random32.c: Remove excess calls to prandom_u32_state in initialization
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <20140607081828.9294.qmail@ns.horizon.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Unrolling code in single-use code paths is just silly.  There are two
instances:

1) prandom_warmup() calls 10 times.
2) prandom_state_selftest() can avoid one call and simplify the
   loop logic by repeating an assignment to a local variable
   (that probably adds zero code anyway)

Signed-off-by: George Spelvin <linux@horizon.com>
---
 lib/random32.c | 21 ++++++++-------------
 1 file changed, 8 insertions(+), 13 deletions(-)

diff --git a/lib/random32.c b/lib/random32.c
index 4da5d281..2e7c15c0 100644
--- a/lib/random32.c
+++ b/lib/random32.c
@@ -134,17 +134,11 @@ EXPORT_SYMBOL(prandom_bytes);
 
 static void prandom_warmup(struct rnd_state *state)
 {
+	int i;
+
 	/* Calling RNG ten times to satify recurrence condition */
-	prandom_u32_state(state);
-	prandom_u32_state(state);
-	prandom_u32_state(state);
-	prandom_u32_state(state);
-	prandom_u32_state(state);
-	prandom_u32_state(state);
-	prandom_u32_state(state);
-	prandom_u32_state(state);
-	prandom_u32_state(state);
-	prandom_u32_state(state);
+	for (i = 0; i < 10; i++)
+		prandom_u32_state(state);
 }
 
 static void prandom_seed_very_weak(struct rnd_state *state, u32 seed)
@@ -433,14 +427,15 @@ static void __init prandom_state_selftest(void)
 
 	for (i = 0; i < ARRAY_SIZE(test2); i++) {
 		struct rnd_state state;
+		u32 result;
 
 		prandom_seed_very_weak(&state, test2[i].seed);
 		prandom_warmup(&state);
 
-		for (j = 0; j < test2[i].iteration - 1; j++)
-			prandom_u32_state(&state);
+		for (j = 0; j < test2[i].iteration; j++)
+			result = prandom_u32_state(&state);
 
-		if (test2[i].result != prandom_u32_state(&state))
+		if (test2[i].result != result)
 			errors++;
 
 		runs++;
-- 
2.0.0

