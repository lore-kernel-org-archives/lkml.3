Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757381Ab3KHNeh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Nov 2013 08:34:37 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:56549 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756955Ab3KHNeE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Nov 2013 08:34:04 -0500
From: Charles Keepax <ckeepax@opensource.wolfsonmicro.com>
To: cw00.choi@samsung.com
Cc: myungjoo.ham@samsung.com, sameo@linux.intel.com, lee.jones@linaro.org,
        patches@opensource.wolfsonmicro.com, linux-kernel@vger.kernel.org,
        Charles Keepax <ckeepax@opensource.wolfsonmicro.com>
Subject: [PATCH 4/4] extcon: arizona: Eliminate dead error handling code
Date: Fri,  8 Nov 2013 13:19:43 +0000
Message-Id: <1383916783-17921-4-git-send-email-ckeepax@opensource.wolfsonmicro.com>
X-Mailer: git-send-email 1.7.2.5
In-Reply-To: <1383916783-17921-1-git-send-email-ckeepax@opensource.wolfsonmicro.com>
References: <1383916783-17921-1-git-send-email-ckeepax@opensource.wolfsonmicro.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

As a small disclaimer I would personally prefer to not merge this patch.
I have added it based on previous code review of the other patches in
this chain.

arizona_hpdet_do_id currently can only return 0 or -EAGAIN making the
else if clause handling error codes redundant, this patch removes this
clause.

Whilst this clause is not currently hit removing it makes the code
fragile. It will not be obvious whilst editing arizona_hpdet_do_id that
you shouldn't add a return value other than 0 or -EAGAIN.

Signed-off-by: Charles Keepax <ckeepax@opensource.wolfsonmicro.com>
---
 drivers/extcon/extcon-arizona.c |    5 +++--
 1 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/extcon/extcon-arizona.c b/drivers/extcon/extcon-arizona.c
index 0d70bf6..2313b1e 100644
--- a/drivers/extcon/extcon-arizona.c
+++ b/drivers/extcon/extcon-arizona.c
@@ -476,6 +476,9 @@ static int arizona_hpdet_read(struct arizona_extcon_info *info)
 	return val;
 }
 
+/* This function should only return 0 or -EAGAIN, if other return values are
+ * added additional handling should be added in arizona_hpdet_irq.
+ */
 static int arizona_hpdet_do_id(struct arizona_extcon_info *info, int *reading,
 			       bool *mic)
 {
@@ -591,8 +594,6 @@ static irqreturn_t arizona_hpdet_irq(int irq, void *data)
 	ret = arizona_hpdet_do_id(info, &reading, &mic);
 	if (ret == -EAGAIN)
 		goto out;
-	else if (ret < 0)
-		goto done;
 
 	/* Report high impedence cables as line outputs */
 	if (reading >= 5000)
-- 
1.7.2.5

