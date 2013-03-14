Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757291Ab3CNK7L (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Mar 2013 06:59:11 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:51820 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756974Ab3CNKhQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Mar 2013 06:37:16 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Tejun Heo <tj@kernel.org>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 24/88] idr: fix a subtle bug in idr_get_next()
Date: Thu, 14 Mar 2013 10:35:17 +0000
Message-Id: <1363257381-15900-25-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1363257381-15900-1-git-send-email-luis.henriques@canonical.com>
References: <1363257381-15900-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.8 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tejun Heo <tj@kernel.org>

commit 6cdae7416a1c45c2ce105a78187d9b7e8feb9e24 upstream.

The iteration logic of idr_get_next() is borrowed mostly verbatim from
idr_for_each().  It walks down the tree looking for the slot matching
the current ID.  If the matching slot is not found, the ID is
incremented by the distance of single slot at the given level and
repeats.

The implementation assumes that during the whole iteration id is aligned
to the layer boundaries of the level closest to the leaf, which is true
for all iterations starting from zero or an existing element and thus is
fine for idr_for_each().

However, idr_get_next() may be given any point and if the starting id
hits in the middle of a non-existent layer, increment to the next layer
will end up skipping the same offset into it.  For example, an IDR with
IDs filled between [64, 127] would look like the following.

          [  0  64 ... ]
       /----/   |
       |        |
      NULL    [ 64 ... 127 ]

If idr_get_next() is called with 63 as the starting point, it will try
to follow down the pointer from 0.  As it is NULL, it will then try to
proceed to the next slot in the same level by adding the slot distance
at that level which is 64 - making the next try 127.  It goes around the
loop and finds and returns 127 skipping [64, 126].

Note that this bug also triggers in idr_for_each_entry() loop which
deletes during iteration as deletions can make layers go away leaving
the iteration with unaligned ID into missing layers.

Fix it by ensuring proceeding to the next slot doesn't carry over the
unaligned offset - ie.  use round_up(id + 1, slot_distance) instead of
id += slot_distance.

Signed-off-by: Tejun Heo <tj@kernel.org>
Reported-by: David Teigland <teigland@redhat.com>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 lib/idr.c | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/lib/idr.c b/lib/idr.c
index 4046e29..e90d2d0 100644
--- a/lib/idr.c
+++ b/lib/idr.c
@@ -625,7 +625,14 @@ void *idr_get_next(struct idr *idp, int *nextidp)
 			return p;
 		}
 
-		id += 1 << n;
+		/*
+		 * Proceed to the next layer at the current level.  Unlike
+		 * idr_for_each(), @id isn't guaranteed to be aligned to
+		 * layer boundary at this point and adding 1 << n may
+		 * incorrectly skip IDs.  Make sure we jump to the
+		 * beginning of the next layer using round_up().
+		 */
+		id = round_up(id + 1, 1 << n);
 		while (n < fls(id)) {
 			n += IDR_BITS;
 			p = *--paa;
-- 
1.8.1.2

