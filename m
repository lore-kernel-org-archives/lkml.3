Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933171Ab3CYUI0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Mar 2013 16:08:26 -0400
Received: from mail-pa0-f42.google.com ([209.85.220.42]:39454 "EHLO
	mail-pa0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932801Ab3CYUIZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Mar 2013 16:08:25 -0400
From: John Stultz <john.stultz@linaro.org>
To: lkml <linux-kernel@vger.kernel.org>
Cc: John Stultz <john.stultz@linaro.org>, Thomas Gleixner <tglx@linutronix.de>,
        Richard Cochran <richardcochran@gmail.com>,
        Prarit Bhargava <prarit@redhat.com>
Subject: [PATCH 0/8] Move ntp state to be protected by timekeeping lock
Date: Mon, 25 Mar 2013 13:08:10 -0700
Message-Id: <1364242098-5977-1-git-send-email-john.stultz@linaro.org>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

So this is sort of a frustrating patchset, as previously much work
had been done to split the NTP state out from being protected by the
xtime_lock of yore. But apparently the crystal ball was foggy back
then.

For some time now, Thomas and Eric have been pushing to use
shadow-updates on the timekeeping state. Basically he's split the
timekeeping seq lock into a  spinlock and a seqcounter. On updates,
one much take the spinlock and the seqcount write lock. And on the
read-side you just take the seqcount readlock.

The benefit with this appraoch is that classically timekeeping
updates can be somewhat calculation heavy and can take some time.
This new lock-splitting allows us  to just take the spinlock,
blocking only other updaters, and using  a shadow copy of the
timekeeping state calculate the update. Then we only take the
seqcounter write lock for a very short time in order to copy over
the pre-calculated shadow-time state. This allows for much reduced
write-side lock hold times on the timekeeping lock, which avoids
blocking timekeeping readers for the entire update.

In his realtime testing, this reduces his worst case latencies from
8us to 4us, which is a very attractive improvement.

The problem of course, is that the new asynchronous behavior the
shadow updates breaks some of the assumptions on how the NTP state
is used. Thus to correct this, we really need to serialize the ntp
state updates along with the timekeeping state. With the added side
benefit that of reducing lock acquisitions.

The downside is that the timekeeping state has been cleaned up to
live nicely in the timekeeper struct, which nicely bounded what the
timekeeping lock protected. Where as 99% of the NTP state was all
static to ntp.c, and was protected by the ntp.c static ntp_lock, so
it was all nicely encapsulated as well. 

This patchset makes the lock ownership lines less obvious, but I've
been sure to keep the ntp state static to ntp.c and instead provided
some accessors via ntp-internal.h that timekeping code can use to
make changes.  The only really ugly part is that do_adjtimex() has
to split some of the logic between timekeeping.c and ntp.c in order
to really get the locking done correctly.

I may try to rework the code in the future so that the timekeeper
holds the ntp state and passes it to the ntp.c functions to be
modified, but that is a much deeper rework then I'd like to do right
now, and causes fruther complexity to the shadow-state updates, since
we'd end up unnecessarily copying the ntp state back and forth every
time.

This applies on top of my fortglx/3.10/time queue here:
git://git.linaro.org/people/jstultz/linux.git fortglx/3.10/time

If you want to see this entire set (along with Thomas' shadow-update
work) it can be found here:
git://git.linaro.org/people/jstultz/linux.git dev/tglx-shadowtime
or 
http://git.linaro.org/gitweb?p=people/jstultz/linux.git;a=shortlog;h=refs/heads/dev/tglx-shadowtime


Let me know if you have any feedback or comments!

thanks
-john

Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Richard Cochran <richardcochran@gmail.com>
Cc: Prarit Bhargava <prarit@redhat.com>

John Stultz (8):
  ntp: Split out timex validation from do_adjtimex
  ntp: Move do_adjtimex() and hardpps() functions to timekeeping.c
  ntp: Move timex validation to timekeeping do_adjtimex call.
  ntp: Rework do_adjtimex to take timespec and tai arguments
  timekeeping: Move ADJ_SETOFFSET to top level do_adjtimex()
  timekeeping: Hold timekeepering locks in do_adjtimex and hardpps
  timekeeping: Simplify tai updating from do_adjtimex
  ntp: Remove ntp_lock, using the timekeeping locks to protect ntp
    state

 include/linux/timex.h      |    7 ----
 kernel/time/ntp.c          |   99 +++++++++++++-------------------------------
 kernel/time/ntp_internal.h |   12 ++++++
 kernel/time/timekeeping.c  |   66 ++++++++++++++++++++++++++++-
 4 files changed, 104 insertions(+), 80 deletions(-)
 create mode 100644 kernel/time/ntp_internal.h

-- 
1.7.10.4

