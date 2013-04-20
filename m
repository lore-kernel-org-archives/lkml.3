Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755351Ab3DTOky (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Apr 2013 10:40:54 -0400
Received: from cantor2.suse.de ([195.135.220.15]:46594 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755295Ab3DTOkx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Apr 2013 10:40:53 -0400
Date: Sat, 20 Apr 2013 16:40:37 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
To: "Theodore Ts'o" <tytso@mit.edu>
Cc: linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [PATCH] random: fix accounting race condition with lockless irq
 entropy_count update
Message-ID: <alpine.LNX.2.00.1304201633440.11076@pobox.suse.cz>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ted,

the patch below has been now preliminarily verified to fix the read() on 
/dev/urandom returning 0 -- the bug we have been discussing in San 
Francisco last week.

I think it should be applied to the current Linus' tree as soon as 
possible, and also all the way back to all the affected -stable trees (the 
backport to 3.0. is trivial, just a simple context change); on 
architectures affected by this (apparently not x86_64, at least to my 
knowledge), this causes severe malfunctioning of userspace which relies on 
/dev/urandom never returning EOF (sshd, apache, ...). Observed on s390.

BTW, do we have some numbers that would prove how and why exactly is
902c098a3663 fixing real-time throughput by removing the spinlock?

Basically what we have now is producer and consumer over r->entropy_count
being serialized by retried cmpxchg loops, and I would think this could
actually make the whole situation less fair. The reason being that we are
basically spinning anyway in case of conflict on the critical section but
we are lacking the fairness comfort ticket-based spinlocks do provide
us ... hmm?

Thanks in advance.




From: Jiri Kosina <jkosina@suse.cz>
Subject: [PATCH] random: fix accounting race condition with lockless irq entropy_count update

Commit 902c098a3663 ("random: use lockless techniques in the interrupt path")
turned IRQ path from being spinlock protected into lockless cmpxchg-retry
update.

That commit removed r->lock serialization between crediting entropy bits
from IRQ context and accounting when extracting entropy on userspace read
path, but didn't turn the r->entropy_count reads/updates in account() to
use cmpxchg as well.

It has been observed, that under certain circumstances this leads to read()
on /dev/urandom to return 0 (EOF), as r->entropy_count gets corrupted and
becomes negative, which in turn results in propagating 0 all the way from
account() to the actual read() call.

Convert the accounting code to be the proper lockless counterpart of what
has been partially done by 902c098a3663.

Cc: stable@vger.kernel.org
Signed-off-by: Jiri Kosina <jkosina@suse.cz>
---
 drivers/char/random.c |   26 +++++++++++++++++---------
 1 files changed, 17 insertions(+), 9 deletions(-)

diff --git a/drivers/char/random.c b/drivers/char/random.c
index 32a6c57..442377c 100644
--- a/drivers/char/random.c
+++ b/drivers/char/random.c
@@ -865,16 +865,24 @@ static size_t account(struct entropy_store *r, size_t nbytes, int min,
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
Jiri Kosina
SUSE Labs
