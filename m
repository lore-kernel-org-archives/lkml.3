Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758974Ab3EWNXA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 May 2013 09:23:00 -0400
Received: from cantor2.suse.de ([195.135.220.15]:57476 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757998Ab3EWNW7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 May 2013 09:22:59 -0400
Date: Thu, 23 May 2013 15:22:55 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
To: tytso@mit.edu, "H. Peter Anvin" <hpa@linux.intel.com>,
        Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH umpteenth RESEND] random: fix accounting race condition with
 lockless irq entropy_count update
Message-ID: <alpine.LNX.2.00.1305231515510.22195@pobox.suse.cz>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi everybody,

this is an umpteenth resend of patch that has been queued in -mm tree for 
quite some time, but apart from that, hasn't been acted upon for some 
reason. A few more CCs added.

As the bug is causing observable failures of userspace services relying on 
/dev/urandom never EOFing (openssh and apache reported to fail) on certain 
architectures (s390 known to be hit by this), I think it shouldn't be 
unnecessarily delayed.

Thanks in advance.





From: Jiri Kosina <jkosina@suse.cz>
Subject: random: fix accounting race condition with lockless irq entropy_count update

Commit 902c098a3663 ("random: use lockless techniques in the interrupt
path") turned IRQ path from being spinlock protected into lockless
cmpxchg-retry update.

That commit removed r->lock serialization between crediting entropy bits
from IRQ context and accounting when extracting entropy on userspace read
path, but didn't turn the r->entropy_count reads/updates in account() to
use cmpxchg as well.

It has been observed, that under certain circumstances this leads to
read() on /dev/urandom to return 0 (EOF), as r->entropy_count gets
corrupted and becomes negative, which in turn results in propagating 0 all
the way from account() to the actual read() call.

Convert the accounting code to be the proper lockless counterpart of what
has been partially done by 902c098a3663.

Signed-off-by: Jiri Kosina <jkosina@suse.cz>
Cc: Theodore Ts'o <tytso@mit.edu>
Cc: Greg KH <greg@kroah.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/random.c |   22 +++++++++++++++-------
 1 file changed, 15 insertions(+), 7 deletions(-)

diff -puN drivers/char/random.c~random-fix-accounting-race-condition-with-lockless-irq-entropy_count-update drivers/char/random.c
--- a/drivers/char/random.c~random-fix-accounting-race-condition-with-lockless-irq-entropy_count-update
+++ a/drivers/char/random.c
@@ -865,16 +865,24 @@ static size_t account(struct entropy_sto
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
 
-		if (r->entropy_count < random_write_wakeup_thresh)
+		if (entropy_count < random_write_wakeup_thresh)
 			wakeup_write = 1;
 	}
 
_
