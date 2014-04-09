Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934165AbaDISFz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Apr 2014 14:05:55 -0400
Received: from top.free-electrons.com ([176.31.233.9]:34426 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S933353AbaDISFw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Apr 2014 14:05:52 -0400
From: Alexandre Belloni <alexandre.belloni@free-electrons.com>
To: Thierry Reding <thierry.reding@gmail.com>
Cc: Tony Lindgren <tony@atomide.com>, Philipp Zabel <philipp.zabel@gmail.com>,
        Paul Parsons <lost.distance@yahoo.com>,
        Simon Horman <horms@verge.net.au>, Magnus Damm <magnus.damm@gmail.com>,
        linux-pwm@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-omap@vger.kernel.org,
        linux-sh@vger.kernel.org,
        Alexandre Belloni <alexandre.belloni@free-electrons.com>
Subject: [PATCH 1/2] pwm: add period and polarity to struct pwm_lookup
Date: Wed,  9 Apr 2014 20:04:08 +0200
Message-Id: <1397066649-3767-2-git-send-email-alexandre.belloni@free-electrons.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1397066649-3767-1-git-send-email-alexandre.belloni@free-electrons.com>
References: <1397066649-3767-1-git-send-email-alexandre.belloni@free-electrons.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Adds a period and a polarity member to struct pwm_lookup so that when performing
a lookup using the lookup table instead of device tree, we are able to set the
period and the polarity accordingly like what is done in
of_pwm_xlate_with_flags.

Signed-off-by: Alexandre Belloni <alexandre.belloni@free-electrons.com>
---
 drivers/pwm/core.c  | 5 +++++
 include/linux/pwm.h | 2 ++
 2 files changed, 7 insertions(+)

diff --git a/drivers/pwm/core.c b/drivers/pwm/core.c
index a80471399c20..206e5996359c 100644
--- a/drivers/pwm/core.c
+++ b/drivers/pwm/core.c
@@ -663,6 +663,11 @@ struct pwm_device *pwm_get(struct device *dev, const char *con_id)
 
 	if (chip)
 		pwm = pwm_request_from_chip(chip, index, con_id ?: dev_id);
+	if (IS_ERR(pwm))
+		return pwm;
+
+	pwm_set_period(pwm, p->period);
+	pwm_set_polarity(pwm, p->polarity);
 
 	mutex_unlock(&pwm_lookup_lock);
 
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

