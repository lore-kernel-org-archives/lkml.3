Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756780Ab3LBUFK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Dec 2013 15:05:10 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:39204 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753593Ab3LBTRt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Dec 2013 14:17:49 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Joe Thornber <ejt@redhat.com>, Mike Snitzer <snitzer@redhat.com>
Subject: [PATCH 3.12 087/212] dm array: fix bug in growing array
Date: Mon,  2 Dec 2013 11:14:38 -0800
Message-Id: <20131202191257.342833495@linuxfoundation.org>
X-Mailer: git-send-email 1.8.4.3.gca3854a
In-Reply-To: <20131202191248.517975703@linuxfoundation.org>
References: <20131202191248.517975703@linuxfoundation.org>
User-Agent: quilt/0.60-8.1.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Joe Thornber <ejt@redhat.com>

commit 9c1d4de56066e4d6abc66ec188faafd7b303fb08 upstream.

Entries would be lost if the old tail block was partially filled.

Signed-off-by: Joe Thornber <ejt@redhat.com>
Signed-off-by: Mike Snitzer <snitzer@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/md/persistent-data/dm-array.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

--- a/drivers/md/persistent-data/dm-array.c
+++ b/drivers/md/persistent-data/dm-array.c
@@ -509,15 +509,18 @@ static int grow_add_tail_block(struct re
 static int grow_needs_more_blocks(struct resize *resize)
 {
 	int r;
+	unsigned old_nr_blocks = resize->old_nr_full_blocks;
 
 	if (resize->old_nr_entries_in_last_block > 0) {
+		old_nr_blocks++;
+
 		r = grow_extend_tail_block(resize, resize->max_entries);
 		if (r)
 			return r;
 	}
 
 	r = insert_full_ablocks(resize->info, resize->size_of_block,
-				resize->old_nr_full_blocks,
+				old_nr_blocks,
 				resize->new_nr_full_blocks,
 				resize->max_entries, resize->value,
 				&resize->root);


