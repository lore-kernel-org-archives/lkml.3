Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753815AbaBRWtF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Feb 2014 17:49:05 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:51299 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753637AbaBRWrk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Feb 2014 17:47:40 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        "Darrick J. Wong" <darrick.wong@oracle.com>,
        Kent Overstreet <kmo@daterainc.com>
Subject: [PATCH 3.13 38/40] bcache: fix BUG_ON due to integer overflow with GC_SECTORS_USED
Date: Tue, 18 Feb 2014 14:47:39 -0800
Message-Id: <20140218224434.405866285@linuxfoundation.org>
X-Mailer: git-send-email 1.8.5.1.163.gd7aced9
In-Reply-To: <20140218224433.337299968@linuxfoundation.org>
References: <20140218224433.337299968@linuxfoundation.org>
User-Agent: quilt/0.61-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: "Darrick J. Wong" <darrick.wong@oracle.com>

commit 947174476701fbc84ea8c7ec9664270f9d80b076 upstream.

The BUG_ON at the end of __bch_btree_mark_key can be triggered due to
an integer overflow error:

BITMASK(GC_SECTORS_USED, struct bucket, gc_mark, 2, 13);
...
SET_GC_SECTORS_USED(g, min_t(unsigned,
	     GC_SECTORS_USED(g) + KEY_SIZE(k),
	     (1 << 14) - 1));
BUG_ON(!GC_SECTORS_USED(g));

In bcache.h, the SECTORS_USED bitfield is defined to be 13 bits wide.
While the SET_ code tries to ensure that the field doesn't overflow by
clamping it to (1<<14)-1 == 16383, this is incorrect because 16383
requires 14 bits.  Therefore, if GC_SECTORS_USED() + KEY_SIZE() =
8192, the SET_ statement tries to store 8192 into a 13-bit field.  In
a 13-bit field, 8192 becomes zero, thus triggering the BUG_ON.

Therefore, create a field width constant and a max value constant, and
use those to create the bitfield and check the inputs to
SET_GC_SECTORS_USED.  Arguably the BITMASK() template ought to have
BUG_ON checks for too-large values, but that's a separate patch.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
Cc: Kent Overstreet <kmo@daterainc.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/md/bcache/bcache.h |    4 +++-
 drivers/md/bcache/btree.c  |    2 +-
 2 files changed, 4 insertions(+), 2 deletions(-)

--- a/drivers/md/bcache/bcache.h
+++ b/drivers/md/bcache/bcache.h
@@ -209,7 +209,9 @@ BITMASK(GC_MARK,	 struct bucket, gc_mark
 #define GC_MARK_RECLAIMABLE	0
 #define GC_MARK_DIRTY		1
 #define GC_MARK_METADATA	2
-BITMASK(GC_SECTORS_USED, struct bucket, gc_mark, 2, 13);
+#define GC_SECTORS_USED_SIZE	13
+#define MAX_GC_SECTORS_USED	(~(~0ULL << GC_SECTORS_USED_SIZE))
+BITMASK(GC_SECTORS_USED, struct bucket, gc_mark, 2, GC_SECTORS_USED_SIZE);
 BITMASK(GC_MOVE, struct bucket, gc_mark, 15, 1);
 
 #include "journal.h"
--- a/drivers/md/bcache/btree.c
+++ b/drivers/md/bcache/btree.c
@@ -1163,7 +1163,7 @@ uint8_t __bch_btree_mark_key(struct cach
 		/* guard against overflow */
 		SET_GC_SECTORS_USED(g, min_t(unsigned,
 					     GC_SECTORS_USED(g) + KEY_SIZE(k),
-					     (1 << 14) - 1));
+					     MAX_GC_SECTORS_USED));
 
 		BUG_ON(!GC_SECTORS_USED(g));
 	}


