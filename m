Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758578Ab3CYOsO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Mar 2013 10:48:14 -0400
Received: from mail-we0-f179.google.com ([74.125.82.179]:51464 "EHLO
	mail-we0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758345Ab3CYOsK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Mar 2013 10:48:10 -0400
From: Richard Genoud <richard.genoud@gmail.com>
To: Linus Walleij <linus.walleij@linaro.org>,
        Stephen Warren <swarren@nvidia.com>
Cc: linux-kernel@vger.kernel.org, Richard Genoud <richard.genoud@gmail.com>
Subject: [PATCH 3/4] pinctrl: disable and free setting in select_state in case of error
Date: Mon, 25 Mar 2013 15:47:22 +0100
Message-Id: <1364222843-30305-4-git-send-email-richard.genoud@gmail.com>
X-Mailer: git-send-email 1.7.2.5
In-Reply-To: <1364222843-30305-1-git-send-email-richard.genoud@gmail.com>
References: <1364222843-30305-1-git-send-email-richard.genoud@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If enabling a pin fails in pinctrl_select_state_locked(), all the
previous enabled pins have to be disabled to get back to the previous
state.

Signed-off-by: Richard Genoud <richard.genoud@gmail.com>
---
 drivers/pinctrl/core.c |   28 +++++++++++++++++++++++++---
 1 files changed, 25 insertions(+), 3 deletions(-)

diff --git a/drivers/pinctrl/core.c b/drivers/pinctrl/core.c
index a28dcca..350d5f8 100644
--- a/drivers/pinctrl/core.c
+++ b/drivers/pinctrl/core.c
@@ -894,7 +894,7 @@ static int pinctrl_select_state_locked(struct pinctrl *p,
 		}
 	}
 
-	p->state = state;
+	p->state = NULL;
 
 	/* Apply all the settings for the new state */
 	list_for_each_entry(setting, &state->settings, node) {
@@ -910,13 +910,35 @@ static int pinctrl_select_state_locked(struct pinctrl *p,
 			ret = -EINVAL;
 			break;
 		}
+
 		if (ret < 0) {
-			/* FIXME: Difficult to return to prev state */
-			return ret;
+			goto unapply_new_state;
 		}
 	}
 
+	p->state = state;
+
 	return 0;
+
+unapply_new_state:
+	pr_info("Error applying setting, reverse things back\n");
+
+	/*
+	 * If the loop stopped on the 1st entry, nothing has been enabled,
+	 * so jump directly to the 2nd phase
+	 */
+	if (list_entry(&setting->node, typeof(*setting), node) ==
+	    list_first_entry(&state->settings, typeof(*setting), node))
+		goto reapply_old_state;
+
+	list_for_each_entry(setting2, &state->settings, node) {
+		if (&setting2->node == &setting->node)
+			break;
+		pinctrl_free_setting(true, setting2);
+	}
+reapply_old_state:
+	/* FIXME: re-enable old setting */
+	return ret;
 }
 
 /**
-- 
1.7.2.5

