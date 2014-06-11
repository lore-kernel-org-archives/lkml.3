Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755541AbaFKDa3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jun 2014 23:30:29 -0400
Received: from imap.thunk.org ([74.207.234.97]:60942 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755397AbaFKDaZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jun 2014 23:30:25 -0400
From: "Theodore Ts'o" <tytso@mit.edu>
To: linux-kernel@vger.kernel.org
Cc: "Theodore Ts'o" <tytso@mit.edu>, George Spelvin <linux@horizon.com>
Subject: [PATCH 3/3] random: only update the last_pulled time if we actually transferred entropy
Date: Tue, 10 Jun 2014 23:30:20 -0400
Message-Id: <1402457420-2527-4-git-send-email-tytso@mit.edu>
X-Mailer: git-send-email 2.0.0
In-Reply-To: <1402457420-2527-1-git-send-email-tytso@mit.edu>
References: <1402457420-2527-1-git-send-email-tytso@mit.edu>
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on imap.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In xfer_secondary_pull(), check to make sure we need to pull from the
secondary pool before checking and potentially updating the
last_pulled time.

Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Cc: George Spelvin <linux@horizon.com>
---
 drivers/char/random.c | 11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)

diff --git a/drivers/char/random.c b/drivers/char/random.c
index 97f390b..4bb6e37 100644
--- a/drivers/char/random.c
+++ b/drivers/char/random.c
@@ -919,6 +919,11 @@ static ssize_t extract_entropy(struct entropy_store *r, void *buf,
 static void _xfer_secondary_pool(struct entropy_store *r, size_t nbytes);
 static void xfer_secondary_pool(struct entropy_store *r, size_t nbytes)
 {
+	if (!r->pull ||
+	    r->entropy_count >= (nbytes << (ENTROPY_SHIFT + 3)) ||
+	    r->entropy_count > r->poolinfo->poolfracbits)
+		return;
+
 	if (r->limit == 0 && random_min_urandom_seed) {
 		unsigned long now = jiffies;
 
@@ -927,10 +932,8 @@ static void xfer_secondary_pool(struct entropy_store *r, size_t nbytes)
 			return;
 		r->last_pulled = now;
 	}
-	if (r->pull &&
-	    r->entropy_count < (nbytes << (ENTROPY_SHIFT + 3)) &&
-	    r->entropy_count < r->poolinfo->poolfracbits)
-		_xfer_secondary_pool(r, nbytes);
+
+	_xfer_secondary_pool(r, nbytes);
 }
 
 static void _xfer_secondary_pool(struct entropy_store *r, size_t nbytes)
-- 
2.0.0

