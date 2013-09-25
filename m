Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756686Ab3IYAUl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Sep 2013 20:20:41 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:39616 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756611Ab3IYAUb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Sep 2013 20:20:31 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Jan Kara <jack@suse.cz>, "Theodore Tso" <tytso@mit.edu>
Subject: [ 061/117] ext4: move test whether extent to map can be extended to one place
Date: Tue, 24 Sep 2013 17:18:47 -0700
Message-Id: <20130925001747.521451488@linuxfoundation.org>
X-Mailer: git-send-email 1.8.4.3.gca3854a
In-Reply-To: <20130925001740.833541979@linuxfoundation.org>
References: <20130925001740.833541979@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jan Kara <jack@suse.cz>

commit 09930042a2e94cf8ee79d22943915612c1e4ba51 upstream.

Currently the logic whether the current buffer can be added to an extent
of buffers to map is split between mpage_add_bh_to_extent() and
add_page_bufs_to_extent(). Move the whole logic to
mpage_add_bh_to_extent() which makes things a bit more straightforward
and make following i_size fixes easier.

Signed-off-by: Jan Kara <jack@suse.cz>
Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/ext4/inode.c |   49 +++++++++++++++++++++++++++++--------------------
 1 file changed, 29 insertions(+), 20 deletions(-)

--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -1904,34 +1904,48 @@ static int ext4_writepage(struct page *p
  *
  * @mpd - extent of blocks
  * @lblk - logical number of the block in the file
- * @b_state - b_state of the buffer head added
+ * @bh - buffer head we want to add to the extent
  *
- * the function is used to collect contig. blocks in same state
+ * The function is used to collect contig. blocks in the same state. If the
+ * buffer doesn't require mapping for writeback and we haven't started the
+ * extent of buffers to map yet, the function returns 'true' immediately - the
+ * caller can write the buffer right away. Otherwise the function returns true
+ * if the block has been added to the extent, false if the block couldn't be
+ * added.
  */
-static int mpage_add_bh_to_extent(struct mpage_da_data *mpd, ext4_lblk_t lblk,
-				  unsigned long b_state)
+static bool mpage_add_bh_to_extent(struct mpage_da_data *mpd, ext4_lblk_t lblk,
+				   struct buffer_head *bh)
 {
 	struct ext4_map_blocks *map = &mpd->map;
 
-	/* Don't go larger than mballoc is willing to allocate */
-	if (map->m_len >= MAX_WRITEPAGES_EXTENT_LEN)
-		return 0;
+	/* Buffer that doesn't need mapping for writeback? */
+	if (!buffer_dirty(bh) || !buffer_mapped(bh) ||
+	    (!buffer_delay(bh) && !buffer_unwritten(bh))) {
+		/* So far no extent to map => we write the buffer right away */
+		if (map->m_len == 0)
+			return true;
+		return false;
+	}
 
 	/* First block in the extent? */
 	if (map->m_len == 0) {
 		map->m_lblk = lblk;
 		map->m_len = 1;
-		map->m_flags = b_state & BH_FLAGS;
-		return 1;
+		map->m_flags = bh->b_state & BH_FLAGS;
+		return true;
 	}
 
+	/* Don't go larger than mballoc is willing to allocate */
+	if (map->m_len >= MAX_WRITEPAGES_EXTENT_LEN)
+		return false;
+
 	/* Can we merge the block to our big extent? */
 	if (lblk == map->m_lblk + map->m_len &&
-	    (b_state & BH_FLAGS) == map->m_flags) {
+	    (bh->b_state & BH_FLAGS) == map->m_flags) {
 		map->m_len++;
-		return 1;
+		return true;
 	}
-	return 0;
+	return false;
 }
 
 static bool add_page_bufs_to_extent(struct mpage_da_data *mpd,
@@ -1946,18 +1960,13 @@ static bool add_page_bufs_to_extent(stru
 	do {
 		BUG_ON(buffer_locked(bh));
 
-		if (!buffer_dirty(bh) || !buffer_mapped(bh) ||
-		    (!buffer_delay(bh) && !buffer_unwritten(bh)) ||
-		    lblk >= blocks) {
+		if (lblk >= blocks || !mpage_add_bh_to_extent(mpd, lblk, bh)) {
 			/* Found extent to map? */
 			if (mpd->map.m_len)
 				return false;
-			if (lblk >= blocks)
-				return true;
-			continue;
+			/* Everything mapped so far and we hit EOF */
+			return true;
 		}
-		if (!mpage_add_bh_to_extent(mpd, lblk, bh->b_state))
-			return false;
 	} while (lblk++, (bh = bh->b_this_page) != head);
 	return true;
 }


