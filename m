Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753783AbaLIIf3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Dec 2014 03:35:29 -0500
Received: from mx07-00178001.pphosted.com ([62.209.51.94]:42710 "EHLO
	mx07-00178001.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751453AbaLIIf1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Dec 2014 03:35:27 -0500
From: Patrice CHOTARD <patrice.chotard@st.com>
To: <linux-kernel@vger.kernel.org>, Linus Walleij <linus.walleij@linaro.org>
Subject: [PATCH 1/2] pinctrl: st: avoid multiple mutex lock
Date: Tue,  9 Dec 2014 09:35:14 +0100
Message-Id: <1418114115-26064-2-git-send-email-patrice.chotard@st.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1418114115-26064-1-git-send-email-patrice.chotard@st.com>
References: <1418114115-26064-1-git-send-email-patrice.chotard@st.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.13.68,1.0.33,0.0.0000
 definitions=2014-12-09_03:2014-12-08,2014-12-09,1970-01-01 signatures=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Francesco VIRLINZI <francesco.virlinzi@st.com>

Using the sysfs inteface to inspect the pins configuration
the system can walk around a path which acquires the same
mutex twice.

On STiH407 platform, for example :
cat /sys/kernel/debug/pinctrl/920f080.pin-controller-front0/pinconf-pins
hangs the kernel and never returns.

With this patch the mutex is temporary freed.

Signed-off-by: Francesco Virlinzi <francesco.virlinzi@st.com>
Signed-off-by: Patrice Chotard <patrice.chotard@st.com>
---
 drivers/pinctrl/pinctrl-st.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/pinctrl/pinctrl-st.c b/drivers/pinctrl/pinctrl-st.c
index caeeb1c..2870a68 100644
--- a/drivers/pinctrl/pinctrl-st.c
+++ b/drivers/pinctrl/pinctrl-st.c
@@ -1012,8 +1012,10 @@ static void st_pinconf_dbg_show(struct pinctrl_dev *pctldev,
 				   struct seq_file *s, unsigned pin_id)
 {
 	unsigned long config;
-	st_pinconf_get(pctldev, pin_id, &config);
 
+	mutex_unlock(&pctldev->mutex);
+	st_pinconf_get(pctldev, pin_id, &config);
+	mutex_lock(&pctldev->mutex);
 	seq_printf(s, "[OE:%ld,PU:%ld,OD:%ld]\n"
 		"\t\t[retime:%ld,invclk:%ld,clknotdat:%ld,"
 		"de:%ld,rt-clk:%ld,rt-delay:%ld]",
-- 
1.9.1

