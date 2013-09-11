Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752963Ab3IKIUZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Sep 2013 04:20:25 -0400
Received: from mga11.intel.com ([192.55.52.93]:17430 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751680Ab3IKIUY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Sep 2013 04:20:24 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.90,883,1371106800"; 
   d="scan'208";a="399811700"
Subject: [PATCH] ACPI / osl: implement acpi_os_sleep() with msleep()
From: Chuansheng Liu <chuansheng.liu@intel.com>
To: lenb@kernel.org, rjw@sisk.pl
Cc: linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org,
        zhuangzhi.li@intel.com, fei.li@intel.com, chuansheng.liu@intel.com
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 12 Sep 2013 01:42:57 +0800
Message-ID: <1378921377.26153.26.camel@cliu38-desktop-build>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Currently the acpi_os_sleep() is using the schedule_timeout_interruptible(),
which can be interrupted by signal, which causes the real sleep time is shorter.

According to the ACPI spec:
The Sleep term is used to implement long-term timing requirements.
Execution is delayed for at least the required number of milliseconds.

The sleeping time should be at least of the required number msecs, here
using msleep() to implement it.

Also if the real time is shorter, we meet the device POWER ON issue.

CC: lizhuangzhi <zhuangzhi.li@intel.com>
CC: Li Fei <fei.li@intel.com>
Signed-off-by: liu chuansheng <chuansheng.liu@intel.com>
---
 drivers/acpi/osl.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/acpi/osl.c b/drivers/acpi/osl.c
index e5f416c..b1629b5 100644
--- a/drivers/acpi/osl.c
+++ b/drivers/acpi/osl.c
@@ -820,7 +820,7 @@ acpi_status acpi_os_remove_interrupt_handler(u32 irq, acpi_osd_handler handler)
 
 void acpi_os_sleep(u64 ms)
 {
-	schedule_timeout_interruptible(msecs_to_jiffies(ms));
+	msleep(ms);
 }
 
 void acpi_os_stall(u32 us)
-- 
1.7.0.4



