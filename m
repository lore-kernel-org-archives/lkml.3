Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756334Ab3JCEUj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Oct 2013 00:20:39 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:47338 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756244Ab3JCEUf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Oct 2013 00:20:35 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Kent Overstreet <kmo@daterainc.com>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [ 09/57] bcache: Fix a shrinker deadlock
Date: Wed,  2 Oct 2013 21:08:35 -0700
Message-Id: <20131003040637.242274700@linuxfoundation.org>
X-Mailer: git-send-email 1.8.4.6.g82e253f.dirty
In-Reply-To: <20131003040636.600441214@linuxfoundation.org>
References: <20131003040636.600441214@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kent Overstreet <kmo@daterainc.com>

commit a698e08c82dfb9771e0bac12c7337c706d729b6d upstream.

GFP_NOIO means we could be getting called recursively - mca_alloc() ->
mca_data_alloc() - definitely can't use mutex_lock(bucket_lock) then.
Whoops.

Signed-off-by: Kent Overstreet <kmo@daterainc.com>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/md/bcache/btree.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/md/bcache/btree.c
+++ b/drivers/md/bcache/btree.c
@@ -617,7 +617,7 @@ static int bch_mca_shrink(struct shrinke
 		return mca_can_free(c) * c->btree_pages;
 
 	/* Return -1 if we can't do anything right now */
-	if (sc->gfp_mask & __GFP_WAIT)
+	if (sc->gfp_mask & __GFP_IO)
 		mutex_lock(&c->bucket_lock);
 	else if (!mutex_trylock(&c->bucket_lock))
 		return -1;


