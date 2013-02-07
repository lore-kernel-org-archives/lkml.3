Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758709Ab3BGN3N (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Feb 2013 08:29:13 -0500
Received: from mx1.redhat.com ([209.132.183.28]:27943 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758680Ab3BGN3K (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Feb 2013 08:29:10 -0500
From: Prarit Bhargava <prarit@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Prarit Bhargava <prarit@redhat.com>, John Stultz <johnstul@us.ibm.com>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: [RFE PATCH] time, Fix setting of hardware clock in NTP code
Date: Thu,  7 Feb 2013 08:29:01 -0500
Message-Id: <1360243741-25213-1-git-send-email-prarit@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I have found a long existing bug in the ntp code that causes a forwarding of
time equal to that of the local timezone every reboot.  This is the sequence
indicating what happens during boot.

+ start boot
|
+ rtc read, written as UTC into xtime/system clock.  This time is rtc0_time
  below.
|
|
+ ... rest of initial kernel boot, initramfs, etc.
|
|
+ systemd/initscript/etc: set timezone data through first call to settimeofday()
        - if LOCAL, a timezone offset is applied so that all applications "see"
           the system time as UTC, ie) sys_tz = {offset from UTC, 0}
        - if UTC, no timezone offset is applied, ie) sys_tz = {0,0};
+ The first settimeofday() calls warp_clock().  xtime (system time) is set to
  rtc time + sys_tz.tz_minuteswest .
  On my system, the difference between the rtc and the system time is now
  300 mins.
|
|
+ ntpd starts
+       - RHEL7: the first adjtimex() clears the STA_PLL flag.  This causes
          STA_UNSYNC to be cleared and the system time/xtime to be written to
          the rtc via update_persistent_clock().
                - if LOCAL, this means that the rtc now reads
                  rtc + sys_tz.tz_minuteswest; on my system this is rtc + 300.
                - if UTC, this means that the rtc on my system reads rtc + 0.

The problem with this model is what happens if /etc/adjtime is LOCAL, ie)
the rtc is set to localtime:

Reboot the system, on the next boot,
        rtc0_time = rtc + sys_tz.tz_minuteswest
Reboot the system, on the next boot,
        rtc0_time = rtc + sys_tz.tz_minuteswest + sys_tz.tz_minuteswest

AFAICT the only call to update_persistent_clock() in the kernel is the
ntp code.  It is wired in to allow ntp to occasionally update the system
clock.  Other calls to update the rtc are made directly through the
RTC_SET_TIME ioctl.

I believe that the value passed into update_persistent_time() is wrong.  It
should take into account the sys_tz data.  If the rtc is UTC, then the
offset is 0.  If the system is LOCAL, then there should be a 300 min offset
for the value of now.

We do not see this manifest on some architectures because they limit changes
to the rtc to +/-15 minutes of the current value of the rtc (x86, alpha,
mn10300).  Other arches do nothing (cris, mips, sh), and only a few seem to
show this problem (power, sparc).  I can reproduce this reliably on powerpc
with the latest Fedoras (17, 18, rawhide), as well as an Ubuntu powerpc spin.
I can also reproduce it "older" OSes such as RHEL6.

A few things about the patch.  'sys_time_offset' certainly could have a
better name and it could be a bool.  Also, technically I do not need to add the
'adjust' struct in sync_cmos_clock() as the value of now.tv_sec is not used
after being passed into update_persistent_clock().  However, I think the code
is easier to follow if I do add 'adjust'.

------8<---------

Take the timezone offset applied in warp_clock() into account when writing
the hardware clock in the ntp code.  This patch adds sys_time_offset which
indicates that an offset has been applied in warp_clock().

Signed-off-by: Prarit Bhargava <prarit@redhat.com>
Cc: John Stultz <johnstul@us.ibm.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
---
 include/linux/time.h |    1 +
 kernel/time.c        |    8 ++++++++
 kernel/time/ntp.c    |    8 ++++++--
 3 files changed, 15 insertions(+), 2 deletions(-)

diff --git a/include/linux/time.h b/include/linux/time.h
index 4d358e9..02754b5 100644
--- a/include/linux/time.h
+++ b/include/linux/time.h
@@ -117,6 +117,7 @@ static inline bool timespec_valid_strict(const struct timespec *ts)
 
 extern void read_persistent_clock(struct timespec *ts);
 extern void read_boot_clock(struct timespec *ts);
+extern int sys_time_offset;
 extern int update_persistent_clock(struct timespec now);
 void timekeeping_init(void);
 extern int timekeeping_suspended;
diff --git a/kernel/time.c b/kernel/time.c
index d226c6a..66533d3 100644
--- a/kernel/time.c
+++ b/kernel/time.c
@@ -115,6 +115,12 @@ SYSCALL_DEFINE2(gettimeofday, struct timeval __user *, tv,
 }
 
 /*
+ * Indicates if there is an offset between the system clock and the hardware
+ * clock/persistent clock/rtc.
+ */
+int sys_time_offset;
+
+/*
  * Adjust the time obtained from the CMOS to be UTC time instead of
  * local time.
  *
@@ -135,6 +141,8 @@ static inline void warp_clock(void)
 	struct timespec adjust;
 
 	adjust = current_kernel_time();
+	if (sys_tz.tz_minuteswest > 0)
+		sys_time_offset = 1;
 	adjust.tv_sec += sys_tz.tz_minuteswest * 60;
 	do_settimeofday(&adjust);
 }
diff --git a/kernel/time/ntp.c b/kernel/time/ntp.c
index 24174b4..39b88c4 100644
--- a/kernel/time/ntp.c
+++ b/kernel/time/ntp.c
@@ -510,8 +510,12 @@ static void sync_cmos_clock(struct work_struct *work)
 	}
 
 	getnstimeofday(&now);
-	if (abs(now.tv_nsec - (NSEC_PER_SEC / 2)) <= tick_nsec / 2)
-		fail = update_persistent_clock(now);
+	if (abs(now.tv_nsec - (NSEC_PER_SEC / 2)) <= tick_nsec / 2) {
+		struct timespec adjust = now;
+		if (sys_time_offset)
+			adjust.tv_sec -= (sys_tz.tz_minuteswest * 60);
+		fail = update_persistent_clock(adjust);
+	}
 
 	next.tv_nsec = (NSEC_PER_SEC / 2) - now.tv_nsec - (TICK_NSEC / 2);
 	if (next.tv_nsec <= 0)
-- 
1.7.9.3

