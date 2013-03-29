Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753603Ab3C2JDr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Mar 2013 05:03:47 -0400
Received: from mail-we0-f180.google.com ([74.125.82.180]:61292 "EHLO
	mail-we0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750965Ab3C2JDo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Mar 2013 05:03:44 -0400
From: Richard Genoud <richard.genoud@gmail.com>
To: Linus Walleij <linus.walleij@linaro.org>,
        Stephen Warren <swarren@nvidia.com>
Cc: linux-kernel@vger.kernel.org, Richard Genoud <richard.genoud@gmail.com>
Subject: [PATCH 2/2] pinctrl: simplify the re-enable old state code in pinctrl_select_state
Date: Fri, 29 Mar 2013 10:03:27 +0100
Message-Id: <1364547807-22370-2-git-send-email-richard.genoud@gmail.com>
X-Mailer: git-send-email 1.7.2.5
In-Reply-To: <1364547807-22370-1-git-send-email-richard.genoud@gmail.com>
References: <1364547807-22370-1-git-send-email-richard.genoud@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Instead of just enabling the settings that were disabled in the 1st
loop, it's simpler to recall pinctrl_select_state with the old state.

Signed-off-by: Richard Genoud <richard.genoud@gmail.com>
---
 drivers/pinctrl/core.c |   22 +++-------------------
 1 files changed, 3 insertions(+), 19 deletions(-)

diff --git a/drivers/pinctrl/core.c b/drivers/pinctrl/core.c
index ddd9a150..caf9bf9 100644
--- a/drivers/pinctrl/core.c
+++ b/drivers/pinctrl/core.c
@@ -937,26 +937,10 @@ unapply_new_state:
 			pinmux_disable_setting(setting2);
 	}
 
-	if (old_state) {
-		list_for_each_entry(setting, &old_state->settings, node) {
-			bool found = false;
-			if (setting->type != PIN_MAP_TYPE_MUX_GROUP)
-				continue;
-			list_for_each_entry(setting2, &state->settings, node) {
-				if (setting2->type != PIN_MAP_TYPE_MUX_GROUP)
-					continue;
-				if (setting2->data.mux.group ==
-						setting->data.mux.group) {
-					found = true;
-					break;
-				}
-			}
-			if (!found)
-				pinmux_enable_setting(setting);
-		}
-	}
+	/* There's no infinite recursive loop here because p->state is NULL */
+	if (old_state)
+		pinctrl_select_state_locked(p, old_state);
 
-	p->state = old_state;
 	return ret;
 }
 
-- 
1.7.2.5

