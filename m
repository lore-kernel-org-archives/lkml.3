Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753052AbaATEF1 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Jan 2014 23:05:27 -0500
Received: from mail.linux-iscsi.org ([67.23.28.174]:44982 "EHLO
	linux-iscsi.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752585AbaATEFZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Jan 2014 23:05:25 -0500
From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
To: target-devel <target-devel@vger.kernel.org>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>,
        Kent Overstreet <kmo@daterainc.com>, Jens Axboe <axboe@kernel.dk>,
        Nicholas Bellinger <nab@linux-iscsi.org>
Subject: [PATCH-v2 0/3] percpu_ida+Co: Make percpu_ida_alloc accept task state bitmask
Date: Mon, 20 Jan 2014 03:44:43 +0000
Message-Id: <1390189486-13579-1-git-send-email-nab@linux-iscsi.org>
X-Mailer: git-send-email 1.7.2.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Nicholas Bellinger <nab@linux-iscsi.org>

Hi Linus,

Here is the -v2 series for converting percpu_ida_alloc() + consumer
usage to accept the task state bitmask parameter, w/o the extra
legacy gfp_t wrapper.

As requested, the first patch contains only the parameter change
to percpu_ida_alloc() + existing consumers, and makes no semantic
or behavior change.  This patch is CC'ed for stable, and will need
some light massaging to apply back to v3.12.y.

The second patch is a blk-mq cleanup to propigate the task state
bitmask usage up to the blk-mq vs. legacy split in blk_get_request().

The last patch fixes the original iscsi-target session reset bug
by passing TASK_INTERRUPTIBLE, and adds the signal_pending_state()
bit required in percpu_ida_alloc() code.  This is also CC'ed for
v3.12.y.

CC'ing Ingo + Peter for TASK_RUNNING + prepare_to_wait() bit.

Thank you,

--nab

Kent Overstreet (1):
  percpu_ida: Make percpu_ida_alloc + callers accept task state bitmask

Nicholas Bellinger (2):
  blk-mq: Convert gfp_t parameters to task state bitmask
  iscsi-target: Fix connection reset hang with percpu_ida_alloc

 block/blk-core.c                         |    4 +++-
 block/blk-flush.c                        |    2 +-
 block/blk-mq-tag.c                       |   14 +++++++-------
 block/blk-mq-tag.h                       |    2 +-
 block/blk-mq.c                           |   28 ++++++++++++++--------------
 drivers/target/iscsi/iscsi_target_util.c |    8 ++++++--
 drivers/target/tcm_fc/tfc_cmd.c          |    2 +-
 drivers/vhost/scsi.c                     |    2 +-
 include/linux/blk-mq.h                   |    4 ++--
 include/linux/percpu_ida.h               |    3 ++-
 lib/percpu_ida.c                         |   17 +++++++++++------
 11 files changed, 49 insertions(+), 37 deletions(-)

-- 
1.7.10.4

