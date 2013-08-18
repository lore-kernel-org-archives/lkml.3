Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755438Ab3HRMe2 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Aug 2013 08:34:28 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:48261 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755368Ab3HRMe1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Aug 2013 08:34:27 -0400
Message-ID: <1376829262.3391.1.camel@phoenix>
Subject: [PATCH 1/2] pinctrl: core: Hold pinctrldev_list_mutex mutex while
 traversing pinctrldev_list
From: Axel Lin <axel.lin@ingics.com>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: Haojian Zhuang <haojian.zhuang@linaro.org>, linux-kernel@vger.kernel.org
Date: Sun, 18 Aug 2013 20:34:22 +0800
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This one is missed in commit 44d5f7bb "pinctrl: sink pinctrldev_list_mutex".

Signed-off-by: Axel Lin <axel.lin@ingics.com>
---
 drivers/pinctrl/core.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/pinctrl/core.c b/drivers/pinctrl/core.c
index c8fcedb..c670527 100644
--- a/drivers/pinctrl/core.c
+++ b/drivers/pinctrl/core.c
@@ -392,6 +392,8 @@ static int pinctrl_get_device_gpio_range(unsigned gpio,
 {
 	struct pinctrl_dev *pctldev = NULL;
 
+	mutex_lock(&pinctrldev_list_mutex);
+
 	/* Loop over the pin controllers */
 	list_for_each_entry(pctldev, &pinctrldev_list, node) {
 		struct pinctrl_gpio_range *range;
@@ -400,10 +402,13 @@ static int pinctrl_get_device_gpio_range(unsigned gpio,
 		if (range != NULL) {
 			*outdev = pctldev;
 			*outrange = range;
+			mutex_unlock(&pinctrldev_list_mutex);
 			return 0;
 		}
 	}
 
+	mutex_unlock(&pinctrldev_list_mutex);
+
 	return -EPROBE_DEFER;
 }
 
-- 
1.8.1.2



