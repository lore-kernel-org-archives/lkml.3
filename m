Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932470Ab3GOPDM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Jul 2013 11:03:12 -0400
Received: from mail-ie0-f170.google.com ([209.85.223.170]:39487 "EHLO
	mail-ie0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757603Ab3GOPDK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Jul 2013 11:03:10 -0400
MIME-Version: 1.0
In-Reply-To: <20130707101028.GD5651@type.youpi.perso.aquilenet.fr>
References: <201011112205.oABM5KVJ005298@imap1.linux-foundation.org>
	<201011111440.07882.dmitry.torokhov@gmail.com>
	<20110102090935.GV32469@atrey.karlin.mff.cuni.cz>
	<20110102103210.GA25662@core.coreip.homeip.net>
	<20110102225741.GX5480@const.famille.thibault.fr>
	<20110112182702.GA9168@core.coreip.homeip.net>
	<20111114040613.GA4992@type.famille.thibault.fr>
	<20121221003449.GA6999@type.youpi.perso.aquilenet.fr>
	<20130707101028.GD5651@type.youpi.perso.aquilenet.fr>
Date: Mon, 15 Jul 2013 17:03:08 +0200
Message-ID: <CANq1E4TRAOp+=w4oqPt4sjV7iLyDygxxpwrZy7dSB8UK288aNA@mail.gmail.com>
Subject: Re: [PATCH] Route kbd LEDs through the generic LEDs layer
From: David Herrmann <dh.herrmann@gmail.com>
To: Samuel Thibault <samuel.thibault@ens-lyon.org>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Pavel Machek <pavel@ucw.cz>, Andrew Morton <akpm@linux-foundation.org>,
        jslaby@suse.cz, rpurdie@rpsys.net,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Evan Broder <evan@ebroder.net>,
        Arnaud Patard <arnaud.patard@rtp-net.org>,
        Peter Korsgaard <jacmet@sunsite.dk>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Matt Sealey <matt@genesi-usa.com>, Rob Clark <robdclark@gmail.com>,
        Niels de Vos <devos@fedoraproject.org>,
        linux-arm-kernel@lists.infradead.org,
        Steev Klimaszewski <steev@genesi-usa.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi

On Sun, Jul 7, 2013 at 12:10 PM, Samuel Thibault
<samuel.thibault@ens-lyon.org> wrote:
> This permits to reassign keyboard LEDs to something else than keyboard "leds"
> state, by adding keyboard led and modifier triggers connected to a series
> of VT input LEDs, themselves connected to VT input triggers, which
> per-input device LEDs use by default.  Userland can thus easily change the LED
> behavior of (a priori) all input devices, or of particular input devices.
>
> This also permits to fix #7063 from userland by using a modifier to implement
> proper CapsLock behavior and have the keyboard caps lock led show that modifier
> state.
>
> Signed-off-by: Samuel Thibault <samuel.thibault@ens-lyon.org>
> [ebroder@mokafive.com: Rebased to 3.2-rc1 or so, cleaned up some includes, and fixed some constants]
> Signed-off-by: Evan Broder <evan@ebroder.net>
>
> diff --exclude .svn -ur linux-3.10-orig/Documentation/leds/leds-class.txt linux-3.10-perso/Documentation/leds/leds-class.txt
> --- linux-3.10-orig/Documentation/leds/leds-class.txt   2013-04-29 13:27:16.959258613 +0200
> +++ linux-3.10-perso/Documentation/leds/leds-class.txt  2013-07-01 23:51:39.229318781 +0200
> @@ -2,9 +2,6 @@
>  LED handling under Linux
>  ========================
>
> -If you're reading this and thinking about keyboard leds, these are
> -handled by the input subsystem and the led class is *not* needed.
> -
>  In its simplest form, the LED class just allows control of LEDs from
>  userspace. LEDs appear in /sys/class/leds/. The maximum brightness of the
>  LED is defined in max_brightness file. The brightness file will set the brightness
> diff --exclude .svn -ur linux-3.10-orig/drivers/input/input.c linux-3.10-perso/drivers/input/input.c
> --- linux-3.10-orig/drivers/input/input.c       2013-04-29 13:27:16.959258613 +0200
> +++ linux-3.10-perso/drivers/input/input.c      2013-07-01 23:51:39.233318421 +0200
> @@ -28,6 +28,7 @@
>  #include <linux/mutex.h>
>  #include <linux/rcupdate.h>
>  #include "input-compat.h"
> +#include "leds.h"
>
>  MODULE_AUTHOR("Vojtech Pavlik <vojtech@suse.cz>");
>  MODULE_DESCRIPTION("Input core");
> @@ -708,6 +709,11 @@
>                 handle->open = 0;
>
>         spin_unlock_irq(&dev->event_lock);
> +
> +#ifdef CONFIG_INPUT_LEDS
> +       if (is_event_supported(EV_LED, dev->evbit, EV_MAX))
> +               input_led_disconnect(dev);
> +#endif

Please turn "input_led_disconnect()" into a dummy instead of #ifdef
around function calls. See below.

>  }
>
>  /**
> @@ -2092,6 +2098,11 @@
>
>         list_add_tail(&dev->node, &input_dev_list);
>
> +#ifdef CONFIG_INPUT_LEDS
> +       if (is_event_supported(EV_LED, dev->evbit, EV_MAX))
> +               input_led_connect(dev);
> +#endif
> +

Same as above.

>         list_for_each_entry(handler, &input_handler_list, node)
>                 input_attach_handler(dev, handler);
>
> diff --exclude .svn -ur linux-3.10-orig/drivers/input/Kconfig linux-3.10-perso/drivers/input/Kconfig
> --- linux-3.10-orig/drivers/input/Kconfig       2013-04-29 13:32:29.997497163 +0200
> +++ linux-3.10-perso/drivers/input/Kconfig      2013-07-01 23:51:39.233318421 +0200
> @@ -178,6 +178,15 @@
>
>  source "drivers/input/keyboard/Kconfig"
>
> +config INPUT_LEDS
> +       tristate "LED Support"
> +       depends on LEDS_CLASS
> +       select LEDS_TRIGGERS
> +       default y
> +       help
> +         This option enables support for the LEDs on keyboard managed

-the +keyboard_s_?

> +         by the input layer.
> +
>  source "drivers/input/mouse/Kconfig"
>
>  source "drivers/input/joystick/Kconfig"
> diff --exclude .svn -ur linux-3.10-orig/drivers/input/Makefile linux-3.10-perso/drivers/input/Makefile
> --- linux-3.10-orig/drivers/input/Makefile      2013-04-29 13:27:16.959258613 +0200
> +++ linux-3.10-perso/drivers/input/Makefile     2013-07-01 23:51:39.233318421 +0200
> @@ -18,6 +18,7 @@
>  obj-$(CONFIG_INPUT_EVBUG)      += evbug.o
>
>  obj-$(CONFIG_INPUT_KEYBOARD)   += keyboard/
> +obj-$(CONFIG_INPUT_LEDS)       += leds.o

Nitpick, but could you move it into the section above or below? This
section includes sub-directories only.

>  obj-$(CONFIG_INPUT_MOUSE)      += mouse/
>  obj-$(CONFIG_INPUT_JOYSTICK)   += joystick/
>  obj-$(CONFIG_INPUT_TABLET)     += tablet/
> diff --exclude .svn -ur linux-3.10-orig/drivers/leds/Kconfig linux-3.10-perso/drivers/leds/Kconfig
> --- linux-3.10-orig/drivers/leds/Kconfig        2013-07-01 01:56:00.335874214 +0200
> +++ linux-3.10-perso/drivers/leds/Kconfig       2013-07-01 23:51:39.233318421 +0200
> @@ -11,9 +11,6 @@
>           Say Y to enable Linux LED support.  This allows control of supported
>           LEDs from both userspace and optionally, by kernel events (triggers).
>
> -         This is not related to standard keyboard LEDs which are controlled
> -         via the input system.
> -
>  if NEW_LEDS
>
>  config LEDS_CLASS
> diff --exclude .svn -ur linux-3.10-orig/drivers/tty/Kconfig linux-3.10-perso/drivers/tty/Kconfig
> --- linux-3.10-orig/drivers/tty/Kconfig 2013-04-29 13:32:36.353298705 +0200
> +++ linux-3.10-perso/drivers/tty/Kconfig        2013-07-01 23:51:39.237318056 +0200
> @@ -13,6 +13,10 @@
>         bool "Virtual terminal" if EXPERT
>         depends on !S390 && !UML
>         select INPUT
> +       select NEW_LEDS
> +       select LEDS_CLASS
> +       select LEDS_TRIGGERS
> +       select INPUT_LEDS

This looks odd. Any dependency changes in the input-layer will break
this. But I guess that's what we get for a non-recursive "select". Hmm

>         default y
>         ---help---
>           If you say Y here, you will get support for terminal devices with
> diff --exclude .svn -ur linux-3.10-orig/drivers/tty/vt/keyboard.c linux-3.10-perso/drivers/tty/vt/keyboard.c
> --- linux-3.10-orig/drivers/tty/vt/keyboard.c   2013-04-29 13:32:36.681288463 +0200
> +++ linux-3.10-perso/drivers/tty/vt/keyboard.c  2013-07-01 23:51:39.237318056 +0200
> @@ -33,6 +33,7 @@
>  #include <linux/string.h>
>  #include <linux/init.h>
>  #include <linux/slab.h>
> +#include <linux/leds.h>
>
>  #include <linux/kbd_kern.h>
>  #include <linux/kbd_diacr.h>
> @@ -130,6 +131,7 @@
>  static int shift_state = 0;
>
>  static unsigned char ledstate = 0xff;                  /* undefined */
> +static unsigned char lockstate = 0xff;                 /* undefined */
>  static unsigned char ledioctl;
>
>  static struct ledptr {
> @@ -967,6 +969,32 @@
>         }
>  }
>
> +/* We route VT keyboard "leds" through triggers */
> +static void kbd_ledstate_trigger_activate(struct led_classdev *cdev);
> +static struct led_trigger ledtrig_ledstate[] = {
> +#define DEFINE_LEDSTATE_TRIGGER(kbd_led, nam) \
> +       [kbd_led] = { .name = nam, .activate = kbd_ledstate_trigger_activate, }
> +       DEFINE_LEDSTATE_TRIGGER(VC_SCROLLOCK, "scrollock"),
> +       DEFINE_LEDSTATE_TRIGGER(VC_NUMLOCK,   "numlock"),
> +       DEFINE_LEDSTATE_TRIGGER(VC_CAPSLOCK,  "capslock"),
> +       DEFINE_LEDSTATE_TRIGGER(VC_KANALOCK,  "kanalock"),
> +#undef DEFINE_LEDSTATE_TRIGGER
> +};
> +static void kbd_lockstate_trigger_activate(struct led_classdev *cdev);
> +static struct led_trigger ledtrig_lockstate[] = {
> +#define DEFINE_LOCKSTATE_TRIGGER(kbd_led, nam) \
> +       [kbd_led] = { .name = nam, .activate = kbd_lockstate_trigger_activate, }
> +       DEFINE_LOCKSTATE_TRIGGER(VC_SHIFTLOCK,  "shiftlock"),
> +       DEFINE_LOCKSTATE_TRIGGER(VC_ALTGRLOCK,  "altgrlock"),
> +       DEFINE_LOCKSTATE_TRIGGER(VC_CTRLLOCK,   "ctrllock"),
> +       DEFINE_LOCKSTATE_TRIGGER(VC_ALTLOCK,    "altlock"),
> +       DEFINE_LOCKSTATE_TRIGGER(VC_SHIFTLLOCK, "shiftllock"),
> +       DEFINE_LOCKSTATE_TRIGGER(VC_SHIFTRLOCK, "shiftrlock"),
> +       DEFINE_LOCKSTATE_TRIGGER(VC_CTRLLLOCK,  "ctrlllock"),
> +       DEFINE_LOCKSTATE_TRIGGER(VC_CTRLRLOCK,  "ctrlrlock"),
> +#undef DEFINE_LOCKSTATE_TRIGGER
> +};
> +

