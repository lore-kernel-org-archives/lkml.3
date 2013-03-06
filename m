Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754031Ab3CFHTD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Mar 2013 02:19:03 -0500
Received: from mga11.intel.com ([192.55.52.93]:44296 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750972Ab3CFHTA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Mar 2013 02:19:00 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,793,1355126400"; 
   d="scan'208";a="299868678"
From: Feng Tang <feng.tang@intel.com>
To: Thomas Gleixner <tglx@linutronix.de>, John Stultz <john.stultz@linaro.org>,
        Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@linux.intel.com>,
        Jason Gunthorpe <jgunthorpe@obsidianresearch.com>, x86@kernel.org,
        Len Brown <lenb@kernel.org>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        linux-kernel@vger.kernel.org
Cc: gong.chen@linux.intel.com, Feng Tang <feng.tang@intel.com>
Subject: [PATCH v3 0/5] Add support for S3 non-stop TSC support. 
Date: Wed,  6 Mar 2013 15:17:46 +0800
Message-Id: <1362554271-22382-1-git-send-email-feng.tang@intel.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi All,

On some new Intel Atom processors (Penwell and Cloverview), there is
a feature that the TSC won't stop in S3, say the TSC value won't be
reset to 0 after resume. This feature makes TSC a more reliable
clocksource and could benefit the timekeeping code during system
suspend/resume cycles.

The enabling efforts include adding new flags for this feature, 
modifying clocksource.h and timekeeping.c to support and utilizing
it.

The major change to timekeeping is the way to count suspended time,
current way is trying to use the persistent clock first, and then
try the rtc if persistent clock can't do it. This patch will change
the trying order to:
	suspend-nonstop clocksource -> persistent clock -> rtc

Please help to review them, thanks a lot!

Changelog:

	v3:
	    * Adopt Jason Gunthorpe's way to convert large cycles to
	      nsec. And put it into clocksource_cyc2ns()
	    * Small change in flag name
	v2:
	    * Dump the code changing a clocksource's mult and shit,
	      as suggested by John to not hurt accuracy
	    * Modify the CPU feature flag name to be consistent with
	      other flags
	    * Solve the problem of judging S3/S4, as the clocksource
	      counter will be reset after coming out S4.

- Feng

-------------
Feng Tang (5):
  x86: Add cpu capability flag X86_FEATURE_NONSTOP_TSC_S3
  clocksource: Add new feature flag CLOCK_SOURCE_SUSPEND_NONSTOP
  x86: tsc: Add support for new S3_NONSTOP feature
  clocksource: Enable clocksource_cyc2ns() to cover big cycles
  timekeeping: utilize the suspend-nonstop clocksource to count
    suspended time

 arch/x86/include/asm/cpufeature.h |    1 +
 arch/x86/kernel/cpu/intel.c       |   12 +++++++++++
 arch/x86/kernel/tsc.c             |    6 +++++-
 include/linux/clocksource.h       |   12 ++++++++++-
 kernel/time/timekeeping.c         |   42 ++++++++++++++++++++++++++++++-------
 5 files changed, 63 insertions(+), 10 deletions(-)

-- 
1.7.9.5

