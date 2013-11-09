Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933453Ab3KIHNt (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Nov 2013 02:13:49 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:33304 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932727Ab3KIGwA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Nov 2013 01:52:00 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Jes Sorensen <Jes.Sorensen@redhat.com>, Shaohua Li <shli@fusionio.com>,
        NeilBrown <neilb@suse.de>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: [PATCH 3.11 35/94] raid5: set bio bi_vcnt 0 for discard request
Date: Fri,  8 Nov 2013 22:51:41 -0800
Message-Id: <20131109065206.718908827@linuxfoundation.org>
X-Mailer: git-send-email 1.8.5.rc0.dirty
In-Reply-To: <20131109065204.252462489@linuxfoundation.org>
References: <20131109065204.252462489@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Shaohua Li <shli@kernel.org>

commit 37c61ff31e9b5e3fcf3cc6579f5c68f6ad40c4b1 upstream.

SCSI layer will add new payload for discard request. If two bios are merged
to one, the second bio has bi_vcnt 1 which is set in raid5. This will confuse
SCSI and cause oops.

Suitable for backport to 3.7+

Reported-by: Jes Sorensen <Jes.Sorensen@redhat.com>
Signed-off-by: Shaohua Li <shli@fusionio.com>
Signed-off-by: NeilBrown <neilb@suse.de>
Acked-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/md/raid5.c |   12 ++++++++++++
 1 file changed, 12 insertions(+)

--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -668,6 +668,12 @@ static void ops_run_io(struct stripe_hea
 			bi->bi_io_vec[0].bv_len = STRIPE_SIZE;
 			bi->bi_io_vec[0].bv_offset = 0;
 			bi->bi_size = STRIPE_SIZE;
+			/*
+			 * If this is discard request, set bi_vcnt 0. We don't
+			 * want to confuse SCSI because SCSI will replace payload
+			 */
+			if (rw & REQ_DISCARD)
+				bi->bi_vcnt = 0;
 			if (rrdev)
 				set_bit(R5_DOUBLE_LOCKED, &sh->dev[i].flags);
 
@@ -706,6 +712,12 @@ static void ops_run_io(struct stripe_hea
 			rbi->bi_io_vec[0].bv_len = STRIPE_SIZE;
 			rbi->bi_io_vec[0].bv_offset = 0;
 			rbi->bi_size = STRIPE_SIZE;
+			/*
+			 * If this is discard request, set bi_vcnt 0. We don't
+			 * want to confuse SCSI because SCSI will replace payload
+			 */
+			if (rw & REQ_DISCARD)
+				rbi->bi_vcnt = 0;
 			if (conf->mddev->gendisk)
 				trace_block_bio_remap(bdev_get_queue(rbi->bi_bdev),
 						      rbi, disk_devt(conf->mddev->gendisk),


