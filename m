Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752447Ab3C2JDm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Mar 2013 05:03:42 -0400
Received: from mail-we0-f177.google.com ([74.125.82.177]:53613 "EHLO
	mail-we0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750923Ab3C2JDk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Mar 2013 05:03:40 -0400
From: Richard Genoud <richard.genoud@gmail.com>
To: Linus Walleij <linus.walleij@linaro.org>,
        Stephen Warren <swarren@nvidia.com>
Cc: linux-kernel@vger.kernel.org, Richard Genoud <richard.genoud@gmail.com>
Subject: [PATCH 1/2] pinctrl: select_state: don't call pinctrl_free_setting on error
Date: Fri, 29 Mar 2013 10:03:26 +0100
Message-Id: <1364547807-22370-1-git-send-email-richard.genoud@gmail.com>
X-Mailer: git-send-email 1.7.2.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

As Stephen Warren pointed out, pinctrl_free_setting() was called instead
of pinmux_disable_setting() on error.
In this error code, we want to call pinmux_disable_setting() where
pinmux_enable_setting() was called.
And when pinconf_apply_setting() was called, we can't do much to undo
the pin muxing (the closest thing I can think about for "unmuxing" a pin
is muxing it as GPIO input).

Signed-off-by: Richard Genoud <richard.genoud@gmail.com>
---
This commit is on top of:
[PATCH 3/3] pinctrl: pinctrl_select_state: set the old_state back on error

 drivers/pinctrl/core.c |   10 +++++++++-
 1 files changed, 9 insertions(+), 1 deletions(-)

diff --git a/drivers/pinctrl/core.c b/drivers/pinctrl/core.c
index 714cf74..ddd9a150 100644
--- a/drivers/pinctrl/core.c
+++ b/drivers/pinctrl/core.c
@@ -926,7 +926,15 @@ unapply_new_state:
 	list_for_each_entry(setting2, &state->settings, node) {
 		if (&setting2->node == &setting->node)
 			break;
-		pinctrl_free_setting(true, setting2);
+		/*
+		 * All we can do here is pinmux_disable_setting.
+		 * That means that some pins are muxed differently now
+		 * than they were before applying the setting (We can't
+		 * "unmux a pin"!), but it's not a big deal since the pins
+		 * are free to be muxed by another apply_setting.
+		 */
+		if (setting2->type == PIN_MAP_TYPE_MUX_GROUP)
+			pinmux_disable_setting(setting2);
 	}
 
 	if (old_state) {
-- 
1.7.2.5

