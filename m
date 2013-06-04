Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758566Ab3FDRDM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Jun 2013 13:03:12 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:48567 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758385Ab3FDRDG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Jun 2013 13:03:06 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Jarod Wilson <jarod@redhat.com>, Herbert Xu <herbert@gondor.hengli.com.au>,
        "David S. Miller" <davem@davemloft.net>,
        Matt Mackall <mpm@selenic.com>, "Theodore Ts'o" <tytso@mit.edu>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 56/75] drivers/char/random.c: fix priming of last_data
Date: Tue,  4 Jun 2013 09:55:40 -0700
Message-Id: <1370364959-9475-57-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1370364959-9475-1-git-send-email-kamal@canonical.com>
References: <1370364959-9475-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.2 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jarod Wilson <jarod@redhat.com>

commit 1e7e2e05c179a68aaf8830fe91547a87f4589e53 upstream.

Commit ec8f02da9ea5 ("random: prime last_data value per fips
requirements") added priming of last_data per fips requirements.

Unfortuantely, it did so in a way that can lead to multiple threads all
incrementing nbytes, but only one actually doing anything with the extra
data, which leads to some fun random corruption and panics.

The fix is to simply do everything needed to prime last_data in a single
shot, so there's no window for multiple cpus to increment nbytes -- in
fact, we won't even increment or decrement nbytes anymore, we'll just
extract the needed EXTRACT_SIZE one time per pool and then carry on with
the normal routine.

All these changes have been tested across multiple hosts and
architectures where panics were previously encoutered.  The code changes
are are strictly limited to areas only touched when when booted in fips
mode.

This change should also go into 3.8-stable, to make the myriads of fips
users on 3.8.x happy.

Signed-off-by: Jarod Wilson <jarod@redhat.com>
Tested-by: Jan Stancek <jstancek@redhat.com>
Tested-by: Jan Stodola <jstodola@redhat.com>
Cc: Herbert Xu <herbert@gondor.apana.org.au>
Acked-by: Neil Horman <nhorman@tuxdriver.com>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Matt Mackall <mpm@selenic.com>
Cc: "Theodore Ts'o" <tytso@mit.edu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/char/random.c | 30 +++++++++++++++---------------
 1 file changed, 15 insertions(+), 15 deletions(-)

diff --git a/drivers/char/random.c b/drivers/char/random.c
index 57d4b15..ae872f8 100644
--- a/drivers/char/random.c
+++ b/drivers/char/random.c
@@ -957,10 +957,23 @@ static ssize_t extract_entropy(struct entropy_store *r, void *buf,
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
@@ -970,19 +983,6 @@ static ssize_t extract_entropy(struct entropy_store *r, void *buf,
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
1.8.1.2

