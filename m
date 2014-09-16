Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753578AbaIPIwW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Sep 2014 04:52:22 -0400
Received: from mailout1.w1.samsung.com ([210.118.77.11]:14444 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753274AbaIPIwL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Sep 2014 04:52:11 -0400
X-AuditID: cbfec7f5-b7f776d000003e54-91-5417fa382170
From: Krzysztof Kozlowski <k.kozlowski@samsung.com>
To: Russell King <linux@arm.linux.org.uk>,
        Dan Williams <dan.j.williams@intel.com>,
        Vinod Koul <vinod.koul@intel.com>, linux-kernel@vger.kernel.org,
        dmaengine@vger.kernel.org, Ulf Hansson <ulf.hansson@linaro.org>,
        Grant Likely <grant.likely@linaro.org>,
        Lars-Peter Clausen <lars@metafoo.de>,
        Michal Simek <michal.simek@xilinx.com>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Len Brown <len.brown@intel.com>, Pavel Machek <pavel@ucw.cz>,
        Randy Dunlap <rdunlap@infradead.org>,
        Alan Stern <stern@rowland.harvard.edu>, linux-doc@vger.kernel.org,
        linux-pm@vger.kernel.org
Cc: Kyungmin Park <kyungmin.park@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Krzysztof Kozlowski <k.kozlowski@samsung.com>
Subject: [PATCH v4 0/4] amba/dma: pl330: add Power Management support
Date: Tue, 16 Sep 2014 10:51:30 +0200
Message-id: <1410857494-15936-1-git-send-email-k.kozlowski@samsung.com>
X-Mailer: git-send-email 1.9.1
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrJLMWRmVeSWpSXmKPExsVy+t/xy7oWv8RDDL73cVpsnLGe1WL61AuM
	Fqun/mW1OPBnB6PF6xeGFmeb3rBbLJk8n9Vi1pS9TBYL25awWFzeNYfN4nPvEUaL25d5LdYe
	uctu8e5lhMXdU0fZLN7emc5iceb0JVaLCb8vsFkcXxtu8bJvP4uDiEdLcw+bx+YVWh6L97xk
	8rhzbQ+bx5I3h1g9tlxtZ/GYffcHo0ffllWMHitWf2f3+LxJzmPv598sAdxRXDYpqTmZZalF
	+nYJXBmXb9UU3BGuuLVnH2sD4wX+LkZODgkBE4muSRPYIGwxiQv31gPZXBxCAksZJba9vswM
	4fQxSSzun8QEUsUmYCyxefkSsCoRgSMsEs/uPQFzmAWOMkpM730LViUs4Cqx+P1kVhCbRUBV
	4u/c38wgNq+Au0TfxA5miH1yEiePTWadwMi9gJFhFaNoamlyQXFSeq6RXnFibnFpXrpecn7u
	JkZIcH/dwbj0mNUhRgEORiUe3hkbxUKEWBPLiitzDzFKcDArifA++CQeIsSbklhZlVqUH19U
	mpNafIiRiYNTqoFRx21WAK+WyOJdannPKp8WHuKdeGFxY+/C1mfta/pfKtydXbLtafez/hB+
	4/yeULa0y1yxNpU3z4kuFNWbvtc2S3/WwmuJH235KtV33vj3JnNehNTz5Xzr9Apqpvy8+L+Y
	u2hd6U8jL44d9w4WXNJYs2vjQRlLttodzVxaignzJ6yeHh0jN9NWiaU4I9FQi7moOBEAsY8Q
	EEwCAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,


This is fourth version of patches adding runtime PM to the pl330
driver.

The runtime PM of pl330 driver requires interrupt safe suspend/resume
callbacks which is in conflict with current amba bus driver.
The latter also unprepares and prepares the AMBA bus clock which
is not safe for atomic context.

The patchset solves this in patch 3/4 by handling clocks in different
way if device driver set interrupt safe runtime PM.

Any comments are welcome.


Tested on boards with pl330 DMA driver:
 - Trats2 (Exynos4212)
 - Samsung Gear2-like development board (Exynos3250)


TODO/ideas:
===========
Consider renaming existing pm_runtime_irq_safe() function to keep
up with naming convention after adding pm_runtime_is_irq_safe() in
patch 1/4.
This naming:
 - pm_runtime_irq_safe() as setter,
 - pm_runtime_is_irq_safe() as getter,
is contradictory to naming of other PM runtime functions, e.g.:
 - pm_runtime_set_active() as setter,
 - pm_runtime_active() as getter.
I didn't change the naming of pm_runtime_irq_safe() because I wanted
to minimize the impact of the patches.


Changes since v3:
=================
1. Patch 1/4: Document new API in Documentation/power/runtime_pm.txt
   (pointed by Alan Stern).

Changes since v2:
=================
1. Add patch 1 (PM / Runtime: Add getter for quering the IRQ safe option)
2. Add patch 2 (amba: Add helper macros for (un)preparing AMBA clock)
3. Patch 3/4: Rewrite the idea. If IRQ safe runtime PM is set then
   do not unprepare/prepare the clocks. Suggested by Russell King.
4. Patch 4/4: During system sleep unprepare the clock.

Changes since v1:
=================
1. Add patch 1 (amba: Allow AMBA drivers to use their own runtime PM).
2. Patch 2/2: Apply Michal Simek's suggestions.
3. Patch 2/2: Fix atomic context safeness in pl330_issue_pending().


Best regards,
Krzysztof Kozlowski


Krzysztof Kozlowski (4):
  PM / Runtime: Add getter for quering the IRQ safe option
  amba: Add helper macros for (un)preparing AMBA clock
  amba: Don't unprepare the clocks if device driver wants IRQ safe
    runtime PM
  dma: pl330: add Power Management support

 Documentation/power/runtime_pm.txt |  4 ++
 drivers/amba/bus.c                 | 30 +++++++++++++--
 drivers/dma/pl330.c                | 77 ++++++++++++++++++++++++++++++++++++--
 include/linux/amba/bus.h           |  7 ++++
 include/linux/pm_runtime.h         |  6 +++
 5 files changed, 116 insertions(+), 8 deletions(-)

-- 
1.9.1

