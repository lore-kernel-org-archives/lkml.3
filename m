Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754756Ab3J0QbG (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Oct 2013 12:31:06 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:43430 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754264Ab3J0QbE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Oct 2013 12:31:04 -0400
From: Charles Keepax <ckeepax@opensource.wolfsonmicro.com>
To: cw00.choi@samsung.com
Cc: myungjoo.ham@samsung.com, patches@opensource.wolfsonmicro.com,
        linux-kernel@vger.kernel.org,
        Charles Keepax <ckeepax@opensource.wolfsonmicro.com>
Subject: [PATCH 2/2] extcon: arizona: Fix race with microphone detection and removal
Date: Sun, 27 Oct 2013 16:19:12 +0000
Message-Id: <1382890752-30970-2-git-send-email-ckeepax@opensource.wolfsonmicro.com>
X-Mailer: git-send-email 1.7.2.5
In-Reply-To: <1382890752-30970-1-git-send-email-ckeepax@opensource.wolfsonmicro.com>
References: <1382890752-30970-1-git-send-email-ckeepax@opensource.wolfsonmicro.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The microphone detection code is run as delayed work to provide
additional debounce, it is possible that the jack could have been
removed by the time we process the microphone detection. Turn this case
into a no op.

Signed-off-by: Charles Keepax <ckeepax@opensource.wolfsonmicro.com>
---

As Lee Jones took the first patch (extcon: arizona: Add
defines for microphone detection levels) of my series
yesterday through his tree I have based this patch on the
extcon tree without that change applied.

Thanks,
Charles

 drivers/extcon/extcon-arizona.c |    6 ++++++
 1 files changed, 6 insertions(+), 0 deletions(-)

diff --git a/drivers/extcon/extcon-arizona.c b/drivers/extcon/extcon-arizona.c
index dac8ba0..9c20850 100644
--- a/drivers/extcon/extcon-arizona.c
+++ b/drivers/extcon/extcon-arizona.c
@@ -773,6 +773,12 @@ static void arizona_micd_detect(struct work_struct *work)
 
 	mutex_lock(&info->lock);
 
+	if (!info->cable) {
+		dev_dbg(arizona->dev, "Ignoring MICDET for removed cable\n");
+		mutex_unlock(&info->lock);
+		return;
+	}
+
 	for (i = 0; i < 10 && !(val & 0x7fc); i++) {
 		ret = regmap_read(arizona->regmap, ARIZONA_MIC_DETECT_3, &val);
 		if (ret != 0) {
-- 
1.7.2.5

