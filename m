Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759176Ab3E1D4F (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 May 2013 23:56:05 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:52507 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758803Ab3E1DyG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 May 2013 23:54:06 -0400
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org,
        "Linus Torvalds" <torvalds@linux-foundation.org>,
        "Greg KH" <greg@kroah.com>, "Jiri Kosina" <jkosina@suse.cz>,
        "Theodore Ts'o" <tytso@mit.edu>
Date: Tue, 28 May 2013 04:49:53 +0100
Message-ID: <lsq.1369712993.140194207@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [67/94] random: fix accounting race condition with lockless irq
 entropy_count update
In-Reply-To: <lsq.1369712992.755341692@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.101
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.46-rc1 review patch.  If anyone has any objections, please let me know.

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
[bwh: Backported to 3.2: adjust context]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/char/random.c |   24 ++++++++++++++++--------
 1 file changed, 16 insertions(+), 8 deletions(-)

--- a/drivers/char/random.c
+++ b/drivers/char/random.c
@@ -889,16 +889,24 @@ static size_t account(struct entropy_sto
 	if (r->entropy_count / 8 < min + reserved) {
 		nbytes = 0;
 	} else {
+		int entropy_count, orig;
+retry:
+		entropy_count = orig = ACCESS_ONCE(r->entropy_count);
 		/* If limited, never pull more than available */
-		if (r->limit && nbytes + reserved >= r->entropy_count / 8)
-			nbytes = r->entropy_count/8 - reserved;
+		if (r->limit && nbytes + reserved >= entropy_count / 8)
+			nbytes = entropy_count/8 - reserved;
 
-		if (r->entropy_count / 8 >= nbytes + reserved)
-			r->entropy_count -= nbytes*8;
-		else
-			r->entropy_count = reserved;
+		if (entropy_count / 8 >= nbytes + reserved) {
+			entropy_count -= nbytes*8;
+			if (cmpxchg(&r->entropy_count, orig, entropy_count) != orig)
+				goto retry;
+		} else {
+			entropy_count = reserved;
+			if (cmpxchg(&r->entropy_count, orig, entropy_count) != orig)
+				goto retry;
+		}
 
-		if (r->entropy_count < random_write_wakeup_thresh) {
+		if (entropy_count < random_write_wakeup_thresh) {
 			wake_up_interruptible(&random_write_wait);
 			kill_fasync(&fasync, SIGIO, POLL_OUT);
 		}

