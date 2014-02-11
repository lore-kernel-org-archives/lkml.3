Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754749AbaBKTPy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Feb 2014 14:15:54 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:40607 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754431AbaBKTIc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Feb 2014 14:08:32 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Joe Thornber <ejt@redhat.com>, Mike Snitzer <snitzer@redhat.com>
Subject: [PATCH 3.4 16/30] dm space map common: make sure new space is used during extend
Date: Tue, 11 Feb 2014 11:06:16 -0800
Message-Id: <20140211184647.605166802@linuxfoundation.org>
X-Mailer: git-send-email 1.8.5.1.163.gd7aced9
In-Reply-To: <20140211184647.149512538@linuxfoundation.org>
References: <20140211184647.149512538@linuxfoundation.org>
User-Agent: quilt/0.61-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Joe Thornber <ejt@redhat.com>

commit 12c91a5c2d2a8e8cc40a9552313e1e7b0a2d9ee3 upstream.

When extending a low level space map we should update nr_blocks at
the start so the new space is used for the index entries.

Otherwise extend can fail, e.g.: sm_metadata_extend call sequence
that fails:
 -> sm_ll_extend
    -> dm_tm_new_block -> dm_sm_new_block -> sm_bootstrap_new_block
    => returns -ENOSPC because smm->begin == smm->ll.nr_blocks

Signed-off-by: Joe Thornber <ejt@redhat.com>
Signed-off-by: Mike Snitzer <snitzer@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/md/persistent-data/dm-space-map-common.c |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

--- a/drivers/md/persistent-data/dm-space-map-common.c
+++ b/drivers/md/persistent-data/dm-space-map-common.c
@@ -244,6 +244,10 @@ int sm_ll_extend(struct ll_disk *ll, dm_
 		return -EINVAL;
 	}
 
+	/*
+	 * We need to set this before the dm_tm_new_block() call below.
+	 */
+	ll->nr_blocks = nr_blocks;
 	for (i = old_blocks; i < blocks; i++) {
 		struct dm_block *b;
 		struct disk_index_entry idx;
@@ -251,6 +255,7 @@ int sm_ll_extend(struct ll_disk *ll, dm_
 		r = dm_tm_new_block(ll->tm, &dm_sm_bitmap_validator, &b);
 		if (r < 0)
 			return r;
+
 		idx.blocknr = cpu_to_le64(dm_block_location(b));
 
 		r = dm_tm_unlock(ll->tm, b);
@@ -265,7 +270,6 @@ int sm_ll_extend(struct ll_disk *ll, dm_
 			return r;
 	}
 
-	ll->nr_blocks = nr_blocks;
 	return 0;
 }
 


