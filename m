Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755739Ab3C1L4N (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Mar 2013 07:56:13 -0400
Received: from mail-wg0-f51.google.com ([74.125.82.51]:64660 "EHLO
	mail-wg0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755629Ab3C1L4J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Mar 2013 07:56:09 -0400
From: Richard Genoud <richard.genoud@gmail.com>
To: Linus Walleij <linus.walleij@linaro.org>,
        Stephen Warren <swarren@nvidia.com>
Cc: linux-kernel@vger.kernel.org, Richard Genoud <richard.genoud@gmail.com>
Subject: [PATCH 2/3] pinctrl: remove superfluous optimization in pinctrl_select_state_locked
Date: Thu, 28 Mar 2013 12:55:47 +0100
Message-Id: <1364471748-23192-2-git-send-email-richard.genoud@gmail.com>
X-Mailer: git-send-email 1.7.2.5
In-Reply-To: <1364471748-23192-1-git-send-email-richard.genoud@gmail.com>
References: <1364471748-23192-1-git-send-email-richard.genoud@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

As Stephen Warren suggested, checking first if the setting->node entry
is the first in the list or not is superfluous, as it is checked again
in the list_for_each_entry bellow.
So, remove it, the code will be simpler and lighter !

Signed-off-by: Richard Genoud <richard.genoud@gmail.com>
---
If can also be squashed whit commit:
3102a76cfbf9ac4ae0cf54c7452f7ba4292a4760
"pinctrl: disable and free setting in select_state in case of error"
(But there will be a conflict on "if (old_state)" vs "FIXME comment")

 drivers/pinctrl/core.c |   10 +---------
 1 files changed, 1 insertions(+), 9 deletions(-)

diff --git a/drivers/pinctrl/core.c b/drivers/pinctrl/core.c
index b98a275..7c34937 100644
--- a/drivers/pinctrl/core.c
+++ b/drivers/pinctrl/core.c
@@ -923,20 +923,12 @@ static int pinctrl_select_state_locked(struct pinctrl *p,
 unapply_new_state:
 	dev_err(p->dev, "Error applying setting, reverse things back\n");
 
-	/*
-	 * If the loop stopped on the 1st entry, nothing has been enabled,
-	 * so jump directly to the 2nd phase
-	 */
-	if (list_entry(&setting->node, typeof(*setting), node) ==
-	    list_first_entry(&state->settings, typeof(*setting), node))
-		goto reapply_old_state;
-
 	list_for_each_entry(setting2, &state->settings, node) {
 		if (&setting2->node == &setting->node)
 			break;
 		pinctrl_free_setting(true, setting2);
 	}
-reapply_old_state:
+
 	if (old_state) {
 		list_for_each_entry(setting, &old_state->settings, node) {
 			bool found = false;
-- 
1.7.2.5

