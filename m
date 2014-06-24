Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753521AbaFXXMe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jun 2014 19:12:34 -0400
Received: from mail-la0-f50.google.com ([209.85.215.50]:51902 "EHLO
	mail-la0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753200AbaFXXMc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jun 2014 19:12:32 -0400
From: =?UTF-8?q?Matias=20Bj=C3=B8rling?= <m@bjorling.me>
To: willy@linux.intel.com, keith.busch@intel.com, sbradshaw@micron.com,
        axboe@fb.com, linux-kernel@vger.kernel.org,
        linux-nvme@lists.infradead.org, hch@infradead.org, rlnelson@google.com,
        tom.leiming@gmail.com
Cc: =?UTF-8?q?Matias=20Bj=C3=B8rling?= <m@bjorling.me>
Subject: [PATCH v9] Convert NVMe driver to blk-mq
Date: Wed, 25 Jun 2014 01:12:10 +0200
Message-Id: <1403651531-24891-1-git-send-email-m@bjorling.me>
X-Mailer: git-send-email 1.9.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

Added Acked-by from Keith and Jens. Additionally to the acks, we may perform
performance and correctness tests at a few select customers to find any setup
specific bugs and/or regressions.

The patch is based on the following:

Jens for-linus up to:

  66cb45aa41315d1d9972cada354fbdf7870d7714
  block: add support for limiting gaps in SG lists

Matthew master up to:

  7171511eaec5bf23fb06078f59784a3a0626b38f
  Linux 3.16-rc1

The merged trees with the patch on top can be found here:

  https://github.com/MatiasBjorling/linux-collab nvmemq_review

and the separate changes can be found in the nvmemq_v9 branch

Changes since v8:
 * QUEUE_FLAG_VIRT_HOLE was renamed to QUEUE_FLAG_SG_GAPS
 * Previous revertion of patches lost the IRQ affinity hint
 * Removed test code in nvme_reset_notify

Changes since v7:
 * Jens implemented support for QUEUE_FLAG_VIRT_HOLE to limit
   requests to a continuous range of virtual memory.
 * Keith fixed up the abortion logic.
 * Usual style fixups

Changes since v6:
 * Rebased on top of Matthew's master and Jens' for-linus
 * A couple of style fixups

Changes since v5:
 * Splits are now supported directly within blk-mq
 * Remove nvme_queue->cpu_mask variable
 * Remove unnecessary null check
 * Style fixups

Changes since v4:
 * Fix timeout retries
 * Fix naming in nvme_init_hctx
 * Fix racy behavior of admin queue in nvme_dev_remove
 * Fix wrong return values in nvme_queue_request
 * Put cqe_seen back
 * Introduce abort_completion for killing timed out I/Os
 * Move locks outside of nvme_submit_iod
 * Various renaming and style fixes

Changes since v3:
 * Added abortion logic
 * Fixed possible race on abortion
 * Removed req data with flush. Handled by by blk-mq
 * Added safety check for submitting user rq to admin queue.
 * Use dev->online_queues for nr_hw_queues
 * Fix loop with initialization in nvme_create_io_queues
 * Style fixups

Changes since v2:
  * Rebased on top of current 3.16/core.
  * Use blk-mq queue management for spreading io queues
  * Removed rcu handling and allocated all io queues up front for mgmt by blk-mq
  * Removed the need for hotplugging notification
  * Fixed flush data handling
  * Fixed double free of spinlock
  * Various cleanups

Matias Bjørling (1):
  NVMe: Convert to blk-mq

 drivers/block/nvme-core.c | 1204 ++++++++++++++++++---------------------------
 drivers/block/nvme-scsi.c |    8 +-
 include/linux/nvme.h      |   15 +-
 3 files changed, 489 insertions(+), 738 deletions(-)

-- 
1.9.1

