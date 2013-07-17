Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754319Ab3GQLnk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Jul 2013 07:43:40 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:52622 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753707Ab3GQLni (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Jul 2013 07:43:38 -0400
From: Grygorii Strashko <grygorii.strashko@ti.com>
To: Tony Lindgren <tony@atomide.com>, Kevin Hilman <khilman@linaro.org>
CC: <linux-arm-kernel@lists.infradead.org>, <linux-omap@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <devicetree-discuss@lists.ozlabs.org>,
        Grygorii Strashko <grygorii.strashko@ti.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Stephen Warren <swarren@wwwdotorg.org>
Subject: [PATCH 1/3] pinctrl: rollback check for !dev->pins in pinctrl_pm_select*() APIs
Date: Wed, 17 Jul 2013 14:41:50 +0300
Message-ID: <1374061312-25469-2-git-send-email-grygorii.strashko@ti.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1374061312-25469-1-git-send-email-grygorii.strashko@ti.com>
References: <1374061312-25469-1-git-send-email-grygorii.strashko@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The pinctrl support in Device core assumed to be optional - so, It's
valid case, when there are no definition for default device's pinctrl
states in DT at all ("default", "active", "idle", "sleep").
And in this case dev->pins == NULL and pinctrl_pm_select*() API
should return 0 always.

Now the checks for !dev->pins have been removed from
pinctrl_pm_select*() API mistakenly by the patch
pinctrl: Remove duplicate code in pinctrl_pm_select_state functions
http://www.spinics.net/lists/arm-kernel/msg258829.html

Hence, rollback these checks in in pinctrl_pm_select*() APIs.

CC: Linus Walleij <linus.walleij@linaro.org>
Cc: Stephen Warren <swarren@wwwdotorg.org>
Signed-off-by: Grygorii Strashko <grygorii.strashko@ti.com>
---
Seems this one can be squashed in series
[PATCH 0/4] improved support for runtime muxing for pinctrl"
http://www.spinics.net/lists/arm-kernel/msg258827.html

 drivers/pinctrl/core.c |   12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/drivers/pinctrl/core.c b/drivers/pinctrl/core.c
index 4f58a97..ace4eb8 100644
--- a/drivers/pinctrl/core.c
+++ b/drivers/pinctrl/core.c
@@ -1390,6 +1390,9 @@ static int pinctrl_pm_select_state(struct device *dev, struct pinctrl_state *sta
  */
 int pinctrl_pm_select_default_state(struct device *dev)
 {
+	if (!dev->pins)
+		return 0;
+
 	return pinctrl_pm_select_state(dev, dev->pins->default_state);
 }
 EXPORT_SYMBOL_GPL(pinctrl_pm_select_default_state);
@@ -1400,6 +1403,9 @@ EXPORT_SYMBOL_GPL(pinctrl_pm_select_default_state);
  */
 int pinctrl_pm_select_active_state(struct device *dev)
 {
+	if (!dev->pins)
+		return 0;
+
 	return pinctrl_pm_select_state(dev, dev->pins->active_state);
 }
 EXPORT_SYMBOL_GPL(pinctrl_pm_select_active_state);
@@ -1410,6 +1416,9 @@ EXPORT_SYMBOL_GPL(pinctrl_pm_select_active_state);
  */
 int pinctrl_pm_select_sleep_state(struct device *dev)
 {
+	if (!dev->pins)
+		return 0;
+
 	return pinctrl_pm_select_state(dev, dev->pins->sleep_state);
 }
 EXPORT_SYMBOL_GPL(pinctrl_pm_select_sleep_state);
@@ -1420,6 +1429,9 @@ EXPORT_SYMBOL_GPL(pinctrl_pm_select_sleep_state);
  */
 int pinctrl_pm_select_idle_state(struct device *dev)
 {
+	if (!dev->pins)
+		return 0;
+
 	return pinctrl_pm_select_state(dev, dev->pins->idle_state);
 }
 EXPORT_SYMBOL_GPL(pinctrl_pm_select_idle_state);
-- 
1.7.9.5

