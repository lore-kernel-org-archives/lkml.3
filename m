Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754209AbaBLWSn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Feb 2014 17:18:43 -0500
Received: from mx1.redhat.com ([209.132.183.28]:45103 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753426AbaBLWSm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Feb 2014 17:18:42 -0500
Date: Wed, 12 Feb 2014 17:18:36 -0500
From: Mike Snitzer <snitzer@redhat.com>
To: Akhil Bhansali <abhansali@stec-inc.com>
Cc: Jens Axboe <axboe@kernel.dk>, linux-kernel@vger.kernel.org
Subject: [PATCH] skd: disable discard support
Message-ID: <20140212221835.GA4265@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The skd driver has never handled discards reliably.

The kernel will BUG as a result of issuing discards to the skd device.
Disable the skd driver's discard support until it is proven reliable.

The device-mapper-test-suite test that exposed this bug just issues a
discard that covers a portion of the skd device that was previously
written through a dm-thin device.  The discard spans the entire 1GB thin
device (logical sector 0 through 2097152).

dmtest run --profile stec --suite thin-provisioning -n /discard_fully_provisioned_device/

 associated device-mapper-test-suite ruby test code follows:

  def test_discard_fully_provisioned_device
    with_standard_pool(@size) do |pool|
      with_new_thins(pool, @volume_size, 0, 1) do |thin, thin2|
        wipe_device(thin)
        wipe_device(thin2)
        assert_used_blocks(pool, 2 * @blocks_per_dev)
        thin.discard(0, @volume_size)
        assert_used_blocks(pool, @blocks_per_dev)
      end
    end
  ...

Signed-off-by: Mike Snitzer <snitzer@redhat.com>
---
 drivers/block/skd_main.c |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/drivers/block/skd_main.c b/drivers/block/skd_main.c
index eb6e1e0..5dadecc 100644
--- a/drivers/block/skd_main.c
+++ b/drivers/block/skd_main.c
@@ -4441,12 +4441,15 @@ static int skd_cons_disk(struct skd_device *skdev)
 	/* set sysfs ptimal_io_size to 8K */
 	blk_queue_io_opt(q, 8192);
 
+#if 0
+	/* FIXME: Disable discard support until it no longer BUGs */
 	/* DISCARD Flag initialization. */
 	q->limits.discard_granularity = 8192;
 	q->limits.discard_alignment = 0;
 	q->limits.max_discard_sectors = UINT_MAX >> 9;
 	q->limits.discard_zeroes_data = 1;
 	queue_flag_set_unlocked(QUEUE_FLAG_DISCARD, q);
+#endif
 	queue_flag_set_unlocked(QUEUE_FLAG_NONROT, q);
 
 	spin_lock_irqsave(&skdev->lock, flags);
