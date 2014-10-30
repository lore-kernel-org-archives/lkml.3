Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759141AbaJ3LQc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Oct 2014 07:16:32 -0400
Received: from mail-pd0-f169.google.com ([209.85.192.169]:54878 "EHLO
	mail-pd0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758662AbaJ3LQb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Oct 2014 07:16:31 -0400
From: "pang.xunlei" <pang.xunlei@linaro.org>
To: linux-kernel@vger.kernel.org
Cc: rtc-linux@googlegroups.com, xen-devel@lists.xenproject.org,
        John Stultz <john.stultz@linaro.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Alessandro Zummo <a.zummo@towertech.it>,
        Stefano Stabellini <stefano.stabellini@eu.citrix.com>,
        "pang.xunlei" <pang.xunlei@linaro.org>
Subject: [RFC PATCH v2 00/11] Convert do_settimeofday() to use timespec64
Date: Thu, 30 Oct 2014 19:15:34 +0800
Message-Id: <1414667745-7703-1-git-send-email-pang.xunlei@linaro.org>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The kernel uses 32-bit signed value(time_t) for seconds since 
1970-01-01:00:00:00, so it will overflow at 2038-01-19 03:14:08 on 
32-bit systems. We call this "2038 safety" issue.

Currently, I'm working with "John Stultz" to deal with this issue.

This series doesn't involve any functional change, and mainly converts 
do_settimeofday() to use timespec64(By adding new do_settimeofday64() 
using timespec64). During the conversion, it needs to handle mktime(), 
rtc_tm_to_time(), rtc_time_to_tm() and other functions similarly due 
to dependencies.

The main processing logic here is:
Add xxx64() safe version:
	*Add do_settimeofday64() safe version(using timespec64)
	*Add mktime64() safe version(using time64_t)
	*Add rtc_tm_to_time64() safe version(using time64_t)
	*Add rtc_time_to_tm64() safe version(using time64_t)

Clean unsafe do_settimeofday():
	*Convert all users of do_settimeofday() to use do_settimeofday64()
	*Remove do_settimeofday()
	*Try the best to eliminate TODOs brought by these patches

Clean unsafe mktime()/rtc_tm_to_time()/rtc_time_to_tm() respectively:
	*Convert all users of xxx() to use xxx64() one by one
	*Try the best to eliminate TODOs brought by these patches
	*Remove xxx()

So the rest of this patch series does tons of work on these conversions.

NOTE: This series actually contains 153 patches in total, but just sent
out a small subset here for feedback to make sure there are no objections
with my approach. 

Please access the link below for all the related patches if interested:
https://git.linaro.org/people/pang.xunlei/linuxstable.git

pang.xunlei (11):
  time: Add do_settimeofday64() safe version(using timespec64)
  time: Add mktime64() safe version(using time64_t)
  time: Add rtc_tm_to_time64() safe version(using time64_t)
  time: Add rtc_time_to_tm64() safe version(using time64_t)
  time: Convert all users of do_settimeofday() to use
    do_settimeofday64()
  time: Remove do_settimeofday()
  time: Convert alarm_set_rtc() to use timespec64
  time: Convert xen_read_wallclock() to use timespec64
  time: Convert pvclock_read_wallclock() to use timespec64
  time: Convert x86_platform.set_wallclock()to use timespec64
  time: Convert x86_platform.get_wallclock()to use timespec64

 arch/x86/include/asm/intel_mid_vrtc.h        |    4 +-
 arch/x86/include/asm/mc146818rtc.h           |    4 +-
 arch/x86/include/asm/pvclock.h               |    2 +-
 arch/x86/include/asm/x86_init.h              |   11 ++++--
 arch/x86/kernel/kvmclock.c                   |    6 +--
 arch/x86/kernel/pvclock.c                    |    9 +++--
 arch/x86/kernel/rtc.c                        |   30 ++++++++++-----
 arch/x86/lguest/boot.c                       |    4 +-
 arch/x86/platform/intel-mid/intel_mid_vrtc.c |   12 +++---
 arch/x86/xen/time.c                          |   13 +++----
 drivers/hv/hv_util.c                         |    6 +--
 drivers/rtc/hctosys.c                        |   10 ++---
 drivers/rtc/rtc-lib.c                        |   35 ++++++++++++++---
 drivers/staging/android/alarm-dev.c          |   14 +++++--
 include/linux/lguest.h                       |    2 +-
 include/linux/rtc.h                          |    2 +
 include/linux/time.h                         |    4 ++
 include/linux/time64.h                       |    5 ++-
 include/linux/timekeeping.h                  |    2 +-
 kernel/compat.c                              |    5 ++-
 kernel/time/time.c                           |   52 ++++++++++++++++++++++++--
 kernel/time/timekeeping.c                    |   20 +++++-----
 22 files changed, 176 insertions(+), 76 deletions(-)

-- 
1.7.9.5

