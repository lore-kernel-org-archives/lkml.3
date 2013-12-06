Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758936Ab3LFVw1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Dec 2013 16:52:27 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:60421 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758879Ab3LFVwY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Dec 2013 16:52:24 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Stephen Hemminger <stephen@networkplumber.org>,
        Florian Weimer <fweimer@redhat.com>, Theodore Tso <tytso@mit.edu>,
        Daniel Borkmann <dborkman@redhat.com>,
        Hannes Frederic Sowa <hannes@stressinduktion.org>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 3.12 10/83] random32: fix off-by-one in seeding requirement
Date: Fri,  6 Dec 2013 13:51:00 -0800
Message-Id: <20131206214641.031129909@linuxfoundation.org>
X-Mailer: git-send-email 1.8.5.1.67.gb00d244
In-Reply-To: <20131206214640.002320724@linuxfoundation.org>
References: <20131206214640.002320724@linuxfoundation.org>
User-Agent: quilt/0.60-8.1.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.12-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/linux/random.h |    6 +++---
 lib/random32.c         |   14 +++++++-------
 2 files changed, 10 insertions(+), 10 deletions(-)

--- a/include/linux/random.h
+++ b/include/linux/random.h
@@ -50,9 +50,9 @@ static inline void prandom_seed_state(st
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


