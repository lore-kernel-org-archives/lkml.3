Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752233Ab3FFRpn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Jun 2013 13:45:43 -0400
Received: from mms2.broadcom.com ([216.31.210.18]:4897 "EHLO mms2.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750857Ab3FFRpm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Jun 2013 13:45:42 -0400
X-Server-Uuid: 4500596E-606A-40F9-852D-14843D8201B2
From: cbrand@broadcom.com
To: a.zummo@towertech.it, rtc-linux@googlegroups.com,
        linux-kernel@vger.kernel.org
cc: "Chris Brand" <chris.brand@broadcom.com>
Subject: [PATCH] RTC: Return -EBUSY, not -EACCES when device is busy
Date: Thu, 6 Jun 2013 10:46:09 -0700
Message-ID: <1370540769-2466-2-git-send-email-cbrand@broadcom.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1370540769-2466-1-git-send-email-cbrand@broadcom.com>
References: <1370540769-2466-1-git-send-email-cbrand@broadcom.com>
MIME-Version: 1.0
X-WSS-ID: 7DAE16E01R027417913-01-01
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Chris Brand <chris.brand@broadcom.com>

If rtc->irq_task is non-NULL and task is NULL, they always
differ, which means that in rtc_irq_set_state() and
rtc_irq_set_freq(), whenever err is set to -EBUSY it will
then immediately be set to -EACCES, misleading the caller
as to the underlying problem.
---
 drivers/rtc/interface.c |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/rtc/interface.c b/drivers/rtc/interface.c
index 42bd57d..40d4032 100644
--- a/drivers/rtc/interface.c
+++ b/drivers/rtc/interface.c
@@ -698,9 +698,9 @@ retry:
 	spin_lock_irqsave(&rtc->irq_task_lock, flags);
 	if (rtc->irq_task != NULL && task == NULL)
 		err = -EBUSY;
-	if (rtc->irq_task != task)
+	else if (rtc->irq_task != task)
 		err = -EACCES;
-	if (!err) {
+	else {
 		if (rtc_update_hrtimer(rtc, enabled) < 0) {
 			spin_unlock_irqrestore(&rtc->irq_task_lock, flags);
 			cpu_relax();
@@ -734,9 +734,9 @@ retry:
 	spin_lock_irqsave(&rtc->irq_task_lock, flags);
 	if (rtc->irq_task != NULL && task == NULL)
 		err = -EBUSY;
-	if (rtc->irq_task != task)
+	else if (rtc->irq_task != task)
 		err = -EACCES;
-	if (!err) {
+	else {
 		rtc->irq_freq = freq;
 		if (rtc->pie_enabled && rtc_update_hrtimer(rtc, 1) < 0) {
 			spin_unlock_irqrestore(&rtc->irq_task_lock, flags);
-- 
1.7.5.4


