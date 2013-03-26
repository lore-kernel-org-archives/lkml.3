Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760180Ab3CZThK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Mar 2013 15:37:10 -0400
Received: from mail-vc0-f202.google.com ([209.85.220.202]:55132 "EHLO
	mail-vc0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757117Ab3CZThI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Mar 2013 15:37:08 -0400
From: Shawn Nematbakhsh <shawnn@chromium.org>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: Shawn Nematbakhsh <shawnn@chromium.org>, JJ Ding <dgdunix@gmail.com>,
        linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
        Chung-yih Wang <cywang@chromium.org>
Subject: [PATCH] Input: trackpoint - Optimize trackpoint init to use power-on reset
Date: Tue, 26 Mar 2013 12:36:41 -0700
Message-Id: <1364326601-16571-1-git-send-email-shawnn@chromium.org>
X-Mailer: git-send-email 1.8.1.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The trackpoint driver sets various parameter default values, all of
which happen to be power-on defaults (Source: IBM TrackPoint Engineering
Specification, Version 4.0. Also confirmed by empirical data).

By sending the power-on reset command to reset all parameters to
power-on state, we can skip the lengthy process of programming all
parameters. In testing, ~2.5 secs of time writing parameters was reduced
to .35 seconds waiting for power-on reset to complete.

Signed-off-by: Shawn Nematbakhsh <shawnn@chromium.org>
---
 drivers/input/mouse/trackpoint.c | 223 +++++++++++++++++++++++++--------------
 drivers/input/mouse/trackpoint.h |   7 +-
 2 files changed, 149 insertions(+), 81 deletions(-)

diff --git a/drivers/input/mouse/trackpoint.c b/drivers/input/mouse/trackpoint.c
index f310249..17e9b36 100644
--- a/drivers/input/mouse/trackpoint.c
+++ b/drivers/input/mouse/trackpoint.c
@@ -20,6 +20,26 @@
 #include "trackpoint.h"
 
 /*
+ * Power-on Reset: Resets all trackpoint parameters, including RAM values,
+ * to defaults.
+ * Returns zero on success, non-zero on failure.
+ */
+static int trackpoint_power_on_reset(struct ps2dev *ps2dev)
+{
+	unsigned char results[2];
+
+	if (ps2_command(ps2dev, NULL, MAKE_PS2_CMD(0, 0, TP_COMMAND)) ||
+	    ps2_command(ps2dev, results, MAKE_PS2_CMD(0, 2, TP_POR))) {
+		return -1;
+	}
+
+	/* POR response should be 0xAA00 or 0xFC00 */
+	if ((results[0] != 0xAA && results[0] != 0xFC) || results[1] != 0x00)
+		return -1;
+	return 0;
+}
+
+/*
  * Device IO: read, write and toggle bit
  */
 static int trackpoint_read(struct ps2dev *ps2dev, unsigned char loc, unsigned char *results)
@@ -69,6 +89,7 @@ struct trackpoint_attr_data {
 	unsigned char command;
 	unsigned char mask;
 	unsigned char inverted;
+	unsigned char power_on_default;
 };
 
 static ssize_t trackpoint_show_int_attr(struct psmouse *psmouse, void *data, char *buf)
@@ -102,10 +123,11 @@ static ssize_t trackpoint_set_int_attr(struct psmouse *psmouse, void *data,
 	return count;
 }
 
-#define TRACKPOINT_INT_ATTR(_name, _command)					\
+#define TRACKPOINT_INT_ATTR(_name, _command, _default)				\
 	static struct trackpoint_attr_data trackpoint_attr_##_name = {		\
 		.field_offset = offsetof(struct trackpoint_data, _name),	\
 		.command = _command,						\
+		.power_on_default = _default,					\
 	};									\
 	PSMOUSE_DEFINE_ATTR(_name, S_IWUSR | S_IRUGO,				\
 			    &trackpoint_attr_##_name,				\
@@ -139,31 +161,71 @@ static ssize_t trackpoint_set_bit_attr(struct psmouse *psmouse, void *data,
 }
 
 
-#define TRACKPOINT_BIT_ATTR(_name, _command, _mask, _inv)				\
+#define TRACKPOINT_BIT_ATTR(_name, _command, _mask, _inv, _default)		\
 	static struct trackpoint_attr_data trackpoint_attr_##_name = {		\
-		.field_offset	= offsetof(struct trackpoint_data, _name),	\
-		.command	= _command,					\
-		.mask		= _mask,					\
-		.inverted	= _inv,						\
+		.field_offset		= offsetof(struct trackpoint_data,	\
+						   _name),			\
+		.command		= _command,				\
+		.mask			= _mask,				\
+		.inverted		= _inv,					\
+		.power_on_default	= _default,				\
 	};									\
 	PSMOUSE_DEFINE_ATTR(_name, S_IWUSR | S_IRUGO,				\
 			    &trackpoint_attr_##_name,				\
 			    trackpoint_show_int_attr, trackpoint_set_bit_attr)
 
