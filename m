Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932760Ab3E3OZa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 May 2013 10:25:30 -0400
Received: from smtp02.citrix.com ([66.165.176.63]:26070 "EHLO
	SMTP02.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932276Ab3E3OZZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 May 2013 10:25:25 -0400
X-IronPort-AV: E=Sophos;i="4.87,770,1363132800"; 
   d="scan'208";a="26908086"
From: David Vrabel <david.vrabel@citrix.com>
To: <xen-devel@lists.xen.org>
CC: David Vrabel <david.vrabel@citrix.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        John Stultz <john.stultz@linaro.org>, <linux-kernel@vger.kernel.org>
Subject: [PATCHv3 0/2] xen: maintain an accurate persistent clock in more cases 
Date: Thu, 30 May 2013 15:25:17 +0100
Message-ID: <1369923919-26981-1-git-send-email-david.vrabel@citrix.com>
X-Mailer: git-send-email 1.7.2.5
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The kernel has limited support for updating the persistent clock or
RTC when NTP is synced.  This has the following limitations:

* The persistent clock is not updated on step changes.  This leaves a
  window where it will be incorrect (while NTP resyncs).

* Xen guests use the Xen wallclock as their persistent clock.  dom0
  maintains this clock so it is persistent for domUs and not dom0
  itself.

These series fixes the above limitations and depends on "x86: increase
precision of x86_platform.get/set_wallclock()" which was previously
posted.

[ On a related note, with CONFIG_HZ=1000 sync_cmos_clock() is always
  scheduled ~3ms too late which causes it to repeatedly try to
  reschedule in ~997 ms and ends up never calling
  updated_persistent_clock().  With HZ=250, the error is ~1ms too late
  which is close enough.

  It is not clear where this systematic error comes from or whether
  this is only a Xen specific bug.  I don't have time to investigate
  right now. ]

Changes since v2:

Don't peek at the timekeeper internals (use __current_kernel_time()
instead).  Use the native set_wallclock hook in dom0.

Changes since v1:

Reworked to use the pvclock_gtod notifier to sync the wallclock (this
looked similar to what a KVM host does).  update_persistent_clock()
will now only update the CMOS RTC.

David

[1] http://lists.xen.org/archives/html/xen-devel/2013-05/msg01402.html

