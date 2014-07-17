Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754173AbaGQTkI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jul 2014 15:40:08 -0400
Received: from g4t3425.houston.hp.com ([15.201.208.53]:10828 "EHLO
	g4t3425.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753777AbaGQTkD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jul 2014 15:40:03 -0400
Subject: [PATCH 1/3] blk-mq: cleanup after blk_mq_init_rq_map failures
To: axboe@kernel.dk, abhijit.mahajan@avagotech.com, kmo@datarainc.com,
        nagalakshmi.nandigama@avagotech.com, asamymuthupa@micron.com,
        snitzer@redhat.com, JBottomley@parallels.com,
        relliott@beardog.cce.hp.com, sreekanth.reddy@avagotech.com,
        praveen.krishnamoorthy@avagotech.com, agordeev@redhat.com,
        scameron@beardog.cce.hp.com, tom.leiming@gmail.com, elliott@hp.com,
        sbradshaw@micron.com, hch@lst.de, m@bjorling.me
From: Robert Elliott <elliott@hp.com>
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
Date: Thu, 17 Jul 2014 14:39:09 -0500
Message-ID: <20140717193904.1924.84206.stgit@beardog.cce.hp.com>
In-Reply-To: <20140717193707.1924.87867.stgit@beardog.cce.hp.com>
References: <20140717193707.1924.87867.stgit@beardog.cce.hp.com>
User-Agent: StGit/0.15
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In blk-mq.c blk_mq_alloc_tag_set, if:
	set->tags = kmalloc_node()
succeeds, but one of the blk_mq_init_rq_map() calls fails,
	goto out_unwind;
needs to free set->tags so the caller is not obligated
to do so.  None of the current callers (null_blk,
virtio_blk, virtio_blk, or the forthcoming scsi-mq)
do so.

set->tags needs to be set to NULL after doing so,
so other tag cleanup logic doesn't try to free
a stale pointer later.  Also set it to NULL
in blk_mq_free_tag_set.

Tested with error injection on the forthcoming
scsi-mq + hpsa combination.

Signed-off-by: Robert Elliott <elliott@hp.com>
---
 block/blk-mq.c |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/block/blk-mq.c b/block/blk-mq.c
index ad69ef6..4a24b97 100644
--- a/block/blk-mq.c
+++ b/block/blk-mq.c
@@ -1996,6 +1996,8 @@ int blk_mq_alloc_tag_set(struct blk_mq_tag_set *set)
 out_unwind:
 	while (--i >= 0)
 		blk_mq_free_rq_map(set, set->tags[i], i);
+	kfree(set->tags);
+	set->tags = NULL;
 out:
 	return -ENOMEM;
 }
@@ -2011,6 +2013,7 @@ void blk_mq_free_tag_set(struct blk_mq_tag_set *set)
 	}
 
 	kfree(set->tags);
+	set->tags = NULL;
 }
 EXPORT_SYMBOL(blk_mq_free_tag_set);
 

