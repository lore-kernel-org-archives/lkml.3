Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753415Ab3LTS7z (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Dec 2013 13:59:55 -0500
Received: from mail-pa0-f50.google.com ([209.85.220.50]:40581 "EHLO
	mail-pa0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751797Ab3LTS7y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Dec 2013 13:59:54 -0500
From: John Stultz <john.stultz@linaro.org>
To: LKML <linux-kernel@vger.kernel.org>
Cc: John Stultz <john.stultz@linaro.org>, Sasha Levin <sasha.levin@oracle.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Prarit Bhargava <prarit@redhat.com>,
        Richard Cochran <richardcochran@gmail.com>,
        Ingo Molnar <mingo@kernel.org>
Subject: [PATCH 0/3] Timekeeping fixes for 3.13? (v2)
Date: Fri, 20 Dec 2013 10:59:43 -0800
Message-Id: <1387565986-11738-1-git-send-email-john.stultz@linaro.org>
X-Mailer: git-send-email 1.8.3.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hey Ingo, Thomas,
	Here are the timekeeping fixes I was hoping to submit for 3.13,
including  the variable naming tweaks you wanted to see.

However, as I've been thinking about this a bit more, I'm a little
on the fence about sending these out this late in the -rc cycle. The 
lockdep splat is new in 3.13 due to the seqlock lockdep enablement,
but the actual potential deadlock is not new.

Also, given its so close to the holiday week, it might be wise to push
off to 3.14 with these. Does that sound reasonable?  If so please just
apply to tip/timers/core instead, and I'll send Thomas the rest of my
3.14 queue soon.


The changes here are:

The first is a regression caused by the shadow time code that
causes the tai offset to be overwritten. This keeps ntpd from being
able to initialize the tai_offset.

The second fixes an issue where the action flag returned from
accumulate_nsecs_to_secs was not being passed all the way down
to where we update the pv notifiers. While not critical, this
change is a prerequisite for the following critical fix.

The last patch fixes the potential timekeeping/hrtimer
deadlock Sasha found caused by clock_was_set_delayed() not actually
being safe to call while holding the timekeeping lock. This
leverages the previous patch to move the call outside the lock.

I have a number of other fixes queued, including the cleanup to the
tick code that will let us stop using clock_was_set_delayed all
together in the timekeeping code, but I'll save those for 3.14.

thanks
-john

Cc: Sasha Levin <sasha.levin@oracle.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Prarit Bhargava <prarit@redhat.com>
Cc: Richard Cochran <richardcochran@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>




John Stultz (3):
  timekeeping: Fix lost updates to tai adjustment
  timekeeping: Fix potential lost pv notification of time change
  timekeeping: Avoid possible deadlock from clock_was_set_delayed

 kernel/time/timekeeping.c | 41 +++++++++++++++++++++++++++++------------
 1 file changed, 29 insertions(+), 12 deletions(-)

-- 
1.8.3.2

