Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752500AbaJDJkg (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 Oct 2014 05:40:36 -0400
Received: from mout.gmx.net ([212.227.17.20]:60325 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752189AbaJDJkd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 Oct 2014 05:40:33 -0400
From: =?UTF-8?q?Daniel=20Gl=C3=B6ckner?= <daniel-gl@gmx.net>
To: Alessandro Zummo <a.zummo@towertech.it>
Cc: Mika Westerberg <mika.westerberg@linux.intel.com>,
        rtc-linux@googlegroups.com, linux-kernel@vger.kernel.org,
        =?UTF-8?q?Daniel=20Gl=C3=B6ckner?= <daniel-gl@gmx.net>
Subject: [PATCH] rtc-cmos: fix wakeup from S5 without CONFIG_PM_SLEEP
Date: Sat,  4 Oct 2014 11:38:56 +0200
Message-Id: <1412415536-8919-1-git-send-email-daniel-gl@gmx.net>
X-Mailer: git-send-email 1.8.3.4
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Provags-ID: V03:K0:pGHQ56tXhEsJvGxxO8owQzLfsrujQAVJdgOgnW13I/D63ELrKQ/
 n58jl9W3KPz0dRHZvbFHyzXhqOGYYCcgFsRJGH/1VN/JiK6JebRhVIuJykwh1w3IhrV+VS1
 hY5u0OtUBpUUJTxxTScahGmf/RhwYaSvF3uygAfq94mM+zm+wi0PRIwZqHG2P19/hhodDn/
 N2521xBn9qcciA4ack2mw==
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

b5ada4600d broke wakeup from S5 by making cmos_poweroff a nop
unless CONFIG_PM_SLEEP was defined. Fix this by restricting
the #ifdef to cmos_resume and restoring the old dependency on
CONFIG_PM for cmos_suspend and cmos_poweroff.

Signed-off-by: Daniel Glöckner <daniel-gl@gmx.net>
---
 drivers/rtc/rtc-cmos.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/rtc/rtc-cmos.c b/drivers/rtc/rtc-cmos.c
index b0e4a3e..5b2e761 100644
--- a/drivers/rtc/rtc-cmos.c
+++ b/drivers/rtc/rtc-cmos.c
@@ -856,7 +856,7 @@ static void __exit cmos_do_remove(struct device *dev)
 	cmos->dev = NULL;
 }
 
-#ifdef	CONFIG_PM_SLEEP
+#ifdef CONFIG_PM
 
 static int cmos_suspend(struct device *dev)
 {
@@ -907,6 +907,8 @@ static inline int cmos_poweroff(struct device *dev)
 	return cmos_suspend(dev);
 }
 
+#ifdef	CONFIG_PM_SLEEP
+
 static int cmos_resume(struct device *dev)
 {
 	struct cmos_rtc	*cmos = dev_get_drvdata(dev);
@@ -954,6 +956,7 @@ static int cmos_resume(struct device *dev)
 	return 0;
 }
 
+#endif
 #else
 
 static inline int cmos_poweroff(struct device *dev)
-- 
1.8.3.4

