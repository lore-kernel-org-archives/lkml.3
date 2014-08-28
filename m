Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753533AbaH1SqT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Aug 2014 14:46:19 -0400
Received: from cantor2.suse.de ([195.135.220.15]:32885 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752457AbaH1ShM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Aug 2014 14:37:12 -0400
From: Mel Gorman <mgorman@suse.de>
To: Jiri Slaby <jslaby@suse.cz>
Cc: Linux-Stable <stable@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Mel Gorman <mgorman@suse.de>
Subject: [PATCH 83/97] fs: buffer: do not use unnecessary atomic operations when discarding buffers
Date: Thu, 28 Aug 2014 19:35:31 +0100
Message-Id: <1409250945-30874-84-git-send-email-mgorman@suse.de>
X-Mailer: git-send-email 1.8.4.5
In-Reply-To: <1409250945-30874-1-git-send-email-mgorman@suse.de>
References: <1409250945-30874-1-git-send-email-mgorman@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

commit e7470ee89f003634a88e7b5e5a7b65b3025987de upstream.

Discarding buffers uses a bunch of atomic operations when discarding
buffers because ......  I can't think of a reason.  Use a cmpxchg loop to
clear all the necessary flags.  In most (all?) cases this will be a single
atomic operations.

[akpm@linux-foundation.org: move BUFFER_FLAGS_DISCARD into the .c file]
Signed-off-by: Mel Gorman <mgorman@suse.de>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Jan Kara <jack@suse.cz>
Cc: Michal Hocko <mhocko@suse.cz>
Cc: Hugh Dickins <hughd@google.com>
Cc: Dave Hansen <dave.hansen@intel.com>
Cc: Theodore Ts'o <tytso@mit.edu>
Cc: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: Rik van Riel <riel@redhat.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Mel Gorman <mgorman@suse.de>
---
 fs/buffer.c | 21 ++++++++++++++++-----
 1 file changed, 16 insertions(+), 5 deletions(-)

diff --git a/fs/buffer.c b/fs/buffer.c
index aeeea65..6421d61 100644
--- a/fs/buffer.c
+++ b/fs/buffer.c
@@ -1483,16 +1483,27 @@ EXPORT_SYMBOL(set_bh_page);
 /*
  * Called when truncating a buffer on a page completely.
  */
+
+/* Bits that are cleared during an invalidate */
+#define BUFFER_FLAGS_DISCARD \
+	(1 << BH_Mapped | 1 << BH_New | 1 << BH_Req | \
+	 1 << BH_Delay | 1 << BH_Unwritten)
+
 static void discard_buffer(struct buffer_head * bh)
 {
+	unsigned long b_state, b_state_old;
+
 	lock_buffer(bh);
 	clear_buffer_dirty(bh);
 	bh->b_bdev = NULL;
-	clear_buffer_mapped(bh);
-	clear_buffer_req(bh);
-	clear_buffer_new(bh);
-	clear_buffer_delay(bh);
-	clear_buffer_unwritten(bh);
+	b_state = bh->b_state;
+	for (;;) {
+		b_state_old = cmpxchg(&bh->b_state, b_state,
+				      (b_state & ~BUFFER_FLAGS_DISCARD));
+		if (b_state_old == b_state)
+			break;
+		b_state = b_state_old;
+	}
 	unlock_buffer(bh);
 }
 
-- 
1.8.4.5

