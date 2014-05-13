Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760559AbaEMJsJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 May 2014 05:48:09 -0400
Received: from cantor2.suse.de ([195.135.220.15]:49996 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933065AbaEMJqP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 May 2014 05:46:15 -0400
From: Mel Gorman <mgorman@suse.de>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>, Vlastimil Babka <vbabka@suse.cz>,
        Jan Kara <jack@suse.cz>, Michal Hocko <mhocko@suse.cz>,
        Hugh Dickins <hughd@google.com>, Peter Zijlstra <peterz@infradead.org>,
        Dave Hansen <dave.hansen@intel.com>, Mel Gorman <mgorman@suse.de>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Linux-MM <linux-mm@kvack.org>,
        Linux-FSDevel <linux-fsdevel@vger.kernel.org>
Subject: [PATCH 17/19] fs: buffer: Do not use unnecessary atomic operations when discarding buffers
Date: Tue, 13 May 2014 10:45:48 +0100
Message-Id: <1399974350-11089-18-git-send-email-mgorman@suse.de>
X-Mailer: git-send-email 1.8.4.5
In-Reply-To: <1399974350-11089-1-git-send-email-mgorman@suse.de>
References: <1399974350-11089-1-git-send-email-mgorman@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Discarding buffers uses a bunch of atomic operations when discarding buffers
because ...... I can't think of a reason. Use a cmpxchg loop to clear all the
necessary flags. In most (all?) cases this will be a single atomic operations.

Signed-off-by: Mel Gorman <mgorman@suse.de>
---
 fs/buffer.c                 | 14 +++++++++-----
 include/linux/buffer_head.h |  5 +++++
 2 files changed, 14 insertions(+), 5 deletions(-)

diff --git a/fs/buffer.c b/fs/buffer.c
index 9ddb9fc..e80012d 100644
--- a/fs/buffer.c
+++ b/fs/buffer.c
@@ -1485,14 +1485,18 @@ EXPORT_SYMBOL(set_bh_page);
  */
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
+		b_state_old = cmpxchg(&bh->b_state, b_state, (b_state & ~BUFFER_FLAGS_DISCARD));
+		if (b_state_old == b_state)
+			break;
+		b_state = b_state_old;
+	}
 	unlock_buffer(bh);
 }
 
diff --git a/include/linux/buffer_head.h b/include/linux/buffer_head.h
index c40302f..95f565a 100644
--- a/include/linux/buffer_head.h
+++ b/include/linux/buffer_head.h
@@ -77,6 +77,11 @@ struct buffer_head {
 	atomic_t b_count;		/* users using this buffer_head */
 };
 
+/* Bits that are cleared during an invalidate */
+#define BUFFER_FLAGS_DISCARD \
+	(1 << BH_Mapped | 1 << BH_New | 1 << BH_Req | \
+	 1 << BH_Delay | 1 << BH_Unwritten)
+
 /*
  * macro tricks to expand the set_buffer_foo(), clear_buffer_foo()
  * and buffer_foo() functions.
-- 
1.8.4.5

