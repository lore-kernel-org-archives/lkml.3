Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934794Ab3BNRDe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Feb 2013 12:03:34 -0500
Received: from mx1.redhat.com ([209.132.183.28]:26258 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933385Ab3BNRDd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Feb 2013 12:03:33 -0500
From: Prarit Bhargava <prarit@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Prarit Bhargava <prarit@redhat.com>, Thomas Gleixner <tglx@linutronix.de>,
        John Stultz <john.stultz@linaro.org>, x86@kernel.org,
        Matt Fleming <matt.fleming@intel.com>,
        David Vrabel <david.vrabel@citrix.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Andi Kleen <ak@linux.intel.com>, linux-efi@vger.kernel.org
Subject: [RFE PATCH 0/2] x86, rtc, ntp, Enable full rtc synchronization
Date: Thu, 14 Feb 2013 12:02:53 -0500
Message-Id: <1360861375-24131-1-git-send-email-prarit@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patchset enables a full rtc synchronization via ntp on x86.  The current
codebase (plus http://marc.info/?l=linux-kernel&m=136036689219340&w=2, which is
queued for tip), will attempt to synchronize the rtc to the system time every
11 minutes if ntp is running.

The problem in the current code is that the synchronization will only occur
if the system time is within +/-15 minutes of the current rtc time.  ie)
we only do a "partial" synchronization of the rtc.  Other architectures do
full synchronizations and the partial sync appears to be a software limitation.

This patchset introduces a full synchronization of the rtc, and allows the
writing of the rtc date and time via sysfs (read for date and time is already
implemented).

I tested this patch by using the write capability introduced in 2/2 to
write in older and newer dates into the rtc, and then rebooting with ntpdate,
and/or ntpdate enabled and verifying the correct setting of the hwclock (and
system time) via calls to date and hwclock (all on 64-bit x86)

I have not tested the mrst/vrtc.c code, however, code inspection indicates
that the only change required is the year offset of 1972.  I booted 32-bit
Fedora 18 on an UEFI system and confirmed that the system time and hwclock
were now correct at boot.

Signed-off-by: Prarit Bhargava <prarit@redhat.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: John Stultz <john.stultz@linaro.org>
Cc: x86@kernel.org
Cc: Matt Fleming <matt.fleming@intel.com>
Cc: David Vrabel <david.vrabel@citrix.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Andi Kleen <ak@linux.intel.com>
Cc: linux-efi@vger.kernel.org

Prarit Bhargava (2):
  x86, rtc, ntp, Do full rtc synchronization with ntp
  rtc, add write functionality to sysfs

 arch/x86/kernel/rtc.c         | 69 ++++++----------------------------
 arch/x86/platform/efi/efi.c   | 24 ++++++++----
 arch/x86/platform/mrst/vrtc.c | 41 ++++++++++++---------
 drivers/rtc/rtc-sysfs.c       | 86 ++++++++++++++++++++++++++++++++++++++++++-
 4 files changed, 136 insertions(+), 84 deletions(-)

-- 
1.8.1.2

