Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753382AbaIVJq7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Sep 2014 05:46:59 -0400
Received: from mailout2.w1.samsung.com ([210.118.77.12]:34911 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751335AbaIVJq4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Sep 2014 05:46:56 -0400
X-AuditID: cbfec7f5-b7f776d000003e54-8f-541ff00d0f71
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
Subject: [PATCH v6 0/4] amba/dma: pl330: add Power Management support
Date: Mon, 22 Sep 2014 11:46:25 +0200
Message-id: <1411379189-3017-1-git-send-email-k.kozlowski@samsung.com>
X-Mailer: git-send-email 1.9.1
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrJLMWRmVeSWpSXmKPExsVy+t/xq7q8H+RDDPZ181lsnLGe1WL61AuM
	Fqun/mW1OPBnB6PF6xeGFmeb3rBbLJk8n9Vi1pS9TBYL25awWFzeNYfN4nPvEUaL25d5LdYe
	uctu8e5lhMXdU0fZLN7emc5iceb0JVaLCb8vsFkcXxtu8bJvP4uDiEdLcw+bx+YVWh6L97xk
	8rhzbQ+bx5I3h1g9tlxtZ/GYffcHo0ffllWMHitWf2f3+LxJzmPv598sAdxRXDYpqTmZZalF
	+nYJXBnzziUXNIhV7N85iamBcbdgFyMnh4SAicSnj2fZIGwxiQv31gPZXBxCAksZJX6fecMM
	4fQxSZy4eIYJpIpNwFhi8/IlYFUiAkdYJJ7dewLmMAscZZSY3vsWrEpYwFXi/qIeFhCbRUBV
	4vWyy6wgNq+Am8SuY6dZIfbJSZw8Npl1AiP3AkaGVYyiqaXJBcVJ6blGesWJucWleel6yfm5
	mxghwf11B+PSY1aHGAU4GJV4eH+0yIcIsSaWFVfmHmKU4GBWEuF9+hwoxJuSWFmVWpQfX1Sa
	k1p8iJGJg1OqgXHts2/zZlXO9/v+sbTf+7jTUUGeW7+6+y5r73ym05yW7Kj1+WKPV92HUL14
	By2OjJXf/3+W3B79feIPzcq1S+P8ZrmpVrn5HlRgPcjuqHfh2nQexplTHi4ujzumZCxguDbw
	SN59XzO+GQvWXMjYuI53HZeUS2H6M82Vzod5Ftcv5mH9deeeiIYSS3FGoqEWc1FxIgAhSceY
	TAIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,


Changes since v5:
=================
1. Patch 1/4: Add Ulf Hansson's reviewed-by.
2. Patch 4/4: Use PM runtime autosuspend (suggested by Ulf Hansson).
3. Rebase on next-20140922. 

Changes since v4:
1. Patch 3/4: Explicitly initialize amba_device.irq_safe field after
   probing driver (suggested by Russell King).

Changes since v3:
1. Patch 1/4: Document new API in Documentation/power/runtime_pm.txt
   (pointed by Alan Stern).

Changes since v2:
1. Add patch 1 (PM / Runtime: Add getter for quering the IRQ safe option)
2. Add patch 2 (amba: Add helper macros for (un)preparing AMBA clock)
3. Patch 3/4: Rewrite the idea. If IRQ safe runtime PM is set then
   do not unprepare/prepare the clocks. Suggested by Russell King.
4. Patch 4/4: During system sleep unprepare the clock.

Changes since v1:
1. Add patch 1 (amba: Allow AMBA drivers to use their own runtime PM).
2. Patch 2/2: Apply Michal Simek's suggestions.
3. Patch 2/2: Fix atomic context safeness in pl330_issue_pending().


Description:
============
This is sixth version of patches adding runtime PM to the pl330
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


Best regards,
Krzysztof Kozlowski


Krzysztof Kozlowski (4):
  PM / Runtime: Add getter for quering the IRQ safe option
  amba: Add helper macros for (un)preparing AMBA clock
  amba: Don't unprepare the clocks if device driver wants IRQ safe
    runtime PM
  dma: pl330: add Power Management support

 Documentation/power/runtime_pm.txt |  4 ++
 drivers/amba/bus.c                 | 29 +++++++++++--
 drivers/dma/pl330.c                | 87 ++++++++++++++++++++++++++++++++++++--
 include/linux/amba/bus.h           |  7 +++
 include/linux/pm_runtime.h         |  6 +++
 5 files changed, 125 insertions(+), 8 deletions(-)

-- 
1.9.1

