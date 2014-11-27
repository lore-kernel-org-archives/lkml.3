Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754865AbaK0MDZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Nov 2014 07:03:25 -0500
Received: from mail-pd0-f178.google.com ([209.85.192.178]:47155 "EHLO
	mail-pd0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753388AbaK0MDP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Nov 2014 07:03:15 -0500
From: Xunlei Pang <pang.xunlei@linaro.org>
To: linux-kernel@vger.kernel.org
Cc: rtc-linux@googlegroups.com, Thomas Gleixner <tglx@linutronix.de>,
        Alessandro Zummo <a.zummo@towertech.it>,
        Sven Schnelle <svens@stackframe.org>,
        Xunlei Pang <pang.xunlei@linaro.org>,
        John Stultz <john.stultz@linaro.org>,
        Arnd Bergmann <arnd.bergmann@linaro.org>
Subject: [RFC PATCH 0/4] Add rtc 64bit epoch offset for rtc hardware that only provides 32bit time
Date: Thu, 27 Nov 2014 20:02:36 +0800
Message-Id: <1417089760-26848-1-git-send-email-pang.xunlei@linaro.org>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On some systems the rtc hardware may only provide 32bits of time.
This is problematic, as the hardware won't be able to provide
post-y2038 times to initialize the system at boot.

Thus this patch series provides a 64bit epoch offset, which can be
configured to allow the 32bit rtc hardware to represent times past
2038, and also demonstrates how to use the newly-added interfaces
based on rtc epoch offset to eliminate y2038/y2106 issues existing
in many current rtc drivers despite the above-mentioned rtc hardware
limitations.

Patch 1:
mxc_rtc_set_mmss() is one y2038-unsafe user of rtc_class_ops.set_mmss(),
but it uses get_alarm_or_time()/set_alarm_or_time() internal interfaces
which are also y2038 unsafe. The handling of these two internal interfaces
has enough complexity to require a separate patch, so we process it here
before converting rtc_class_ops.set_mmss() which will be done in Patch 2.
Currently, "mxc" is the only driver with such issue.

Patch 2:
Converts rtc_class_ops.set_mmss() to use time64_t, so lays some groundwork
for making rtc drivers y2038/y2106 safe.

Patch 3:
Provides two new interfaces based on the rtc epoch offset to map between
32bit hardware time and 64bit time. We can use them to make 32bit hardware
rtc drivers y2038/y2106 safe.

Patch 4:
Now thanks to foregoing jobs, it's time to provide an example to demonstrate
how to address all 32bit time issues in a single rtc driver(imxdi) whose
rtc hardware only provides 32bit time.

If there're no objections with my approach, I'll go on with the work
to make all the rtc drivers under "drivers/rtc" y2038/y2106 safe.

NOTE: This patch series relies on the former patch series named:
"y2038 in-kernel interface changes for drivers/rtc".

Cc: John Stultz <john.stultz@linaro.org>
Cc: Arnd Bergmann <arnd.bergmann@linaro.org>

Xunlei Pang (4):
  rtc/mxc: Convert get_alarm_or_time()/set_alarm_or_time() to use
    time64_t
  rtc: Convert rtc_class_ops.set_mmss() to use time64_t
  rtc/lib: Provide interfaces to map between 32bit hardware and 64bit
    time
  rtc/imxdi: Update driver to address time issues

 arch/alpha/kernel/rtc.c     |    4 ++--
 drivers/rtc/class.c         |   25 +++++++++++++++++++++++++
 drivers/rtc/interface.c     |    8 ++++----
 drivers/rtc/rtc-ab3100.c    |    4 ++--
 drivers/rtc/rtc-coh901331.c |    8 +++++++-
 drivers/rtc/rtc-ds1672.c    |    8 +++++++-
 drivers/rtc/rtc-ds2404.c    |    9 ++++++++-
 drivers/rtc/rtc-ep93xx.c    |    8 +++++++-
 drivers/rtc/rtc-imxdi.c     |   37 ++++++++++++++++++++++---------------
 drivers/rtc/rtc-jz4740.c    |    8 +++++++-
 drivers/rtc/rtc-lib.c       |   28 ++++++++++++++++++++++++++++
 drivers/rtc/rtc-lpc32xx.c   |    9 ++++++++-
 drivers/rtc/rtc-mc13xxx.c   |    5 ++---
 drivers/rtc/rtc-mxc.c       |   37 ++++++++++++++++++-------------------
 drivers/rtc/rtc-pcap.c      |    6 ++----
 drivers/rtc/rtc-stmp3xxx.c  |    8 +++++++-
 drivers/rtc/rtc-test.c      |    4 ++--
 drivers/rtc/rtc-tx4939.c    |    8 +++++++-
 drivers/rtc/rtc-wm831x.c    |   16 +++++++++-------
 drivers/rtc/rtc-xgene.c     |    6 +++++-
 include/linux/rtc.h         |    5 ++++-
 21 files changed, 183 insertions(+), 68 deletions(-)

-- 
1.7.9.5