We use empty lines between function-declarations and variable
declarations, I think. Would make this a lot easier to read. I also
think that the macros don't really simplify this. So:
  [VC_SHIFTLOCK] = { .name = "shiftlock", .activate =
kbd_lockstate_trigger_activate },
isn't much longer than:
  DEFINE_LOCKSTATE_TRIGGER(VC_SHIFTLOCK,  "shiftlock"),
But I guess that's a matter of taste.

>  /*
>   * The leds display either (i) the status of NumLock, CapsLock, ScrollLock,
>   * or (ii) whatever pattern of lights people want to show using KDSETLED,
> @@ -1002,6 +1030,7 @@
>
>         leds = kbd->ledflagstate;
>
> +       /* TODO: should be replaced by a LED trigger */
>         if (kbd->ledmode == LED_SHOW_MEM) {
>                 for (i = 0; i < 3; i++)
>                         if (ledptrs[i].valid) {
> @@ -1014,18 +1043,24 @@
>         return leds;
>  }
>
> -static int kbd_update_leds_helper(struct input_handle *handle, void *data)
> +/* Called on trigger connection, to set initial state */
> +static void kbd_ledstate_trigger_activate(struct led_classdev *cdev)
>  {
> -       unsigned char leds = *(unsigned char *)data;
> +       struct led_trigger *trigger = cdev->trigger;
> +       int led = trigger - ledtrig_ledstate;
>
> -       if (test_bit(EV_LED, handle->dev->evbit)) {
> -               input_inject_event(handle, EV_LED, LED_SCROLLL, !!(leds & 0x01));
> -               input_inject_event(handle, EV_LED, LED_NUML,    !!(leds & 0x02));
> -               input_inject_event(handle, EV_LED, LED_CAPSL,   !!(leds & 0x04));
> -               input_inject_event(handle, EV_SYN, SYN_REPORT, 0);
> -       }
> +       tasklet_disable(&keyboard_tasklet);
> +       led_trigger_event(trigger, ledstate & (1 << led) ? LED_FULL : LED_OFF);
> +       tasklet_enable(&keyboard_tasklet);
> +}
> +static void kbd_lockstate_trigger_activate(struct led_classdev *cdev)
> +{
> +       struct led_trigger *trigger = cdev->trigger;
> +       int led = trigger - ledtrig_lockstate;
>
> -       return 0;
> +       tasklet_disable(&keyboard_tasklet);
> +       led_trigger_event(trigger, lockstate & (1 << led) ? LED_FULL : LED_OFF);
> +       tasklet_enable(&keyboard_tasklet);
>  }

Again, please add empty lines between functions definitions.

>
>  /**
> @@ -1120,10 +1155,24 @@
>         spin_unlock_irqrestore(&led_lock, flags);
>
>         if (leds != ledstate) {
> -               input_handler_for_each_handle(&kbd_handler, &leds,
> -                                             kbd_update_leds_helper);
> +               int i;

Move "int i;" to the top. You use it again below. gcc is smart enough
to notice that both usages are independent.

> +               for (i = 0; i < ARRAY_SIZE(ledtrig_ledstate); i++)
> +                       if ((leds ^ ledstate) & (1 << i))
> +                               led_trigger_event(&ledtrig_ledstate[i],
> +                                               leds & (1 << i)
> +                                               ? LED_FULL : LED_OFF);
>                 ledstate = leds;
>         }
> +
> +       if (kbd->lockstate != lockstate) {
> +               int i;
> +               for (i = 0; i < ARRAY_SIZE(ledtrig_lockstate); i++)
> +                       if ((kbd->lockstate ^ lockstate) & (1 << i))
> +                               led_trigger_event(&ledtrig_lockstate[i],
> +                                               kbd->lockstate & (1 << i)
> +                                               ? LED_FULL : LED_OFF);
> +               lockstate = kbd->lockstate;
> +       }
>  }
>
>  DECLARE_TASKLET_DISABLED(keyboard_tasklet, kbd_bh, 0);
> @@ -1461,20 +1510,6 @@
>         kfree(handle);
>  }
>
> -/*
> - * Start keyboard handler on the new keyboard by refreshing LED state to
> - * match the rest of the system.
> - */
> -static void kbd_start(struct input_handle *handle)
> -{
> -       tasklet_disable(&keyboard_tasklet);
> -
> -       if (ledstate != 0xff)
> -               kbd_update_leds_helper(handle, &ledstate);
> -
> -       tasklet_enable(&keyboard_tasklet);
> -}
> -
>  static const struct input_device_id kbd_ids[] = {
>         {
>                 .flags = INPUT_DEVICE_ID_MATCH_EVBIT,
> @@ -1496,7 +1531,6 @@
>         .match          = kbd_match,
>         .connect        = kbd_connect,
>         .disconnect     = kbd_disconnect,
> -       .start          = kbd_start,
>         .name           = "kbd",
>         .id_table       = kbd_ids,
>  };
> @@ -1520,6 +1554,11 @@
>         if (error)
>                 return error;
>
> +       for (i = 0; i < ARRAY_SIZE(ledtrig_ledstate); i++)
> +               led_trigger_register(&ledtrig_ledstate[i]);
> +       for (i = 0; i < ARRAY_SIZE(ledtrig_lockstate); i++)
> +               led_trigger_register(&ledtrig_lockstate[i]);
> +

This returns "int", are you sure no error-handling is needed?

>         tasklet_enable(&keyboard_tasklet);
>         tasklet_schedule(&keyboard_tasklet);
>
> diff --exclude .svn -ur linux-3.10-orig/include/linux/input.h linux-3.10-perso/include/linux/input.h
> --- linux-3.10-orig/include/linux/input.h       2013-04-29 13:27:16.959258613 +0200
> +++ linux-3.10-perso/include/linux/input.h      2013-07-01 23:51:39.241317685 +0200
> @@ -164,6 +164,8 @@
>         unsigned long snd[BITS_TO_LONGS(SND_CNT)];
>         unsigned long sw[BITS_TO_LONGS(SW_CNT)];
>
> +       struct led_classdev *leds;
> +
>         int (*open)(struct input_dev *dev);
>         void (*close)(struct input_dev *dev);
>         int (*flush)(struct input_dev *dev, struct file *file);
> --- linux-3.10-orig/drivers/input/leds.h        1970-01-01 01:00:00.000000000 +0100
> +++ linux-3.10-perso/drivers/input/leds.h       2011-11-14 02:24:26.738456456 +0100
> @@ -0,0 +1,14 @@
> +/*
> + * LED support for the input layer
> + *
> + * Copyright 2010-2013 Samuel Thibault <samuel.thibault@ens-lyon.org>
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License version 2 as
> + * published by the Free Software Foundation.
> + */
> +
> +#include <linux/input.h>
> +
> +extern int input_led_connect(struct input_dev *dev);
> +extern void input_led_disconnect(struct input_dev *dev);

Header-protection is missing. Besides, these 2 lines could be easily
merged into input.h. Any reason not to?
Also remove the "extern" before functions. It does not add any value
and we try to drop it for new declarations.

And you can avoid the #ifdef mentioned above if you use something like this:

#ifdef CONFIG_LEDS

int input_led_connect(struct input_dev *dev);
void input_led_disconnect(struct input_dev *dev);

#else

static inline int input_led_connect(struct input_dev *dev)
{
    return 0;
}

static inline void input_led_disconnect(struct input_dev *dev)
{
}

#endif

> --- linux-3.10-orig/drivers/input/leds.c        1970-01-01 01:00:00.000000000 +0100
> +++ linux-3.10-perso/drivers/input/leds.c       2011-11-14 03:23:07.578469395 +0100
> @@ -0,0 +1,243 @@
> +/*
> + * LED support for the input layer
> + *
> + * Copyright 2010-2013 Samuel Thibault <samuel.thibault@ens-lyon.org>
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License version 2 as
> + * published by the Free Software Foundation.
> + */
> +
> +#include <linux/kernel.h>
> +#include <linux/slab.h>
> +#include <linux/module.h>
> +#include <linux/init.h>
> +#include <linux/leds.h>
> +#include <linux/input.h>

If you keep "input/leds.h" you should probably include it here. If you
drop it, you're fine.

> +
> +/*
> + * Keyboard LEDs are propagated by default like the following example:
> + *
> + * VT keyboard numlock trigger
> + * -> vt::numl VT LED
> + * -> vt-numl VT trigger

Nitpick: What's the reason for the syntax difference? "vt-numl" vs. "vt::numl"

> + * -> per-device inputx::numl LED

nitpick, but upper-case "X" is probably easier to understand. I had to
read it twice to get what the "x" means.

> + *
> + * Userland can however choose the trigger for the vt::numl LED, or
> + * independently choose the trigger for any inputx::numl LED.
> + */
> +
> +/* VT LED classes and triggers are registered on-demand according to
> + * existing LED devices */

Merge this comment with the comment above?

> +
> +/* Handler for VT LEDs, just triggers the corresponding VT trigger. */
> +static void vt_led_set(struct led_classdev *cdev,
> +                         enum led_brightness brightness);
> +static struct led_classdev vt_leds[LED_CNT] = {
> +#define DEFINE_INPUT_LED(vt_led, nam, deftrig) \
> +       [vt_led] = { \
> +               .name = "vt::"nam, \
> +               .max_brightness = 1, \
> +               .brightness_set = vt_led_set, \
> +               .default_trigger = deftrig, \
> +       }
> +/* Default triggers for the VT LEDs just correspond to the legacy
> + * usage. */
> +       DEFINE_INPUT_LED(LED_NUML, "numl", "numlock"),
> +       DEFINE_INPUT_LED(LED_CAPSL, "capsl", "capslock"),
> +       DEFINE_INPUT_LED(LED_SCROLLL, "scrolll", "scrollock"),
> +       DEFINE_INPUT_LED(LED_COMPOSE, "compose", NULL),
> +       DEFINE_INPUT_LED(LED_KANA, "kana", "kanalock"),
> +       DEFINE_INPUT_LED(LED_SLEEP, "sleep", NULL),
> +       DEFINE_INPUT_LED(LED_SUSPEND, "suspend", NULL),
> +       DEFINE_INPUT_LED(LED_MUTE, "mute", NULL),
> +       DEFINE_INPUT_LED(LED_MISC, "misc", NULL),
> +       DEFINE_INPUT_LED(LED_MAIL, "mail", NULL),
> +       DEFINE_INPUT_LED(LED_CHARGING, "charging", NULL),
> +};
> +static const char *const vt_led_names[LED_CNT] = {
> +       [LED_NUML] = "numl",
> +       [LED_CAPSL] = "capsl",
> +       [LED_SCROLLL] = "scrolll",
> +       [LED_COMPOSE] = "compose",
> +       [LED_KANA] = "kana",
> +       [LED_SLEEP] = "sleep",
> +       [LED_SUSPEND] = "suspend",
> +       [LED_MUTE] = "mute",
> +       [LED_MISC] = "misc",
> +       [LED_MAIL] = "mail",
> +       [LED_CHARGING] = "charging",
> +};
> +/* Handler for hotplug initialization */
> +static void vt_led_trigger_activate(struct led_classdev *cdev);
> +/* VT triggers */
> +static struct led_trigger vt_led_triggers[LED_CNT] = {
> +#define DEFINE_INPUT_LED_TRIGGER(vt_led, nam) \
> +       [vt_led] = { \
> +               .name = "vt-"nam, \
> +               .activate = vt_led_trigger_activate, \
> +       }
> +       DEFINE_INPUT_LED_TRIGGER(LED_NUML, "numl"),
> +       DEFINE_INPUT_LED_TRIGGER(LED_CAPSL, "capsl"),
> +       DEFINE_INPUT_LED_TRIGGER(LED_SCROLLL, "scrolll"),
> +       DEFINE_INPUT_LED_TRIGGER(LED_COMPOSE, "compose"),
> +       DEFINE_INPUT_LED_TRIGGER(LED_KANA, "kana"),
> +       DEFINE_INPUT_LED_TRIGGER(LED_SLEEP, "sleep"),
> +       DEFINE_INPUT_LED_TRIGGER(LED_SUSPEND, "suspend"),
> +       DEFINE_INPUT_LED_TRIGGER(LED_MUTE, "mute"),
> +       DEFINE_INPUT_LED_TRIGGER(LED_MISC, "misc"),
> +       DEFINE_INPUT_LED_TRIGGER(LED_MAIL, "mail"),
> +       DEFINE_INPUT_LED_TRIGGER(LED_CHARGING, "charging"),
> +};
> +/* Lock for registration coherency */
> +static DEFINE_MUTEX(vt_led_registered_lock);
> +/* Which VT LED classes and triggers are registered */
> +static unsigned long vt_led_registered[BITS_TO_LONGS(LED_CNT)];
> +/* Number of input devices having each LED */
> +static int vt_led_references[LED_CNT];

Please add some empty lines here. At least the different static arrays
should be separated by an empty newline.

> +
> +/* VT LED state change, tell the VT trigger.  */
> +static void vt_led_set(struct led_classdev *cdev,
> +                         enum led_brightness brightness)
> +{
> +       int led = cdev - vt_leds;
> +
> +       led_trigger_event(&vt_led_triggers[led], !!brightness);
> +}
> +
> +/* LED state change for some keyboard, notify that keyboard.  */
> +static void perdevice_input_led_set(struct led_classdev *cdev,
> +                         enum led_brightness brightness)
> +{
> +       struct input_dev *dev;
> +       struct led_classdev *leds;
> +       int led;
> +
> +       dev = cdev->dev->platform_data;
> +       if (!dev)
> +               /* Still initializing */
> +               return;
> +       leds = dev->leds;
> +       led = cdev - leds;
> +
> +       input_event(dev, EV_LED, led, !!brightness);
> +       input_event(dev, EV_SYN, SYN_REPORT, 0);
> +}
> +
> +/* Keyboard hotplug, initialize its LED status */
> +static void vt_led_trigger_activate(struct led_classdev *cdev)
> +{
> +       struct led_trigger *trigger = cdev->trigger;
> +       int led = trigger - vt_led_triggers;
> +
> +       if (cdev->brightness_set)
> +               cdev->brightness_set(cdev, vt_leds[led].brightness);
> +}
> +
> +/* Free led stuff from input device, used at abortion and disconnection.  */
> +static void input_led_delete(struct input_dev *dev)
> +{
> +       if (dev) {
> +               struct led_classdev *leds = dev->leds;
> +               if (leds) {
> +                       int i;
> +                       for (i = 0; i < LED_CNT; i++)
> +                               kfree(leds[i].name);
> +                       kfree(leds);
> +                       dev->leds = NULL;
> +               }
> +       }
> +}
> +
> +/* A new input device with potential LEDs to connect.  */
> +int input_led_connect(struct input_dev *dev)
> +{
> +       int i, error = 0;
> +       struct led_classdev *leds;
> +
> +       dev->leds = leds = kzalloc(sizeof(*leds) * LED_CNT, GFP_KERNEL);
> +       if (!dev->leds)
> +               return -ENOMEM;
> +
> +       /* lazily register missing VT LEDs */
> +       mutex_lock(&vt_led_registered_lock);
> +       for (i = 0; i < LED_CNT; i++)
> +               if (vt_leds[i].name && test_bit(i, dev->ledbit)) {
> +                       if (!vt_led_references[i]) {
> +                               led_trigger_register(&vt_led_triggers[i]);
> +                               /* This keyboard is first to have led i,
> +                                * try to register it */
> +                               if (!led_classdev_register(NULL, &vt_leds[i]))
> +                                       vt_led_references[i] = 1;
> +                               else
> +                                       led_trigger_unregister(&vt_led_triggers[i]);
> +                       } else
> +                               vt_led_references[i]++;
> +               }
> +       mutex_unlock(&vt_led_registered_lock);
> +
> +       /* and register this device's LEDs */
> +       for (i = 0; i < LED_CNT; i++)
> +               if (vt_leds[i].name && test_bit(i, dev->ledbit)) {
> +                       leds[i].name = kasprintf(GFP_KERNEL, "%s::%s",
> +                                               dev_name(&dev->dev),
> +                                               vt_led_names[i]);
> +                       if (!leds[i].name) {
> +                               error = -ENOMEM;
> +                               goto err;
> +                       }
> +                       leds[i].max_brightness = 1;
> +                       leds[i].brightness_set = perdevice_input_led_set;
> +                       leds[i].default_trigger = vt_led_triggers[i].name;
> +               }
> +
> +       /* No issue so far, we can register for real.  */
> +       for (i = 0; i < LED_CNT; i++)
> +               if (leds[i].name) {
> +                       led_classdev_register(&dev->dev, &leds[i]);
> +                       leds[i].dev->platform_data = dev;
> +                       perdevice_input_led_set(&leds[i],
> +                                       vt_leds[i].brightness);
> +               }
> +
> +       return 0;
> +
> +err:
> +       input_led_delete(dev);
> +       return error;
> +}
> +
> +/* Disconnected input device. Clean it, and deregister now-useless VT LEDs
> + * and triggers.  */
> +extern void input_led_disconnect(struct input_dev *dev)
> +{
> +       int i;
> +       struct led_classdev *leds = dev->leds;
> +
> +       for (i = 0; i < LED_CNT; i++)
> +               if (leds[i].name)
> +                       led_classdev_unregister(&leds[i]);
> +
> +       input_led_delete(dev);
> +
> +       mutex_lock(&vt_led_registered_lock);
> +       for (i = 0; i < LED_CNT; i++) {
> +               if (!vt_leds[i].name || !test_bit(i, dev->ledbit))
> +                       continue;
> +
> +               vt_led_references[i]--;
> +               if (vt_led_references[i]) {
> +                       /* Still some devices needing it */
> +                       continue;
> +               }
> +
> +               led_classdev_unregister(&vt_leds[i]);
> +               led_trigger_unregister(&vt_led_triggers[i]);
> +               clear_bit(i, vt_led_registered);
> +       }
> +       mutex_unlock(&vt_led_registered_lock);
> +}
> +
> +MODULE_LICENSE("GPL");
> +MODULE_DESCRIPTION("User LED support for input layer");
> +MODULE_AUTHOR("Samuel Thibault <samuel.thibault@ens-lyon.org>");

I haven't done any locking review, yet, and some of the comments are
probably just a matter of taste. But the patch looks good.

Cheers
David

> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
