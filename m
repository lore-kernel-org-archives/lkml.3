Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758594Ab3CYOsc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Mar 2013 10:48:32 -0400
Received: from mail-wg0-f53.google.com ([74.125.82.53]:57049 "EHLO
	mail-wg0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758462Ab3CYOsN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Mar 2013 10:48:13 -0400
From: Richard Genoud <richard.genoud@gmail.com>
To: Linus Walleij <linus.walleij@linaro.org>,
        Stephen Warren <swarren@nvidia.com>
Cc: linux-kernel@vger.kernel.org, Richard Genoud <richard.genoud@gmail.com>
Subject: [PATCH 4/4] pinctrl: re-enable old state in case of error in pinctrl_select_state
Date: Mon, 25 Mar 2013 15:47:23 +0100
Message-Id: <1364222843-30305-5-git-send-email-richard.genoud@gmail.com>
X-Mailer: git-send-email 1.7.2.5
In-Reply-To: <1364222843-30305-1-git-send-email-richard.genoud@gmail.com>
References: <1364222843-30305-1-git-send-email-richard.genoud@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If a new state is applied, the groups configured in the old state but
not in the new state are disabled.
If something goes wrong and the new state can't be applied, we have to
re-enable those groups.

Signed-off-by: Richard Genoud <richard.genoud@gmail.com>
---
 drivers/pinctrl/core.c |   20 +++++++++++++++++++-
 1 files changed, 19 insertions(+), 1 deletions(-)

diff --git a/drivers/pinctrl/core.c b/drivers/pinctrl/core.c
index 350d5f8..9b505acc 100644
--- a/drivers/pinctrl/core.c
+++ b/drivers/pinctrl/core.c
@@ -861,6 +861,7 @@ static int pinctrl_select_state_locked(struct pinctrl *p,
 				       struct pinctrl_state *state)
 {
 	struct pinctrl_setting *setting, *setting2;
+	struct pinctrl_state *old_state = p->state;
 	int ret;
 
 	if (p->state == state)
@@ -937,7 +938,24 @@ unapply_new_state:
 		pinctrl_free_setting(true, setting2);
 	}
 reapply_old_state:
-	/* FIXME: re-enable old setting */
+	if (old_state) {
+		list_for_each_entry(setting, &old_state->settings, node) {
+			bool found = false;
+			if (setting->type != PIN_MAP_TYPE_MUX_GROUP)
+				continue;
+			list_for_each_entry(setting2, &state->settings, node) {
+				if (setting2->type != PIN_MAP_TYPE_MUX_GROUP)
+					continue;
+				if (setting2->data.mux.group ==
+						setting->data.mux.group) {
+					found = true;
+					break;
+				}
+			}
+			if (!found)
+				pinmux_enable_setting(setting);
+		}
+	}
 	return ret;
 }
 
-- 
1.7.2.5

