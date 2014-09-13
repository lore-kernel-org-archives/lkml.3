Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751877AbaIMNw4 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Sep 2014 09:52:56 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:36204 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751644AbaIMNwz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Sep 2014 09:52:55 -0400
MIME-Version: 1.0
In-Reply-To: <1410577674-17019-1-git-send-email-ming.lei@canonical.com>
References: <1410577674-17019-1-git-send-email-ming.lei@canonical.com>
Date: Sat, 13 Sep 2014 21:52:52 +0800
Message-ID: <CACVXFVMyYWHHOhQQObkaUSnf+CUB5NhD-RTFJCgqciotj85D9w@mail.gmail.com>
Subject: Re: [PATCH v3 0/10] block: per-distpatch_queue flush machinery
From: Ming Lei <ming.lei@canonical.com>
To: Jens Axboe <axboe@kernel.dk>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Cc: Christoph Hellwig <hch@lst.de>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Sep 13, 2014 at 11:07 AM, Ming Lei <ming.lei@canonical.com> wrote:
> Hi,
>
> As recent discussion, especially suggested by Christoph, this patchset
> implements per-distpatch_queue flush machinery, so that:
>
>         - current init_request and exit_request callbacks can
>         cover flush request too, then the buggy copying way of
>         initializing flush request's pdu can be fixed
>
>         - flushing performance gets improved in case of multi hw-queue
>
> About 70% throughput improvement is observed in sync write
> over multi dispatch-queue virtio-blk, see details in commit log
> of patch 10/10.
>
> This patchset can be pulled from below tree too:
>
>         git://kernel.ubuntu.com/ming/linux.git v3.17-block-dev_v3
>
> V3:
>         - don't return failure code from blk_alloc_flush_queue() to
>         avoid freeing invalid buffer in case of allocation failure
>         - remove blk_init_flush() and blk_exit_flush()
>         - remove unnecessary WARN_ON() from blk_alloc_flush_queue()

Looks there are still two problems in V3:

- blk_free_flush_queue() should be called only for legacy queue after
the patch 10's conversion

- pdu copy should be removed from blk_mq_clone_flush_request()

I will post V4 once these two problems are fixed.

Thanks,
>
> V2:
>         - refactor blk_mq_init_hw_queues() and its pair, also it is a fix
>         on failure path, so that conversion to per-queue flush becomes simple.
>         - allocate/initialize flush queue in blk_mq_init_hw_queues()
>         - add sync write tests on virtio-blk which is backed by SSD image
>
> V1:
>         - commit log typo fix
>         - introduce blk_alloc_flush_queue() and its pair earlier, so
>         that patch 5 and 8 become easier for review
>
>  block/blk-core.c       |   12 ++--
>  block/blk-flush.c      |  129 +++++++++++++++++++++++++-------------
>  block/blk-mq.c         |  160 ++++++++++++++++++++++++++++++------------------
>  block/blk-mq.h         |    1 -
>  block/blk-sysfs.c      |    4 +-
>  block/blk.h            |   35 ++++++++++-
>  include/linux/blk-mq.h |    2 +
>  include/linux/blkdev.h |   10 +--
>  8 files changed, 230 insertions(+), 123 deletions(-)
>
>
>
> Thanks,
> --
> Ming Lei
>
>
