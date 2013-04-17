Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756825Ab3DQQ5n (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Apr 2013 12:57:43 -0400
Received: from mail-vb0-f54.google.com ([209.85.212.54]:33974 "EHLO
	mail-vb0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755905Ab3DQQ5l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Apr 2013 12:57:41 -0400
MIME-Version: 1.0
In-Reply-To: <20130416230907.GA8380@core.coreip.homeip.net>
References: <1364326601-16571-1-git-send-email-shawnn@chromium.org>
	<20130328053218.GB2812@core.coreip.homeip.net>
	<CALaWCOOBnsn-mcyp3V1hiP4CwBze9mzEoTV_jeM6gm6kKBZ60Q@mail.gmail.com>
	<20130416230907.GA8380@core.coreip.homeip.net>
Date: Wed, 17 Apr 2013 09:57:40 -0700
X-Google-Sender-Auth: i2PAffh3b8IKhgprGl4k5Av7E5Q
Message-ID: <CALaWCONzTu4rFBap=r0f=Lzr-fhcYUkuRSU+SG1M772PL+nqYQ@mail.gmail.com>
Subject: Re: [PATCH] Input: trackpoint - Optimize trackpoint init to use
 power-on reset
From: Shawn Nematbakhsh <shawnn@chromium.org>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: JJ Ding <dgdunix@gmail.com>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org, Chung-yih Wang <cywang@chromium.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Dmitry,

On Tue, Apr 16, 2013 at 4:09 PM, Dmitry Torokhov
<dmitry.torokhov@gmail.com> wrote:
> Hi Shawn,
>
> On Tue, Apr 09, 2013 at 02:53:44PM -0700, Shawn Nematbakhsh wrote:
>> Hi Dmitry,
>>
>> Thanks for the review. Comments in-line.
>>
>> On Wed, Mar 27, 2013 at 10:32 PM, Dmitry Torokhov
>> <dmitry.torokhov@gmail.com> wrote:
>> > Hi Shawn,
>> >
>> > On Tue, Mar 26, 2013 at 12:36:41PM -0700, Shawn Nematbakhsh wrote:
>> >> The trackpoint driver sets various parameter default values, all of
>> >> which happen to be power-on defaults (Source: IBM TrackPoint Engineering
>> >> Specification, Version 4.0. Also confirmed by empirical data).
>> >>
>> >> By sending the power-on reset command to reset all parameters to
>> >> power-on state, we can skip the lengthy process of programming all
>> >> parameters. In testing, ~2.5 secs of time writing parameters was reduced
>> >> to .35 seconds waiting for power-on reset to complete.
>> >>
>> >> Signed-off-by: Shawn Nematbakhsh <shawnn@chromium.org>
>> >> ---
>> >>  drivers/input/mouse/trackpoint.c | 223 +++++++++++++++++++++++++--------------
>> >>  drivers/input/mouse/trackpoint.h |   7 +-
>> >>  2 files changed, 149 insertions(+), 81 deletions(-)
>> >>
>> >> diff --git a/drivers/input/mouse/trackpoint.c b/drivers/input/mouse/trackpoint.c
>> >> index f310249..17e9b36 100644
>> >> --- a/drivers/input/mouse/trackpoint.c
>> >> +++ b/drivers/input/mouse/trackpoint.c
>> >> @@ -20,6 +20,26 @@
>> >>  #include "trackpoint.h"
>> >>
>> >>  /*
>> >> + * Power-on Reset: Resets all trackpoint parameters, including RAM values,
>> >> + * to defaults.
>> >> + * Returns zero on success, non-zero on failure.
>> >> + */
>> >> +static int trackpoint_power_on_reset(struct ps2dev *ps2dev)
>> >> +{
>> >> +     unsigned char results[2];
>> >> +
>> >> +     if (ps2_command(ps2dev, NULL, MAKE_PS2_CMD(0, 0, TP_COMMAND)) ||
>> >> +         ps2_command(ps2dev, results, MAKE_PS2_CMD(0, 2, TP_POR))) {
>> >> +             return -1;
>> >> +     }
>> >> +
>> >> +     /* POR response should be 0xAA00 or 0xFC00 */
>> >> +     if ((results[0] != 0xAA && results[0] != 0xFC) || results[1] != 0x00)
>> >> +             return -1;
>> >
>> > I am a bit concerned about this. 0xfc00 indicates POR failure. In this
>> > case shouldn't we try to reset the device, issue another POR and bail if
>> > it fails again?
>> >
>>
>> Yes, you are correct. I just now posted v2 to fix this. Now, on
>> 0xfc00, we attempt one retry. On subsequent 0xfc00, we fail POR and
>> attempt to set parameters manually.
>>
>> >>
>> >>  static struct attribute *trackpoint_attrs[] = {
>> >>       &psmouse_attr_sensitivity.dattr.attr,
>> >> @@ -179,6 +241,9 @@ static struct attribute *trackpoint_attrs[] = {
>> >>       &psmouse_attr_press_to_select.dattr.attr,
>> >>       &psmouse_attr_skipback.dattr.attr,
>> >>       &psmouse_attr_ext_dev.dattr.attr,
>> >> +     &psmouse_attr_twohand.dattr.attr,
>> >> +     &psmouse_attr_source_tag.dattr.attr,
>> >> +     &psmouse_attr_mb.dattr.attr,
>> >
>> > What is the benefit of adding these 3 new attributes?
>> >
>>
>> Previously, these attributes were handled in a special way -- the
>> corresponding TP values were set to default, but the attributes were
>> not exported. Now, they are set to default and exported. It makes for
>> cleaner code.
>>
>> I see no good use for these attributes other than driver hacking. I
>> can remove them if you think it's best.
>
>
> Yes, I think that even though having them as attributes makes the code
> look nice we should not be exposing them as they do break driver
> behavior.
>
> Does the version of the patch below work for you?
>

This version looks + tests good, with one small change: Since we no
longer export the three extra parameters, I removed the corresponding
trackpoint_data struct members. Ex.

< @@ -136,10 +138,13 @@ struct trackpoint_data
---
> @@ -136,9 +138,9 @@ struct trackpoint_data
386,388d385
< + unsigned char twohand;
< + unsigned char source_tag;
< + unsigned char mb;

See complete revised patch below.


Input: trackpoint - Optimize trackpoint init to use power-on reset

From: Shawn Nematbakhsh <shawnn@chromium.org>

The trackpoint driver sets various parameter default values, all of
which happen to be power-on defaults (Source: IBM TrackPoint Engineering
Specification, Version 4.0. Also confirmed by empirical data).

By sending the power-on reset command to reset all parameters to
power-on state, we can skip the lengthy process of programming all
parameters. In testing, ~2.5 secs of time writing parameters was reduced
to .35 seconds waiting for power-on reset to complete.

Signed-off-by: Shawn Nematbakhsh <shawnn@chromium.org>
Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
---
 drivers/input/mouse/trackpoint.c | 249 +++++++++++++++++++++++++--------------
 drivers/input/mouse/trackpoint.h |   4 +-
 2 files changed, 166 insertions(+), 87 deletions(-)

diff --git a/drivers/input/mouse/trackpoint.c b/drivers/input/mouse/trackpoint.c
index f310249..ca843b6 100644
--- a/drivers/input/mouse/trackpoint.c
+++ b/drivers/input/mouse/trackpoint.c
@@ -20,9 +20,34 @@
 #include "trackpoint.h"

 /*
+ * Power-on Reset: Resets all trackpoint parameters, including RAM values,
+ * to defaults.
+ * Returns zero on success, non-zero on failure.
+ */
+static int trackpoint_power_on_reset(struct ps2dev *ps2dev)
+{
+ unsigned char results[2];
+ int tries = 0;
+
+ /* Issue POR command, and repeat up to once if 0xFC00 received */
+ do {
+ if (ps2_command(ps2dev, NULL, MAKE_PS2_CMD(0, 0, TP_COMMAND)) ||
+    ps2_command(ps2dev, results, MAKE_PS2_CMD(0, 2, TP_POR)))
+ return -1;
+ } while (results[0] == 0xFC && results[1] == 0x00 && ++tries < 2);
+
+ /* Check for success response -- 0xAA00 */
+ if (results[0] != 0xAA || results[1] != 0x00)
+ return -1;
+
+ return 0;
+}
+
+/*
  * Device IO: read, write and toggle bit
  */
-static int trackpoint_read(struct ps2dev *ps2dev, unsigned char loc,
unsigned char *results)
+static int trackpoint_read(struct ps2dev *ps2dev,
+   unsigned char loc, unsigned char *results)
 {
  if (ps2_command(ps2dev, NULL, MAKE_PS2_CMD(0, 0, TP_COMMAND)) ||
     ps2_command(ps2dev, results, MAKE_PS2_CMD(0, 1, loc))) {
@@ -32,7 +57,8 @@ static int trackpoint_read(struct ps2dev *ps2dev,
unsigned char loc, unsigned ch
  return 0;
 }

-static int trackpoint_write(struct ps2dev *ps2dev, unsigned char loc,
unsigned char val)
+static int trackpoint_write(struct ps2dev *ps2dev,
+    unsigned char loc, unsigned char val)
 {
  if (ps2_command(ps2dev, NULL, MAKE_PS2_CMD(0, 0, TP_COMMAND)) ||
     ps2_command(ps2dev, NULL, MAKE_PS2_CMD(0, 0, TP_WRITE_MEM)) ||
@@ -44,7 +70,8 @@ static int trackpoint_write(struct ps2dev *ps2dev,
unsigned char loc, unsigned c
  return 0;
 }

-static int trackpoint_toggle_bit(struct ps2dev *ps2dev, unsigned char
loc, unsigned char mask)
+static int trackpoint_toggle_bit(struct ps2dev *ps2dev,
+ unsigned char loc, unsigned char mask)
 {
  /* Bad things will happen if the loc param isn't in this range */
  if (loc < 0x20 || loc >= 0x2F)
@@ -60,6 +87,18 @@ static int trackpoint_toggle_bit(struct ps2dev
*ps2dev, unsigned char loc, unsig
  return 0;
 }

+static int trackpoint_update_bit(struct ps2dev *ps2dev, unsigned char loc,
+ unsigned char mask, unsigned char value)
+{
+ int retval = 0;
+ unsigned char data;
+
+ trackpoint_read(ps2dev, loc, &data);
+ if (((data & mask) == mask) != !!value)
+ retval = trackpoint_toggle_bit(ps2dev, loc, mask);
+
+ return retval;
+}

 /*
  * Trackpoint-specific attributes
@@ -69,6 +108,7 @@ struct trackpoint_attr_data {
  unsigned char command;
  unsigned char mask;
  unsigned char inverted;
+ unsigned char power_on_default;
 };

 static ssize_t trackpoint_show_int_attr(struct psmouse *psmouse, void
*data, char *buf)
@@ -102,10 +142,11 @@ static ssize_t trackpoint_set_int_attr(struct
psmouse *psmouse, void *data,
  return count;
 }

-#define TRACKPOINT_INT_ATTR(_name, _command) \
+#define TRACKPOINT_INT_ATTR(_name, _command, _default) \
  static struct trackpoint_attr_data trackpoint_attr_##_name = { \
  .field_offset = offsetof(struct trackpoint_data, _name), \
  .command = _command, \
+ .power_on_default = _default, \
  }; \
  PSMOUSE_DEFINE_ATTR(_name, S_IWUSR | S_IRUGO, \
     &trackpoint_attr_##_name, \
@@ -139,31 +180,60 @@ static ssize_t trackpoint_set_bit_attr(struct
psmouse *psmouse, void *data,
 }


-#define TRACKPOINT_BIT_ATTR(_name, _command, _mask, _inv) \
- static struct trackpoint_attr_data trackpoint_attr_##_name = { \
- .field_offset = offsetof(struct trackpoint_data, _name), \
- .command = _command, \
- .mask = _mask, \
- .inverted = _inv, \
- }; \
- PSMOUSE_DEFINE_ATTR(_name, S_IWUSR | S_IRUGO, \
-    &trackpoint_attr_##_name, \
-    trackpoint_show_int_attr, trackpoint_set_bit_attr)
-
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
+#define TRACKPOINT_BIT_ATTR(_name, _command, _mask, _inv, _default) \
+static struct trackpoint_attr_data trackpoint_attr_##_name = { \
+ .field_offset = offsetof(struct trackpoint_data, \
+   _name), \
+ .command = _command, \
+ .mask = _mask, \
+ .inverted = _inv, \
+ .power_on_default = _default, \
+ }; \
+PSMOUSE_DEFINE_ATTR(_name, S_IWUSR | S_IRUGO, \
+    &trackpoint_attr_##_name, \
+    trackpoint_show_int_attr, trackpoint_set_bit_attr)
+
+#define TRACKPOINT_UPDATE_BIT(_psmouse, _tp, _name) \
+do { \
+ struct trackpoint_attr_data *_attr = &trackpoint_attr_##_name; \
+ \
+ trackpoint_update_bit(&_psmouse->ps2dev, \
+ _attr->command, _attr->mask, _tp->_name); \
+} while (0)
+
+#define TRACKPOINT_UPDATE(_power_on, _psmouse, _tp, _name) \
+do { \
+ if (!_power_on || \
+    _tp->_name != trackpoint_attr_##_name.power_on_default) { \
+ if (!trackpoint_attr_##_name.mask) \
+ trackpoint_write(&_psmouse->ps2dev, \
+ trackpoint_attr_##_name.command, \
+ _tp->_name); \
+ else \
+ TRACKPOINT_UPDATE_BIT(_psmouse, _tp, _name); \
+ } \
+} while (0)
+
+#define TRACKPOINT_SET_POWER_ON_DEFAULT(_tp, _name) \
+ (_tp->_name = trackpoint_attr_##_name.power_on_default)
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
+    TP_DEF_PTSON);
+TRACKPOINT_BIT_ATTR(skipback, TP_TOGGLE_SKIPBACK, TP_MASK_SKIPBACK, 0,
+    TP_DEF_SKIPBACK);
+TRACKPOINT_BIT_ATTR(ext_dev, TP_TOGGLE_EXT_DEV, TP_MASK_EXT_DEV, 1,
+    TP_DEF_EXT_DEV);

 static struct attribute *trackpoint_attrs[] = {
  &psmouse_attr_sensitivity.dattr.attr,
@@ -202,73 +272,72 @@ static int trackpoint_start_protocol(struct
psmouse *psmouse, unsigned char *fir
  return 0;
 }

-static int trackpoint_sync(struct psmouse *psmouse)
+/*
+ * Write parameters to trackpad.
+ * in_power_on_state: Set to true if TP is in default / power-on state (ex. if
+ *      power-on reset was run). If so, values will only be
+ *      written to TP if they differ from power-on default.
+ */
+static int trackpoint_sync(struct psmouse *psmouse, bool in_power_on_state)
 {
  struct trackpoint_data *tp = psmouse->private;
- unsigned char toggle;
-
- /* Disable features that may make device unusable with this driver */
- trackpoint_read(&psmouse->ps2dev, TP_TOGGLE_TWOHAND, &toggle);
- if (toggle & TP_MASK_TWOHAND)
- trackpoint_toggle_bit(&psmouse->ps2dev, TP_TOGGLE_TWOHAND, TP_MASK_TWOHAND);
-
- trackpoint_read(&psmouse->ps2dev, TP_TOGGLE_SOURCE_TAG, &toggle);
- if (toggle & TP_MASK_SOURCE_TAG)
- trackpoint_toggle_bit(&psmouse->ps2dev, TP_TOGGLE_SOURCE_TAG,
TP_MASK_SOURCE_TAG);
-
- trackpoint_read(&psmouse->ps2dev, TP_TOGGLE_MB, &toggle);
- if (toggle & TP_MASK_MB)
- trackpoint_toggle_bit(&psmouse->ps2dev, TP_TOGGLE_MB, TP_MASK_MB);
-
- /* Push the config to the device */
- trackpoint_write(&psmouse->ps2dev, TP_SENS, tp->sensitivity);
- trackpoint_write(&psmouse->ps2dev, TP_INERTIA, tp->inertia);
- trackpoint_write(&psmouse->ps2dev, TP_SPEED, tp->speed);
-
- trackpoint_write(&psmouse->ps2dev, TP_REACH, tp->reach);
- trackpoint_write(&psmouse->ps2dev, TP_DRAGHYS, tp->draghys);
- trackpoint_write(&psmouse->ps2dev, TP_MINDRAG, tp->mindrag);
-
- trackpoint_write(&psmouse->ps2dev, TP_THRESH, tp->thresh);
- trackpoint_write(&psmouse->ps2dev, TP_UP_THRESH, tp->upthresh);

- trackpoint_write(&psmouse->ps2dev, TP_Z_TIME, tp->ztime);
- trackpoint_write(&psmouse->ps2dev, TP_JENKS_CURV, tp->jenks);
+ if (!in_power_on_state) {
+ /*
+ * Disable features that may make device unusable
+ * with this driver.
+ */
+ trackpoint_update_bit(&psmouse->ps2dev, TP_TOGGLE_TWOHAND,
+      TP_MASK_TWOHAND, TP_DEF_TWOHAND);

- trackpoint_read(&psmouse->ps2dev, TP_TOGGLE_PTSON, &toggle);
- if (((toggle & TP_MASK_PTSON) == TP_MASK_PTSON) != tp->press_to_select)
- trackpoint_toggle_bit(&psmouse->ps2dev, TP_TOGGLE_PTSON, TP_MASK_PTSON);
+ trackpoint_update_bit(&psmouse->ps2dev, TP_TOGGLE_SOURCE_TAG,
+      TP_MASK_SOURCE_TAG, TP_DEF_SOURCE_TAG);

- trackpoint_read(&psmouse->ps2dev, TP_TOGGLE_SKIPBACK, &toggle);
- if (((toggle & TP_MASK_SKIPBACK) == TP_MASK_SKIPBACK) != tp->skipback)
- trackpoint_toggle_bit(&psmouse->ps2dev, TP_TOGGLE_SKIPBACK, TP_MASK_SKIPBACK);
+ trackpoint_update_bit(&psmouse->ps2dev, TP_TOGGLE_MB,
+      TP_MASK_MB, TP_DEF_MB);
+ }

- trackpoint_read(&psmouse->ps2dev, TP_TOGGLE_EXT_DEV, &toggle);
- if (((toggle & TP_MASK_EXT_DEV) == TP_MASK_EXT_DEV) != tp->ext_dev)
- trackpoint_toggle_bit(&psmouse->ps2dev, TP_TOGGLE_EXT_DEV, TP_MASK_EXT_DEV);
+ /*
+ * These properties can be changed in this driver. Only
+ * configure them if the values are non-default or if the TP is in
+ * an unknown state.
+ */
+ TRACKPOINT_UPDATE(in_power_on_state, psmouse, tp, sensitivity);
+ TRACKPOINT_UPDATE(in_power_on_state, psmouse, tp, inertia);
+ TRACKPOINT_UPDATE(in_power_on_state, psmouse, tp, speed);
+ TRACKPOINT_UPDATE(in_power_on_state, psmouse, tp, reach);
+ TRACKPOINT_UPDATE(in_power_on_state, psmouse, tp, draghys);
+ TRACKPOINT_UPDATE(in_power_on_state, psmouse, tp, mindrag);
+ TRACKPOINT_UPDATE(in_power_on_state, psmouse, tp, thresh);
+ TRACKPOINT_UPDATE(in_power_on_state, psmouse, tp, upthresh);
+ TRACKPOINT_UPDATE(in_power_on_state, psmouse, tp, ztime);
+ TRACKPOINT_UPDATE(in_power_on_state, psmouse, tp, jenks);
+
+ /* toggles */
+ TRACKPOINT_UPDATE(in_power_on_state, psmouse, tp, press_to_select);
+ TRACKPOINT_UPDATE(in_power_on_state, psmouse, tp, skipback);
+ TRACKPOINT_UPDATE(in_power_on_state, psmouse, tp, ext_dev);

  return 0;
 }

 static void trackpoint_defaults(struct trackpoint_data *tp)
 {
- tp->press_to_select = TP_DEF_PTSON;
- tp->sensitivity = TP_DEF_SENS;
- tp->speed = TP_DEF_SPEED;
- tp->reach = TP_DEF_REACH;
-
- tp->draghys = TP_DEF_DRAGHYS;
- tp->mindrag = TP_DEF_MINDRAG;
-
- tp->thresh = TP_DEF_THRESH;
- tp->upthresh = TP_DEF_UP_THRESH;
-
- tp->ztime = TP_DEF_Z_TIME;
- tp->jenks = TP_DEF_JENKS_CURV;
-
- tp->inertia = TP_DEF_INERTIA;
- tp->skipback = TP_DEF_SKIPBACK;
- tp->ext_dev = TP_DEF_EXT_DEV;
+ TRACKPOINT_SET_POWER_ON_DEFAULT(tp, sensitivity);
+ TRACKPOINT_SET_POWER_ON_DEFAULT(tp, speed);
+ TRACKPOINT_SET_POWER_ON_DEFAULT(tp, reach);
+ TRACKPOINT_SET_POWER_ON_DEFAULT(tp, draghys);
+ TRACKPOINT_SET_POWER_ON_DEFAULT(tp, mindrag);
+ TRACKPOINT_SET_POWER_ON_DEFAULT(tp, thresh);
+ TRACKPOINT_SET_POWER_ON_DEFAULT(tp, upthresh);
+ TRACKPOINT_SET_POWER_ON_DEFAULT(tp, ztime);
+ TRACKPOINT_SET_POWER_ON_DEFAULT(tp, jenks);
+ TRACKPOINT_SET_POWER_ON_DEFAULT(tp, inertia);
+
+ /* toggles */
+ TRACKPOINT_SET_POWER_ON_DEFAULT(tp, press_to_select);
+ TRACKPOINT_SET_POWER_ON_DEFAULT(tp, skipback);
+ TRACKPOINT_SET_POWER_ON_DEFAULT(tp, ext_dev);
 }

 static void trackpoint_disconnect(struct psmouse *psmouse)
@@ -281,10 +350,13 @@ static void trackpoint_disconnect(struct psmouse *psmouse)

 static int trackpoint_reconnect(struct psmouse *psmouse)
 {
+ int reset_fail;
+
  if (trackpoint_start_protocol(psmouse, NULL))
  return -1;

- if (trackpoint_sync(psmouse))
+ reset_fail = trackpoint_power_on_reset(&psmouse->ps2dev);
+ if (trackpoint_sync(psmouse, !reset_fail))
  return -1;

  return 0;
@@ -322,7 +394,12 @@ int trackpoint_detect(struct psmouse *psmouse,
bool set_properties)
  __set_bit(BTN_MIDDLE, psmouse->dev->keybit);

  trackpoint_defaults(psmouse->private);
- trackpoint_sync(psmouse);
+
+ error = trackpoint_power_on_reset(&psmouse->ps2dev);
+
+ /* Write defaults to TP only if reset fails. */
+ if (error)
+ trackpoint_sync(psmouse, false);

  error = sysfs_create_group(&ps2dev->serio->dev.kobj, &trackpoint_attr_group);
  if (error) {
diff --git a/drivers/input/mouse/trackpoint.h b/drivers/input/mouse/trackpoint.h
index e558a70..ecd0547 100644
--- a/drivers/input/mouse/trackpoint.h
+++ b/drivers/input/mouse/trackpoint.h
@@ -126,6 +126,8 @@
 #define TP_DEF_PTSON 0x00
 #define TP_DEF_SKIPBACK 0x00
 #define TP_DEF_EXT_DEV 0x00 /* 0 means enabled */
+#define TP_DEF_TWOHAND 0x00
+#define TP_DEF_SOURCE_TAG 0x00

 #define MAKE_PS2_CMD(params, results, cmd) ((params<<12) |
(results<<8) | (cmd))

@@ -136,9 +138,9 @@ struct trackpoint_data
  unsigned char thresh, upthresh;
  unsigned char ztime, jenks;

+ /* toggles */
  unsigned char press_to_select;
  unsigned char skipback;
-
  unsigned char ext_dev;
 };

 #ifdef CONFIG_MOUSE_PS2_TRACKPOINT
