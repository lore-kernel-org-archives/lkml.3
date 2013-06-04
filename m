Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756572Ab3FDOTt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Jun 2013 10:19:49 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:46801 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755902Ab3FDOIO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Jun 2013 10:08:14 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Jiri Kosina <jkosina@suse.cz>, "Theodore Ts'o" <tytso@mit.edu>,
        Greg KH <greg@kroah.com>, Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 36/70] random: fix accounting race condition with lockless irq entropy_count update
Date: Tue,  4 Jun 2013 15:06:52 +0100
Message-Id: <1370354846-14213-37-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1370354846-14213-1-git-send-email-luis.henriques@canonical.com>
References: <1370354846-14213-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.14 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jiri Kosina <jkosina@suse.cz>

commit 10b3a32d292c21ea5b3ad5ca5975e88bb20b8d68 upstream.

Commit 902c098a3663 ("random: use lockless techniques in the interrupt
path") turned IRQ path from being spinlock protected into lockless
cmpxchg-retry update.

That commit removed r->lock serialization between crediting entropy bits
from IRQ context and accounting when extracting entropy on userspace
read path, but didn't turn the r->entropy_count reads/updates in
account() to use cmpxchg as well.

It has been observed, that under certain circumstances this leads to
read() on /dev/urandom to return 0 (EOF), as r->entropy_count gets
corrupted and becomes negative, which in turn results in propagating 0
all the way from account() to the actual read() call.

Convert the accounting code to be the proper lockless counterpart of
what has been partially done by 902c098a3663.

Signed-off-by: Jiri Kosina <jkosina@suse.cz>
Cc: Theodore Ts'o <tytso@mit.edu>
Cc: Greg KH <greg@kroah.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/char/random.c | 24 ++++++++++++++++--------
 1 file changed, 16 insertions(+), 8 deletions(-)

diff --git a/drivers/char/random.c b/drivers/char/random.c
index 91abbc4..395d2e8 100644
--- a/drivers/char/random.c
+++ b/drivers/char/random.c
@@ -868,16 +868,24 @@ static size_t account(struct entropy_store *r, size_t nbytes, int min,
 	if (r->entropy_count / 8 < min + reserved) {
 		nbytes = 0;
 	} else {
+		int entropy_count, orig;
+retry:
+		entropy_count = orig = ACCESS_ONCE(r->entropy_count);
 		/* If limited, never pull more than available */
-		if (r->limit && nbytes + reserved >= r->entropy_count / 8)
-			nbytes = r->entropy_count/8 - reserved;
-
-		if (r->entropy_count / 8 >= nbytes + reserved)
-			r->entropy_count -= nbytes*8;
-		else
-			r->entropy_count = reserved;
+		if (r->limit && nbytes + reserved >= entropy_count / 8)
+			nbytes = entropy_count/8 - reserved;
+
+		if (entropy_count / 8 >= nbytes + reserved) {
+			entropy_count -= nbytes*8;
+			if (cmpxchg(&r->entropy_count, orig, entropy_count) != orig)
+				goto retry;
+		} else {
+			entropy_count = reserved;
+			if (cmpxchg(&r->entropy_count, orig, entropy_count) != orig)
+				goto retry;
+		}
 
-		if (r->entropy_count < random_write_wakeup_thresh)
+		if (entropy_count < random_write_wakeup_thresh)
 			wakeup_write = 1;
 	}
 
-- 
1.8.1.2

