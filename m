Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758173Ab3EQWAj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 May 2013 18:00:39 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:54614 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932351Ab3EQVrz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 May 2013 17:47:55 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Mike Snitzer <snitzer@redhat.com>, Joe Thornber <ejt@redhat.com>,
        Alasdair G Kergon <agk@redhat.com>, Libo Chen <libo.chen@huawei.com>
Subject: [ 39/50] dm thin: do not set discard_zeroes_data
Date: Fri, 17 May 2013 14:47:14 -0700
Message-Id: <20130517213846.801853756@linuxfoundation.org>
X-Mailer: git-send-email 1.8.3.rc0.20.gb99dd2e
In-Reply-To: <20130517213842.447809965@linuxfoundation.org>
References: <20130517213842.447809965@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mike Snitzer <snitzer@redhat.com>

commit 307615a26e95406c42c95916a66ba50434567e0f upstream.

The dm thin pool target claims to support the zeroing of discarded
data areas.  This turns out to be incorrect when processing discards
that do not exactly cover a complete number of blocks, so the target
must always set discard_zeroes_data_unsupported.

The thin pool target will zero blocks when they are allocated if the
skip_block_zeroing feature is not specified.  The block layer
may send a discard that only partly covers a block.  If a thin pool
block is partially discarded then there is no guarantee that the
discarded data will get zeroed before it is accessed again.
Due to this, thin devices cannot claim discards will always zero data.

Signed-off-by: Mike Snitzer <snitzer@redhat.com>
Signed-off-by: Joe Thornber <ejt@redhat.com>
Signed-off-by: Alasdair G Kergon <agk@redhat.com>
Cc: Libo Chen <libo.chen@huawei.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/md/dm-thin.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/md/dm-thin.c
+++ b/drivers/md/dm-thin.c
@@ -2027,6 +2027,7 @@ static int pool_ctr(struct dm_target *ti
 		 * thin devices' discard limits consistent).
 		 */
 		ti->discards_supported = 1;
+		ti->discard_zeroes_data_unsupported = 1;
 	}
 	ti->private = pt;
 
@@ -2443,7 +2444,6 @@ static void set_discard_limits(struct po
 	 * bios that overlap 2 blocks.
 	 */
 	limits->discard_granularity = pool->sectors_per_block << SECTOR_SHIFT;
-	limits->discard_zeroes_data = pool->pf.zero_new_blocks;
 }
 
 static void pool_io_hints(struct dm_target *ti, struct queue_limits *limits)


