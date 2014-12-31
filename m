Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751669AbaLaNXK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Dec 2014 08:23:10 -0500
Received: from mail-yh0-f49.google.com ([209.85.213.49]:39129 "EHLO
	mail-yh0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751210AbaLaNXI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Dec 2014 08:23:08 -0500
From: Ming Lei <ming.lei@canonical.com>
To: Jens Axboe <axboe@fb.com>, linux-kernel@vger.kernel.org
Cc: Christoph Hellwig <hch@lst.de>, Robert Elliott <elliott@hp.com>
Subject: [PATCH v3 0/5] block: loop: convert to blk-mq
Date: Wed, 31 Dec 2014 13:22:55 +0000
Message-Id: <1420032180-30256-1-git-send-email-ming.lei@canonical.com>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

The following 5 patches convert current loop driver into blk-mq:

	- loop's throughput of read and randread can get improved much
	because of the work queue implementation, also there is opportunity
	for blk-mq to merge I/O from loop block
	- loop driver gets quite simplified with blk-mq because there is
	the whole request based framework and something like flush mechanism,
	and the conversion can be throught as cleanup

V3:
        - rebased on v3.19-rc2-next20141231
        - submit I/O via workqueue
        - don't handle write requests concurrently
        - set flag of BLK_MQ_F_SG_MERGE
        - fix failure path in patch 2/5

V2:
        - replace work queue with kthread worker because wq may cause
        regression on some fast devices(such as loop over null_blk, tmpfs
        file, ...), in these cases, loop thread becomes CPU bound actually,
        so work queue will introduce lots of unnecessary context switch, and
        decrease throughput a lot one this cases
        - introduce prepare_flush_rq_fn callback and its pair in blk-mq ops
        for setting up flush rq's pdu correctly
        - move kernel aio patches into another patchset as suggested by
        Christoph
        - no change in the other 4 patches

V1:
        - improve failure path in aio_kernel_submit()

 block/blk-mq.c         |    4 +-
 block/blk-mq.h         |    1 -
 drivers/block/loop.c   |  417 ++++++++++++++++++++++++------------------------
 drivers/block/loop.h   |   17 +-
 include/linux/blk-mq.h |    2 +
 5 files changed, 221 insertions(+), 220 deletions(-)

Thanks,
Ming Lei


