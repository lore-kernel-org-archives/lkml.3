Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758283Ab3FTTQj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Jun 2013 15:16:39 -0400
Received: from smtp02.citrix.com ([66.165.176.63]:8084 "EHLO SMTP02.CITRIX.COM"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758237Ab3FTTQh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Jun 2013 15:16:37 -0400
X-IronPort-AV: E=Sophos;i="4.87,906,1363132800"; 
   d="scan'208";a="30925426"
From: David Vrabel <david.vrabel@citrix.com>
To: <xen-devel@lists.xen.org>
CC: David Vrabel <david.vrabel@citrix.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        <linux-kernel@vger.kernel.org>, John Stultz <john.stultz@linaro.org>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: [PATCHv5 0/4] xen: maintain an accurate persistent clock in more cases
Date: Thu, 20 Jun 2013 20:16:28 +0100
Message-ID: <1371755792-25962-1-git-send-email-david.vrabel@citrix.com>
X-Mailer: git-send-email 1.7.2.5
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Xen guests use the Xen wallclock as their persistent clock.  This is a
software only clock in the hypervisor that is used by guests instead
of a real hardware RTC.

The kernel has limited support for updating the persistent clock or
RTC when NTP is synced.  This has the following limitations:

* The persistent clock is not updated on step changes.  This leaves a
  window where it will be incorrect (while NTP resyncs).

* Xen guests use the Xen wallclock as their persistent clock.  dom0
  maintains this clock so it is persistent for domUs but not dom0
  itself.

These limitations mean that guests started before NTP is synchronized
will start with an incorrect wallclock time and the hardware RTC will
not be updated (as on bare metal).

These series fixes the above limitations and depends on "x86: increase
precision of x86_platform.get/set_wallclock()" which was previously
posted.

Changes since v4:

Dropped the change to disable non-boot CPUs during suspend on Xen as
migration downtime was too poor.  Instead, provide
hrtimers_late_resume() for use by Xen's resume code to replace the
call of clock_was_set().  Fix two unused variable warnings.

Changes since v3:

Add a new clock_was_set notifier chain. Use this instead of direct
calls to clock_was_set() from the timekeeping code.  Use this notifier
and a new timer to synchronize the Xen wallclock.

Changes since v2:

Don't peek at the timekeeper internals (use __current_kernel_time()
instead).  Use the native set_wallclock hook in dom0.

Changes since v1:

Reworked to use the pvclock_gtod notifier to sync the wallclock (this
looked similar to what a KVM host does).  update_persistent_clock()
will now only update the CMOS RTC.

David

