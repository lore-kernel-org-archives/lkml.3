Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758549Ab3CYOyp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Mar 2013 10:54:45 -0400
Received: from mail-we0-f180.google.com ([74.125.82.180]:61640 "EHLO
	mail-we0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758522Ab3CYOyo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Mar 2013 10:54:44 -0400
From: Richard Genoud <richard.genoud@gmail.com>
To: Linus Walleij <linus.walleij@linaro.org>,
        Stephen Warren <swarren@nvidia.com>
Cc: linux-kernel@vger.kernel.org, Richard Genoud <richard.genoud@gmail.com>
Subject: [PATCH 2/4] pinctrl: create pinctrl_free_setting function
Date: Mon, 25 Mar 2013 15:47:21 +0100
Message-Id: <1364222843-30305-3-git-send-email-richard.genoud@gmail.com>
X-Mailer: git-send-email 1.7.2.5
In-Reply-To: <1364222843-30305-1-git-send-email-richard.genoud@gmail.com>
References: <1364222843-30305-1-git-send-email-richard.genoud@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This prepares the implementation of pinctrl_select_state_locked() free code.

No functionnal change.

Signed-off-by: Richard Genoud <richard.genoud@gmail.com>
---
 drivers/pinctrl/core.c |   32 +++++++++++++++++++-------------
 1 files changed, 19 insertions(+), 13 deletions(-)

diff --git a/drivers/pinctrl/core.c b/drivers/pinctrl/core.c
index b0de6e7..a28dcca 100644
--- a/drivers/pinctrl/core.c
+++ b/drivers/pinctrl/core.c
@@ -758,6 +758,24 @@ struct pinctrl *pinctrl_get(struct device *dev)
 }
 EXPORT_SYMBOL_GPL(pinctrl_get);
 
+static void pinctrl_free_setting(bool disable_setting,
+				 struct pinctrl_setting *setting)
+{
+	switch (setting->type) {
+	case PIN_MAP_TYPE_MUX_GROUP:
+		if (disable_setting)
+			pinmux_disable_setting(setting);
+		pinmux_free_setting(setting);
+		break;
+	case PIN_MAP_TYPE_CONFIGS_PIN:
+	case PIN_MAP_TYPE_CONFIGS_GROUP:
+		pinconf_free_setting(setting);
+		break;
+	default:
+		break;
+	}
+}
+
 static void pinctrl_put_locked(struct pinctrl *p, bool inlist)
 {
 	struct pinctrl_state *state, *n1;
@@ -765,19 +783,7 @@ static void pinctrl_put_locked(struct pinctrl *p, bool inlist)
 
 	list_for_each_entry_safe(state, n1, &p->states, node) {
 		list_for_each_entry_safe(setting, n2, &state->settings, node) {
-			switch (setting->type) {
-			case PIN_MAP_TYPE_MUX_GROUP:
-				if (state == p->state)
-					pinmux_disable_setting(setting);
-				pinmux_free_setting(setting);
-				break;
-			case PIN_MAP_TYPE_CONFIGS_PIN:
-			case PIN_MAP_TYPE_CONFIGS_GROUP:
-				pinconf_free_setting(setting);
-				break;
-			default:
-				break;
-			}
+			pinctrl_free_setting(state == p->state, setting);
 			list_del(&setting->node);
 			kfree(setting);
 		}
-- 
1.7.2.5

