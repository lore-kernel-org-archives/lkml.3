Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752451AbaLELyD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Dec 2014 06:54:03 -0500
Received: from mail-wi0-f181.google.com ([209.85.212.181]:50250 "EHLO
	mail-wi0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751122AbaLELyA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Dec 2014 06:54:00 -0500
From: =?UTF-8?q?Pali=20Roh=C3=A1r?= <pali.rohar@gmail.com>
To: Darren Hart <dvhart@infradead.org>, Matthew Garrett <mjg59@srcf.ucam.org>
Cc: platform-driver-x86@vger.kernel.org, linux-kernel@vger.kernel.org,
        libsmbios-devel@lists.us.dell.com, Srinivas_G_Gowda@dell.com,
        Michael_E_Brown@dell.com,
        =?UTF-8?q?Pali=20Roh=C3=A1r?= <pali.rohar@gmail.com>,
        Gabriele Mazzotta <gabriele.mzt@gmail.com>,
        Dan Carpenter <dan.carpenter@oracle.com>
Subject: [PATCH v3] platform: x86: dell-laptop: Add support for keyboard backlight
Date: Fri,  5 Dec 2014 12:53:31 +0100
Message-Id: <1417780411-5859-1-git-send-email-pali.rohar@gmail.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1415967813-7223-1-git-send-email-pali.rohar@gmail.com>
References: <1415967813-7223-1-git-send-email-pali.rohar@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds support for configuring keyboard backlight settings on supported
Dell laptops. It exports kernel leds interface and uses Dell SMBIOS tokens or
keyboard class interface.

With this patch it is possible to set:
* keyboard backlight level
* timeout after which will be backlight automatically turned off
* input activity triggers (keyboard, touchpad, mouse) which enable backlight
* ambient light settings

Settings are exported via sysfs:
/sys/class/leds/dell::kbd_backlight/

Code is based on newly released documentation by Dell in libsmbios project.

Thanks to Dan Carpenter who reported bug about unpredictable results in
quirks->kbd_timeouts for loop. His fix adds needs_kbd_timeouts flag to
quirk structure to indicate if kbd_timeouts array is empty or not.

Signed-off-by: Pali Rohár <pali.rohar@gmail.com>
Signed-off-by: Gabriele Mazzotta <gabriele.mzt@gmail.com>
Cc: Dan Carpenter <dan.carpenter@oracle.com>
---
Changes since v2:
* fix bug reported by Dan Carpenter with his patch
* style fixes
* add some comments
Changes since v1:
* returns also -EIO/-ENXIO (with helper function dell_smi_error)
* simplify code to have less levels of indentation
* style fixes
* add some comments
---
 drivers/platform/x86/dell-laptop.c | 1055 +++++++++++++++++++++++++++++++++++-
 1 file changed, 1049 insertions(+), 6 deletions(-)

diff --git a/drivers/platform/x86/dell-laptop.c b/drivers/platform/x86/dell-laptop.c
index 233d2ee..08d34f3 100644
--- a/drivers/platform/x86/dell-laptop.c
+++ b/drivers/platform/x86/dell-laptop.c
@@ -2,9 +2,11 @@
  *  Driver for Dell laptop extras
  *
  *  Copyright (c) Red Hat <mjg@redhat.com>
+ *  Copyright (c) 2014 Gabriele Mazzotta <gabriele.mzt@gmail.com>
+ *  Copyright (c) 2014 Pali Rohár <pali.rohar@gmail.com>
  *
- *  Based on documentation in the libsmbios package, Copyright (C) 2005 Dell
- *  Inc.
+ *  Based on documentation in the libsmbios package:
+ *  Copyright (C) 2005-2014 Dell Inc.
  *
  *  This program is free software; you can redistribute it and/or modify
  *  it under the terms of the GNU General Public License version 2 as
@@ -32,6 +34,13 @@
 #include "../../firmware/dcdbas.h"
 
 #define BRIGHTNESS_TOKEN 0x7d
+#define KBD_LED_OFF_TOKEN 0x01E1
+#define KBD_LED_ON_TOKEN 0x01E2
+#define KBD_LED_AUTO_TOKEN 0x01E3
+#define KBD_LED_AUTO_25_TOKEN 0x02EA
+#define KBD_LED_AUTO_50_TOKEN 0x02EB
+#define KBD_LED_AUTO_75_TOKEN 0x02EC
+#define KBD_LED_AUTO_100_TOKEN 0x02F6
 
 /* This structure will be modified by the firmware when we enter
  * system management mode, hence the volatiles */
@@ -62,6 +71,13 @@ struct calling_interface_structure {
 
 struct quirk_entry {
 	u8 touchpad_led;
+
+	int needs_kbd_timeouts;
+	/*
+	 * Ordered list of timeouts expressed in seconds.
+	 * The list must end with -1
+	 */
+	int kbd_timeouts[];
 };
 
 static struct quirk_entry *quirks;
@@ -76,6 +92,15 @@ static int __init dmi_matched(const struct dmi_system_id *dmi)
 	return 1;
 }
 
+/*
+ * These values come from Windows utility provided by Dell. If any other value
+ * is used then BIOS silently set timeout to 0 without any error message.
+ */
+static struct quirk_entry quirk_dell_xps13_9333 = {
+	.needs_kbd_timeouts = 1,
+	.kbd_timeouts = { 0, 5, 15, 60, 5 * 60, 15 * 60, -1 },
+};
+
 static int da_command_address;
 static int da_command_code;
 static int da_num_tokens;
@@ -268,6 +293,15 @@ static const struct dmi_system_id dell_quirks[] __initconst = {
 		},
 		.driver_data = &quirk_dell_vostro_v130,
 	},
