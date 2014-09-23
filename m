Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754446AbaIWFzX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Sep 2014 01:55:23 -0400
Received: from mail-qa0-f48.google.com ([209.85.216.48]:36918 "EHLO
	mail-qa0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752587AbaIWFzV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Sep 2014 01:55:21 -0400
From: Tejun Heo <tj@kernel.org>
To: linux-kernel@vger.kernel.org
Cc: kmo@daterainc.com, axboe@kernel.dk, hch@infradead.org, hannes@cmpxchg.org
Subject: [PATCHSET percpu/for-3.18] percpu_ref: implement switch_to_atomic/percpu()
Date: Tue, 23 Sep 2014 01:55:09 -0400
Message-Id: <1411451718-17807-1-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.9.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

Over the past several months, percpu_ref grew use cases where it's
used as a persistent on/off switch which may be cycled multiple times
using percpu_ref_reinit().  One of such use cases is blk-mq's
mq_usage_counter which tracks the number of in-flight commands and is
used to drain them.  Unfortunately, SCSI device probing involves
synchronously creating and destroying request_queues for non-existent
devices and the sched RCU grace period involved in percpu_ref killing
adds upto a significant amount of latency.

Block layer already experienced the same issue in other areas and
works around it by starting the queue in a degraded mode which is
faster to shut down and making it fully functional only after it's
known that the queue isn't a temporary one for probing.

This patchset implements percpu_ref mechanisms to manually switch
between atomic and percpu operation modes so that blk-mq can implement
a similar degraded operation mode.  This will also allow implementing
debug mode for percpu_ref so that underflow can be detected sooner.

This patchset contains the following nine patches.

 0001-percpu_ref-relocate-percpu_ref_reinit.patch
 0002-percpu_ref-minor-code-and-comment-updates.patch
 0003-percpu_ref-replace-pcpu_-prefix-with-percpu_.patch
 0004-percpu_ref-rename-things-to-prepare-for-decoupling-p.patch
 0005-percpu_ref-add-PCPU_REF_DEAD.patch
 0006-percpu_ref-decouple-switching-to-atomic-mode-and-kil.patch
 0007-percpu_ref-decouple-switching-to-percpu-mode-and-rei.patch
 0008-percpu_ref-add-PERCPU_REF_INIT_-flags.patch
 0009-percpu_ref-make-INIT_ATOMIC-and-switch_to_atomic-sti.patch

0001-0005 are prep patches.

0006-0007 implement percpu_ref_switch_to_atomic/percpu().

0008 extends percpu_ref_init() so that a percpu_ref can be initialized
in different states including atomic mode.

0009 makes atomic mode sticky so that it survives through reinits.

This patchset is on top of percpu/for-3.18 and available in the
following git branch.

 git://git.kernel.org/pub/scm/linux/kernel/git/tj/percpu.git review-percpu_ref-switch

diffstat follows.

 block/blk-mq.c                  |    2 
 fs/aio.c                        |    4 
 include/linux/percpu-refcount.h |  108 +++++++++-----
 kernel/cgroup.c                 |    7 
 lib/percpu-refcount.c           |  291 +++++++++++++++++++++++++++++-----------
 5 files changed, 295 insertions(+), 117 deletions(-)

Thanks.

--
tejun
