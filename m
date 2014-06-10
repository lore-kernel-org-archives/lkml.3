Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751494AbaFJJVh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jun 2014 05:21:37 -0400
Received: from mail-lb0-f180.google.com ([209.85.217.180]:57229 "EHLO
	mail-lb0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750771AbaFJJVg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jun 2014 05:21:36 -0400
From: =?UTF-8?q?Matias=20Bj=C3=B8rling?= <m@bjorling.me>
To: willy@linux.intel.com, keith.busch@intel.com, sbradshaw@micron.com,
        axboe@fb.com, tom.leiming@gmail.com, hch@infradead.org
Cc: linux-kernel@vger.kernel.org, linux-nvme@lists.infradead.org,
        =?UTF-8?q?Matias=20Bj=C3=B8rling?= <m@bjorling.me>
Subject: [PATCH v7] conversion to blk-mq
Date: Tue, 10 Jun 2014 11:20:37 +0200
Message-Id: <1402392038-5268-1-git-send-email-m@bjorling.me>
X-Mailer: git-send-email 1.9.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

I've rebased the patch on top of Jens' for-linus and Matthew's master.
The patch now applies cleanly when submitted upstream.

The bug reports seem to have calmed down. Ming reported a double completion bug
that is fixed in Jens' for-linus tree. We should be able to flesh out any
outstanding bugs in the 3.16-rc cycles.

Jens for-linus up to:

  2b8393b43ec672bb263009cd74c056ab01d6ac17
  blk-mq: add timer in blk_mq_start_request

Matthew master up to:

  bd67608a6127c994e897c49cc4f72d9095925301
  NVMe: Rename io_timeout to nvme_io_timeout

The merged trees with the patch on top is found here:

  https://github.com/MatiasBjorling/linux-collab nvmemq_review

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
  NVMe: conversion to blk-mq

 drivers/block/nvme-core.c | 1199 ++++++++++++++++++---------------------------
 drivers/block/nvme-scsi.c |    8 +-
 include/linux/nvme.h      |   15 +-
 3 files changed, 494 insertions(+), 728 deletions(-)

-- 
1.9.1

