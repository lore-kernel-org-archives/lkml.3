Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762215AbaGRWH3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jul 2014 18:07:29 -0400
Received: from imap.thunk.org ([74.207.234.97]:44387 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754379AbaGRWH2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jul 2014 18:07:28 -0400
From: "Theodore Ts'o" <tytso@mit.edu>
To: linux-kernel@vger.kernel.org
Cc: hannes@stressinduktion.org, davej@redhat.com, price@mit.edu,
        Greg Price <price@mit.edu>, "Theodore Ts'o" <tytso@mit.edu>
Subject: [PATCH] random: check for increase of entropy_count because of signed conversion
Date: Fri, 18 Jul 2014 18:07:19 -0400
Message-Id: <1405721239-2630-1-git-send-email-tytso@mit.edu>
X-Mailer: git-send-email 2.0.0
In-Reply-To: <20140718215054.GD18775@thunk.org>
References: <20140718215054.GD18775@thunk.org>
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on imap.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Hannes Frederic Sowa <hannes@stressinduktion.org>

The expression entropy_count -= ibytes << (ENTROPY_SHIFT + 3) could
actually increase entropy_count if during assignment of the unsigned
expression on the RHS (mind the -=) we reduce the value modulo
2^width(int) and assign it to entropy_count. Trinity found this.

[ Commit modified by tytso to add an additional safety check for a
  negative entropy_count -- which should never happen, and to also add
  an additional paranoia check to prevent overly large count values to
  be passed into urandom_read().  ]

Reported-by: Dave Jones <davej@redhat.com>
Cc: Greg Price <price@mit.edu>
Signed-off-by: Hannes Frederic Sowa <hannes@stressinduktion.org>
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
---
 drivers/char/random.c | 17 ++++++++++++++---
 1 file changed, 14 insertions(+), 3 deletions(-)

diff --git a/drivers/char/random.c b/drivers/char/random.c
index 0a7ac0a..003f744 100644
--- a/drivers/char/random.c
+++ b/drivers/char/random.c
@@ -641,7 +641,7 @@ retry:
 		} while (unlikely(entropy_count < pool_size-2 && pnfrac));
 	}
 
-	if (entropy_count < 0) {
+	if (unlikely(entropy_count < 0)) {
 		pr_warn("random: negative entropy/overflow: pool %s count %d\n",
 			r->name, entropy_count);
 		WARN_ON(1);
@@ -981,7 +981,7 @@ static size_t account(struct entropy_store *r, size_t nbytes, int min,
 		      int reserved)
 {
 	int entropy_count, orig;
-	size_t ibytes;
+	size_t ibytes, nfrac;
 
 	BUG_ON(r->entropy_count > r->poolinfo->poolfracbits);
 
@@ -999,7 +999,17 @@ retry:
 	}
 	if (ibytes < min)
 		ibytes = 0;
-	if ((entropy_count -= ibytes << (ENTROPY_SHIFT + 3)) < 0)
+
+	nfrac = ibytes << (ENTROPY_SHIFT + 3);
+	if (entropy_count < 0) {
+		pr_warn("random: negative entropy count: pool %s count %d\n",
+			r->name, entropy_count);
+		WARN_ON(1);
+		entropy_count = 0;
+	}
+	if ((unsigned) entropy_count > nfrac)
+		entropy_count -= nfrac;
+	else
 		entropy_count = 0;
 
 	if (cmpxchg(&r->entropy_count, orig, entropy_count) != orig)
@@ -1376,6 +1386,7 @@ urandom_read(struct file *file, char __user *buf, size_t nbytes, loff_t *ppos)
 			    "with %d bits of entropy available\n",
 			    current->comm, nonblocking_pool.entropy_total);
 
+	nbytes = min_t(size_t, nbytes, INT_MAX >> ENTROPY_SHIFT);
 	ret = extract_entropy_user(&nonblocking_pool, buf, nbytes);
 
 	trace_urandom_read(8 * nbytes, ENTROPY_BITS(&nonblocking_pool),
-- 
2.0.0

