Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755783AbaDNWAR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Apr 2014 18:00:17 -0400
Received: from top.free-electrons.com ([176.31.233.9]:35498 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755145AbaDNWAK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Apr 2014 18:00:10 -0400
From: Alexandre Belloni <alexandre.belloni@free-electrons.com>
To: Thierry Reding <thierry.reding@gmail.com>
Cc: Tony Lindgren <tony@atomide.com>, Philipp Zabel <philipp.zabel@gmail.com>,
        Paul Parsons <lost.distance@yahoo.com>,
        Simon Horman <horms@verge.net.au>, Magnus Damm <magnus.damm@gmail.com>,
        Eric Miao <eric.y.miao@gmail.com>,
        Haojian Zhuang <haojian.zhuang@gmail.com>,
        Bryan Wu <cooloney@gmail.com>, Jingoo Han <jg1.han@samsung.com>,
        Lee Jones <lee.jones@linaro.org>, linux-pwm@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-omap@vger.kernel.org, linux-sh@vger.kernel.org,
        linux-leds@vger.kernel.org, linux-fbdev@vger.kernel.org,
        Alexandre Belloni <alexandre.belloni@free-electrons.com>
Subject: [PATCHv2 01/11] pwm: add period and polarity to struct pwm_lookup
Date: Mon, 14 Apr 2014 23:59:43 +0200
Message-Id: <1397512793-10325-2-git-send-email-alexandre.belloni@free-electrons.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1397512793-10325-1-git-send-email-alexandre.belloni@free-electrons.com>
References: <1397512793-10325-1-git-send-email-alexandre.belloni@free-electrons.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Adds a period and a polarity member to struct pwm_lookup so that when performing
a lookup using the lookup table instead of device tree, we are able to set the
period and the polarity accordingly like what is done in
of_pwm_xlate_with_flags.

The period and polarity can be set unconditionally as the default is 0 anyway.

Signed-off-by: Alexandre Belloni <alexandre.belloni@free-electrons.com>
---
 drivers/pwm/core.c  | 8 +++++++-
 include/linux/pwm.h | 2 ++
 2 files changed, 9 insertions(+), 1 deletion(-)

diff --git a/drivers/pwm/core.c b/drivers/pwm/core.c
index a80471399c20..4b66bf09ee55 100644
--- a/drivers/pwm/core.c
+++ b/drivers/pwm/core.c
@@ -661,10 +661,16 @@ struct pwm_device *pwm_get(struct device *dev, const char *con_id)
 		}
 	}
 
+	mutex_unlock(&pwm_lookup_lock);
+
 	if (chip)
 		pwm = pwm_request_from_chip(chip, index, con_id ?: dev_id);
+	if (IS_ERR(pwm))
+		return pwm;
+
+	pwm_set_period(pwm, p->period);
+	pwm_set_polarity(pwm, p->polarity);
 
-	mutex_unlock(&pwm_lookup_lock);
 
 	return pwm;
 }
diff --git a/include/linux/pwm.h b/include/linux/pwm.h
index 4717f54051cb..2f45e2fe5b93 100644
--- a/include/linux/pwm.h
+++ b/include/linux/pwm.h
@@ -274,6 +274,8 @@ struct pwm_lookup {
 	unsigned int index;
 	const char *dev_id;
 	const char *con_id;
+	unsigned int period;
+	enum pwm_polarity polarity;
 };
 
 #define PWM_LOOKUP(_provider, _index, _dev_id, _con_id)	\
-- 
1.8.3.2

