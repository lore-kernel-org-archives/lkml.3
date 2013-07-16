Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754692Ab3GPJGy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Jul 2013 05:06:54 -0400
Received: from mho-02-ewr.mailhop.org ([204.13.248.72]:24159 "EHLO
	mho-02-ewr.mailhop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754151Ab3GPJFf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Jul 2013 05:05:35 -0400
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 50.131.214.131
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX19Ric9Y204SANzD771qGk86
Subject: [PATCH 2/4] pinctrl: Allow pinctrl to have multiple active states
To: linus.walleij@linaro.org
From: Tony Lindgren <tony@atomide.com>
Cc: linux-omap@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Stephen Warren <swarren@wwwdotorg.org>
Date: Tue, 16 Jul 2013 02:05:34 -0700
Message-ID: <20130716090534.5541.60381.stgit@localhost>
In-Reply-To: <20130716090310.5541.36777.stgit@localhost>
References: <20130716090310.5541.36777.stgit@localhost>
User-Agent: StGit/0.16-1-ga54b
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It's quite common that we need to dynamically change some pins for a
device for runtime PM, or toggle a pin between rx and tx. Changing all
the pins for a device is not efficient way of doing it.

So let's allow setting up multiple active states for pinctrl. Currently
we only need PINCTRL_STATIC and PINCTRL_DYNAMIC, where PINCTRL_STATIC
covers the current default pins, and PINCTRL_DYNAMIC holds the dynamic
pins that need to be toggled.

Cc: Stephen Warren <swarren@wwwdotorg.org>
Signed-off-by: Tony Lindgren <tony@atomide.com>
---
 drivers/pinctrl/core.c |   18 ++++++++++--------
 drivers/pinctrl/core.h |   10 ++++++++--
 2 files changed, 18 insertions(+), 10 deletions(-)

diff --git a/drivers/pinctrl/core.c b/drivers/pinctrl/core.c
index bda2c61..8da11d5 100644
--- a/drivers/pinctrl/core.c
+++ b/drivers/pinctrl/core.c
@@ -885,7 +885,8 @@ static void pinctrl_free(struct pinctrl *p, bool inlist)
 	mutex_lock(&pinctrl_list_mutex);
 	list_for_each_entry_safe(state, n1, &p->states, node) {
 		list_for_each_entry_safe(setting, n2, &state->settings, node) {
-			pinctrl_free_setting(state == p->state, setting);
+			pinctrl_free_setting(state == p->state[PINCTRL_STATIC],
+					     setting);
 			list_del(&setting->node);
 			kfree(setting);
 		}
@@ -955,13 +956,13 @@ EXPORT_SYMBOL_GPL(pinctrl_lookup_state);
 int pinctrl_select_state(struct pinctrl *p, struct pinctrl_state *state)
 {
 	struct pinctrl_setting *setting, *setting2;
-	struct pinctrl_state *old_state = p->state;
+	struct pinctrl_state *old_state = p->state[PINCTRL_STATIC];
 	int ret;
 
-	if (p->state == state)
+	if (old_state == state)
 		return 0;
 
-	if (p->state) {
+	if (old_state) {
 		/*
 		 * The set of groups with a mux configuration in the old state
 		 * may not be identical to the set of groups with a mux setting
@@ -971,7 +972,7 @@ int pinctrl_select_state(struct pinctrl *p, struct pinctrl_state *state)
 		 * but not in the new state, this code puts that group into a
 		 * safe/disabled state.
 		 */
-		list_for_each_entry(setting, &p->state->settings, node) {
+		list_for_each_entry(setting, &old_state->settings, node) {
 			bool found = false;
 			if (setting->type != PIN_MAP_TYPE_MUX_GROUP)
 				continue;
@@ -989,7 +990,7 @@ int pinctrl_select_state(struct pinctrl *p, struct pinctrl_state *state)
 		}
 	}
 
-	p->state = NULL;
+	p->state[PINCTRL_STATIC] = NULL;
 
 	/* Apply all the settings for the new state */
 	list_for_each_entry(setting, &state->settings, node) {
@@ -1011,7 +1012,7 @@ int pinctrl_select_state(struct pinctrl *p, struct pinctrl_state *state)
 		}
 	}
 
-	p->state = state;
+	p->state[PINCTRL_STATIC] = state;
 
 	return 0;
 
@@ -1484,7 +1485,8 @@ static int pinctrl_show(struct seq_file *s, void *what)
 	list_for_each_entry(p, &pinctrl_list, node) {
 		seq_printf(s, "device: %s current state: %s\n",
 			   dev_name(p->dev),
-			   p->state ? p->state->name : "none");
+			   p->state[PINCTRL_STATIC] ?
+			   p->state[PINCTRL_STATIC]->name : "none");
 
 		list_for_each_entry(state, &p->states, node) {
 			seq_printf(s, "  state: %s\n", state->name);
diff --git a/drivers/pinctrl/core.h b/drivers/pinctrl/core.h
index 75476b3..b99e4b3 100644
--- a/drivers/pinctrl/core.h
+++ b/drivers/pinctrl/core.h
@@ -53,12 +53,18 @@ struct pinctrl_dev {
 #endif
 };
 
+enum pinctr_states {
+	PINCTRL_STATIC,
+	PINCTRL_DYNAMIC,
+	PINCTRL_NR_STATES,
+};
+
 /**
  * struct pinctrl - per-device pin control state holder
  * @node: global list node
  * @dev: the device using this pin control handle
  * @states: a list of states for this device
- * @state: the current state
+ * @state: the current state(s)
  * @dt_maps: the mapping table chunks dynamically parsed from device tree for
  *	this device, if any
  * @users: reference count
@@ -67,7 +73,7 @@ struct pinctrl {
 	struct list_head node;
 	struct device *dev;
 	struct list_head states;
-	struct pinctrl_state *state;
+	struct pinctrl_state *state[PINCTRL_NR_STATES];
 	struct list_head dt_maps;
 	struct kref users;
 };

