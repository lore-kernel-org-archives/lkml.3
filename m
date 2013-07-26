Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933535Ab3GZVeF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Jul 2013 17:34:05 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:50831 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759953Ab3GZUsl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Jul 2013 16:48:41 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Kent Overstreet <kmo@daterainc.com>
Subject: [ 52/79] bcache: Fix GC_SECTORS_USED() calculation
Date: Fri, 26 Jul 2013 13:47:42 -0700
Message-Id: <20130726204728.056200551@linuxfoundation.org>
X-Mailer: git-send-email 1.8.3.rc0.20.gb99dd2e
In-Reply-To: <20130726204721.849052763@linuxfoundation.org>
References: <20130726204721.849052763@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kent Overstreet <kmo@daterainc.com>

commit 29ebf465b9050f241c4433a796a32e6c896a9dcd upstream.

Part of the job of garbage collection is to add up however many sectors
of live data it finds in each bucket, but that doesn't work very well if
it doesn't reset GC_SECTORS_USED() when it starts. Whoops.

This wouldn't have broken anything horribly, but allocation tries to
preferentially reclaim buckets that are mostly empty and that's not
gonna work with an incorrect GC_SECTORS_USED() value.

Signed-off-by: Kent Overstreet <kmo@daterainc.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/md/bcache/btree.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/drivers/md/bcache/btree.c
+++ b/drivers/md/bcache/btree.c
@@ -1419,8 +1419,10 @@ static void btree_gc_start(struct cache_
 	for_each_cache(ca, c, i)
 		for_each_bucket(b, ca) {
 			b->gc_gen = b->gen;
-			if (!atomic_read(&b->pin))
+			if (!atomic_read(&b->pin)) {
 				SET_GC_MARK(b, GC_MARK_RECLAIMABLE);
+				SET_GC_SECTORS_USED(b, 0);
+			}
 		}
 
 	for (d = c->devices;


