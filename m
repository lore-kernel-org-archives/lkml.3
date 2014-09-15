Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752514AbaIONLW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Sep 2014 09:11:22 -0400
Received: from mail-pa0-f46.google.com ([209.85.220.46]:42817 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751036AbaIONLV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Sep 2014 09:11:21 -0400
From: Ming Lei <ming.lei@canonical.com>
To: Jens Axboe <axboe@kernel.dk>, linux-kernel@vger.kernel.org
Cc: Christoph Hellwig <hch@lst.de>
Subject: [PATCH v4 0/10] block: per-distpatch_queue flush machinery
Date: Mon, 15 Sep 2014 21:11:04 +0800
Message-Id: <1410786675-7761-1-git-send-email-ming.lei@canonical.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

As recent discussion, especially suggested by Christoph, this patchset
implements per-distpatch_queue flush machinery, so that:

	- current init_request and exit_request callbacks can
	cover flush request too, then the buggy copying way of
	initializing flush request's pdu can be fixed

	- flushing performance gets improved in case of multi hw-queue

About 70% throughput improvement is observed in sync write
over multi dispatch-queue virtio-blk, see details in commit log
of patch 10/10.

This patchset can be pulled from below tree too:

	git://kernel.ubuntu.com/ming/linux.git v3.17-block-dev-flush_v4

V4:
	- remove pdu copy from original request to flush request
	- don't call blk_free_flush_queue for !q->mq_ops

V3:
	- don't return failure code from blk_alloc_flush_queue() to
	avoid freeing invalid buffer in case of allocation failure
	- remove blk_init_flush() and blk_exit_flush()
	- remove unnecessary WARN_ON() from blk_alloc_flush_queue()
V2:
	- refactor blk_mq_init_hw_queues() and its pair, also it is a fix
	on failure path, so that conversion to per-queue flush becomes simple.
	- allocate/initialize flush queue in blk_mq_init_hw_queues()
	- add sync write tests on virtio-blk which is backed by SSD image

V1:
	- commit log typo fix
	- introduce blk_alloc_flush_queue() and its pair earlier, so
	that patch 5 and 8 become easier for review

 block/blk-core.c       |   12 ++--
 block/blk-flush.c      |  138 +++++++++++++++++++++++++------------
 block/blk-mq.c         |  180 +++++++++++++++++++++++++++---------------------
 block/blk-mq.h         |    1 -
 block/blk-sysfs.c      |    4 +-
 block/blk.h            |   35 +++++++++-
 include/linux/blk-mq.h |    2 +
 include/linux/blkdev.h |   10 +--
 8 files changed, 238 insertions(+), 144 deletions(-)

Thanks,
--
Ming Lei

