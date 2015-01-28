Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759675AbbA1B2f (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jan 2015 20:28:35 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:41026 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759748AbbA1B2P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jan 2015 20:28:15 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Jim Lin <jilin@nvidia.com>, Linus Walleij <linus.walleij@linaro.org>
Subject: [PATCH 3.18 04/61] pinctrl: Fix two deadlocks
Date: Tue, 27 Jan 2015 17:26:16 -0800
Message-Id: <20150128012637.353047191@linuxfoundation.org>
X-Mailer: git-send-email 2.2.2
In-Reply-To: <20150128012636.936333725@linuxfoundation.org>
References: <20150128012636.936333725@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jim Lin <jilin@nvidia.com>

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/pinctrl/core.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

--- a/drivers/pinctrl/core.c
+++ b/drivers/pinctrl/core.c
@@ -1801,14 +1801,15 @@ void pinctrl_unregister(struct pinctrl_d
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


