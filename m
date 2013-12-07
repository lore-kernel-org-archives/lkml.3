Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758392Ab3LGNJp (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Dec 2013 08:09:45 -0500
Received: from top.free-electrons.com ([176.31.233.9]:57585 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755446Ab3LGNJL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Dec 2013 08:09:11 -0500
From: Alexandre Belloni <alexandre.belloni@free-electrons.com>
To: Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>
Cc: Nicolas Ferre <nicolas.ferre@atmel.com>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Linus Walleij <linus.walleij@linaro.org>,
        Alexandre Belloni <alexandre.belloni@free-electrons.com>
Subject: [PATCH 3/3] pinctrl: at91: implement at91_pinconf_dbg_show
Date: Sat,  7 Dec 2013 14:08:54 +0100
Message-Id: <1386421734-10240-3-git-send-email-alexandre.belloni@free-electrons.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1386421734-10240-1-git-send-email-alexandre.belloni@free-electrons.com>
References: <1386421734-10240-1-git-send-email-alexandre.belloni@free-electrons.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This allows to get the pin configuration by using debugfs. On my system:
 # cat /sys/kernel/debug/pinctrl/pinctrl.3/pinconf-pins

Signed-off-by: Alexandre Belloni <alexandre.belloni@free-electrons.com>
---
 drivers/pinctrl/pinctrl-at91.c | 25 +++++++++++++++++++++++++
 1 file changed, 25 insertions(+)

diff --git a/drivers/pinctrl/pinctrl-at91.c b/drivers/pinctrl/pinctrl-at91.c
index b0b78f3468ae..bcfc8a2eebca 100644
--- a/drivers/pinctrl/pinctrl-at91.c
+++ b/drivers/pinctrl/pinctrl-at91.c
@@ -784,10 +784,35 @@ static int at91_pinconf_set(struct pinctrl_dev *pctldev,
 	return 0;
 }
 
+#define DBG_SHOW_FLAG(flag) do {		\
+	if (config & flag) {			\
+		if (num_conf)			\
+			seq_puts(s, "|");	\
+		seq_puts(s, #flag);		\
+		num_conf++;			\
+	}					\
+} while (0)
+
 static void at91_pinconf_dbg_show(struct pinctrl_dev *pctldev,
 				   struct seq_file *s, unsigned pin_id)
 {
+	unsigned long config;
+	int ret, val, num_conf = 0;
+
+	ret = at91_pinconf_get(pctldev, pin_id, &config);
+
+	DBG_SHOW_FLAG(MULTI_DRIVE);
+	DBG_SHOW_FLAG(PULL_UP);
+	DBG_SHOW_FLAG(PULL_DOWN);
+	DBG_SHOW_FLAG(DIS_SCHMIT);
+	DBG_SHOW_FLAG(DEGLITCH);
+	DBG_SHOW_FLAG(DEBOUNCE);
+	if (config & DEBOUNCE) {
+		val = config >> DEBOUNCE_VAL_SHIFT;
+		seq_printf(s, "(%d)", val);
+	}
 
+	return;
 }
 
 static void at91_pinconf_group_dbg_show(struct pinctrl_dev *pctldev,
-- 
1.8.3.2

