Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932870AbbA0Mjw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jan 2015 07:39:52 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:35110 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932288AbbA0MST (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jan 2015 07:18:19 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Kent Overstreet <kmo@daterainc.com>,
        Gabriel de Perthuis <g2p.code@gmail.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.16.y-ckt 054/126] bcache: Make sure to pass GFP_WAIT to mempool_alloc()
Date: Tue, 27 Jan 2015 12:15:59 +0000
Message-Id: <1422361031-19364-55-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 2.1.4
In-Reply-To: <1422361031-19364-1-git-send-email-luis.henriques@canonical.com>
References: <1422361031-19364-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.16
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.16.7-ckt5 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kent Overstreet <kmo@daterainc.com>

commit bcf090e0040e30f8409e6a535a01e6473afb096f upstream.

this was very wrong - mempool_alloc() only guarantees success with GFP_WAIT.
bcache uses GFP_NOWAIT in various other places where we have a fallback,
circuits must've gotten crossed when writing this code or something.

Signed-off-by: Kent Overstreet <kmo@daterainc.com>
Cc: Gabriel de Perthuis <g2p.code@gmail.com>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/md/bcache/btree.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/md/bcache/btree.c b/drivers/md/bcache/btree.c
index 7347b6100961..5ef445d2d81e 100644
--- a/drivers/md/bcache/btree.c
+++ b/drivers/md/bcache/btree.c
@@ -202,7 +202,7 @@ void bch_btree_node_read_done(struct btree *b)
 	struct bset *i = btree_bset_first(b);
 	struct btree_iter *iter;
 
-	iter = mempool_alloc(b->c->fill_iter, GFP_NOWAIT);
+	iter = mempool_alloc(b->c->fill_iter, GFP_NOIO);
 	iter->size = b->c->sb.bucket_size / b->c->sb.block_size;
 	iter->used = 0;
 
-- 
2.1.4

