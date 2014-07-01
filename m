Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757988AbaGAOxa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jul 2014 10:53:30 -0400
Received: from mail-la0-f50.google.com ([209.85.215.50]:36440 "EHLO
	mail-la0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753916AbaGAOx2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jul 2014 10:53:28 -0400
From: =?UTF-8?q?Matias=20Bj=C3=B8rling?= <m@bjorling.me>
To: willy@linux.intel.com, keith.busch@intel.com, sbradshaw@micron.com,
        axboe@fb.com, tom.leiming@gmail.com, hch@infradead.org,
        rlnelson@google.com
Cc: linux-kernel@vger.kernel.org, linux-nvme@lists.infradead.org,
        =?UTF-8?q?Matias=20Bj=C3=B8rling?= <m@bjorling.me>
Subject: [PATCH v10] Convert NVMe driver to blk-mq
Date: Tue,  1 Jul 2014 16:53:01 +0200
Message-Id: <1404226382-7179-1-git-send-email-m@bjorling.me>
X-Mailer: git-send-email 1.9.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

Thanks for the feedback. I've rebased the patch on top of 3.16-rc3.

Willy, if you like to rebase your current patchset for 3.17 on top of rc3.
Then I'll rebase the patch on top. Thank you.

A branch with the patch on top is found here:

  https://github.com/MatiasBjorling/linux-collab nvmemq_review

and the separate changes can be found in the nvmemq_v10 branch

Changes since v9:
 * Rebased on top of Linus' v3.16-rc3.
 * Ming noted that we should remember to kick the request queue after requeue.
 * Jens noted a couple of superfluous warnings.
 * Christoph is removed from the contribution section. Instead he is going to
   be added as reviewed-by.

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
  * rebased on top of current 3.16/core.
  * use blk-mq queue management for spreading io queues
  * removed rcu handling and allocated all io queues up front for mgmt by blk-mq
  * removed the need for hotplugging notification
  * fixed flush data handling
  * fixed double free of spinlock
  * various cleanup

Matias Bjørling (1):
  NVMe: Convert to blk-mq

 drivers/block/nvme-core.c | 1219 ++++++++++++++++++---------------------------
 drivers/block/nvme-scsi.c |    8 +-
 include/linux/nvme.h      |   15 +-
 3 files changed, 489 insertions(+), 753 deletions(-)

-- 
1.9.1

