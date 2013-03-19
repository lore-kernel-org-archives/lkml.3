Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932839Ab3CSQSj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Mar 2013 12:18:39 -0400
Received: from mx1.redhat.com ([209.132.183.28]:45371 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756606Ab3CSQSh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Mar 2013 12:18:37 -0400
From: Jarod Wilson <jarod@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Jarod Wilson <jarod@redhat.com>, Herbert Xu <herbert@gondor.hengli.com.au>,
        Neil Horman <nhorman@tuxdriver.com>,
        "David S. Miller" <davem@davemloft.net>,
        Matt Mackall <mpm@selenic.com>, "Theodore Ts'o" <tytso@mit.edu>,
        linux-crypto@vger.kernel.org, stable@vger.kernel.org
Subject: [PATCH] [char] random: fix priming of last_data
Date: Tue, 19 Mar 2013 12:18:09 -0400
Message-Id: <1363709889-22344-1-git-send-email-jarod@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit ec8f02da9e added priming of last_data per fips requirements.
Unfortuantely, it did so in a way that can lead to multiple threads all
incrementing nbytes, but only one actually doing anything with the extra
data, which leads to some fun  random corruption and panics.

The fix is to simply do everything needed to prime last_data in a single
shot, so there's no window for multiple cpus to increment nbytes -- in
fact, we won't even increment or decrement nbytes anymore, we'll just
extract the needed EXTRACT_BYTES one time per pool and then carry on with
the normal routine.

All these changes have been tested across multiple hosts and architectures
where panics were previously encoutered. The code changes are are strictly
limited to areas only touched when when booted in fips mode.

This change should also go into 3.8-stable, to make the myriads of fips
users on 3.8.x happy.

Tested-by: Jan Stancek <jstancek@redhat.com>
Tested-by: Jan Stodola <jstodola@redhat.com>
CC: Herbert Xu <herbert@gondor.apana.org.au>
CC: Neil Horman <nhorman@tuxdriver.com>
CC: "David S. Miller" <davem@davemloft.net>
CC: Matt Mackall <mpm@selenic.com>
CC: "Theodore Ts'o" <tytso@mit.edu>
CC: linux-crypto@vger.kernel.org
CC: stable@vger.kernel.org
Signed-off-by: Jarod Wilson <jarod@redhat.com>
---
 drivers/char/random.c |   30 +++++++++++++++---------------
 1 files changed, 15 insertions(+), 15 deletions(-)

diff --git a/drivers/char/random.c b/drivers/char/random.c
index 85e81ec..15e5a2b 100644
--- a/drivers/char/random.c
+++ b/drivers/char/random.c
@@ -953,10 +953,23 @@ static ssize_t extract_entropy(struct entropy_store *r, void *buf,
 {
 	ssize_t ret = 0, i;
 	__u8 tmp[EXTRACT_SIZE];
+	unsigned long flags;
 
 	/* if last_data isn't primed, we need EXTRACT_SIZE extra bytes */
-	if (fips_enabled && !r->last_data_init)
-		nbytes += EXTRACT_SIZE;
+	if (fips_enabled) {
+		spin_lock_irqsave(&r->lock, flags);
+		if (!r->last_data_init) {
+			r->last_data_init = true;
+			spin_unlock_irqrestore(&r->lock, flags);
+			trace_extract_entropy(r->name, EXTRACT_SIZE,
+					      r->entropy_count, _RET_IP_);
+			xfer_secondary_pool(r, EXTRACT_SIZE);
+			extract_buf(r, tmp);
+			spin_lock_irqsave(&r->lock, flags);
+			memcpy(r->last_data, tmp, EXTRACT_SIZE);
+		}
+		spin_unlock_irqrestore(&r->lock, flags);
+	}
 
 	trace_extract_entropy(r->name, nbytes, r->entropy_count, _RET_IP_);
 	xfer_secondary_pool(r, nbytes);
@@ -966,19 +979,6 @@ static ssize_t extract_entropy(struct entropy_store *r, void *buf,
 		extract_buf(r, tmp);
 
 		if (fips_enabled) {
-			unsigned long flags;
-
-
-			/* prime last_data value if need be, per fips 140-2 */
-			if (!r->last_data_init) {
-				spin_lock_irqsave(&r->lock, flags);
-				memcpy(r->last_data, tmp, EXTRACT_SIZE);
-				r->last_data_init = true;
-				nbytes -= EXTRACT_SIZE;
-				spin_unlock_irqrestore(&r->lock, flags);
-				extract_buf(r, tmp);
-			}
-
 			spin_lock_irqsave(&r->lock, flags);
 			if (!memcmp(tmp, r->last_data, EXTRACT_SIZE))
 				panic("Hardware RNG duplicated output!\n");
-- 
1.7.1

