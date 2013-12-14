Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754454Ab3LOAfA (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Dec 2013 19:35:00 -0500
Received: from www.prifuk.cz ([31.31.77.241]:40261 "EHLO prifuk.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754404Ab3LOAe4 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Dec 2013 19:34:56 -0500
From: Michal =?ISO-8859-1?Q?Mal=FD?= <madcatxster@prifuk.cz>
To: dmitry.torokhov@gmail.com
Cc: linux-kernel@vger.kernel.org, linux-input@vger.kernel.org,
        elias.vds@gmail.com, anssi.hannula@iki.fi
Subject: [RFC] Add ff-memless-next driver
Date: Sat, 14 Dec 2013 21:58:45 +0100
Message-ID: <1742860.KNd72mBNnt@geidi-prime>
User-Agent: KMail/4.11.4 (Linux/3.13.0-1-ARCHMOD; KDE/4.11.4; x86_64; ; )
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
Content-Type: text/plain; charset="iso-8859-1"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

"ff-memless-next" driver is an extended modification of the original ff-memless driver. Unlike ff-memless, ff-memless-next targets only "serious" FFB devices such as racing wheels and hi(ish)-end joysticks with FFB actuators instead of simple rumble motors. Modifications in ff-memless-next include:
- Support of periodic and ramp effects
  These are treated as "combinable" effects and forces created by each of these effects is superposed into one total force
- Support for conditional effects
  As these effects cannot be effectively combined together, they are handled separately depending on the capabilities of the underlying HW-specific driver
- Removed emulation of rumble effect
- Adjustable update rate
- Differentiation between "set effect's force to zero" and "stop effect"
- Checks whether the effect's parameters are valid upon upload - this should better be handled by ff-core though IMHO.

At the moment there is no HW-specific backend that would make use of ff-memless-next, the plan is to update hid-lg4ff once ff-memless-next gets accepted by upstream. ff-memless-next can be tested with dummy FFB device module which is available here (git://prifuk.cz/ff-dummy-device).

My primary motivation to write ff-memless-next were limitations of the current ff-memless driver I came across during work on the driver for Logitech gaming wheels. However, ff-memless-next contains no code that would specifically target Logitech devices.

I must give a huge thanks to Elias Vanderstuyft (CC'd) for his extensive testing of the driver and numerous helpful suggestions.

Tested-by: Elias Vanderstuyft <elias.vds@gmail.com>
Signed-off-by: Michal Malý <madcatxster@prifuk.cz>
---
>From 12c7feb547ff16d91f6d04986862eaf5f266ddeb Mon Sep 17 00:00:00 2001
From: =?UTF-8?q?Michal=20Mal=C3=BD?= <madcatxster@prifuk.cz>
Date: Sat, 14 Dec 2013 21:53:26 +0100
Subject: [PATCH 1/1] Add ff-memless-next driver

---
 drivers/input/Kconfig                 |  12 +
 drivers/input/Makefile                |   1 +
 drivers/input/ff-memless-next.c       | 675 ++++++++++++++++++++++++++++++++++
 include/linux/input/ff-memless-next.h |  29 ++
 4 files changed, 717 insertions(+)
 create mode 100644 drivers/input/ff-memless-next.c
 create mode 100644 include/linux/input/ff-memless-next.h

diff --git a/drivers/input/Kconfig b/drivers/input/Kconfig
index a11ff74..893ab00 100644
--- a/drivers/input/Kconfig
+++ b/drivers/input/Kconfig
@@ -77,6 +77,18 @@ config INPUT_MATRIXKMAP
 	  To compile this driver as a module, choose M here: the
 	  module will be called matrix-keymap.
 
+config INPUT_FF_MEMLESS_NEXT
+	tristate "New version of support for memoryless force feedback devices"
+	help
+	  Say Y here if you want to enable support for various memoryless
+	  force feedback devices (as of now there is no hardware-specific
+	  driver that supports this)
+
+	  If unsure, say N.
+
+	  To compile this driver as a module, choose M here: the
+	  module will be called ff-memless-next.
+
 comment "Userland interfaces"
 
 config INPUT_MOUSEDEV
diff --git a/drivers/input/Makefile b/drivers/input/Makefile
index 5ca3f63..169e99c 100644
--- a/drivers/input/Makefile
+++ b/drivers/input/Makefile
@@ -11,6 +11,7 @@ obj-$(CONFIG_INPUT_FF_MEMLESS)	+= ff-memless.o
 obj-$(CONFIG_INPUT_POLLDEV)	+= input-polldev.o
 obj-$(CONFIG_INPUT_SPARSEKMAP)	+= sparse-keymap.o
 obj-$(CONFIG_INPUT_MATRIXKMAP)	+= matrix-keymap.o
+obj-$(CONFIG_INPUT_FF_MEMLESS_NEXT)	+= ff-memless-next.o
 
 obj-$(CONFIG_INPUT_MOUSEDEV)	+= mousedev.o
 obj-$(CONFIG_INPUT_JOYDEV)	+= joydev.o
diff --git a/drivers/input/ff-memless-next.c b/drivers/input/ff-memless-next.c
new file mode 100644
index 0000000..23727b2
--- /dev/null
+++ b/drivers/input/ff-memless-next.c
@@ -0,0 +1,675 @@
+/*
+ *
+ * Force feedback support for memory-less devices
+ *
+ * This module is based on "ff-memless" orignally written by Anssi Hannula.
+ * It is extented to support all force feedback effects currently supported
+ * by the Linux input stack. All effects except FF_RAMP are handled in accordance with
+ * Microsoft DirectInput specification valid at the time the module was written.
+ *
+ * Copyright(c) 2013 Michal Maly <madcatxster@prifuk.cz>
+ *
+ */
+
+/*
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ */
+
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
+#include <linux/slab.h>
+#include <linux/module.h>
+#include <linux/mutex.h>
+#include <linux/spinlock.h>
+#include <linux/jiffies.h>
+#include <linux/fixp-arith.h>
+#include <linux/input/ff-memless-next.h>
+
+MODULE_LICENSE("GPL");
+MODULE_AUTHOR("Michal \"MadCatX\" Maly");
+MODULE_DESCRIPTION("Force feedback support for memoryless force feedback devices");
+
+#define FF_MAX_EFFECTS 16
+#define FF_MIN_UPDATE_RATE_MSECS 5
+
+#define FF_EFFECT_STARTED 0x0
+#define FF_EFFECT_PLAYING 0x1
+
+
+struct mlnx_effect {
+	struct ff_effect *effect;
+	unsigned long flags;
+	unsigned long begin_at;
+	unsigned long stop_at;
+	unsigned long updated_at;
+	unsigned long attack_stop;
+	unsigned long fade_begin;
+	int repeat;
+	u16 playback_time;
+};
+
+struct mlnx_device {
+	u8 combinable_playing;
+	unsigned long update_rate_jiffies;
+	void *private;
+	struct mlnx_effect effects[FF_MAX_EFFECTS];
+	int gain;
+	struct timer_list timer;
+	struct input_dev *dev;
+
+	int (*control_effect)(struct input_dev *, void *, const struct mlnx_effect_command *);
+};
+
+static inline s32 mlnx_calculate_x_force(const s32 level, const u16 direction)
+{
+	s32 new = (level * -fixp_sin(direction)) >> FRAC_N;
+	pr_debug("x force: %d\n", new);
+	return new;
+}
+
+static inline s32 mlnx_calculate_y_force(const s32 level, const u16 direction)
+{
+	s32 new = (level * -fixp_cos(direction)) >> FRAC_N;
+	pr_debug("y force: %d\n", new);
+	return new;
+}
+
+static inline s32 mlnx_clamp_level(const s32 level)
+{
+	return (level > 0x7fff) ? 0x7fff : ((level < -0x7fff) ? -0x7fff : level);
+}
+
+static inline int mlnx_is_conditional(const struct ff_effect *effect)
+{
+	return (effect->type == FF_DAMPER) || (effect->type == FF_FRICTION) || (effect->type == FF_INERTIA) || (effect->type == FF_SPRING);
+}
+
+static void mlnx_set_envelope_times(struct mlnx_effect *mlnxeff)
+{
+	struct ff_effect *effect = mlnxeff->effect;
+	switch (effect->type) {
+	case FF_CONSTANT:
+		if (effect->u.constant.envelope.attack_length)
+			mlnxeff->attack_stop = mlnxeff->begin_at + msecs_to_jiffies(effect->u.constant.envelope.attack_length);
+		if (effect->replay.length && effect->u.constant.envelope.fade_length)
+			mlnxeff->fade_begin = mlnxeff->stop_at - msecs_to_jiffies(effect->u.constant.envelope.fade_length);
+		break;
+	case FF_PERIODIC:
+		pr_debug("Phase: %u, Offset: %d\n", effect->u.periodic.phase, effect->u.periodic.offset);
+		if (effect->u.periodic.envelope.attack_length)
+			mlnxeff->attack_stop = mlnxeff->begin_at + msecs_to_jiffies(effect->u.periodic.envelope.attack_length);
+		if (effect->replay.length && effect->u.periodic.envelope.fade_length)
+			mlnxeff->fade_begin = mlnxeff->stop_at - msecs_to_jiffies(effect->u.periodic.envelope.fade_length);
+		break;
+	case FF_RAMP:
+		if (effect->u.ramp.envelope.attack_length)
+			mlnxeff->attack_stop = mlnxeff->begin_at + msecs_to_jiffies(effect->u.ramp.envelope.attack_length);
+		if (effect->replay.length && effect->u.ramp.envelope.fade_length)
+			mlnxeff->fade_begin = mlnxeff->stop_at - msecs_to_jiffies(effect->u.ramp.envelope.fade_length);
+		break;
+	default:
+		break;
+	}
+}
+
+static void mlnx_set_trip_times(struct mlnx_effect *mlnxeff, const unsigned long now)
+{
+	mlnxeff->begin_at = now + msecs_to_jiffies(mlnxeff->effect->replay.delay);
+	mlnxeff->stop_at = mlnxeff->begin_at + msecs_to_jiffies(mlnxeff->effect->replay.length);
+	mlnxeff->updated_at = mlnxeff->begin_at;
+	if (mlnxeff->effect->type == FF_PERIODIC) {
+		mlnxeff->playback_time = mlnxeff->effect->u.periodic.phase;
+		/* Adjust periodic effects phase accordingly to Microsoft DirectInput specification */
+		switch (mlnxeff->effect->u.periodic.waveform) {
+		case FF_TRIANGLE:
+			mlnxeff->playback_time += mlnxeff->effect->u.periodic.period / 4;
+			break;
+		default:
+			break;
+		}
+	}
+}
+
+static void mlnx_start_effect(struct mlnx_device *mlnxdev, struct mlnx_effect *mlnxeff)
+{
+	const unsigned long now = jiffies;
+
+	mlnx_set_trip_times(mlnxeff, now);
+	mlnx_set_envelope_times(mlnxeff);
+	__set_bit(FF_EFFECT_STARTED, &mlnxeff->flags);
+}
+
+static void mlnx_stop_effect(struct mlnx_device *mlnxdev, struct mlnx_effect *mlnxeff, const int idx)
+{
+	switch (mlnxeff->effect->type) {
+	case FF_CONSTANT:
+	case FF_PERIODIC:
+		if (--mlnxdev->combinable_playing == 0) {
+			const struct mlnx_effect_command c = { .cmd = MLNX_STOP_COMBINED };
+			mlnxdev->control_effect(mlnxdev->dev, mlnxdev->private, &c);
+		}
+		return;
+	case FF_DAMPER:
+	case FF_FRICTION:
+	case FF_INERTIA:
+	case FF_SPRING:
+	{
+		const struct mlnx_effect_command c = { .cmd = MLNX_STOP_UNCOMB,
+							 .u.uncomb.id = idx,
+							 .u.uncomb.effect = mlnxeff->effect };
+		mlnxdev->control_effect(mlnxdev->dev, mlnxdev->private, &c);
+		return;
+	}
+	default:
+		return;
+	}
+}
+
+static const struct ff_envelope *mlnx_get_envelope(const struct ff_effect *effect)
+{
+	static const struct ff_envelope empty;
+
+	switch (effect->type) {
+	case FF_CONSTANT:
+		return &effect->u.constant.envelope;
+	case FF_PERIODIC:
+		return &effect->u.periodic.envelope;
+	case FF_RAMP:
+		return &effect->u.ramp.envelope;
+	default:
+		return &empty;
+	}
+}
+
+static s32 mlnx_apply_envelope(const struct mlnx_effect *mlnxeff, const s32 level)
+{
+	const struct ff_effect *effect = mlnxeff->effect;
+	const struct ff_envelope *envelope = mlnx_get_envelope(effect);
+	const unsigned long now = jiffies;
+	const s32 alevel = abs(level);
+
+	/* Effect has an envelope with nonzero attack time */
+	if (envelope->attack_length && time_before(now, mlnxeff->attack_stop)) {
+		const s32 into_trans_msecs = jiffies_to_msecs(now - mlnxeff->begin_at);
+		const s32 trans_length = envelope->attack_length;
+		const s32 dlevel = (alevel - envelope->attack_level) * into_trans_msecs / trans_length;
+		pr_debug("Effect is attacking\n");
+		pr_debug("Envelope orig: %d, dlevel: %d, into: %d, length: %d\n", level, dlevel, into_trans_msecs, trans_length);
+		return level < 0 ? -(dlevel + envelope->attack_level) : (dlevel + envelope->attack_level);
+	} else if (envelope->fade_length && time_before_eq(mlnxeff->fade_begin, now)) {
+		const s32 into_trans_msecs = jiffies_to_msecs(now - mlnxeff->fade_begin);
+		const s32 trans_length = envelope->fade_length;
+		const s32 dlevel = (envelope->fade_level - alevel) * into_trans_msecs / trans_length;
+		pr_debug("Effect is fading\n");
+		pr_debug("Envelope orig: %d, dlevel: %d, into: %d, length: %d\n", level, dlevel, into_trans_msecs, trans_length);
+		return level < 0 ? -(dlevel + alevel) : (dlevel + alevel);
+	}
+
+	return level;
+}
+
+static s32 mlnx_calculate_periodic(struct mlnx_effect *mlnxeff, const s32 level)
+{
+	const struct ff_effect *effect = mlnxeff->effect;
+	const unsigned long now = jiffies;
+	const u16 period = effect->u.periodic.period;
+	const unsigned long dt = jiffies_to_msecs(now - mlnxeff->updated_at);
+	s32 new = level;
+	unsigned long n_periods;
+	u16 t;
+
+	mlnxeff->playback_time += dt;
+	mlnxeff->playback_time &= 0x7fff; /* Make sure we don't exceed the max allowed period */
+	n_periods = mlnxeff->playback_time / period;
+	t = mlnxeff->playback_time - (n_periods * period);
+
+	switch (effect->u.periodic.waveform) {
+	case FF_SINE:
+	{
+		u16 degrees = (360 * t) / period;
+		new = ((level * fixp_sin(degrees)) >> FRAC_N) + effect->u.periodic.offset;
+		break;
+	}
+	case FF_SQUARE:
+	{
+		u16 degrees = (360 * t) / period;
+		new = level * (degrees < 180 ? 1 : -1);
+		break;
+	}
+	case FF_SAW_UP:
+		new = 2 * level * t / period - level + effect->u.periodic.offset;
+		break;
+	case FF_SAW_DOWN:
+		new = level - 2 * level * t / period + effect->u.periodic.offset;
+		break;
+	case FF_TRIANGLE:
+	{
+		/* Fixed-point implementation of A = 1 - 4 * ABS(0.5 - FRAC(0.5x + 0.25)) */
+		s32 a = abs(0x4000 - (((0x8000 * t / period) + 0x2000) & 0x7fff));
+		new = ((level * (0x8000 - 4 * a)) >> 15) + effect->u.periodic.offset;
+		break;
+	}
+	case FF_CUSTOM:
+		pr_debug("Custom waveform is not handled by this driver.\n");
+		return level;
+	default:
+		pr_debug("Invalid waveform.\n");
+		return level;
+	}
+
+	new = mlnx_clamp_level(new); /* Make sure that the offset did not make the value exceed the s16 range */
+	pr_debug("level: %d, playback: %u, t: %u, dt: %lu\n", new, mlnxeff->playback_time, t, dt);
+	return new;
+}
+
+static s32 mlnx_calculate_ramp(const struct mlnx_effect *mlnxeff)
+{
+	const struct ff_effect *effect = mlnxeff->effect;
+	const struct ff_envelope *envelope = mlnx_get_envelope(effect);
+	const unsigned long now = jiffies;
+	const u16 length = effect->replay.length;
+	s16 start = effect->u.ramp.start_level;
+	s16 end = effect->u.ramp.end_level;
+	u16 t = jiffies_to_msecs(now - mlnxeff->begin_at);
+	s32 new;
+
+	/* Effect has an envelope with nonzero attack time
+	 * If the envelope is attacking, adjust "start", if the
+	 * effect is fading, adjust "end". */
+	if (envelope->attack_length && time_before(now, mlnxeff->attack_stop)) {
+		const s32 into_trans_msecs = jiffies_to_msecs(now - mlnxeff->begin_at);
+		const s32 trans_length = envelope->attack_length;
+		const s32 dlevel = (abs(start) - envelope->attack_level) * into_trans_msecs / trans_length;
+		start = start < 0 ? -(dlevel + envelope->attack_level) : (dlevel + envelope->attack_level);
+		pr_debug("RA Envelope orig: %d, dlevel: %d, into: %d, length: %d\n", start, dlevel, into_trans_msecs, trans_length);
+	} else if (envelope->fade_length && time_before_eq(mlnxeff->fade_begin, now)) {
+		const s32 into_trans_msecs = jiffies_to_msecs(now - mlnxeff->fade_begin);
+		const s32 trans_length = envelope->fade_length;
+		const s32 dlevel = (envelope->fade_level - abs(end)) * into_trans_msecs / trans_length;
+		end = end < 0 ? -(dlevel + abs(end)) : (dlevel + abs(end));
+		pr_debug("RA Envelope orig: %d, dlevel: %d, into: %d, length: %d\n", end, dlevel, into_trans_msecs, trans_length);
+	}
+
+	new = ((end - start) * t) / (length) + start;
+	pr_debug("RAMP level: %d, t: %u\n", new, t);
+	return new;
+}
+
+static void mlnx_destroy(struct ff_device *dev)
+{
+	struct mlnx_device *mlnxdev = dev->private;
+	del_timer_sync(&mlnxdev->timer);
+
+	kfree(mlnxdev->private);
+}
+
+static unsigned long mlnx_get_envelope_update_time(const struct mlnx_effect *mlnxeff, const unsigned long update_rate_jiffies)
+{
+	const struct ff_effect *effect = mlnxeff->effect;
+	const struct ff_envelope *envelope = mlnx_get_envelope(effect);
+	const unsigned long now = jiffies;
+	unsigned long fade_next;
+
+	/* Effect has an envelope with nonzero attack time */
+	if (envelope->attack_length && time_before(now, mlnxeff->attack_stop)) {
+		pr_debug("Attack stop: %lu\n", mlnxeff->attack_stop);
+		if (time_before(mlnxeff->updated_at + update_rate_jiffies, mlnxeff->attack_stop))
+			return mlnxeff->updated_at + update_rate_jiffies;
+		else
+			return mlnxeff->attack_stop;
+	}
+
+	/* Effect has an envelope with nonzero fade time */
+	if (mlnxeff->effect->replay.length) {
+		if (envelope->fade_length) {
+
+			/* Schedule the next update when the fade begins */
+			if (time_before(mlnxeff->updated_at, mlnxeff->fade_begin))
+				return mlnxeff->fade_begin;
+
+			/* Already fading */
+			else if (time_before(mlnxeff->fade_begin, now)) {
+				fade_next = mlnxeff->updated_at + update_rate_jiffies;
+				if (time_after(fade_next, mlnxeff->stop_at))
+					return mlnxeff->stop_at; /* Schedule update when the effect stops */
+				else
+					return fade_next;      /* Schedule update at the next checkpoint */
+			}
+		} else
+			return mlnxeff->stop_at;
+	}
+
+	/* There is no envelope */
+	if (mlnxeff->begin_at == now && test_bit(FF_EFFECT_PLAYING, &mlnxeff->flags))
+		return now - 1; /* Prevent the effect from being started twice */
+	else
+		return mlnxeff->begin_at;
+}
+
+static unsigned long mlnx_get_update_time(const struct mlnx_effect *mlnxeff, const unsigned long update_rate_jiffies)
+{
+	const unsigned long now = jiffies;
+	unsigned long time, update_periodic;
+
+	switch (mlnxeff->effect->type) {
+	/* Constant effect does not change with time, but it can have an envelope and a duration */
+	case FF_CONSTANT:
+		return mlnx_get_envelope_update_time(mlnxeff, update_rate_jiffies);
+	/* Periodic and ramp effects have to be periodically updated */
+	case FF_PERIODIC:
+	case FF_RAMP:
+		time = mlnx_get_envelope_update_time(mlnxeff, update_rate_jiffies);
+
+		if (mlnxeff->effect->type == FF_PERIODIC && mlnxeff->effect->u.periodic.waveform == FF_SQUARE)
+			update_periodic = msecs_to_jiffies(mlnxeff->effect->u.periodic.period / 2) + mlnxeff->updated_at;
+		else
+			update_periodic = mlnxeff->updated_at + update_rate_jiffies;
+
+		/* Periodic effect has to be updated earlier than envelope or envelope update time is in the past */
+		if (time_before(update_periodic, time) || time_before(time, now))
+			return update_periodic;
+		else /* Envelope needs to be updated */
+			return time;
+	case FF_DAMPER:
+	case FF_FRICTION:
+	case FF_INERTIA:
+	case FF_SPRING:
+	default:
+		if (time_after_eq(mlnxeff->begin_at, now))
+			return mlnxeff->begin_at;
+		else
+			return mlnxeff->stop_at;
+	}
+}
+
+static void mlnx_schedule_playback(struct mlnx_device *mlnxdev)
+{
+	struct mlnx_effect *mlnxeff;
+	const unsigned long now = jiffies;
+	int events = 0;
+	int i;
+	unsigned long earliest = 0;
+	unsigned long time;
+
+	/* Iterate over all effects and determine the earliest time when we have to attend to any */
+	for (i = 0; i < FF_MAX_EFFECTS; i++) {
+		mlnxeff = &mlnxdev->effects[i];
+
+		if (!test_bit(FF_EFFECT_STARTED, &mlnxeff->flags))
+			continue; /* Effect is not started, skip it */
+
+		if (test_bit(FF_EFFECT_PLAYING, &mlnxeff->flags))
+			time = mlnx_get_update_time(mlnxeff, mlnxdev->update_rate_jiffies);
+		else
+			time = mlnxeff->begin_at;
+
+		pr_debug("Update time for effect %d: %lu\n", i, time);
+
+		/* Scheduled time is in the future and is either before the current earliest time
+		 * or it is the first valid time value in this pass */
+		if (time_before_eq(now, time) && (++events == 1 || time_before(time, earliest)))
+			earliest = time;
+	}
+
+	if (events) {
+		pr_debug("Events: %d, earliest: %lu\n", events, earliest);
+		mod_timer(&mlnxdev->timer, earliest);
+	}
+}
+
+static void mlnx_add_force(struct mlnx_effect *mlnxeff, s32 *cfx, s32 *cfy, const u16 gain)
+{
+	u16 direction;
+	s32 level;
+
+	pr_debug("Processing effect type %d, ID %d\n", mlnxeff->effect->type, mlnxeff->effect->id);
+
+	direction = mlnxeff->effect->direction * 360 / 0xffff;
+	pr_debug("Direction deg: %u\n", direction);
+
+	switch (mlnxeff->effect->type) {
+	case FF_CONSTANT:
+		level = mlnx_apply_envelope(mlnxeff, mlnxeff->effect->u.constant.level);
+		break;
+	case FF_PERIODIC:
+		level = mlnx_apply_envelope(mlnxeff, mlnxeff->effect->u.periodic.magnitude);
+		level = mlnx_calculate_periodic(mlnxeff, level);
+		break;
+	case FF_RAMP:
+		level = mlnx_calculate_ramp(mlnxeff);
+		break;
+	default:
+		pr_debug("Effect %d is not handled by mlnx_add_force, this is probably a bug!\n", mlnxeff->effect->type);
+		return;
+	}
+
+	*cfx += mlnx_calculate_x_force(level, direction) * gain / 0xffff;
+	*cfy += mlnx_calculate_y_force(level, direction) * gain / 0xffff;
+}
+
+static void mlnx_play_effects(struct mlnx_device *mlnxdev)
+{
+	const u16 gain = mlnxdev->gain;
+	const unsigned long now = jiffies;
+	int i;
+	int cfx = 0;
+	int cfy = 0;
+
+	for (i = 0; i < FF_MAX_EFFECTS; i++) {
+		struct mlnx_effect *mlnxeff = &mlnxdev->effects[i];
+
+		if (!test_bit(FF_EFFECT_STARTED, &mlnxeff->flags)) {
+			pr_debug("Effect %hd/%d not started\n", mlnxeff->effect->id, i);
+			continue;
+		}
+
+		if (time_before(now, mlnxeff->begin_at)) {
+			pr_debug("Effect %hd/%d begins at a later time\n", mlnxeff->effect->id, i);
+			continue;
+		}
+
+		if (time_before_eq(mlnxeff->stop_at, now) && mlnxeff->effect->replay.length) {
+			pr_debug("Effect %hd/%d has to be stopped\n", mlnxeff->effect->id, i);
+
+			/* If the effect should be repeated, reset it */
+			if (--mlnxeff->repeat > 0) {
+				__clear_bit(FF_EFFECT_PLAYING, &mlnxeff->flags);
+				mlnxeff->begin_at = mlnxeff->stop_at + msecs_to_jiffies(mlnxeff->effect->replay.delay);
+				mlnxeff->stop_at = mlnxeff->begin_at + msecs_to_jiffies(mlnxeff->effect->replay.length);
+			} else /* The effect has to be stopped */
+				mlnx_stop_effect(mlnxdev, mlnxeff, i);
+
+			continue;
+		}
+
+		switch (mlnxeff->effect->type) {
+		case FF_CONSTANT:
+		case FF_PERIODIC:
+		case FF_RAMP:
+			if (!test_and_set_bit(FF_EFFECT_PLAYING, &mlnxeff->flags)) {
+				mlnxdev->combinable_playing++;
+				pr_debug("Starting combinable effect, total %u\n", mlnxdev->combinable_playing);
+			}
+			mlnx_add_force(mlnxeff, &cfx, &cfy, gain);
+			break;
+		case FF_DAMPER:
+		case FF_FRICTION:
+		case FF_INERTIA:
+		case FF_SPRING:
+			if (!test_and_set_bit(FF_EFFECT_PLAYING, &mlnxeff->flags)) {
+				const struct mlnx_effect_command ecmd = { .cmd = MLNX_START_UNCOMB,
+									  .u.uncomb.id = i,
+									  .u.uncomb.effect = mlnxeff->effect };
+				mlnxdev->control_effect(mlnxdev->dev, mlnxdev->private, &ecmd);
+			}
+			break;
+		default:
+			pr_debug("Unhandled type of effect.\n");
+		}
+		mlnxeff->updated_at = now;
+	}
+
+	if (mlnxdev->combinable_playing) {
+		const struct mlnx_effect_command ecmd = { .cmd = MLNX_START_COMBINED,
+							  .u.simple_force = { .x = mlnx_clamp_level(cfx), .y = mlnx_clamp_level(cfy) } };
+		mlnxdev->control_effect(mlnxdev->dev, mlnxdev->private, &ecmd);
+	}
+
+	mlnx_schedule_playback(mlnxdev);
+}
+
+static void mlnx_set_gain(struct input_dev *dev, u16 gain)
+{
+	struct mlnx_device *mlnxdev = dev->ff->private;
+	int i;
+
+	mlnxdev->gain = gain;
+
+	for (i = 0; i < FF_MAX_EFFECTS; i++)
+		__clear_bit(FF_EFFECT_PLAYING, &mlnxdev->effects[i].flags);
+
+	mlnx_play_effects(mlnxdev);
+}
+
+static int mlnx_startstop(struct input_dev *dev, int effect_id, int repeat)
+{
+	struct mlnx_device *mlnxdev = dev->ff->private;
+	struct mlnx_effect *mlnxeff = &mlnxdev->effects[effect_id];
+
+	if (repeat > 0) {
+		pr_debug("Starting effect ID %d\n", effect_id);
+		mlnxeff->repeat = repeat;
+		mlnx_start_effect(mlnxdev, mlnxeff);
+	} else {
+		pr_debug("Stopping effect ID %d\n", effect_id);
+		if (test_bit(FF_EFFECT_STARTED, &mlnxdev->effects[effect_id].flags)) {
+			if (test_bit(FF_EFFECT_PLAYING, &mlnxdev->effects[effect_id].flags)) {
+				mlnx_stop_effect(mlnxdev, mlnxeff, effect_id);
+				__clear_bit(FF_EFFECT_PLAYING, &mlnxdev->effects[effect_id].flags);
+			}
+			__clear_bit(FF_EFFECT_STARTED, &mlnxdev->effects[effect_id].flags);
+		} else
+			pr_debug("Effect ID %d already stopped.\n", effect_id);
+	}
+
+	mlnx_play_effects(mlnxdev);
+
+	return 0;
+}
+
+static void mlnx_timer_fired(unsigned long data)
+{
+	struct input_dev *dev = (struct input_dev *)data;
+	unsigned long flags;
+
+	spin_lock_irqsave(&dev->event_lock, flags);
+	mlnx_play_effects(dev->ff->private);
+	spin_unlock_irqrestore(&dev->event_lock, flags);
+}
+
+static int mlnx_upload(struct input_dev *dev, struct ff_effect *effect, struct ff_effect *old)
+{
+	struct mlnx_device *mlnxdev = dev->ff->private;
+	struct mlnx_effect *mlnxeff = &mlnxdev->effects[effect->id];
+	const unsigned long now = jiffies;
+	int ret, fade_from;
+
+	pr_debug("Uploading effect type %d, ID %d\n", effect->type, effect->id);
+
+	if (effect->type == FF_PERIODIC) {
+		if (!effect->u.periodic.period)
+			return -EINVAL;
+	}
+
+	if (effect->type == FF_CONSTANT || effect->type == FF_PERIODIC || effect->type == FF_RAMP) {
+		const struct ff_envelope *envelope = mlnx_get_envelope(effect);
+
+		/* Infinite effects cannot fade */
+		if (effect->replay.length == 0 && envelope->fade_length > 0)
+			return -EINVAL;
+		/* Fade length cannot be greater than effect duration */
+		fade_from = (int)effect->replay.length - (int)envelope->fade_length;
+		if (fade_from < 0)
+			return -EINVAL;
+		/* Envelope cannot start fading before it finishes attacking */
+		if (fade_from < envelope->attack_length)
+			return -EINVAL;
+	}
+
+	spin_lock_irq(&dev->event_lock);
+	/* Check if the effect being modified is playing */
+	if (test_bit(FF_EFFECT_STARTED, &mlnxeff->flags)) {
+		/* Set the effect to stopped state */
+		__clear_bit(FF_EFFECT_STARTED, &mlnxeff->flags);
+		mlnx_set_trip_times(mlnxeff, now);
+		mlnx_set_envelope_times(mlnxeff);
+		mlnx_schedule_playback(mlnxdev);
+	}
+
+	/* Some devices might have a limit on how many uncombinable effect can be played at once */
+	if (mlnx_is_conditional(effect)) {
+		struct mlnx_effect_command ecmd = { .cmd = MLNX_CAN_PLAY,
+						    .u.uncomb.id = effect->id,
+						    .u.uncomb.effect = effect };
+		ret = mlnxdev->control_effect(dev, mlnxdev->private, &ecmd);
+		if (ret) {
+			pr_debug("Device rejected effect\n");
+			spin_unlock_irq(&dev->event_lock);
+			return ret;
+		}
+	}
+
+	spin_unlock_irq(&dev->event_lock);
+
+	return 0;
+}
+
+int input_ff_create_mlnx(struct input_dev *dev, void *data, int(*control_effect)(struct input_dev *, void *, const struct mlnx_effect_command *),
+			 const u16 update_rate)
+{
+	struct mlnx_device *mlnxdev;
+	int ret;
+	int i;
+
+	if (update_rate < FF_MIN_UPDATE_RATE_MSECS)
+		return -EINVAL;
+
+	mlnxdev = kzalloc(sizeof(struct mlnx_device), GFP_KERNEL);
+	if (!mlnxdev)
+		return -ENOMEM;
+
+	mlnxdev->dev = dev;
+	mlnxdev->private = data;
+	mlnxdev->control_effect = control_effect;
+	mlnxdev->gain = 0xffff;
+	mlnxdev->update_rate_jiffies = msecs_to_jiffies(update_rate);
+	setup_timer(&mlnxdev->timer, mlnx_timer_fired, (unsigned long)dev);
+
+	ret = input_ff_create(dev, FF_MAX_EFFECTS);
+	if (ret) {
+		kfree(mlnxdev);
+		return ret;
+	}
+
+	dev->ff->private = mlnxdev;
+	dev->ff->upload = mlnx_upload;
+	dev->ff->set_gain = mlnx_set_gain;
+	dev->ff->destroy = mlnx_destroy;
+	dev->ff->playback = mlnx_startstop;
+
+	/* Link mlnxdev->effects to dev->ff->effects */
+	for (i = 0; i < FF_MAX_EFFECTS; i++)
+		mlnxdev->effects[i].effect = &dev->ff->effects[i];
+
+	pr_debug("MLNX: Device successfully registered.\n");
+	return 0;
+}
+EXPORT_SYMBOL_GPL(input_ff_create_mlnx);
diff --git a/include/linux/input/ff-memless-next.h b/include/linux/input/ff-memless-next.h
new file mode 100644
index 0000000..0711c1c
--- /dev/null
+++ b/include/linux/input/ff-memless-next.h
@@ -0,0 +1,29 @@
+#include <linux/input.h>
+
+enum mlnx_commands {
+	MLNX_START_COMBINED,
+	MLNX_STOP_COMBINED,
+	MLNX_START_UNCOMB,
+	MLNX_STOP_UNCOMB,
+	MLNX_CAN_PLAY
+};
+
+struct mlnx_simple_force {
+	const s32 x;
+	const s32 y;
+};
+
+struct mlnx_uncomb_effect {
+	const int id;
+	const struct ff_effect *effect;
+};
+
+struct mlnx_effect_command {
+	const enum mlnx_commands cmd;
+	union {
+		const struct mlnx_simple_force simple_force;
+		const struct mlnx_uncomb_effect uncomb;
+	} u;
+};
+
+int input_ff_create_mlnx(struct input_dev *dev, void *data, int(*control_effect)(struct input_dev *, void *, const struct mlnx_effect_command *), const u16 update_rate);
-- 
1.8.5.1



