Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755368AbaHNPvB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Aug 2014 11:51:01 -0400
Received: from mail-pd0-f170.google.com ([209.85.192.170]:33890 "EHLO
	mail-pd0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755103AbaHNPu7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Aug 2014 11:50:59 -0400
From: Ming Lei <ming.lei@canonical.com>
To: Jens Axboe <axboe@kernel.dk>, linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Dave Kleikamp <dave.kleikamp@oracle.com>
Cc: Zach Brown <zab@zabbo.net>, Benjamin LaHaise <bcrl@kvack.org>,
        Christoph Hellwig <hch@infradead.org>,
        Kent Overstreet <kmo@daterainc.com>, linux-aio@kvack.org,
        linux-fsdevel@vger.kernel.org, Dave Chinner <david@fromorbit.com>
Subject: [PATCH v1 0/9] block & aio: kernel aio and loop mq conversion
Date: Thu, 14 Aug 2014 23:50:31 +0800
Message-Id: <1408031441-31156-1-git-send-email-ming.lei@canonical.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

The 1st two patches introduce kernel AIO support, most of
is borrowed from Dave's work last year, and thanks to ITER_BVEC,
it is much simper to implement kernel AIO now. AIO model
is quite suitable for implementing kernel stuff, and can
help improve both throughput and CPU utilization. Lots of
kernel components should benefit from it, such as:
	- loop driver,
	- all kinds of kernel I/O target driver(SCSI, USB storage
	or UAS, ...)
	- kernel socket users might benefit from it too if socket
	AIO is mature

The following 6 patches convert current loop driver into blk-mq:
	- loop's scalability gets improved much
	- loop driver gets quite simplified, and the conversion can
	be throught as cleanup too

The 9th patch uses kernel AIO with O_DIRECT to improve loop's
performance in single job situation, and avoid double cache
issue for loop driver too.

With the change, loop block's performance can be doubled in my
fio test(randread, single job, libaio). If more fio jobs are used,
the throughput can be improved much more because of blk-mq.

Given loop is used quite widely, especially in VM environment,
also the change is quite small, hope it can be merged finally.

V1:
	- improve failure path in aio_kernel_submit()


 block/blk-mq.c            |   11 +-
 block/blk-mq.h            |    1 -
 drivers/block/loop.c      |  474 +++++++++++++++++++++++++--------------------
 drivers/block/loop.h      |   15 +-
 fs/aio.c                  |  121 ++++++++++++
 fs/direct-io.c            |    9 +-
 include/linux/aio.h       |   15 +-
 include/linux/blk-mq.h    |   13 ++
 include/uapi/linux/loop.h |    1 +
 9 files changed, 439 insertions(+), 221 deletions(-)


Thanks,
--
Ming Lei


