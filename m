Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753056AbaFGI3B (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Jun 2014 04:29:01 -0400
Received: from ns.horizon.com ([71.41.210.147]:35595 "HELO ns.horizon.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1752839AbaFGI3A (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Jun 2014 04:29:00 -0400
Date: 7 Jun 2014 04:28:59 -0400
Message-ID: <20140607082859.10162.qmail@ns.horizon.com>
From: "George Spelvin" <linux@horizon.com>
To: davem@davemloft.net, dborkman@redhat.com, linux@horizon.com,
        shemminger@osdl.org, tytso@mit.edu
Subject: [PATCH 6/7] lib/random32.c: Randomize timeout to the millisecond, not the second
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <20140607081828.9294.qmail@ns.horizon.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If you're going to bother randomizing it, do it right.
And use prandom_u32_max(), which is designed for the job, rather
than "% 40".

Signed-off-by: George Spelvin <linux@horizon.com>
---
 lib/random32.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/lib/random32.c b/lib/random32.c
index eee60100..9cc410dd 100644
--- a/lib/random32.c
+++ b/lib/random32.c
@@ -208,14 +208,14 @@ static DEFINE_TIMER(seed_timer, __prandom_timer, 0, 0);
 static void __prandom_timer(unsigned long dontcare)
 {
 	u32 entropy;
-	unsigned long expires;
+	unsigned int expires;
 
 	get_random_bytes(&entropy, sizeof(entropy));
 	prandom_seed(entropy);
 
 	/* reseed every ~60 seconds, in [40 .. 80) interval with slack */
-	expires = 40 + (prandom_u32() % 40);
-	seed_timer.expires = jiffies + msecs_to_jiffies(expires * MSEC_PER_SEC);
+	expires = 40000 + prandom_u32_max(40000);
+	seed_timer.expires = jiffies + msecs_to_jiffies(expires);
 
 	add_timer(&seed_timer);
 }
-- 
2.0.0

