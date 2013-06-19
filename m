Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757084Ab3FSP0N (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Jun 2013 11:26:13 -0400
Received: from smtp.citrix.com ([66.165.176.89]:46366 "EHLO SMTP.CITRIX.COM"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757028Ab3FSPZv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Jun 2013 11:25:51 -0400
X-IronPort-AV: E=Sophos;i="4.87,898,1363132800"; 
   d="scan'208";a="32137912"
From: David Vrabel <david.vrabel@citrix.com>
To: <xen-devel@lists.xen.org>
CC: David Vrabel <david.vrabel@citrix.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        <linux-kernel@vger.kernel.org>, John Stultz <john.stultz@linaro.org>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: [PATCHv4 0/4] xen: maintain an accurate persistent clock in more cases
Date: Wed, 19 Jun 2013 16:25:19 +0100
Message-ID: <1371655523-15609-1-git-send-email-david.vrabel@citrix.com>
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

Patch 1 is a prerequisite.  It removes a call to clock_was_set() from
the Xen suspend/resume code.

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