+	{
+		.callback = dmi_matched,
+		.ident = "Dell XPS13 9333",
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "Dell Inc."),
+			DMI_MATCH(DMI_PRODUCT_NAME, "XPS13 9333"),
+		},
+		.driver_data = &quirk_dell_xps13_9333,
+	},
 	{ }
 };
 
@@ -332,17 +366,29 @@ static void __init find_tokens(const struct dmi_header *dm, void *dummy)
 	}
 }
 
-static int find_token_location(int tokenid)
+static int find_token_id(int tokenid)
 {
 	int i;
+
 	for (i = 0; i < da_num_tokens; i++) {
 		if (da_tokens[i].tokenID == tokenid)
-			return da_tokens[i].location;
+			return i;
 	}
 
 	return -1;
 }
 
+static int find_token_location(int tokenid)
+{
+	int id;
+
+	id = find_token_id(tokenid);
+	if (id == -1)
+		return -1;
+
+	return da_tokens[id].location;
+}
+
 static struct calling_interface_buffer *
 dell_send_request(struct calling_interface_buffer *buffer, int class,
 		  int select)
@@ -363,6 +409,20 @@ dell_send_request(struct calling_interface_buffer *buffer, int class,
 	return buffer;
 }
 
+static inline int dell_smi_error(int value)
+{
+	switch (value) {
+	case 0: /* Completed successfully */
+		return 0;
+	case -1: /* Completed with error */
+		return -EIO;
+	case -2: /* Function not supported */
+		return -ENXIO;
+	default: /* Unknown error */
+		return -EINVAL;
+	}
+}
+
 /* Derived from information in DellWirelessCtl.cpp:
    Class 17, select 11 is radio control. It returns an array of 32-bit values.
 
@@ -717,7 +777,7 @@ static int dell_send_intensity(struct backlight_device *bd)
 	else
 		dell_send_request(buffer, 1, 1);
 
-out:
+ out:
 	release_buffer();
 	return ret;
 }
@@ -741,7 +801,7 @@ static int dell_get_intensity(struct backlight_device *bd)
 
 	ret = buffer->output[1];
 
-out:
+ out:
 	release_buffer();
 	return ret;
 }
@@ -790,6 +850,984 @@ static void touchpad_led_exit(void)
 	led_classdev_unregister(&touchpad_led);
 }
 
+/*
+ * Derived from information in smbios-keyboard-ctl:
+ *
+ * cbClass 4
+ * cbSelect 11
+ * Keyboard illumination
+ * cbArg1 determines the function to be performed
+ *
+ * cbArg1 0x0 = Get Feature Information
+ *  cbRES1         Standard return codes (0, -1, -2)
+ *  cbRES2, word0  Bitmap of user-selectable modes
+ *     bit 0     Always off (All systems)
+ *     bit 1     Always on (Travis ATG, Siberia)
+ *     bit 2     Auto: ALS-based On; ALS-based Off (Travis ATG)
+ *     bit 3     Auto: ALS- and input-activity-based On; input-activity based Off
+ *     bit 4     Auto: Input-activity-based On; input-activity based Off
+ *     bit 5     Auto: Input-activity-based On (illumination level 25%); input-activity based Off
+ *     bit 6     Auto: Input-activity-based On (illumination level 50%); input-activity based Off
+ *     bit 7     Auto: Input-activity-based On (illumination level 75%); input-activity based Off
+ *     bit 8     Auto: Input-activity-based On (illumination level 100%); input-activity based Off
+ *     bits 9-15 Reserved for future use
+ *  cbRES2, byte2  Reserved for future use
+ *  cbRES2, byte3  Keyboard illumination type
+ *     0         Reserved
+ *     1         Tasklight
+ *     2         Backlight
+ *     3-255     Reserved for future use
+ *  cbRES3, byte0  Supported auto keyboard illumination trigger bitmap.
+ *     bit 0     Any keystroke
+ *     bit 1     Touchpad activity
+ *     bit 2     Pointing stick
+ *     bit 3     Any mouse
+ *     bits 4-7  Reserved for future use
+ *  cbRES3, byte1  Supported timeout unit bitmap
+ *     bit 0     Seconds
+ *     bit 1     Minutes
+ *     bit 2     Hours
+ *     bit 3     Days
+ *     bits 4-7  Reserved for future use
+ *  cbRES3, byte2  Number of keyboard light brightness levels
+ *  cbRES4, byte0  Maximum acceptable seconds value (0 if seconds not supported).
+ *  cbRES4, byte1  Maximum acceptable minutes value (0 if minutes not supported).
+ *  cbRES4, byte2  Maximum acceptable hours value (0 if hours not supported).
+ *  cbRES4, byte3  Maximum acceptable days value (0 if days not supported)
+ *
+ * cbArg1 0x1 = Get Current State
+ *  cbRES1         Standard return codes (0, -1, -2)
+ *  cbRES2, word0  Bitmap of current mode state
+ *     bit 0     Always off (All systems)
+ *     bit 1     Always on (Travis ATG, Siberia)
+ *     bit 2     Auto: ALS-based On; ALS-based Off (Travis ATG)
+ *     bit 3     Auto: ALS- and input-activity-based On; input-activity based Off
+ *     bit 4     Auto: Input-activity-based On; input-activity based Off
+ *     bit 5     Auto: Input-activity-based On (illumination level 25%); input-activity based Off
+ *     bit 6     Auto: Input-activity-based On (illumination level 50%); input-activity based Off
+ *     bit 7     Auto: Input-activity-based On (illumination level 75%); input-activity based Off
+ *     bit 8     Auto: Input-activity-based On (illumination level 100%); input-activity based Off
+ *     bits 9-15 Reserved for future use
+ *     Note: Only One bit can be set
+ *  cbRES2, byte2  Currently active auto keyboard illumination triggers.
+ *     bit 0     Any keystroke
+ *     bit 1     Touchpad activity
+ *     bit 2     Pointing stick
+ *     bit 3     Any mouse
+ *     bits 4-7  Reserved for future use
+ *  cbRES2, byte3  Current Timeout
+ *     bits 7:6  Timeout units indicator:
+ *     00b       Seconds
+ *     01b       Minutes
+ *     10b       Hours
+ *     11b       Days
+ *     bits 5:0  Timeout value (0-63) in sec/min/hr/day
+ *     NOTE: A value of 0 means always on (no timeout) if any bits of RES3 byte
+ *     are set upon return from the [Get feature information] call.
+ *  cbRES3, byte0  Current setting of ALS value that turns the light on or off.
+ *  cbRES3, byte1  Current ALS reading
+ *  cbRES3, byte2  Current keyboard light level.
+ *
+ * cbArg1 0x2 = Set New State
+ *  cbRES1         Standard return codes (0, -1, -2)
+ *  cbArg2, word0  Bitmap of current mode state
+ *     bit 0     Always off (All systems)
+ *     bit 1     Always on (Travis ATG, Siberia)
+ *     bit 2     Auto: ALS-based On; ALS-based Off (Travis ATG)
+ *     bit 3     Auto: ALS- and input-activity-based On; input-activity based Off
+ *     bit 4     Auto: Input-activity-based On; input-activity based Off
+ *     bit 5     Auto: Input-activity-based On (illumination level 25%); input-activity based Off
+ *     bit 6     Auto: Input-activity-based On (illumination level 50%); input-activity based Off
+ *     bit 7     Auto: Input-activity-based On (illumination level 75%); input-activity based Off
+ *     bit 8     Auto: Input-activity-based On (illumination level 100%); input-activity based Off
+ *     bits 9-15 Reserved for future use
+ *     Note: Only One bit can be set
+ *  cbArg2, byte2  Desired auto keyboard illumination triggers. Must remain inactive to allow
+ *                 keyboard to turn off automatically.
+ *     bit 0     Any keystroke
+ *     bit 1     Touchpad activity
+ *     bit 2     Pointing stick
+ *     bit 3     Any mouse
+ *     bits 4-7  Reserved for future use
+ *  cbArg2, byte3  Desired Timeout
+ *     bits 7:6  Timeout units indicator:
+ *     00b       Seconds
+ *     01b       Minutes
+ *     10b       Hours
+ *     11b       Days
+ *     bits 5:0  Timeout value (0-63) in sec/min/hr/day
+ *  cbArg3, byte0  Desired setting of ALS value that turns the light on or off.
+ *  cbArg3, byte2  Desired keyboard light level.
+ */
+
+
+enum kbd_timeout_unit {
+	KBD_TIMEOUT_SECONDS = 0,
+	KBD_TIMEOUT_MINUTES,
+	KBD_TIMEOUT_HOURS,
+	KBD_TIMEOUT_DAYS,
+};
+
+enum kbd_mode_bit {
+	KBD_MODE_BIT_OFF = 0,
+	KBD_MODE_BIT_ON,
+	KBD_MODE_BIT_ALS,
+	KBD_MODE_BIT_TRIGGER_ALS,
+	KBD_MODE_BIT_TRIGGER,
+	KBD_MODE_BIT_TRIGGER_25,
+	KBD_MODE_BIT_TRIGGER_50,
+	KBD_MODE_BIT_TRIGGER_75,
+	KBD_MODE_BIT_TRIGGER_100,
+};
+
+#define kbd_is_als_mode_bit(bit) \
+	((bit) == KBD_MODE_BIT_ALS || (bit) == KBD_MODE_BIT_TRIGGER_ALS)
+#define kbd_is_trigger_mode_bit(bit) \
+	((bit) >= KBD_MODE_BIT_TRIGGER_ALS && (bit) <= KBD_MODE_BIT_TRIGGER_100)
+#define kbd_is_level_mode_bit(bit) \
+	((bit) >= KBD_MODE_BIT_TRIGGER_25 && (bit) <= KBD_MODE_BIT_TRIGGER_100)
+
+struct kbd_info {
+	u16 modes;
+	u8 type;
+	u8 triggers;
+	u8 levels;
+	u8 seconds;
+	u8 minutes;
+	u8 hours;
+	u8 days;
+};
+
+struct kbd_state {
+	u8 mode_bit;
+	u8 triggers;
+	u8 timeout_value;
+	u8 timeout_unit;
+	u8 als_setting;
+	u8 als_value;
+	u8 level;
+};
+
+static const int kbd_tokens[] = {
+	KBD_LED_OFF_TOKEN,
+	KBD_LED_AUTO_25_TOKEN,
+	KBD_LED_AUTO_50_TOKEN,
+	KBD_LED_AUTO_75_TOKEN,
+	KBD_LED_AUTO_100_TOKEN,
+	KBD_LED_ON_TOKEN,
+};
+
+static u16 kbd_token_bits;
+
+static struct kbd_info kbd_info;
+static bool kbd_als_supported;
+static bool kbd_triggers_supported;
+
+static u8 kbd_mode_levels[16];
+static int kbd_mode_levels_count;
+
+static u8 kbd_previous_level;
+static u8 kbd_previous_mode_bit;
+
+static bool kbd_led_present;
+
+/*
+ * NOTE: there are three ways how to set keyboard backlight level.
+ * First is via kbd_state.mode_bit (assigning KBD_MODE_BIT_TRIGGER_* value)
+ * Second is via kbd_state.level (assigning number value <= kbd_info.levels)
+ * Third is via SMBIOS tokens (KBD_LED_* in kbd_tokens)
+ *
+ * There are laptops which support only one of above methods. If we want to
+ * support as much as possible machines we need to implement all of methods.
+ * First two methods are using kbd_state structure third is using SMBIOS tokens.
+ * If kbd_info.levels == 0 then machine does not support setting keyboard
+ * backlight level via second way.
+ */
+
+static int kbd_get_info(struct kbd_info *info)
+{
+	u8 units;
+	int ret;
+
+	get_buffer();
+
+	buffer->input[0] = 0x0;
+	dell_send_request(buffer, 4, 11);
+	ret = buffer->output[0];
+
+	if (ret) {
+		ret = dell_smi_error(ret);
+		goto out;
+	}
+
+	info->modes = buffer->output[1] & 0xFFFF;
+	info->type = (buffer->output[1] >> 24) & 0xFF;
+	info->triggers = buffer->output[2] & 0xFF;
+	units = (buffer->output[2] >> 8) & 0xFF;
+	info->levels = (buffer->output[2] >> 16) & 0xFF;
+
+	if (units & BIT(0))
+		info->seconds = (buffer->output[3] >> 0) & 0xFF;
+	if (units & BIT(1))
+		info->minutes = (buffer->output[3] >> 8) & 0xFF;
+	if (units & BIT(2))
+		info->hours = (buffer->output[3] >> 16) & 0xFF;
+	if (units & BIT(3))
+		info->days = (buffer->output[3] >> 24) & 0xFF;
+
+ out:
+	release_buffer();
+	return ret;
+}
+
+static unsigned int kbd_get_max_level(void)
+{
+	if (kbd_info.levels != 0)
+		return kbd_info.levels;
+	if (kbd_mode_levels_count > 0)
+		return kbd_mode_levels_count - 1;
+	return 0;
+}
+
+static int kbd_get_level(struct kbd_state *state)
+{
+	int i;
+
+	if (kbd_info.levels != 0)
+		return state->level;
+
+	if (kbd_mode_levels_count > 0) {
+		for (i = 0; i < kbd_mode_levels_count; ++i)
+			if (kbd_mode_levels[i] == state->mode_bit)
+				return i;
+		return 0;
+	}
+
+	return -EINVAL;
+}
+
+static int kbd_set_level(struct kbd_state *state, u8 level)
+{
+	if (kbd_info.levels != 0) {
+		if (level != 0)
+			kbd_previous_level = level;
+		if (state->level == level)
+			return 0;
+		state->level = level;
+		if (level != 0 && state->mode_bit == KBD_MODE_BIT_OFF)
+			state->mode_bit = kbd_previous_mode_bit;
+		else if (level == 0 && state->mode_bit != KBD_MODE_BIT_OFF) {
+			kbd_previous_mode_bit = state->mode_bit;
+			state->mode_bit = KBD_MODE_BIT_OFF;
+		}
+		return 0;
+	}
+
+	if (kbd_mode_levels_count > 0 && level < kbd_mode_levels_count) {
+		if (level != 0)
+			kbd_previous_level = level;
+		state->mode_bit = kbd_mode_levels[level];
+		return 0;
+	}
+
+	return -EINVAL;
+}
+
+static int kbd_get_state(struct kbd_state *state)
+{
+	int ret;
+
+	get_buffer();
+
+	buffer->input[0] = 0x1;
+	dell_send_request(buffer, 4, 11);
+	ret = buffer->output[0];
+
+	if (ret) {
+		ret = dell_smi_error(ret);
+		goto out;
+	}
+
+	state->mode_bit = ffs(buffer->output[1] & 0xFFFF);
+	if (state->mode_bit != 0)
+		state->mode_bit--;
+
+	state->triggers = (buffer->output[1] >> 16) & 0xFF;
+	state->timeout_value = (buffer->output[1] >> 24) & 0x3F;
+	state->timeout_unit = (buffer->output[1] >> 30) & 0x3;
+	state->als_setting = buffer->output[2] & 0xFF;
+	state->als_value = (buffer->output[2] >> 8) & 0xFF;
+	state->level = (buffer->output[2] >> 16) & 0xFF;
+
+ out:
+	release_buffer();
+	return ret;
+}
+
+static int kbd_set_state(struct kbd_state *state)
+{
+	int ret;
+
+	get_buffer();
+	buffer->input[0] = 0x2;
+	buffer->input[1] = BIT(state->mode_bit) & 0xFFFF;
+	buffer->input[1] |= (state->triggers & 0xFF) << 16;
+	buffer->input[1] |= (state->timeout_value & 0x3F) << 24;
+	buffer->input[1] |= (state->timeout_unit & 0x3) << 30;
+	buffer->input[2] = state->als_setting & 0xFF;
+	buffer->input[2] |= (state->level & 0xFF) << 16;
+	dell_send_request(buffer, 4, 11);
+	ret = buffer->output[0];
+	release_buffer();
+
+	return dell_smi_error(ret);
+}
+
+static int kbd_set_state_safe(struct kbd_state *state, struct kbd_state *old)
+{
+	int ret;
+
+	ret = kbd_set_state(state);
+	if (ret == 0)
+		return 0;
+
+	/*
+	 * When setting new state failed, restore previous old one. This is
+	 * needed because on some machines BIOS set default state when setting
+	 * new failed. And default state could be also eveything is turned off.
+	 */
+
+	if (kbd_set_state(old))
+		pr_err("Setting old previous keyboard state failed\n");
+
+	return ret;
+}
+
+static int kbd_set_token_bit(u8 bit)
+{
+	int id;
+	int ret;
+
+	if (bit >= ARRAY_SIZE(kbd_tokens))
+		return -EINVAL;
+
+	id = find_token_id(kbd_tokens[bit]);
+	if (id == -1)
+		return -EINVAL;
+
+	get_buffer();
+	buffer->input[0] = da_tokens[id].location;
+	buffer->input[1] = da_tokens[id].value;
+	dell_send_request(buffer, 1, 0);
+	ret = buffer->output[0];
+	release_buffer();
+
+	return dell_smi_error(ret);
+}
+
+static int kbd_get_token_bit(u8 bit)
+{
+	int id;
+	int ret;
+	int val;
+
+	if (bit >= ARRAY_SIZE(kbd_tokens))
+		return -EINVAL;
+
+	id = find_token_id(kbd_tokens[bit]);
+	if (id == -1)
+		return -EINVAL;
+
+	get_buffer();
+	buffer->input[0] = da_tokens[id].location;
+	dell_send_request(buffer, 0, 0);
+	ret = buffer->output[0];
+	val = buffer->output[1];
+	release_buffer();
+
+	if (ret)
+		return dell_smi_error(ret);
+
+	return (val == da_tokens[id].value);
+}
+
+static int kbd_get_first_active_token_bit(void)
+{
+	int i;
+	int ret;
+
+	for (i = 0; i < ARRAY_SIZE(kbd_tokens); ++i) {
+		ret = kbd_get_token_bit(i);
+		if (ret == 1)
+			return i;
+	}
+
+	return ret;
+}
+
+static int kbd_get_valid_token_counts(void)
+{
+	return hweight16(kbd_token_bits);
+}
+
+static inline int kbd_init_info(void)
+{
+	struct kbd_state state;
+	int ret;
+	int i;
+
+	ret = kbd_get_info(&kbd_info);
+	if (ret)
+		return ret;
+
+	kbd_get_state(&state);
+
+	/* NOTE: timeout value is stored in 6 bits so max value is 63 */
+	if (kbd_info.seconds > 63)
+		kbd_info.seconds = 63;
+	if (kbd_info.minutes > 63)
+		kbd_info.minutes = 63;
+	if (kbd_info.hours > 63)
+		kbd_info.hours = 63;
+	if (kbd_info.days > 63)
+		kbd_info.days = 63;
+
+	/* NOTE: On tested machines ON mode did not work and caused
+	 *       problems (turned backlight off) so do not use it
+	 */
+	kbd_info.modes &= ~BIT(KBD_MODE_BIT_ON);
+
+	kbd_previous_level = kbd_get_level(&state);
+	kbd_previous_mode_bit = state.mode_bit;
+
+	if (kbd_previous_level == 0 && kbd_get_max_level() != 0)
+		kbd_previous_level = 1;
+
+	if (kbd_previous_mode_bit == KBD_MODE_BIT_OFF) {
+		kbd_previous_mode_bit =
+			ffs(kbd_info.modes & ~BIT(KBD_MODE_BIT_OFF));
+		if (kbd_previous_mode_bit != 0)
+			kbd_previous_mode_bit--;
+	}
+
+	if (kbd_info.modes & (BIT(KBD_MODE_BIT_ALS) |
+			      BIT(KBD_MODE_BIT_TRIGGER_ALS)))
+		kbd_als_supported = true;
+
+	if (kbd_info.modes & (
+	    BIT(KBD_MODE_BIT_TRIGGER_ALS) | BIT(KBD_MODE_BIT_TRIGGER) |
+	    BIT(KBD_MODE_BIT_TRIGGER_25) | BIT(KBD_MODE_BIT_TRIGGER_50) |
+	    BIT(KBD_MODE_BIT_TRIGGER_75) | BIT(KBD_MODE_BIT_TRIGGER_100)
+	   ))
+		kbd_triggers_supported = true;
+
+	/* kbd_mode_levels[0] is reserved, see below */
+	for (i = 0; i < 16; ++i)
+		if (kbd_is_level_mode_bit(i) && (BIT(i) & kbd_info.modes))
+			kbd_mode_levels[1 + kbd_mode_levels_count++] = i;
+
+	/*
+	 * Find the first supported mode and assign to kbd_mode_levels[0].
+	 * This should be 0 (off), but we cannot depend on the BIOS to
+	 * support 0.
+	 */
+	if (kbd_mode_levels_count > 0) {
+		for (i = 0; i < 16; ++i) {
+			if (BIT(i) & kbd_info.modes) {
+				kbd_mode_levels[0] = i;
+				break;
+			}
+		}
+		kbd_mode_levels_count++;
+	}
+
+	return 0;
+
+}
+
+static inline void kbd_init_tokens(void)
+{
+	int i;
+
+	for (i = 0; i < ARRAY_SIZE(kbd_tokens); ++i)
+		if (find_token_id(kbd_tokens[i]) != -1)
+			kbd_token_bits |= BIT(i);
+}
+
+static void kbd_init(void)
+{
+	int ret;
+
+	ret = kbd_init_info();
+	kbd_init_tokens();
+
+	if (kbd_token_bits != 0 || ret == 0)
+		kbd_led_present = true;
+}
+
+static ssize_t kbd_led_timeout_store(struct device *dev,
+				     struct device_attribute *attr,
+				     const char *buf, size_t count)
+{
+	struct kbd_state new_state;
+	struct kbd_state state;
+	bool convert;
+	int value;
+	int ret;
+	char ch;
+	u8 unit;
+	int i;
+
+	ret = sscanf(buf, "%d %c", &value, &ch);
+	if (ret < 1)
+		return -EINVAL;
+	else if (ret == 1)
+		ch = 's';
+
+	if (value < 0)
+		return -EINVAL;
+
+	convert = false;
+
+	switch (ch) {
+	case 's':
+		if (value > kbd_info.seconds)
+			convert = true;
+		unit = KBD_TIMEOUT_SECONDS;
+		break;
+	case 'm':
+		if (value > kbd_info.minutes)
+			convert = true;
+		unit = KBD_TIMEOUT_MINUTES;
+		break;
+	case 'h':
+		if (value > kbd_info.hours)
+			convert = true;
+		unit = KBD_TIMEOUT_HOURS;
+		break;
+	case 'd':
+		if (value > kbd_info.days)
+			convert = true;
+		unit = KBD_TIMEOUT_DAYS;
+		break;
+	default:
+		return -EINVAL;
+	}
+
+	if (quirks && quirks->needs_kbd_timeouts)
+		convert = true;
+
+	if (convert) {
+		/* Convert value from current units to seconds */
+		switch (unit) {
+		case KBD_TIMEOUT_DAYS:
+			value *= 24;
+		case KBD_TIMEOUT_HOURS:
+			value *= 60;
+		case KBD_TIMEOUT_MINUTES:
+			value *= 60;
+			unit = KBD_TIMEOUT_SECONDS;
+		}
+
+		if (quirks && quirks->needs_kbd_timeouts) {
+			for (i = 0; quirks->kbd_timeouts[i] != -1; i++) {
+				if (value <= quirks->kbd_timeouts[i]) {
+					value = quirks->kbd_timeouts[i];
+					break;
+				}
+			}
+		}
+
+		if (value <= kbd_info.seconds && kbd_info.seconds) {
+			unit = KBD_TIMEOUT_SECONDS;
+		} else if (value / 60 <= kbd_info.minutes && kbd_info.minutes) {
+			value /= 60;
+			unit = KBD_TIMEOUT_MINUTES;
+		} else if (value / (60 * 60) <= kbd_info.hours && kbd_info.hours) {
+			value /= (60 * 60);
+			unit = KBD_TIMEOUT_HOURS;
+		} else if (value / (60 * 60 * 24) <= kbd_info.days && kbd_info.days) {
+			value /= (60 * 60 * 24);
+			unit = KBD_TIMEOUT_DAYS;
+		} else {
+			return -EINVAL;
+		}
+	}
+
+	ret = kbd_get_state(&state);
+	if (ret)
+		return ret;
+
+	new_state = state;
+	new_state.timeout_value = value;
+	new_state.timeout_unit = unit;
+
+	ret = kbd_set_state_safe(&new_state, &state);
+	if (ret)
+		return ret;
+
+	return count;
+}
+
+static ssize_t kbd_led_timeout_show(struct device *dev,
+				    struct device_attribute *attr, char *buf)
+{
+	struct kbd_state state;
+	int ret;
+	int len;
+
+	ret = kbd_get_state(&state);
+	if (ret)
+		return ret;
+
+	len = sprintf(buf, "%d", state.timeout_value);
+
+	switch (state.timeout_unit) {
+	case KBD_TIMEOUT_SECONDS:
+		return len + sprintf(buf+len, "s\n");
+	case KBD_TIMEOUT_MINUTES:
+		return len + sprintf(buf+len, "m\n");
+	case KBD_TIMEOUT_HOURS:
+		return len + sprintf(buf+len, "h\n");
+	case KBD_TIMEOUT_DAYS:
+		return len + sprintf(buf+len, "d\n");
+	default:
+		return -EINVAL;
+	}
+
+	return len;
+}
+
+static DEVICE_ATTR(stop_timeout, S_IRUGO | S_IWUSR,
+		   kbd_led_timeout_show, kbd_led_timeout_store);
+
+static const char * const kbd_led_triggers[] = {
+	"keyboard",
+	"touchpad",
+	/*"trackstick"*/ NULL, /* NOTE: trackstick is just alias for touchpad */
+	"mouse",
+};
+
+static ssize_t kbd_led_triggers_store(struct device *dev,
+				      struct device_attribute *attr,
+				      const char *buf, size_t count)
+{
+	struct kbd_state new_state;
+	struct kbd_state state;
+	bool triggers_enabled = false;
+	bool als_enabled = false;
+	bool disable_als = false;
+	bool enable_als = false;
+	int trigger_bit = -1;
+	char trigger[21];
+	int i, ret;
+
+	ret = sscanf(buf, "%20s", trigger);
+	if (ret != 1)
+		return -EINVAL;
+
+	if (trigger[0] != '+' && trigger[0] != '-')
+		return -EINVAL;
+
+	ret = kbd_get_state(&state);
+	if (ret)
+		return ret;
+
+	if (kbd_als_supported)
+		als_enabled = kbd_is_als_mode_bit(state.mode_bit);
+
+	if (kbd_triggers_supported)
+		triggers_enabled = kbd_is_trigger_mode_bit(state.mode_bit);
+
+	if (kbd_als_supported) {
+		if (strcmp(trigger, "+als") == 0) {
+			if (als_enabled)
+				return count;
+			enable_als = true;
+		} else if (strcmp(trigger, "-als") == 0) {
+			if (!als_enabled)
+				return count;
+			disable_als = true;
+		}
+	}
+
+	if (enable_als || disable_als) {
+		new_state = state;
+		if (enable_als) {
+			if (triggers_enabled)
+				new_state.mode_bit = KBD_MODE_BIT_TRIGGER_ALS;
+			else
+				new_state.mode_bit = KBD_MODE_BIT_ALS;
+		} else {
+			if (triggers_enabled) {
+				new_state.mode_bit = KBD_MODE_BIT_TRIGGER;
+				kbd_set_level(&new_state, kbd_previous_level);
+			} else {
+				new_state.mode_bit = KBD_MODE_BIT_ON;
+			}
+		}
+		if (!(kbd_info.modes & BIT(new_state.mode_bit)))
+			return -EINVAL;
+		ret = kbd_set_state_safe(&new_state, &state);
+		if (ret)
+			return ret;
+		kbd_previous_mode_bit = new_state.mode_bit;
+		return count;
+	}
+
+	if (kbd_triggers_supported) {
+		for (i = 0; i < ARRAY_SIZE(kbd_led_triggers); ++i) {
+			if (!(kbd_info.triggers & BIT(i)))
+				continue;
+			if (!kbd_led_triggers[i])
+				continue;
+			if (strcmp(trigger+1, kbd_led_triggers[i]) != 0)
+				continue;
+			if (trigger[0] == '+' &&
+			    triggers_enabled && (state.triggers & BIT(i)))
+				return count;
+			if (trigger[0] == '-' &&
+			    (!triggers_enabled || !(state.triggers & BIT(i))))
+				return count;
+			trigger_bit = i;
+			break;
+		}
+	}
+
+	if (trigger_bit != -1) {
+		new_state = state;
+		if (trigger[0] == '+')
+			new_state.triggers |= BIT(trigger_bit);
+		else {
+			new_state.triggers &= ~BIT(trigger_bit);
+			/* NOTE: trackstick bit (2) must be disabled when
+			 *       disabling touchpad bit (1), otherwise touchpad
+			 *       bit (1) will not be disabled */
+			if (trigger_bit == 1)
+				new_state.triggers &= ~BIT(2);
+		}
+		if ((kbd_info.triggers & new_state.triggers) !=
+		    new_state.triggers)
+			return -EINVAL;
+		if (new_state.triggers && !triggers_enabled) {
+			if (als_enabled)
+				new_state.mode_bit = KBD_MODE_BIT_TRIGGER_ALS;
+			else {
+				new_state.mode_bit = KBD_MODE_BIT_TRIGGER;
+				kbd_set_level(&new_state, kbd_previous_level);
+			}
+		} else if (new_state.triggers == 0) {
+			if (als_enabled)
+				new_state.mode_bit = KBD_MODE_BIT_ALS;
+			else
+				kbd_set_level(&new_state, 0);
+		}
+		if (!(kbd_info.modes & BIT(new_state.mode_bit)))
+			return -EINVAL;
+		ret = kbd_set_state_safe(&new_state, &state);
+		if (ret)
+			return ret;
+		if (new_state.mode_bit != KBD_MODE_BIT_OFF)
+			kbd_previous_mode_bit = new_state.mode_bit;
+		return count;
+	}
+
+	return -EINVAL;
+}
+
+static ssize_t kbd_led_triggers_show(struct device *dev,
+				     struct device_attribute *attr, char *buf)
+{
+	struct kbd_state state;
+	bool triggers_enabled;
+	int level, i, ret;
+	int len = 0;
+
+	ret = kbd_get_state(&state);
+	if (ret)
+		return ret;
+
+	len = 0;
+
+	if (kbd_triggers_supported) {
+		triggers_enabled = kbd_is_trigger_mode_bit(state.mode_bit);
+		level = kbd_get_level(&state);
+		for (i = 0; i < ARRAY_SIZE(kbd_led_triggers); ++i) {
+			if (!(kbd_info.triggers & BIT(i)))
+				continue;
+			if (!kbd_led_triggers[i])
+				continue;
+			if ((triggers_enabled || level <= 0) &&
+			    (state.triggers & BIT(i)))
+				buf[len++] = '+';
+			else
+				buf[len++] = '-';
+			len += sprintf(buf+len, "%s ", kbd_led_triggers[i]);
+		}
+	}
+
+	if (kbd_als_supported) {
+		if (kbd_is_als_mode_bit(state.mode_bit))
+			len += sprintf(buf+len, "+als ");
+		else
+			len += sprintf(buf+len, "-als ");
+	}
+
+	if (len)
+		buf[len - 1] = '\n';
+
+	return len;
+}
+
+static DEVICE_ATTR(start_triggers, S_IRUGO | S_IWUSR,
+		   kbd_led_triggers_show, kbd_led_triggers_store);
+
+static ssize_t kbd_led_als_store(struct device *dev,
+				 struct device_attribute *attr,
+				 const char *buf, size_t count)
+{
+	struct kbd_state state;
+	struct kbd_state new_state;
+	u8 setting;
+	int ret;
+
+	ret = kstrtou8(buf, 10, &setting);
+	if (ret)
+		return ret;
+
+	ret = kbd_get_state(&state);
+	if (ret)
+		return ret;
+
+	new_state = state;
+	new_state.als_setting = setting;
+
+	ret = kbd_set_state_safe(&new_state, &state);
+	if (ret)
+		return ret;
+
+	return count;
+}
+
+static ssize_t kbd_led_als_show(struct device *dev,
+				struct device_attribute *attr, char *buf)
+{
+	struct kbd_state state;
+	int ret;
+
+	ret = kbd_get_state(&state);
+	if (ret)
+		return ret;
+
+	return sprintf(buf, "%d\n", state.als_setting);
+}
+
+static DEVICE_ATTR(als_setting, S_IRUGO | S_IWUSR,
+		   kbd_led_als_show, kbd_led_als_store);
+
+static struct attribute *kbd_led_attrs[] = {
+	&dev_attr_stop_timeout.attr,
+	&dev_attr_start_triggers.attr,
+	&dev_attr_als_setting.attr,
+	NULL,
+};
+ATTRIBUTE_GROUPS(kbd_led);
+
+static enum led_brightness kbd_led_level_get(struct led_classdev *led_cdev)
+{
+	int ret;
+	u16 num;
+	struct kbd_state state;
+
+	if (kbd_get_max_level()) {
+		ret = kbd_get_state(&state);
+		if (ret)
+			return 0;
+		ret = kbd_get_level(&state);
+		if (ret < 0)
+			return 0;
+		return ret;
+	}
+
+	if (kbd_get_valid_token_counts()) {
+		ret = kbd_get_first_active_token_bit();
+		if (ret < 0)
+			return 0;
+		for (num = kbd_token_bits; num != 0 && ret > 0; --ret)
+			num &= num - 1; /* clear the first bit set */
+		if (num == 0)
+			return 0;
+		return ffs(num) - 1;
+	}
+
+	pr_warn("Keyboard brightness level control not supported\n");
+	return 0;
+}
+
+static void kbd_led_level_set(struct led_classdev *led_cdev,
+			      enum led_brightness value)
+{
+	struct kbd_state state;
+	struct kbd_state new_state;
+	u16 num;
+
+	if (kbd_get_max_level()) {
+		if (kbd_get_state(&state))
+			return;
+		new_state = state;
+		if (kbd_set_level(&new_state, value))
+			return;
+		kbd_set_state_safe(&new_state, &state);
+		return;
+	}
+
+	if (kbd_get_valid_token_counts()) {
+		for (num = kbd_token_bits; num != 0 && value > 0; --value)
+			num &= num - 1; /* clear the first bit set */
+		if (num == 0)
+			return;
+		kbd_set_token_bit(ffs(num) - 1);
+		return;
+	}
+
+	pr_warn("Keyboard brightness level control not supported\n");
+}
+
+static struct led_classdev kbd_led = {
+	.name           = "dell::kbd_backlight",
+	.brightness_set = kbd_led_level_set,
+	.brightness_get = kbd_led_level_get,
+	.groups         = kbd_led_groups,
+};
+
+static int __init kbd_led_init(struct device *dev)
+{
+	kbd_init();
+	if (!kbd_led_present)
+		return -ENODEV;
+	kbd_led.max_brightness = kbd_get_max_level();
+	if (!kbd_led.max_brightness) {
+		kbd_led.max_brightness = kbd_get_valid_token_counts();
+		if (kbd_led.max_brightness)
+			kbd_led.max_brightness--;
+	}
+	return led_classdev_register(dev, &kbd_led);
+}
+
+static void brightness_set_exit(struct led_classdev *led_cdev,
+				enum led_brightness value)
+{
+	/* Don't change backlight level on exit */
+};
+
+static void kbd_led_exit(void)
+{
+	if (!kbd_led_present)
+		return;
+	kbd_led.brightness_set = brightness_set_exit;
+	led_classdev_unregister(&kbd_led);
+}
+
 static int __init dell_init(void)
 {
 	int max_intensity = 0;
@@ -842,6 +1880,8 @@ static int __init dell_init(void)
 	if (quirks && quirks->touchpad_led)
 		touchpad_led_init(&platform_device->dev);
 
+	kbd_led_init(&platform_device->dev);
+
 	dell_laptop_dir = debugfs_create_dir("dell_laptop", NULL);
 	if (dell_laptop_dir != NULL)
 		debugfs_create_file("rfkill", 0444, dell_laptop_dir, NULL,
@@ -909,6 +1949,7 @@ static void __exit dell_exit(void)
 	debugfs_remove_recursive(dell_laptop_dir);
 	if (quirks && quirks->touchpad_led)
 		touchpad_led_exit();
+	kbd_led_exit();
 	i8042_remove_filter(dell_laptop_i8042_filter);
 	cancel_delayed_work_sync(&dell_rfkill_work);
 	backlight_device_unregister(dell_backlight_device);
@@ -925,5 +1966,7 @@ module_init(dell_init);
 module_exit(dell_exit);
 
 MODULE_AUTHOR("Matthew Garrett <mjg@redhat.com>");
+MODULE_AUTHOR("Gabriele Mazzotta <gabriele.mzt@gmail.com>");
+MODULE_AUTHOR("Pali Rohár <pali.rohar@gmail.com>");
 MODULE_DESCRIPTION("Dell laptop driver");
 MODULE_LICENSE("GPL");
-- 
1.7.9.5

