Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756845AbaLJHBI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Dec 2014 02:01:08 -0500
Received: from arrakis.dune.hu ([78.24.191.176]:49737 "EHLO arrakis.dune.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753149AbaLJHBG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Dec 2014 02:01:06 -0500
Message-ID: <5487EFAC.3070402@openwrt.org>
Date: Wed, 10 Dec 2014 08:01:00 +0100
From: John Crispin <blogic@openwrt.org>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.9; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Samuel Thibault <samuel.thibault@ens-lyon.org>,
        Pavel Machek <pavel@ucw.cz>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        David Herrmann <dh.herrmann@gmail.com>, akpm@linux-foundation.org,
        jslaby@suse.cz, Bryan Wu <cooloney@gmail.com>, rpurdie@rpsys.net,
        linux-kernel@vger.kernel.org, Evan Broder <evan@ebroder.net>,
        Arnaud Patard <arnaud.patard@rtp-net.org>,
        Peter Korsgaard <jacmet@sunsite.dk>,
        Sascha Hauer <s.hauer@pengutronix.de>, Rob Clark <robdclark@gmail.com>,
        Niels de Vos <devos@fedoraproject.org>,
        linux-arm-kernel@lists.infradead.org,
        =?ISO-8859-1?Q?Pali_Roh=E1r?= <pali.rohar@gmail.com>
Subject: Re: [PATCHv4] INPUT: Route keyboard LEDs through the generic LEDs
 layer.
References: <20141210010214.GZ3074@type.youpi.perso.aquilenet.fr>
In-Reply-To: <20141210010214.GZ3074@type.youpi.perso.aquilenet.fr>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi

On 10/12/2014 02:02, Samuel Thibault wrote:
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
> [ebroder@mokafive.com: Rebased to 3.2-rc1 or so, cleaned up some includes, and fixed some constants]
> [blogic@openwrt.org: CONFIG_INPUT_LEDS stubs should be static inline]
> [akpm@linux-foundation.org: remove unneeded `extern', fix comment layout]
> Signed-off-by: Samuel Thibault <samuel.thibault@ens-lyon.org>
> Signed-off-by: Evan Broder <evan@ebroder.net>
> Reviewed-by: David Herrmann <dh.herrmann@gmail.com>
> Tested-by: Pavel Machek <pavel@ucw.cz>
> Acked-by: Peter Korsgaard <jacmet@sunsite.dk>
> Signed-off-by: John Crispin <blogic@openwrt.org>

I am not sure why my SoB was added. I originally sent a trivial fix up
for a header file as linux-next was not building (this was a year or
more ago). I never reviewed this patch nor have I tested it and I
certainly was not involved in the development. the patch simply broke
the compile of the Mips based Wifi and DSL SoCs that i maitain.

the code I touched is marked below

[snip]

> --- a/include/linux/input.h
> +++ b/include/linux/input.h
> @@ -79,6 +79,7 @@ struct input_value {
>   * @led: reflects current state of device's LEDs
>   * @snd: reflects current state of sound effects
>   * @sw: reflects current state of device's switches
> + * @leds: leds objects for the device's LEDs
>   * @open: this method is called when the very first user calls
>   *	input_open_device(). The driver must prepare the device
>   *	to start generating events (start polling thread,
> @@ -164,6 +165,8 @@ struct input_dev {
>  	unsigned long snd[BITS_TO_LONGS(SND_CNT)];
>  	unsigned long sw[BITS_TO_LONGS(SW_CNT)];
>  
> +	struct led_classdev *leds;
> +
>  	int (*open)(struct input_dev *dev);
>  	void (*close)(struct input_dev *dev);
>  	int (*flush)(struct input_dev *dev, struct file *file);
> @@ -531,4 +534,29 @@ int input_ff_erase(struct input_dev *dev
>  int input_ff_create_memless(struct input_dev *dev, void *data,
>  		int (*play_effect)(struct input_dev *, void *, struct ff_effect *));
>  
> +#ifdef CONFIG_INPUT_LEDS
> +
> +void input_led_init(void);
> +void input_led_exit(void);
> +
> +int input_led_connect(struct input_dev *dev);
> +void input_led_disconnect(struct input_dev *dev);
> +
> +#else
> +
> +static inline void input_led_init(void) { }
> +
> +static inline void input_led_exit(void) { }
> +
> +static inline int input_led_connect(struct input_dev *dev)
> +{
> +	return 0;
> +}
> +
> +static inline void input_led_disconnect(struct input_dev *dev)
> +{
> +}
> +
> +#endif
> +

this #else part was added by me to make sure that linux-next was
building again. this really does not qualify my SoB being added.

	John















>  #endif
> --- /dev/null
> +++ b/drivers/input/leds.c
> @@ -0,0 +1,272 @@
> +/*
> + * LED support for the input layer
> + *
> + * Copyright 2010-2014 Samuel Thibault <samuel.thibault@ens-lyon.org>
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
> +
> +/*
> + * Keyboard LEDs are propagated by default like the following example:
> + *
> + * VT keyboard numlock trigger
> + * -> vt::numl VT LED
> + * -> vt-numl VT trigger
> + * -> per-device inputX::numl LED
> + *
> + * Userland can however choose the trigger for the vt::numl LED, or
> + * independently choose the trigger for any inputx::numl LED.
> + *
> + *
> + * VT LED classes and triggers are registered on-demand according to
> + * existing LED devices
> + */
> +
> +/* Handler for VT LEDs, just triggers the corresponding VT trigger. */
> +static void vt_led_set(struct led_classdev *cdev,
> +			  enum led_brightness brightness);
> +static struct led_classdev vt_leds[LED_CNT] = {
> +#define DEFINE_INPUT_LED(vt_led, nam, deftrig) \
> +	[vt_led] = { \
> +		.name = "vt::"nam, \
> +		.max_brightness = 1, \
> +		.brightness_set = vt_led_set, \
> +		.default_trigger = deftrig, \
> +	}
> +/* Default triggers for the VT LEDs just correspond to the legacy
> + * usage. */
> +	DEFINE_INPUT_LED(LED_NUML, "numl", "kbd-numlock"),
> +	DEFINE_INPUT_LED(LED_CAPSL, "capsl", "kbd-capslock"),
> +	DEFINE_INPUT_LED(LED_SCROLLL, "scrolll", "kbd-scrollock"),
> +	DEFINE_INPUT_LED(LED_COMPOSE, "compose", NULL),
> +	DEFINE_INPUT_LED(LED_KANA, "kana", "kbd-kanalock"),
> +	DEFINE_INPUT_LED(LED_SLEEP, "sleep", NULL),
> +	DEFINE_INPUT_LED(LED_SUSPEND, "suspend", NULL),
> +	DEFINE_INPUT_LED(LED_MUTE, "mute", NULL),
> +	DEFINE_INPUT_LED(LED_MISC, "misc", NULL),
> +	DEFINE_INPUT_LED(LED_MAIL, "mail", NULL),
> +	DEFINE_INPUT_LED(LED_CHARGING, "charging", NULL),
> +};
> +static const char *const vt_led_names[LED_CNT] = {
> +	[LED_NUML] = "numl",
> +	[LED_CAPSL] = "capsl",
> +	[LED_SCROLLL] = "scrolll",
> +	[LED_COMPOSE] = "compose",
> +	[LED_KANA] = "kana",
> +	[LED_SLEEP] = "sleep",
> +	[LED_SUSPEND] = "suspend",
> +	[LED_MUTE] = "mute",
> +	[LED_MISC] = "misc",
> +	[LED_MAIL] = "mail",
> +	[LED_CHARGING] = "charging",
> +};
> +/* Handler for hotplug initialization */
> +static void vt_led_trigger_activate(struct led_classdev *cdev);
> +/* VT triggers */
> +static struct led_trigger vt_led_triggers[LED_CNT] = {
> +#define DEFINE_INPUT_LED_TRIGGER(vt_led, nam) \
> +	[vt_led] = { \
> +		.name = "vt-"nam, \
> +		.activate = vt_led_trigger_activate, \
> +	}
> +	DEFINE_INPUT_LED_TRIGGER(LED_NUML, "numl"),
> +	DEFINE_INPUT_LED_TRIGGER(LED_CAPSL, "capsl"),
> +	DEFINE_INPUT_LED_TRIGGER(LED_SCROLLL, "scrolll"),
> +	DEFINE_INPUT_LED_TRIGGER(LED_COMPOSE, "compose"),
> +	DEFINE_INPUT_LED_TRIGGER(LED_KANA, "kana"),
> +	DEFINE_INPUT_LED_TRIGGER(LED_SLEEP, "sleep"),
> +	DEFINE_INPUT_LED_TRIGGER(LED_SUSPEND, "suspend"),
> +	DEFINE_INPUT_LED_TRIGGER(LED_MUTE, "mute"),
> +	DEFINE_INPUT_LED_TRIGGER(LED_MISC, "misc"),
> +	DEFINE_INPUT_LED_TRIGGER(LED_MAIL, "mail"),
> +	DEFINE_INPUT_LED_TRIGGER(LED_CHARGING, "charging"),
> +};
> +
> +/* Lock for registration coherency */
> +static DEFINE_MUTEX(vt_led_registered_lock);
> +
> +/* Which VT LED classes and triggers are registered */
> +static unsigned long vt_led_registered[BITS_TO_LONGS(LED_CNT)];
> +
> +/* Number of input devices having each LED */
> +static int vt_led_references[LED_CNT];
> +
> +static int vt_led_state[LED_CNT];
> +static struct work_struct vt_led_work[LED_CNT];
> +
> +static void vt_led_cb(struct work_struct *work)
> +{
> +	int led = work - vt_led_work;
> +
> +	led_trigger_event(&vt_led_triggers[led], vt_led_state[led]);
> +}
> +
> +/* VT LED state change, tell the VT trigger.  */
> +static void vt_led_set(struct led_classdev *cdev,
> +			  enum led_brightness brightness)
> +{
> +	int led = cdev - vt_leds;
> +
> +	vt_led_state[led] = !!brightness;
> +	schedule_work(&vt_led_work[led]);
> +}
> +
> +/* LED state change for some keyboard, notify that keyboard.  */
> +static void perdevice_input_led_set(struct led_classdev *cdev,
> +			  enum led_brightness brightness)
> +{
> +	struct input_dev *dev;
> +	struct led_classdev *leds;
> +	int led;
> +
> +	dev = cdev->dev->platform_data;
> +	if (!dev)
> +		/* Still initializing */
> +		return;
> +	leds = dev->leds;
> +	led = cdev - leds;
> +
> +	input_event(dev, EV_LED, led, !!brightness);
> +	input_event(dev, EV_SYN, SYN_REPORT, 0);
> +}
> +
> +/* Keyboard hotplug, initialize its LED status */
> +static void vt_led_trigger_activate(struct led_classdev *cdev)
> +{
> +	struct led_trigger *trigger = cdev->trigger;
> +	int led = trigger - vt_led_triggers;
> +
> +	if (cdev->brightness_set)
> +		cdev->brightness_set(cdev, vt_leds[led].brightness);
> +}
> +
> +/* Free led stuff from input device, used at abortion and disconnection.  */
> +static void input_led_delete(struct input_dev *dev)
> +{
> +	if (dev) {
> +		struct led_classdev *leds = dev->leds;
> +		if (leds) {
> +			int i;
> +			for (i = 0; i < LED_CNT; i++)
> +				kfree(leds[i].name);
> +			kfree(leds);
> +			dev->leds = NULL;
> +		}
> +	}
> +}
> +
> +/* A new input device with potential LEDs to connect.  */
> +int input_led_connect(struct input_dev *dev)
> +{
> +	int i, error = 0;
> +	struct led_classdev *leds;
> +
> +	dev->leds = leds = kcalloc(LED_CNT, sizeof(*leds), GFP_KERNEL);
> +	if (!dev->leds)
> +		return -ENOMEM;
> +
> +	/* lazily register missing VT LEDs */
> +	mutex_lock(&vt_led_registered_lock);
> +	for (i = 0; i < LED_CNT; i++)
> +		if (vt_leds[i].name && test_bit(i, dev->ledbit)) {
> +			if (!vt_led_references[i]) {
> +				led_trigger_register(&vt_led_triggers[i]);
> +				/* This keyboard is first to have led i,
> +				 * try to register it */
> +				if (!led_classdev_register(NULL, &vt_leds[i]))
> +					vt_led_references[i] = 1;
> +				else
> +					led_trigger_unregister(&vt_led_triggers[i]);
> +			} else
> +				vt_led_references[i]++;
> +		}
> +	mutex_unlock(&vt_led_registered_lock);
> +
> +	/* and register this device's LEDs */
> +	for (i = 0; i < LED_CNT; i++)
> +		if (vt_leds[i].name && test_bit(i, dev->ledbit)) {
> +			leds[i].name = kasprintf(GFP_KERNEL, "%s::%s",
> +						dev_name(&dev->dev),
> +						vt_led_names[i]);
> +			if (!leds[i].name) {
> +				error = -ENOMEM;
> +				goto err;
> +			}
> +			leds[i].max_brightness = 1;
> +			leds[i].brightness_set = perdevice_input_led_set;
> +			leds[i].default_trigger = vt_led_triggers[i].name;
> +		}
> +
> +	/* No issue so far, we can register for real.  */
> +	for (i = 0; i < LED_CNT; i++)
> +		if (leds[i].name) {
> +			led_classdev_register(&dev->dev, &leds[i]);
> +			leds[i].dev->platform_data = dev;
> +			perdevice_input_led_set(&leds[i],
> +					vt_leds[i].brightness);
> +		}
> +
> +	return 0;
> +
> +err:
> +	input_led_delete(dev);
> +	return error;
> +}
> +
> +/*
> + * Disconnected input device. Clean it, and deregister now-useless VT LEDs
> + * and triggers.
> + */
> +void input_led_disconnect(struct input_dev *dev)
> +{
> +	int i;
> +	struct led_classdev *leds = dev->leds;
> +
> +	for (i = 0; i < LED_CNT; i++)
> +		if (leds[i].name)
> +			led_classdev_unregister(&leds[i]);
> +
> +	input_led_delete(dev);
> +
> +	mutex_lock(&vt_led_registered_lock);
> +	for (i = 0; i < LED_CNT; i++) {
> +		if (!vt_leds[i].name || !test_bit(i, dev->ledbit))
> +			continue;
> +
> +		vt_led_references[i]--;
> +		if (vt_led_references[i]) {
> +			/* Still some devices needing it */
> +			continue;
> +		}
> +
> +		led_classdev_unregister(&vt_leds[i]);
> +		led_trigger_unregister(&vt_led_triggers[i]);
> +		clear_bit(i, vt_led_registered);
> +	}
> +	mutex_unlock(&vt_led_registered_lock);
> +}
> +
> +void __init input_led_init(void)
> +{
> +	unsigned i;
> +
> +	for (i = 0; i < LED_CNT; i++)
> +		INIT_WORK(&vt_led_work[i], vt_led_cb);
> +}
> +
> +void __exit input_led_exit(void)
> +{
> +	unsigned i;
> +
> +	for (i = 0; i < LED_CNT; i++)
> +		cancel_work_sync(&vt_led_work[i]);
> +}
> 