-TRACKPOINT_INT_ATTR(sensitivity, TP_SENS);
-TRACKPOINT_INT_ATTR(speed, TP_SPEED);
-TRACKPOINT_INT_ATTR(inertia, TP_INERTIA);
-TRACKPOINT_INT_ATTR(reach, TP_REACH);
-TRACKPOINT_INT_ATTR(draghys, TP_DRAGHYS);
-TRACKPOINT_INT_ATTR(mindrag, TP_MINDRAG);
-TRACKPOINT_INT_ATTR(thresh, TP_THRESH);
-TRACKPOINT_INT_ATTR(upthresh, TP_UP_THRESH);
-TRACKPOINT_INT_ATTR(ztime, TP_Z_TIME);
-TRACKPOINT_INT_ATTR(jenks, TP_JENKS_CURV);
-
-TRACKPOINT_BIT_ATTR(press_to_select, TP_TOGGLE_PTSON, TP_MASK_PTSON, 0);
-TRACKPOINT_BIT_ATTR(skipback, TP_TOGGLE_SKIPBACK, TP_MASK_SKIPBACK, 0);
-TRACKPOINT_BIT_ATTR(ext_dev, TP_TOGGLE_EXT_DEV, TP_MASK_EXT_DEV, 1);
+#define TRACKPOINT_UPDATE_BIT(_psmouse, _tp, _name)				\
+	do {									\
+		unsigned char _toggle;						\
+		struct trackpoint_attr_data *_attr = &trackpoint_attr_##_name;	\
+		trackpoint_read(&_psmouse->ps2dev, _attr->command, &_toggle);	\
+		if (((_toggle & _attr->mask) == _attr->mask) !=			\
+		      _tp->_name)						\
+			trackpoint_toggle_bit(&_psmouse->ps2dev,		\
+					      _attr->command,			\
+					      _attr->mask);			\
+	} while (0)
+
+#define TRACKPOINT_UPDATE(_power_on, _psmouse, _tp, _name)			\
+	do {									\
+		if (!_power_on ||						\
+		    _tp->_name != trackpoint_attr_##_name.power_on_default) {	\
+			if (!trackpoint_attr_##_name.mask)			\
+				trackpoint_write(&_psmouse->ps2dev,		\
+						 trackpoint_attr_##_name.	\
+						 command,			\
+						 _tp->_name);			\
+			else							\
+				TRACKPOINT_UPDATE_BIT(_psmouse, _tp, _name);	\
+		}								\
+	} while (0)
+
+#define TRACKPOINT_SET_POWER_ON_DEFAULT(_tp, _name)				\
+	(_tp->_name = trackpoint_attr_##_name.power_on_default)
+
+TRACKPOINT_INT_ATTR(sensitivity, TP_SENS, TP_DEF_SENS);
+TRACKPOINT_INT_ATTR(speed, TP_SPEED, TP_DEF_SPEED);
+TRACKPOINT_INT_ATTR(inertia, TP_INERTIA, TP_DEF_INERTIA);
+TRACKPOINT_INT_ATTR(reach, TP_REACH, TP_DEF_REACH);
+TRACKPOINT_INT_ATTR(draghys, TP_DRAGHYS, TP_DEF_DRAGHYS);
+TRACKPOINT_INT_ATTR(mindrag, TP_MINDRAG, TP_DEF_MINDRAG);
+TRACKPOINT_INT_ATTR(thresh, TP_THRESH, TP_DEF_THRESH);
+TRACKPOINT_INT_ATTR(upthresh, TP_UP_THRESH, TP_DEF_UP_THRESH);
+TRACKPOINT_INT_ATTR(ztime, TP_Z_TIME, TP_DEF_Z_TIME);
+TRACKPOINT_INT_ATTR(jenks, TP_JENKS_CURV, TP_DEF_JENKS_CURV);
+
+TRACKPOINT_BIT_ATTR(press_to_select, TP_TOGGLE_PTSON, TP_MASK_PTSON, 0,
+		    TP_DEF_PTSON);
+TRACKPOINT_BIT_ATTR(skipback, TP_TOGGLE_SKIPBACK, TP_MASK_SKIPBACK, 0,
+		    TP_DEF_SKIPBACK);
+TRACKPOINT_BIT_ATTR(ext_dev, TP_TOGGLE_EXT_DEV, TP_MASK_EXT_DEV, 1,
+		    TP_DEF_EXT_DEV);
+TRACKPOINT_BIT_ATTR(twohand, TP_TOGGLE_TWOHAND, TP_MASK_TWOHAND, 0,
+		    TP_DEF_TWOHAND);
+TRACKPOINT_BIT_ATTR(source_tag, TP_TOGGLE_SOURCE_TAG, TP_MASK_SOURCE_TAG, 0,
+		    TP_DEF_SOURCE_TAG);
+TRACKPOINT_BIT_ATTR(mb, TP_TOGGLE_MB, TP_MASK_MB, 0,
+		    TP_DEF_MB);
 
 static struct attribute *trackpoint_attrs[] = {
 	&psmouse_attr_sensitivity.dattr.attr,
@@ -179,6 +241,9 @@ static struct attribute *trackpoint_attrs[] = {
 	&psmouse_attr_press_to_select.dattr.attr,
 	&psmouse_attr_skipback.dattr.attr,
 	&psmouse_attr_ext_dev.dattr.attr,
+	&psmouse_attr_twohand.dattr.attr,
+	&psmouse_attr_source_tag.dattr.attr,
+	&psmouse_attr_mb.dattr.attr,
 	NULL
 };
 
@@ -202,73 +267,63 @@ static int trackpoint_start_protocol(struct psmouse *psmouse, unsigned char *fir
 	return 0;
 }
 
-static int trackpoint_sync(struct psmouse *psmouse)
+/*
+ * Write parameters to trackpad.
+ * in_power_on_state: Set to true if TP is in default / power-on state (ex. if
+ *		      power-on reset was run). If so, values will only be
+ *		      written to TP if they differ from power-on default.
+ */
+static int trackpoint_sync(struct psmouse *psmouse, bool in_power_on_state)
 {
 	struct trackpoint_data *tp = psmouse->private;
-	unsigned char toggle;
-
-	/* Disable features that may make device unusable with this driver */
-	trackpoint_read(&psmouse->ps2dev, TP_TOGGLE_TWOHAND, &toggle);
-	if (toggle & TP_MASK_TWOHAND)
-		trackpoint_toggle_bit(&psmouse->ps2dev, TP_TOGGLE_TWOHAND, TP_MASK_TWOHAND);
 
-	trackpoint_read(&psmouse->ps2dev, TP_TOGGLE_SOURCE_TAG, &toggle);
-	if (toggle & TP_MASK_SOURCE_TAG)
-		trackpoint_toggle_bit(&psmouse->ps2dev, TP_TOGGLE_SOURCE_TAG, TP_MASK_SOURCE_TAG);
-
-	trackpoint_read(&psmouse->ps2dev, TP_TOGGLE_MB, &toggle);
-	if (toggle & TP_MASK_MB)
-		trackpoint_toggle_bit(&psmouse->ps2dev, TP_TOGGLE_MB, TP_MASK_MB);
-
-	/* Push the config to the device */
-	trackpoint_write(&psmouse->ps2dev, TP_SENS, tp->sensitivity);
-	trackpoint_write(&psmouse->ps2dev, TP_INERTIA, tp->inertia);
-	trackpoint_write(&psmouse->ps2dev, TP_SPEED, tp->speed);
-
-	trackpoint_write(&psmouse->ps2dev, TP_REACH, tp->reach);
-	trackpoint_write(&psmouse->ps2dev, TP_DRAGHYS, tp->draghys);
-	trackpoint_write(&psmouse->ps2dev, TP_MINDRAG, tp->mindrag);
-
-	trackpoint_write(&psmouse->ps2dev, TP_THRESH, tp->thresh);
-	trackpoint_write(&psmouse->ps2dev, TP_UP_THRESH, tp->upthresh);
-
-	trackpoint_write(&psmouse->ps2dev, TP_Z_TIME, tp->ztime);
-	trackpoint_write(&psmouse->ps2dev, TP_JENKS_CURV, tp->jenks);
-
-	trackpoint_read(&psmouse->ps2dev, TP_TOGGLE_PTSON, &toggle);
-	if (((toggle & TP_MASK_PTSON) == TP_MASK_PTSON) != tp->press_to_select)
-		 trackpoint_toggle_bit(&psmouse->ps2dev, TP_TOGGLE_PTSON, TP_MASK_PTSON);
-
-	trackpoint_read(&psmouse->ps2dev, TP_TOGGLE_SKIPBACK, &toggle);
-	if (((toggle & TP_MASK_SKIPBACK) == TP_MASK_SKIPBACK) != tp->skipback)
-		trackpoint_toggle_bit(&psmouse->ps2dev, TP_TOGGLE_SKIPBACK, TP_MASK_SKIPBACK);
-
-	trackpoint_read(&psmouse->ps2dev, TP_TOGGLE_EXT_DEV, &toggle);
-	if (((toggle & TP_MASK_EXT_DEV) == TP_MASK_EXT_DEV) != tp->ext_dev)
-		trackpoint_toggle_bit(&psmouse->ps2dev, TP_TOGGLE_EXT_DEV, TP_MASK_EXT_DEV);
+	/*
+	* These properties can be changed in this driver. Only
+	* configure them if the values are non-default or if the TP is in
+	* an unknown state.
+	*/
+	TRACKPOINT_UPDATE(in_power_on_state, psmouse, tp, sensitivity);
+	TRACKPOINT_UPDATE(in_power_on_state, psmouse, tp, inertia);
+	TRACKPOINT_UPDATE(in_power_on_state, psmouse, tp, speed);
+	TRACKPOINT_UPDATE(in_power_on_state, psmouse, tp, reach);
+	TRACKPOINT_UPDATE(in_power_on_state, psmouse, tp, draghys);
+	TRACKPOINT_UPDATE(in_power_on_state, psmouse, tp, mindrag);
+	TRACKPOINT_UPDATE(in_power_on_state, psmouse, tp, thresh);
+	TRACKPOINT_UPDATE(in_power_on_state, psmouse, tp, upthresh);
+	TRACKPOINT_UPDATE(in_power_on_state, psmouse, tp, ztime);
+	TRACKPOINT_UPDATE(in_power_on_state, psmouse, tp, jenks);
+
+	/* toggles */
+	TRACKPOINT_UPDATE(in_power_on_state, psmouse, tp, press_to_select);
+	TRACKPOINT_UPDATE(in_power_on_state, psmouse, tp, skipback);
+	TRACKPOINT_UPDATE(in_power_on_state, psmouse, tp, ext_dev);
+	TRACKPOINT_UPDATE(in_power_on_state, psmouse, tp, twohand);
+	TRACKPOINT_UPDATE(in_power_on_state, psmouse, tp, source_tag);
+	TRACKPOINT_UPDATE(in_power_on_state, psmouse, tp, mb);
 
 	return 0;
 }
 
 static void trackpoint_defaults(struct trackpoint_data *tp)
 {
-	tp->press_to_select = TP_DEF_PTSON;
-	tp->sensitivity = TP_DEF_SENS;
-	tp->speed = TP_DEF_SPEED;
-	tp->reach = TP_DEF_REACH;
-
-	tp->draghys = TP_DEF_DRAGHYS;
-	tp->mindrag = TP_DEF_MINDRAG;
-
-	tp->thresh = TP_DEF_THRESH;
-	tp->upthresh = TP_DEF_UP_THRESH;
-
-	tp->ztime = TP_DEF_Z_TIME;
-	tp->jenks = TP_DEF_JENKS_CURV;
-
-	tp->inertia = TP_DEF_INERTIA;
-	tp->skipback = TP_DEF_SKIPBACK;
-	tp->ext_dev = TP_DEF_EXT_DEV;
+	TRACKPOINT_SET_POWER_ON_DEFAULT(tp, sensitivity);
+	TRACKPOINT_SET_POWER_ON_DEFAULT(tp, speed);
+	TRACKPOINT_SET_POWER_ON_DEFAULT(tp, reach);
+	TRACKPOINT_SET_POWER_ON_DEFAULT(tp, draghys);
+	TRACKPOINT_SET_POWER_ON_DEFAULT(tp, mindrag);
+	TRACKPOINT_SET_POWER_ON_DEFAULT(tp, thresh);
+	TRACKPOINT_SET_POWER_ON_DEFAULT(tp, upthresh);
+	TRACKPOINT_SET_POWER_ON_DEFAULT(tp, ztime);
+	TRACKPOINT_SET_POWER_ON_DEFAULT(tp, jenks);
+	TRACKPOINT_SET_POWER_ON_DEFAULT(tp, inertia);
+
+	/* toggles */
+	TRACKPOINT_SET_POWER_ON_DEFAULT(tp, press_to_select);
+	TRACKPOINT_SET_POWER_ON_DEFAULT(tp, skipback);
+	TRACKPOINT_SET_POWER_ON_DEFAULT(tp, ext_dev);
+	TRACKPOINT_SET_POWER_ON_DEFAULT(tp, twohand);
+	TRACKPOINT_SET_POWER_ON_DEFAULT(tp, source_tag);
+	TRACKPOINT_SET_POWER_ON_DEFAULT(tp, mb);
 }
 
 static void trackpoint_disconnect(struct psmouse *psmouse)
@@ -281,10 +336,13 @@ static void trackpoint_disconnect(struct psmouse *psmouse)
 
 static int trackpoint_reconnect(struct psmouse *psmouse)
 {
+	int reset_fail;
+
 	if (trackpoint_start_protocol(psmouse, NULL))
 		return -1;
 
-	if (trackpoint_sync(psmouse))
+	reset_fail = trackpoint_power_on_reset(&psmouse->ps2dev);
+	if (trackpoint_sync(psmouse, !reset_fail))
 		return -1;
 
 	return 0;
@@ -322,7 +380,12 @@ int trackpoint_detect(struct psmouse *psmouse, bool set_properties)
 		__set_bit(BTN_MIDDLE, psmouse->dev->keybit);
 
 	trackpoint_defaults(psmouse->private);
-	trackpoint_sync(psmouse);
+
+	error = trackpoint_power_on_reset(&psmouse->ps2dev);
+
+	/* Write defaults to TP only if reset fails. */
+	if (error)
+		trackpoint_sync(psmouse, false);
 
 	error = sysfs_create_group(&ps2dev->serio->dev.kobj, &trackpoint_attr_group);
 	if (error) {
diff --git a/drivers/input/mouse/trackpoint.h b/drivers/input/mouse/trackpoint.h
index e558a70..e0bc03b 100644
--- a/drivers/input/mouse/trackpoint.h
+++ b/drivers/input/mouse/trackpoint.h
@@ -126,6 +126,8 @@
 #define TP_DEF_PTSON		0x00
 #define TP_DEF_SKIPBACK		0x00
 #define TP_DEF_EXT_DEV		0x00	/* 0 means enabled */
+#define TP_DEF_TWOHAND		0x00
+#define TP_DEF_SOURCE_TAG	0x00
 
 #define MAKE_PS2_CMD(params, results, cmd) ((params<<12) | (results<<8) | (cmd))
 
@@ -136,10 +138,13 @@ struct trackpoint_data
 	unsigned char thresh, upthresh;
 	unsigned char ztime, jenks;
 
+	/* toggles */
 	unsigned char press_to_select;
 	unsigned char skipback;
-
 	unsigned char ext_dev;
+	unsigned char twohand;
+	unsigned char source_tag;
+	unsigned char mb;
 };
 
 #ifdef CONFIG_MOUSE_PS2_TRACKPOINT
-- 
1.7.12.4

