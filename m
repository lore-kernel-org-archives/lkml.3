Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756902AbbA2JBD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Jan 2015 04:01:03 -0500
Received: from ip4-83-240-67-251.cust.nbox.cz ([83.240.67.251]:44737 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1756668AbbA2JA6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Jan 2015 04:00:58 -0500
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Kent Overstreet <kmo@daterainc.com>,
        Gabriel de Perthuis <g2p.code@gmail.com>, Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 137/176] bcache: Make sure to pass GFP_WAIT to mempool_alloc()
Date: Wed, 28 Jan 2015 15:29:27 +0100
Message-Id: <b02e6ea1e1e0037530a9119d216e82983f21b64d.1422455352.git.jslaby@suse.cz>
X-Mailer: git-send-email 2.2.2
In-Reply-To: <ce4a451f616a1e7ab58cfeceea5e49c8b1c68c81.1422455352.git.jslaby@suse.cz>
References: <ce4a451f616a1e7ab58cfeceea5e49c8b1c68c81.1422455352.git.jslaby@suse.cz>
In-Reply-To: <cover.1422455352.git.jslaby@suse.cz>
References: <cover.1422455352.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Kent Overstreet <kmo@daterainc.com>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

commit bcf090e0040e30f8409e6a535a01e6473afb096f upstream.

this was very wrong - mempool_alloc() only guarantees success with GFP_WAIT.
bcache uses GFP_NOWAIT in various other places where we have a fallback,
circuits must've gotten crossed when writing this code or something.

Signed-off-by: Kent Overstreet <kmo@daterainc.com>
Cc: Gabriel de Perthuis <g2p.code@gmail.com>
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 drivers/md/bcache/btree.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/md/bcache/btree.c b/drivers/md/bcache/btree.c
index d1734d9d9c79..26ca4db908b9 100644
--- a/drivers/md/bcache/btree.c
+++ b/drivers/md/bcache/btree.c
@@ -141,7 +141,7 @@ static void bch_btree_node_read_done(struct btree *b)
 	struct bset *i = b->sets[0].data;
 	struct btree_iter *iter;
 
-	iter = mempool_alloc(b->c->fill_iter, GFP_NOWAIT);
+	iter = mempool_alloc(b->c->fill_iter, GFP_NOIO);
 	iter->size = b->c->sb.bucket_size / b->c->sb.block_size;
 	iter->used = 0;
 
-- 
2.2.2

