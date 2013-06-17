Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755196Ab3FQRgt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Jun 2013 13:36:49 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:50757 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754814Ab3FQRgr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Jun 2013 13:36:47 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Tony Lindgren <tony@atomide.com>, Alessandro Zummo <a.zummo@towertech.it>,
        Jingoo Han <jg1.han@samsung.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 78/84] drivers/rtc/rtc-twl.c: fix missing device_init_wakeup() when booted with device tree
Date: Mon, 17 Jun 2013 10:31:22 -0700
Message-Id: <1371490288-23167-79-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1371490288-23167-1-git-send-email-kamal@canonical.com>
References: <1371490288-23167-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.3 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tony Lindgren <tony@atomide.com>

commit 24b8256a1fb28d357bc6fa09184ba29b4255ba5c upstream.

When booted in legacy mode device_init_wakeup() gets called by
drivers/mfd/twl-core.c when the children are initialized.  However, when
booted using device tree, the children are created with
of_platform_populate() instead add_children().

This means that the RTC driver will not have device_init_wakeup() set,
and we need to call it from the driver probe like RTC drivers typically
do.

Without this we cannot test PM wake-up events on omaps for cases where
there may not be any physical wake-up event.

Signed-off-by: Tony Lindgren <tony@atomide.com>
Reported-by: Kevin Hilman <khilman@linaro.org>
Cc: Alessandro Zummo <a.zummo@towertech.it>
Cc: Jingoo Han <jg1.han@samsung.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/rtc/rtc-twl.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/rtc/rtc-twl.c b/drivers/rtc/rtc-twl.c
index ccd4ad3..5cb7720 100644
--- a/drivers/rtc/rtc-twl.c
+++ b/drivers/rtc/rtc-twl.c
@@ -523,6 +523,7 @@ static int twl_rtc_probe(struct platform_device *pdev)
 	}
 
 	platform_set_drvdata(pdev, rtc);
+	device_init_wakeup(&pdev->dev, 1);
 	return 0;
 
 out2:
-- 
1.8.1.2

