Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756011AbaDWDhr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Apr 2014 23:37:47 -0400
Received: from mail-pb0-f41.google.com ([209.85.160.41]:34984 "EHLO
	mail-pb0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755552AbaDWDhH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Apr 2014 23:37:07 -0400
From: John Stultz <john.stultz@linaro.org>
To: LKML <linux-kernel@vger.kernel.org>
Cc: John Stultz <john.stultz@linaro.org>, Jan Kara <jack@suse.cz>,
        Peter Zijlstra <peterz@infradead.org>, Jiri Bohac <jbohac@suse.cz>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [RFC][PATCH 0/3] Convert timekeeping core to use printk_deferred
Date: Tue, 22 Apr 2014 20:36:55 -0700
Message-Id: <1398224218-4429-1-git-send-email-john.stultz@linaro.org>
X-Mailer: git-send-email 1.8.3.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jiri pointed out a potential deadlock when calling printk while holding
the timekeeping seqlock.

Annoyingly, the seqlock lockdep enablement doesn't catch this, as
printk disables lockdep.

When looking for possible solutions, one idea was to use a local buffer
and defer the printk to later. Ends up there is already similar
functionality in printk_sched() to avoid similar style deadlocks w/
the scheduler. 

Thus this patchset renames printk_sched to printk_deferred and then
moves the affected timekeeping printks to make use of it.

There were some points in the discussion between Jan and Peter that
made it seem that there may still be problems lurking in the console
layer, and I'm not sure I fully understand their point, so this solution
may be incomplete.

Additionally, the same issue likely affects any WARN_ONs as well, but
I wanted to get some thoughts on this approach before trying to remove
or convert affected WARN_ONS.

Your thoughts and feedback are greatly appreciated!

thanks
-john


Cc: Jan Kara <jack@suse.cz>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Jiri Bohac <jbohac@suse.cz>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>

John Stultz (3):
  printk: Rename printk_sched to printk_deferred
  printk: Add printk_once_deferred
  timekeeping: Use printk_deferred when holding timekeeping seqlock

 include/linux/printk.h    | 17 ++++++++++++++---
 kernel/printk/printk.c    |  8 ++++----
 kernel/sched/core.c       |  2 +-
 kernel/sched/deadline.c   |  7 +------
 kernel/sched/rt.c         |  8 +-------
 kernel/time/ntp.c         | 15 +++++++++------
 kernel/time/timekeeping.c |  7 ++++---
 7 files changed, 34 insertions(+), 30 deletions(-)

-- 
1.8.3.2

