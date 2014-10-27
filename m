Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753390AbaJ0ORW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Oct 2014 10:17:22 -0400
Received: from mail-lb0-f175.google.com ([209.85.217.175]:58226 "EHLO
	mail-lb0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753344AbaJ0ORU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Oct 2014 10:17:20 -0400
From: Jan Kardell <jan.kardell@telliq.com>
To: Alessandro Zummo <a.zummo@towertech.it>, rtc-linux@googlegroups.com,
        linux-kernel@vger.kernel.org
Cc: Vincent Donnefort <vdonnefort@gmail.com>,
        Dan Carpenter <dan.carpenter@oracle.com>
Subject: [PATCH 4/6] rtc: pcf8563 Handle consequeces of lacking second alarm reg
Date: Mon, 27 Oct 2014 15:16:59 +0100
Message-Id: <1414419421-11098-5-git-send-email-jan.kardell@telliq.com>
X-Mailer: git-send-email 1.8.4.5
In-Reply-To: <1414419421-11098-1-git-send-email-jan.kardell@telliq.com>
References: <1414419421-11098-1-git-send-email-jan.kardell@telliq.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

To guarantee that a set alarm occurs in the future, the set alarm time
is rounded up to the nearest minute.
Also we cannot handle UIE as it requires second precision.

Signed-off-by: Jan Kardell <jan.kardell@telliq.com>
---
 drivers/rtc/rtc-pcf8563.c | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/drivers/rtc/rtc-pcf8563.c b/drivers/rtc/rtc-pcf8563.c
index 78f76d9..ce6a11b 100644
--- a/drivers/rtc/rtc-pcf8563.c
+++ b/drivers/rtc/rtc-pcf8563.c
@@ -361,6 +361,14 @@ static int pcf8563_rtc_set_alarm(struct device *dev, struct rtc_wkalrm *tm)
 	struct i2c_client *client = to_i2c_client(dev);
 	unsigned char buf[4];
 	int err;
+	unsigned long alarm_time;
+
+	/* The alarm has no seconds, round up to nearest minute */
+	if (tm->time.tm_sec) {
+		rtc_tm_to_time(&tm->time, &alarm_time);
+		alarm_time += 60-tm->time.tm_sec;
+		rtc_time_to_tm(alarm_time, &tm->time);
+	}
 
 	dev_dbg(dev, "%s, min=%d hour=%d wday=%d mday=%d "
 		"enabled=%d pending=%d\n", __func__,
@@ -435,6 +443,9 @@ static int pcf8563_probe(struct i2c_client *client,
 
 	}
 
+	/* the pcf8563 alarm only supports a minute accuracy */
+	pcf8563->rtc->uie_unsupported = 1;
+
 	return 0;
 }
 
-- 
1.8.4.5

