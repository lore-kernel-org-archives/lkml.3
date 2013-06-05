Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933422Ab3FEWDr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Jun 2013 18:03:47 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:37708 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932491Ab3FEVfT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Jun 2013 17:35:19 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Jarod Wilson <jarod@redhat.com>, Jan Stancek <jstancek@redhat.com>,
        Jan Stodola <jstodola@redhat.com>,
        Herbert Xu <herbert@gondor.hengli.com.au>,
        Neil Horman <nhorman@tuxdriver.com>,
        "David S. Miller" <davem@davemloft.net>,
        Matt Mackall <mpm@selenic.com>, "Theodore Tso" <tytso@mit.edu>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [ 034/127] drivers/char/random.c: fix priming of last_data
Date: Wed,  5 Jun 2013 14:33:21 -0700
Message-Id: <20130605213221.842817427@linuxfoundation.org>
X-Mailer: git-send-email 1.8.3.rc0.20.gb99dd2e
In-Reply-To: <20130605213217.966891866@linuxfoundation.org>
References: <20130605213217.966891866@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.9-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/char/random.c |   30 +++++++++++++++---------------
 1 file changed, 15 insertions(+), 15 deletions(-)

--- a/drivers/char/random.c
+++ b/drivers/char/random.c
@@ -957,10 +957,23 @@ static ssize_t extract_entropy(struct en
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
@@ -970,19 +983,6 @@ static ssize_t extract_entropy(struct en
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


