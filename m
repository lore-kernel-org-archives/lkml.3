Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1162304Ab3LFNsS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Dec 2013 08:48:18 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:44138 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758124Ab3LFNCP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Dec 2013 08:02:15 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Joe Thornber <ejt@redhat.com>, Mike Snitzer <snitzer@redhat.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 123/272] dm array: fix bug in growing array
Date: Fri,  6 Dec 2013 12:56:52 +0000
Message-Id: <1386334761-25517-124-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1386334761-25517-1-git-send-email-luis.henriques@canonical.com>
References: <1386334761-25517-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11.10.1 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Joe Thornber <ejt@redhat.com>

commit 9c1d4de56066e4d6abc66ec188faafd7b303fb08 upstream.

Entries would be lost if the old tail block was partially filled.

Signed-off-by: Joe Thornber <ejt@redhat.com>
Signed-off-by: Mike Snitzer <snitzer@redhat.com>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/md/persistent-data/dm-array.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/md/persistent-data/dm-array.c b/drivers/md/persistent-data/dm-array.c
index 172147e..af96e24 100644
--- a/drivers/md/persistent-data/dm-array.c
+++ b/drivers/md/persistent-data/dm-array.c
@@ -509,15 +509,18 @@ static int grow_add_tail_block(struct resize *resize)
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
-- 
1.8.3.2

