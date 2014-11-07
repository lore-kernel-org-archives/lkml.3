Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752877AbaKGWEN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Nov 2014 17:04:13 -0500
Received: from mail-wg0-f41.google.com ([74.125.82.41]:53463 "EHLO
	mail-wg0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752470AbaKGWEM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Nov 2014 17:04:12 -0500
From: Paolo Bonzini <pbonzini@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Jens Axboe <axboe@kernel.dk>, Thomas Gleixner <tglx@linutronix.de>,
        Clark Williams <williams@redhat.com>
Subject: [PATCH 0/2] blk-mq: switch from preempt_disable/enable to get/put_cpu
Date: Fri,  7 Nov 2014 23:03:58 +0100
Message-Id: <1415397840-18041-1-git-send-email-pbonzini@redhat.com>
X-Mailer: git-send-email 2.1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

blk-mq is using preempt_disable/enable in order to ensure that the
queue runners are placed on the right CPU.  This does not work with
the RT patches, because __blk_mq_run_hw_queue takes a non-raw
spinlock with the preemption-disabled region.  If there is contention
on the lock, this violates the rules for preemption-disabled regions.

While this could be fixed easily within the RT patches just by doing
migrate_disable/enable (note: this was not tested :)), we can do
better.  The first patch concentrates the preempt_disable/enable in
a single place in blk_mq_run_hw_queue, and also avoids useless calls
when the caller wants to start __blk_mq_run_hw_queue asynchronously.
(There is already a call to __blk_mq_run_hw_queue that does not disable
preemption in blk-flush.c; not coincidentially, it passes async=true).

Once this is done, it is trivial to use get/put_cpu instead of
preempt_disable/smp_processor_id/preempt_enable, which is what the
second patch does.  The RT patches then can change this to use
get_cpu_light.

With these changes (and the additional switch to get_cpu_light),
virtio-blk can be used again with RT kernels.

Paolo

Paolo Bonzini (2):
  blk_mq: call preempt_disable/enable in blk_mq_run_hw_queue, and only
    if needed
  blk-mq: use get_cpu/put_cpu instead of preempt_disable/preempt_enable

 block/blk-mq.c | 21 ++++++++++++---------
 1 file changed, 12 insertions(+), 9 deletions(-)

-- 
2.1.0

