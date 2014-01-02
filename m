Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754265AbaABR26 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Jan 2014 12:28:58 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:40202 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752274AbaABRFb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Jan 2014 12:05:31 -0500
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Stephen Hemminger <stephen@networkplumber.org>,
        Florian Weimer <fweimer@redhat.com>, "Theodore Ts'o" <tytso@mit.edu>,
        Daniel Borkmann <dborkman@redhat.com>,
        Hannes Frederic Sowa <hannes@stressinduktion.org>,
        "David S. Miller" <davem@davemloft.net>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.8 05/91] random32: fix off-by-one in seeding requirement
Date: Thu,  2 Jan 2014 09:03:40 -0800
Message-Id: <1388682306-30859-6-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1388682306-30859-1-git-send-email-kamal@canonical.com>
References: <1388682306-30859-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.15 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Daniel Borkmann <dborkman@redhat.com>

[ Upstream commit 51c37a70aaa3f95773af560e6db3073520513912 ]

For properly initialising the Tausworthe generator [1], we have
a strict seeding requirement, that is, s1 > 1, s2 > 7, s3 > 15.

Commit 697f8d0348 ("random32: seeding improvement") introduced
a __seed() function that imposes boundary checks proposed by the
errata paper [2] to properly ensure above conditions.

However, we're off by one, as the function is implemented as:
"return (x < m) ? x + m : x;", and called with __seed(X, 1),
__seed(X, 7), __seed(X, 15). Thus, an unwanted seed of 1, 7, 15
would be possible, whereas the lower boundary should actually
be of at least 2, 8, 16, just as GSL does. Fix this, as otherwise
an initialization with an unwanted seed could have the effect
that Tausworthe's PRNG properties cannot not be ensured.

Note that this PRNG is *not* used for cryptography in the kernel.

 [1] http://www.iro.umontreal.ca/~lecuyer/myftp/papers/tausme.ps
 [2] http://www.iro.umontreal.ca/~lecuyer/myftp/papers/tausme2.ps

Joint work with Hannes Frederic Sowa.

Fixes: 697f8d0348a6 ("random32: seeding improvement")
Cc: Stephen Hemminger <stephen@networkplumber.org>
Cc: Florian Weimer <fweimer@redhat.com>
Cc: Theodore Ts'o <tytso@mit.edu>
Signed-off-by: Daniel Borkmann <dborkman@redhat.com>
Signed-off-by: Hannes Frederic Sowa <hannes@stressinduktion.org>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 include/linux/random.h |  6 +++---
 lib/random32.c         | 14 +++++++-------
 2 files changed, 10 insertions(+), 10 deletions(-)

diff --git a/include/linux/random.h b/include/linux/random.h
index 6069225..d024cc6 100644
--- a/include/linux/random.h
+++ b/include/linux/random.h
@@ -57,9 +57,9 @@ static inline void prandom_seed_state(struct rnd_state *state, u64 seed)
 {
 	u32 i = (seed >> 32) ^ (seed << 10) ^ seed;
 
-	state->s1 = __seed(i, 1);
-	state->s2 = __seed(i, 7);
-	state->s3 = __seed(i, 15);
+	state->s1 = __seed(i, 2);
+	state->s2 = __seed(i, 8);
+	state->s3 = __seed(i, 16);
 }
 
 #ifdef CONFIG_ARCH_RANDOM
diff --git a/lib/random32.c b/lib/random32.c
index 52280d5..01e8890 100644
--- a/lib/random32.c
+++ b/lib/random32.c
@@ -141,7 +141,7 @@ void prandom_seed(u32 entropy)
 	 */
 	for_each_possible_cpu (i) {
 		struct rnd_state *state = &per_cpu(net_rand_state, i);
-		state->s1 = __seed(state->s1 ^ entropy, 1);
+		state->s1 = __seed(state->s1 ^ entropy, 2);
 	}
 }
 EXPORT_SYMBOL(prandom_seed);
@@ -158,9 +158,9 @@ static int __init prandom_init(void)
 		struct rnd_state *state = &per_cpu(net_rand_state,i);
 
 #define LCG(x)	((x) * 69069)	/* super-duper LCG */
-		state->s1 = __seed(LCG(i + jiffies), 1);
-		state->s2 = __seed(LCG(state->s1), 7);
-		state->s3 = __seed(LCG(state->s2), 15);
+		state->s1 = __seed(LCG(i + jiffies), 2);
+		state->s2 = __seed(LCG(state->s1), 8);
+		state->s3 = __seed(LCG(state->s2), 16);
 
 		/* "warm it up" */
 		prandom_u32_state(state);
@@ -187,9 +187,9 @@ static int __init prandom_reseed(void)
 		u32 seeds[3];
 
 		get_random_bytes(&seeds, sizeof(seeds));
-		state->s1 = __seed(seeds[0], 1);
-		state->s2 = __seed(seeds[1], 7);
-		state->s3 = __seed(seeds[2], 15);
+		state->s1 = __seed(seeds[0], 2);
+		state->s2 = __seed(seeds[1], 8);
+		state->s3 = __seed(seeds[2], 16);
 
 		/* mix it in */
 		prandom_u32_state(state);
-- 
1.8.3.2

