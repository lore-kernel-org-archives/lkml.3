Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752927AbbA2JAp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Jan 2015 04:00:45 -0500
Received: from ip4-83-240-67-251.cust.nbox.cz ([83.240.67.251]:44737 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1756097AbbA2JAj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Jan 2015 04:00:39 -0500
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Jim Lin <jilin@nvidia.com>,
        Linus Walleij <linus.walleij@linaro.org>, Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 141/176] pinctrl: Fix two deadlocks
Date: Wed, 28 Jan 2015 15:29:31 +0100
Message-Id: <ded7a6cf7db0671259f479a48f51748473647361.1422455352.git.jslaby@suse.cz>
X-Mailer: git-send-email 2.2.2
In-Reply-To: <ce4a451f616a1e7ab58cfeceea5e49c8b1c68c81.1422455352.git.jslaby@suse.cz>
References: <ce4a451f616a1e7ab58cfeceea5e49c8b1c68c81.1422455352.git.jslaby@suse.cz>
In-Reply-To: <cover.1422455352.git.jslaby@suse.cz>
References: <cover.1422455352.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jim Lin <jilin@nvidia.com>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

commit db93facfb0ef542aa5d8079e47580b3e669a4d82 upstream.

This patch is to fix two deadlock cases.
Deadlock 1:
CPU #1
 pinctrl_register-> pinctrl_get ->
 create_pinctrl
 (Holding lock pinctrl_maps_mutex)
 -> get_pinctrl_dev_from_devname
 (Trying to acquire lock pinctrldev_list_mutex)
CPU #0
 pinctrl_unregister
 (Holding lock pinctrldev_list_mutex)
 -> pinctrl_put ->> pinctrl_free ->
 pinctrl_dt_free_maps -> pinctrl_unregister_map
 (Trying to acquire lock pinctrl_maps_mutex)

Simply to say
CPU#1 is holding lock A and trying to acquire lock B,
CPU#0 is holding lock B and trying to acquire lock A.

Deadlock 2:
CPU #3
 pinctrl_register-> pinctrl_get ->
 create_pinctrl
 (Holding lock pinctrl_maps_mutex)
 -> get_pinctrl_dev_from_devname
 (Trying to acquire lock pinctrldev_list_mutex)
CPU #2
 pinctrl_unregister
 (Holding lock pctldev->mutex)
 -> pinctrl_put ->> pinctrl_free ->
 pinctrl_dt_free_maps -> pinctrl_unregister_map
 (Trying to acquire lock pinctrl_maps_mutex)
CPU #0
 tegra_gpio_request
 (Holding lock pinctrldev_list_mutex)
 -> pinctrl_get_device_gpio_range
 (Trying to acquire lock pctldev->mutex)

Simply to say
CPU#3 is holding lock A and trying to acquire lock D,
CPU#2 is holding lock B and trying to acquire lock A,
CPU#0 is holding lock D and trying to acquire lock B.

Signed-off-by: Jim Lin <jilin@nvidia.com>
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 drivers/pinctrl/core.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/pinctrl/core.c b/drivers/pinctrl/core.c
index a1ffae4c3770..260a2551d612 100644
--- a/drivers/pinctrl/core.c
+++ b/drivers/pinctrl/core.c
@@ -1796,14 +1796,15 @@ void pinctrl_unregister(struct pinctrl_dev *pctldev)
 	if (pctldev == NULL)
 		return;
 
-	mutex_lock(&pinctrldev_list_mutex);
 	mutex_lock(&pctldev->mutex);
-
 	pinctrl_remove_device_debugfs(pctldev);
+	mutex_unlock(&pctldev->mutex);
 
 	if (!IS_ERR(pctldev->p))
 		pinctrl_put(pctldev->p);
 
+	mutex_lock(&pinctrldev_list_mutex);
+	mutex_lock(&pctldev->mutex);
 	/* TODO: check that no pinmuxes are still active? */
 	list_del(&pctldev->node);
 	/* Destroy descriptor tree */
-- 
2.2.2

