Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753442AbaIYPYF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Sep 2014 11:24:05 -0400
Received: from mail-pd0-f178.google.com ([209.85.192.178]:56962 "EHLO
	mail-pd0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752350AbaIYPYD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Sep 2014 11:24:03 -0400
From: Ming Lei <ming.lei@canonical.com>
To: linux-kernel@vger.kernel.org
Cc: Jens Axboe <axboe@kernel.dk>, Christoph Hellwig <hch@lst.de>
Subject: [PATCH v5 0/10] block: per-distpatch_queue flush machinery
Date: Thu, 25 Sep 2014 23:23:37 +0800
Message-Id: <1411658627-19754-1-git-send-email-ming.lei@canonical.com>
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

        git://kernel.ubuntu.com/ming/linux.git v3.17-block-dev-flush_v5

V5:
	- make the failure path fix and cleanup patch as 1st one
	- fix oops in case of bio based request queue(patch 6)
	- pass 'node' to blk_alloc_flush_queue() instead of 'hctx'(patch 10)
	- comment on init_request/exit_request about flush request(patch 10)

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

 block/blk-core.c       |   13 ++--
 block/blk-flush.c      |  141 +++++++++++++++++++++++++------------
 block/blk-mq.c         |  180 +++++++++++++++++++++++++++---------------------
 block/blk-mq.h         |    1 -
 block/blk-sysfs.c      |    4 +-
 block/blk.h            |   35 +++++++++-
 include/linux/blk-mq.h |    6 ++
 include/linux/blkdev.h |   10 +--
 8 files changed, 246 insertions(+), 144 deletions(-)


thanks,
--
Ming Lei

