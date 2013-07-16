Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933606Ab3GPRe4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Jul 2013 13:34:56 -0400
Received: from mail-qe0-f54.google.com ([209.85.128.54]:53816 "EHLO
	mail-qe0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933481Ab3GPRex (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Jul 2013 13:34:53 -0400
From: Richard Henderson <rth@twiddle.net>
To: linux-kernel@vger.kernel.org
Cc: ink@jurassic.park.msu.ru, mattst88@gmail.com, linux-alpha@vger.kernel.org
Subject: [RFC PATCH 00/10] Alpha support for QEMU
Date: Tue, 16 Jul 2013 10:34:08 -0700
Message-Id: <1373996058-13399-1-git-send-email-rth@twiddle.net>
X-Mailer: git-send-email 1.8.1.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

While there are 3 patches in this series that are specifically related
to QEMU, there are 3 more that significantly re-architect generic parts
of arch/alpha that hopefully bring them more into line with current
linux-kernel design, and 2 more that seem like they ought to work
generically, but ought to be tested on real hardware.  In particular:

 1/10: Ought to have no effect on real hw, since the "interrupt handling"
       was a printk.

 5/10: Ought to work, and result in cooler cpus, on real hardware.  That
       said, excersising parts of random PALcodes on misc machines is
       surely doomed to failure.  I can well imagine that we'll need
       some sort of black/white-list for the various machines.

 6/10: Ought to work better for Marvel, since more accesses to the RTC
       are now being vectored across the smp-call.  OTOH, I could have
       introduced a silly typo somewhere.

 9/10: Probably the most significant cleanup, and the one most likely to
       have something subtle go wrong on the various machines.

The series seems pretty stable under QEMU, but I have no real hardware
on which to test -- the whole reason I'm interested in QEMU of course.
So I'm hoping that someone will notice this and help me out with testing.

In addition, if folks more familiar with the various kernel/time or
driver/rtc interfaces spot anything I'm doing wrong in the rewrite,
please let me know.


r~


Richard Henderson (10):
  alpha: Don't if-out dp264_device_interrupt.
  alpha: Notice if we're being run under QEMU
  alpha: Force the user-visible HZ to a constant 1024.
  alpha: Allow HZ to be configured
  alpha: Primitive support for CPU power down.
  alpha: Reorganize rtc handling
  alpha: Add an rtc driver for the qemu wallclock PALcall
  alpha: Always enable the rpcc clocksource for single processor
  alpha: Switch to GENERIC_CLOCKEVENTS
  alpha: Use qemu+cserve provided high-res clock and alarm.

 arch/alpha/Kconfig                  |  52 ++++-
 arch/alpha/include/asm/machvec.h    |  22 +-
 arch/alpha/include/asm/pal.h        |  71 +++++++
 arch/alpha/include/asm/param.h      |   8 +-
 arch/alpha/include/asm/rtc.h        |  11 -
 arch/alpha/include/uapi/asm/pal.h   |   1 +
 arch/alpha/include/uapi/asm/param.h |   7 -
 arch/alpha/kernel/Makefile          |   2 +-
 arch/alpha/kernel/irq_alpha.c       |  16 +-
 arch/alpha/kernel/machvec_impl.h    |   5 +-
 arch/alpha/kernel/process.c         |  15 ++
 arch/alpha/kernel/proto.h           |  13 +-
 arch/alpha/kernel/rtc.c             | 374 +++++++++++++++++++++++++++++++++
 arch/alpha/kernel/setup.c           |  23 +-
 arch/alpha/kernel/smp.c             |  33 +--
 arch/alpha/kernel/sys_dp264.c       |   8 -
 arch/alpha/kernel/sys_jensen.c      |   2 -
 arch/alpha/kernel/sys_marvel.c      |  55 +----
 arch/alpha/kernel/time.c            | 403 ++++++++++++++++--------------------
 arch/alpha/kernel/traps.c           |  12 ++
 drivers/rtc/Kconfig                 |  17 +-
 21 files changed, 767 insertions(+), 383 deletions(-)
 create mode 100644 arch/alpha/kernel/rtc.c

-- 
1.8.1.4

