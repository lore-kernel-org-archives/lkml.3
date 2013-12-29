Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755589Ab3L2C0w (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Dec 2013 21:26:52 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:55285 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752358Ab3L2CLB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Dec 2013 21:11:01 -0500
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org,
        "Hannes Frederic Sowa" <hannes@stressinduktion.org>,
        "Theodore Ts'o" <tytso@mit.edu>,
        "Daniel Borkmann" <dborkman@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        "Florian Weimer" <fweimer@redhat.com>,
        "Stephen Hemminger" <stephen@networkplumber.org>
Date: Sun, 29 Dec 2013 03:08:44 +0100
Message-ID: <lsq.1388282924.990856915@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [PATCH 3.2 151/185] random32: fix off-by-one in seeding requirement
In-Reply-To: <lsq.1388282923.751256928@decadent.org.uk>
X-SA-Exim-Connect-IP: 31.18.200.85
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.54-rc1 review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 include/linux/random.h |  6 +++---
 lib/random32.c         | 14 +++++++-------
 2 files changed, 10 insertions(+), 10 deletions(-)

diff --git a/include/linux/random.h b/include/linux/random.h
index 7e77cee..f5e1311 100644
--- a/include/linux/random.h
+++ b/include/linux/random.h
@@ -89,9 +89,9 @@ static inline void prandom32_seed(struct rnd_state *state, u64 seed)
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
index fc3545a..1f44bdc 100644
--- a/lib/random32.c
+++ b/lib/random32.c
@@ -92,7 +92,7 @@ void srandom32(u32 entropy)
 	 */
 	for_each_possible_cpu (i) {
 		struct rnd_state *state = &per_cpu(net_rand_state, i);
-		state->s1 = __seed(state->s1 ^ entropy, 1);
+		state->s1 = __seed(state->s1 ^ entropy, 2);
 	}
 }
 EXPORT_SYMBOL(srandom32);
@@ -109,9 +109,9 @@ static int __init random32_init(void)
 		struct rnd_state *state = &per_cpu(net_rand_state,i);
 
 #define LCG(x)	((x) * 69069)	/* super-duper LCG */
-		state->s1 = __seed(LCG(i + jiffies), 1);
-		state->s2 = __seed(LCG(state->s1), 7);
-		state->s3 = __seed(LCG(state->s2), 15);
+		state->s1 = __seed(LCG(i + jiffies), 2);
+		state->s2 = __seed(LCG(state->s1), 8);
+		state->s3 = __seed(LCG(state->s2), 16);
 
 		/* "warm it up" */
 		prandom32(state);
@@ -138,9 +138,9 @@ static int __init random32_reseed(void)
 		u32 seeds[3];
 
 		get_random_bytes(&seeds, sizeof(seeds));
-		state->s1 = __seed(seeds[0], 1);
-		state->s2 = __seed(seeds[1], 7);
-		state->s3 = __seed(seeds[2], 15);
+		state->s1 = __seed(seeds[0], 2);
+		state->s2 = __seed(seeds[1], 8);
+		state->s3 = __seed(seeds[2], 16);
 
 		/* mix it in */
 		prandom32(state);

