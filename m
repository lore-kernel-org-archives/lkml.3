Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752343Ab3BBXK5 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Feb 2013 18:10:57 -0500
Received: from mail-da0-f46.google.com ([209.85.210.46]:60680 "EHLO
	mail-da0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751435Ab3BBXKx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Feb 2013 18:10:53 -0500
Date: Sat, 2 Feb 2013 15:10:48 -0800
From: Tejun Heo <tj@kernel.org>
To: David Teigland <teigland@redhat.com>
Cc: akpm@linux-foundation.org, rusty@rustcorp.com.au,
        linux-kernel@vger.kernel.org,
        Christine Caulfield <ccaulfie@redhat.com>, cluster-devel@redhat.com,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Subject: [PATCH] idr: fix a subtle bug in idr_get_next()
Message-ID: <20130202231048.GA3940@mtj.dyndns.org>
References: <1359163872-1949-1-git-send-email-tj@kernel.org>
 <1359163872-1949-11-git-send-email-tj@kernel.org>
 <20130128155723.GC16789@redhat.com>
 <20130129151317.GA11609@redhat.com>
 <20130130212417.GJ24014@redhat.com>
 <20130131235320.GN6824@mtj.dyndns.org>
 <20130201001841.GP6824@mtj.dyndns.org>
 <20130201174443.GC3812@redhat.com>
 <20130201180028.GC31863@mtj.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130201180028.GC31863@mtj.dyndns.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The iteration logic of idr_get_next() is borrowed mostly verbatim from
idr_for_each().  It walks down the tree looking for the slot matching
the current ID.  If the matching slot is not found, the ID is
incremented by the distance of single slot at the given level and
repeats.

The implementation assumes that during the whole iteration id is
aligned to the layer boundaries of the level closest to the leaf,
which is true for all iterations starting from zero or an existing
element and thus is fine for idr_for_each().

However, idr_get_next() may be given any point and if the starting id
hits in the middle of a non-existent layer, increment to the next
layer will end up skipping the same offset into it.  For example, an
IDR with IDs filled between [64, 127] would look like the following.

          [  0  64 ... ]
       /----/   |
       |        |
      NULL    [ 64 ... 127 ]

If idr_get_next() is called with 63 as the starting point, it will try
to follow down the pointer from 0.  As it is NULL, it will then try to
proceed to the next slot in the same level by adding the slot distance
at that level which is 64 - making the next try 127.  It goes around
the loop and finds and returns 127 skipping [64, 126].

Note that this bug also triggers in idr_for_each_entry() loop which
deletes during iteration as deletions can make layers go away leaving
the iteration with unaligned ID into missing layers.

Fix it by ensuring proceeding to the next slot doesn't carry over the
unaligned offset - ie. use round_up(id + 1, slot_distance) instead of
id += slot_distance.

Signed-off-by: Tejun Heo <tj@kernel.org>
Reported-by: David Teigland <teigland@redhat.com>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
---
 lib/idr.c |    9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/lib/idr.c b/lib/idr.c
index 6482390..ca5aa00 100644
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
