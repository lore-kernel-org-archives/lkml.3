Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932622AbbAYTFt (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Jan 2015 14:05:49 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:57551 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755391AbbAYSJa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Jan 2015 13:09:30 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Kent Overstreet <kmo@daterainc.com>,
        Gabriel de Perthuis <g2p.code@gmail.com>
Subject: [PATCH 3.14 91/98] bcache: Make sure to pass GFP_WAIT to mempool_alloc()
Date: Sun, 25 Jan 2015 10:07:49 -0800
Message-Id: <20150125180716.850844636@linuxfoundation.org>
X-Mailer: git-send-email 2.2.2
In-Reply-To: <20150125180712.859646324@linuxfoundation.org>
References: <20150125180712.859646324@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kent Overstreet <kmo@daterainc.com>

commit bcf090e0040e30f8409e6a535a01e6473afb096f upstream.

this was very wrong - mempool_alloc() only guarantees success with GFP_WAIT.
bcache uses GFP_NOWAIT in various other places where we have a fallback,
circuits must've gotten crossed when writing this code or something.

Signed-off-by: Kent Overstreet <kmo@daterainc.com>
Cc: Gabriel de Perthuis <g2p.code@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/md/bcache/btree.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/md/bcache/btree.c
+++ b/drivers/md/bcache/btree.c
@@ -199,7 +199,7 @@ void bch_btree_node_read_done(struct btr
 	struct bset *i = btree_bset_first(b);
 	struct btree_iter *iter;
 
-	iter = mempool_alloc(b->c->fill_iter, GFP_NOWAIT);
+	iter = mempool_alloc(b->c->fill_iter, GFP_NOIO);
 	iter->size = b->c->sb.bucket_size / b->c->sb.block_size;
 	iter->used = 0;
 


