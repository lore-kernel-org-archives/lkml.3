Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753118Ab3AVNk2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jan 2013 08:40:28 -0500
Received: from bear.ext.ti.com ([192.94.94.41]:42816 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752265Ab3AVNkV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jan 2013 08:40:21 -0500
From: Peter Ujfalusi <peter.ujfalusi@ti.com>
To: Richard Purdie <rpurdie@rpsys.net>
CC: Grant Likely <grant.likely@secretlab.ca>, Rob Landley <rob@landley.net>,
        Thierry Reding <thierry.reding@avionic-design.de>,
        Florian Tobias Schandinat <FlorianSchandinat@gmx.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        <devicetree-discuss@lists.ozlabs.org>, <linux-doc@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-fbdev@vger.kernel.org>
Subject: [PATCH 1/4] pwm_backlight: Fix PWM levels support in non DT case
Date: Tue, 22 Jan 2013 14:39:53 +0100
Message-ID: <1358861996-27194-2-git-send-email-peter.ujfalusi@ti.com>
X-Mailer: git-send-email 1.8.1.1
In-Reply-To: <1358861996-27194-1-git-send-email-peter.ujfalusi@ti.com>
References: <1358861996-27194-1-git-send-email-peter.ujfalusi@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It is expected that board files would have:
static unsigned int bl_levels[] = { 0, 50, 100, 150, 200, 250, };

static struct platform_pwm_backlight_data bl_data = {
	.levels = bl_levels,
	.max_brightness = ARRAY_SIZE(bl_levels),
	.dft_brightness = 4,
	.pwm_period_ns = 7812500,
};

In this case the max_brightness would be out of range in the levels array.
Decrement the received max_brightness in every case (DT or non DT) when the
levels has been provided.

Signed-off-by: Peter Ujfalusi <peter.ujfalusi@ti.com>
---
 drivers/video/backlight/pwm_bl.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/video/backlight/pwm_bl.c b/drivers/video/backlight/pwm_bl.c
index 069983c..f0d6854 100644
--- a/drivers/video/backlight/pwm_bl.c
+++ b/drivers/video/backlight/pwm_bl.c
@@ -142,7 +142,6 @@ static int pwm_backlight_parse_dt(struct device *dev,
 		}
 
 		data->dft_brightness = value;
-		data->max_brightness--;
 	}
 
 	/*
@@ -202,6 +201,7 @@ static int pwm_backlight_probe(struct platform_device *pdev)
 	}
 
 	if (data->levels) {
+		data->max_brightness--;
 		max = data->levels[data->max_brightness];
 		pb->levels = data->levels;
 	} else
-- 
1.8.1.1

