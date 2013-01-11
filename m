Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755575Ab3AKNNm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jan 2013 08:13:42 -0500
Received: from mail-wi0-f171.google.com ([209.85.212.171]:41581 "EHLO
	mail-wi0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755368Ab3AKNNi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jan 2013 08:13:38 -0500
From: Lee Jones <lee.jones@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: arnd@arndb.de, linus.walleij@stericsson.com, cbouatmailru@gmail.com,
        Hakan Berg <hakan.berg@stericsson.com>,
        Lee Jones <lee.jones@linaro.org>
Subject: [PATCH 09/18] power: ab8500_btemp: Ignore false btemp low interrupt
Date: Fri, 11 Jan 2013 13:12:57 +0000
Message-Id: <1357909986-9262-10-git-send-email-lee.jones@linaro.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1357909986-9262-1-git-send-email-lee.jones@linaro.org>
References: <1357909986-9262-1-git-send-email-lee.jones@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Hakan Berg <hakan.berg@stericsson.com>

Ignore the low btemp interrupts for ab8500 3.0 and 3.3

Signed-off-by: Lee Jones <lee.jones@linaro.org>
Signed-off-by: Hakan Berg <hakan.berg@stericsson.com>
Reviewed-by: Jonas ABERG <jonas.aberg@stericsson.com>
Tested-by: Marcus COOPER <marcus.xm.cooper@stericsson.com>
---
 drivers/power/ab8500_btemp.c      |    8 ++++----
 include/linux/mfd/abx500/ab8500.h |    5 +++++
 2 files changed, 9 insertions(+), 4 deletions(-)

diff --git a/drivers/power/ab8500_btemp.c b/drivers/power/ab8500_btemp.c
index 3ad47b0..6f6a715 100644
--- a/drivers/power/ab8500_btemp.c
+++ b/drivers/power/ab8500_btemp.c
@@ -622,9 +622,9 @@ static irqreturn_t ab8500_btemp_templow_handler(int irq, void *_di)
 {
 	struct ab8500_btemp *di = _di;
 
-	if (is_ab8500_2p0_or_earlier(di->parent)) {
+	if (is_ab8500_3p3_or_earlier(di->parent)) {
 		dev_dbg(di->dev, "Ignore false btemp low irq"
-			" for ABB cut 1.0, 1.1 and 2.0\n");
+			" for ABB cut 1.0, 1.1, 2.0 and 3.3\n");
 	} else {
 		dev_crit(di->dev, "Battery temperature lower than -10deg c\n");
 
@@ -738,10 +738,10 @@ static int ab8500_btemp_get_temp(struct ab8500_btemp *di)
 	int temp = 0;
 
 	/*
-	 * The BTEMP events are not reliabe on AB8500 cut2.0
+	 * The BTEMP events are not reliabe on AB8500 cut3.3
 	 * and prior versions
 	 */
-	if (is_ab8500_2p0_or_earlier(di->parent)) {
+	if (is_ab8500_3p3_or_earlier(di->parent)) {
 		temp = di->bat_temp * 10;
 	} else {
 		if (di->events.btemp_low) {
diff --git a/include/linux/mfd/abx500/ab8500.h b/include/linux/mfd/abx500/ab8500.h
index 1491044..46f5f62 100644
--- a/include/linux/mfd/abx500/ab8500.h
+++ b/include/linux/mfd/abx500/ab8500.h
@@ -335,6 +335,11 @@ static inline int is_ab8500_2p0_or_earlier(struct ab8500 *ab)
 	return (is_ab8500(ab) && (ab->chip_id <= AB8500_CUT2P0));
 }
 
+static inline int is_ab8500_3p3_or_earlier(struct ab8500 *ab)
+{
+	return (is_ab8500(ab) && (ab->chip_id <= AB8500_CUT3P3));
+}
+
 /* exclude also ab8505, ab9540... */
 static inline int is_ab8500_2p0(struct ab8500 *ab)
 {
-- 
1.7.9.5

