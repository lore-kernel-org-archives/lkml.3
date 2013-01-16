Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756931Ab3APROF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jan 2013 12:14:05 -0500
Received: from arroyo.ext.ti.com ([192.94.94.40]:37552 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752850Ab3APROA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jan 2013 12:14:00 -0500
Date: Wed, 16 Jan 2013 19:13:50 +0200
From: Felipe Balbi <balbi@ti.com>
To: Alan Cox <alan@linux.intel.com>
CC: <arve@android.com>, <x86@kernel.org>, <linux-kernel@vger.kernel.org>,
        <mikechan@google.com>
Subject: Re: [PATCH 04/10] goldfish: virtual input event driver
Message-ID: <20130116171350.GC6377@arwen.pp.htv.fi>
Reply-To: <balbi@ti.com>
References: <20130116165552.15183.92942.stgit@bob.linux.org.uk>
 <20130116165913.15183.94039.stgit@bob.linux.org.uk>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="hYooF8G/hrfVAmum"
Content-Disposition: inline
In-Reply-To: <20130116165913.15183.94039.stgit@bob.linux.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--hYooF8G/hrfVAmum
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Wed, Jan 16, 2013 at 04:59:14PM +0000, Alan Cox wrote:
> From: Brian Swetland <swetland@google.com>
>=20
> This device is a direct pipe from "hardware" to the input
> event subsystem, allowing us to avoid having to route
> "keypad" style events through an AT keyboard driver (gross!)
>=20
> As with the other submissions this driver is cross architecture.
>=20
> Signed-off-by: Mike A. Chan <mikechan@google.com>
> [Tided up to work on x86]
> Signed-off-by: Sheng Yang <sheng@linux.intel.com>
> Signed-off-by: Yunhong Jiang <yunhong.jiang@intel.com>
> Signed-off-by: Xiaohui Xin <xiaohui.xin@intel.com>
> Signed-off-by: Jun Nakajima <jun.nakajima@intel.com>
> Signed-off-by: Bruce Beare <bruce.j.beare@intel.com>
> [Ported to 3.4]
> Signed-off-by: Tom Keel <thomas.keel@intel.com>
> [Cleaned up for 3.7 and submission]
> Signed-off-by: Alan Cox <alan@linux.intel.com>
> ---
>=20
>  drivers/input/keyboard/Kconfig           |   11 ++
>  drivers/input/keyboard/Makefile          |    1=20
>  drivers/input/keyboard/goldfish_events.c |  187 ++++++++++++++++++++++++=
++++++
>  3 files changed, 199 insertions(+)
>  create mode 100644 drivers/input/keyboard/goldfish_events.c
>=20
>=20
> diff --git a/drivers/input/keyboard/Kconfig b/drivers/input/keyboard/Kcon=
fig
> index 5a240c6..df884b8 100644
> --- a/drivers/input/keyboard/Kconfig
> +++ b/drivers/input/keyboard/Kconfig
> @@ -479,6 +479,17 @@ config KEYBOARD_SAMSUNG
>  	  To compile this driver as a module, choose M here: the
>  	  module will be called samsung-keypad.
> =20
> +config KEYBOARD_GOLDFISH_EVENTS
> +	depends on GOLDFISH
> +	tristate "Generic Input Event device for Goldfish"
> +	help
> +	  Say Y here to get an input event device for the Goldfish virtual
> +	  device emulator.
> +
> +	  To compile this driver as a module, choose M here: the
> +	  module will be called goldfish-events.
> +
> +
>  config KEYBOARD_STOWAWAY
>  	tristate "Stowaway keyboard"
>  	select SERIO
> diff --git a/drivers/input/keyboard/Makefile b/drivers/input/keyboard/Mak=
efile
> index 44e7600..49b1645 100644
> --- a/drivers/input/keyboard/Makefile
> +++ b/drivers/input/keyboard/Makefile
> @@ -13,6 +13,7 @@ obj-$(CONFIG_KEYBOARD_ATKBD)		+=3D atkbd.o
>  obj-$(CONFIG_KEYBOARD_BFIN)		+=3D bf54x-keys.o
>  obj-$(CONFIG_KEYBOARD_DAVINCI)		+=3D davinci_keyscan.o
>  obj-$(CONFIG_KEYBOARD_EP93XX)		+=3D ep93xx_keypad.o
> +obj-$(CONFIG_KEYBOARD_GOLDFISH_EVENTS)	+=3D goldfish_events.o
>  obj-$(CONFIG_KEYBOARD_GPIO)		+=3D gpio_keys.o
>  obj-$(CONFIG_KEYBOARD_GPIO_POLLED)	+=3D gpio_keys_polled.o
>  obj-$(CONFIG_KEYBOARD_TCA6416)		+=3D tca6416-keypad.o
> diff --git a/drivers/input/keyboard/goldfish_events.c b/drivers/input/key=
board/goldfish_events.c
> new file mode 100644
> index 0000000..b72068b
> --- /dev/null
> +++ b/drivers/input/keyboard/goldfish_events.c
> @@ -0,0 +1,187 @@
> +/*
> + * Copyright (C) 2007 Google, Inc.
> + * Copyright (C) 2012 Intel, Inc.
> + *
> + * This software is licensed under the terms of the GNU General Public
> + * License version 2, as published by the Free Software Foundation, and
> + * may be copied, distributed, and modified under those terms.
> + *
> + * This program is distributed in the hope that it will be useful,
> + * but WITHOUT ANY WARRANTY; without even the implied warranty of
> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> + * GNU General Public License for more details.
> + *
> + */
> +
> +#include <linux/module.h>
> +#include <linux/init.h>
> +#include <linux/interrupt.h>
> +#include <linux/types.h>
> +#include <linux/input.h>
> +#include <linux/kernel.h>
> +#include <linux/platform_device.h>
> +#include <linux/slab.h>
> +#include <linux/irq.h>
> +#include <linux/io.h>
> +
> +enum {
> +	REG_READ        =3D 0x00,
> +	REG_SET_PAGE    =3D 0x00,
> +	REG_LEN         =3D 0x04,
> +	REG_DATA        =3D 0x08,
> +
> +	PAGE_NAME       =3D 0x00000,
> +	PAGE_EVBITS     =3D 0x10000,
> +	PAGE_ABSDATA    =3D 0x20000 | EV_ABS,
> +};
> +
> +struct event_dev {
> +	struct input_dev *input;
> +	int irq;
> +	void __iomem *addr;
> +	char name[0];
> +};
> +
> +static irqreturn_t events_interrupt(int irq, void *dev_id)
> +{
> +	struct event_dev *edev =3D dev_id;
> +	unsigned type, code, value;
> +
> +	type =3D __raw_readl(edev->addr + REG_READ);
> +	code =3D __raw_readl(edev->addr + REG_READ);
> +	value =3D __raw_readl(edev->addr + REG_READ);
> +
> +	input_event(edev->input, type, code, value);
> +	if (type =3D=3D EV_KEY)
> +		input_sync(edev->input);
> +	return IRQ_HANDLED;
> +}
> +
> +static void events_import_bits(struct event_dev *edev,
> +			unsigned long bits[], unsigned type, size_t count)
> +{
> +	int i, j;
> +	size_t size;
> +	uint8_t val;
> +	void __iomem *addr =3D edev->addr;
> +	__raw_writel(PAGE_EVBITS | type, addr + REG_SET_PAGE);
> +	size =3D __raw_readl(addr + REG_LEN) * 8;
> +	if (size < count)
> +		count =3D size;
> +	addr =3D addr + REG_DATA;
> +	for (i =3D 0; i < count; i +=3D 8) {
> +		val =3D __raw_readb(addr++);
> +		for (j =3D 0; j < 8; j++)
> +			if (val & 1 << j)
> +				set_bit(i + j, bits);
> +	}

I guess something like below would be better ?

for (i =3D 0; i < count; i +=3D 8) {
	val =3D readb(addr++);

	while (val) {
		unsigned long j =3D __ffs(val);
		unsigned int bit =3D i + j;

		val &=3D ~BIT(j);
		set_bit(bit, bits);
	}
}

guess I wrote it correctly, not even compile tested however.

> +static int events_probe(struct platform_device *pdev)
> +{
> +	struct input_dev *input_dev;
> +	struct event_dev *edev =3D NULL;
> +	struct resource *res;
> +	unsigned keymapnamelen;
> +	int i;
> +	int count;
> +	int irq;
> +	void __iomem *addr;
> +	int ret;
> +
> +	pr_debug("*** events probe ***\n");

looks unnecessary to me. Also, you have a struct device * inside your
pdev, so if you really wanna keep these debugging messages, it might be
better to make use of dev_dbg(&pdev->dev, ....) instead.

> +	input_dev =3D input_allocate_device();

devm_input_allocate_device()

> +	res =3D platform_get_resource(pdev, IORESOURCE_MEM, 0);
> +	if (!input_dev || !res)
> +		goto fail;
> +
> +	addr =3D ioremap(res->start, 4096);

missing request_mem_region(), 4096 has a define in <linux/sizes.h>
SZ_4K. As said before, this could be converted to
devm_request_and_ioremap()

> +	irq =3D platform_get_irq(pdev, 0);
> +
> +	pr_debug("events_probe() addr=3D%p irq=3D%d\n", addr, irq);
> +
> +	if (!addr)
> +		goto fail;
> +	if (irq < 0)
> +		goto fail;
> +
> +	__raw_writel(PAGE_NAME, addr + REG_SET_PAGE);
> +	keymapnamelen =3D __raw_readl(addr + REG_LEN);
> +
> +	edev =3D kzalloc(sizeof(struct event_dev) + keymapnamelen + 1,
> +								GFP_KERNEL);

devm_kzalloc()

> +	if (!edev)
> +		goto fail;
> +
> +	edev->input =3D input_dev;
> +	edev->addr =3D addr;
> +	edev->irq =3D irq;
> +
> +	for (i =3D 0; i < keymapnamelen; i++)
> +		edev->name[i] =3D __raw_readb(edev->addr + REG_DATA + i);
> +
> +	pr_debug("events_probe() keymap=3D%s\n", edev->name);
> +
> +	events_import_bits(edev, input_dev->evbit, EV_SYN, EV_MAX);
> +	events_import_bits(edev, input_dev->keybit, EV_KEY, KEY_MAX);
> +	events_import_bits(edev, input_dev->relbit, EV_REL, REL_MAX);
> +	events_import_bits(edev, input_dev->absbit, EV_ABS, ABS_MAX);
> +	events_import_bits(edev, input_dev->mscbit, EV_MSC, MSC_MAX);
> +	events_import_bits(edev, input_dev->ledbit, EV_LED, LED_MAX);
> +	events_import_bits(edev, input_dev->sndbit, EV_SND, SND_MAX);
> +	events_import_bits(edev, input_dev->ffbit, EV_FF, FF_MAX);
> +	events_import_bits(edev, input_dev->swbit, EV_SW, SW_MAX);
> +
> +	__raw_writel(PAGE_ABSDATA, addr + REG_SET_PAGE);
> +	count =3D __raw_readl(addr + REG_LEN) / (4 * 4);
> +	if (count > ABS_MAX)
> +		count =3D ABS_MAX;
> +	for (i =3D 0; i < count; i++) {
> +		int val[4];
> +		int j;
> +		if (!test_bit(i, input_dev->absbit))
> +			continue;
> +		for (j =3D 0; j < ARRAY_SIZE(val); j++)
> +			val[j] =3D __raw_readl(edev->addr + REG_DATA + (i * ARRAY_SIZE(val) +=
 j) * 4);
> +		input_set_abs_params(input_dev, i, val[0], val[1],
> +							val[2], val[3]);
> +	}
> +
> +	platform_set_drvdata(pdev, edev);
> +
> +	input_dev->name =3D edev->name;
> +	input_set_drvdata(input_dev, edev);
> +
> +	ret =3D input_register_device(input_dev);
> +	if (ret)
> +		goto fail;
> +
> +	if (request_irq(edev->irq, events_interrupt, 0,
> +				"goldfish-events-keypad", edev) < 0) {

devm_request_irq()

> +		input_unregister_device(input_dev);
> +		kfree(edev);
> +		return -EINVAL;
> +	}
> +
> +	return 0;
> +
> +fail:
> +	kfree(edev);
> +	input_free_device(input_dev);
> +
> +	return -EINVAL;
> +}
> +
> +static struct platform_driver events_driver =3D {
> +	.probe =3D events_probe,

no remove ?

--=20
balbi

--hYooF8G/hrfVAmum
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJQ9t/OAAoJEIaOsuA1yqRELkcP/jqQyIAM6UXdFv/Zk2wbccth
+FFOCqKfVEc16SotQ3O78jjR3wqgTaWdK6KQFFijGXrA6SxgLtAGO+4ZrYP9bTaO
o0TstZaY1JuKX6xJShzHkHWlJP7FpYUTb4I3R1rPOC3rEOgJYEJDXZSLLBetJdDc
YHbnXG09nW/ZLxqyC/58Vuxv8I+jUmoQ70AaiHwt5W/yDsTk99vZ3vfC+zn3H/tm
q3C5ZhZQtiVVL8hyyYKsPIFKxAIWkZaG/8oYOfQI3sjSt1cYj+m742C/hguQ3z0i
xe/c7ZnjmQr/NxmpiQgraJV/yw/fURzaJHDRR2hfWF1l0zmFROh+rlhu137/QU3E
5hcXI3ZIPId0qGkOmbGTwwcQvzooUvbv37zzP9fzhz5yB2dVm0sMJ1OyenolCZiP
W7M2IlgNPLYZS9FYyaHJy2ecY53OFZR/AUYi4rxhAz6mQLeu0HI6rehldUaQKeTF
6SLVjie4J2iRO5HscgoyLSQpsJp3VSCSzXOTrN604ZWXS94q7BgjllMIOOCwJbpp
5g0TccRwyKoLsnF0CJf6+FXLhgwjk3Ue4zh3nCCi9WxNC7mUi9NKmOB3njbDsWow
EgCDLdzrKPSyqkASGmvyYh/ulz1iE4CDgUTiw9VWrAnRfe+RIy2LnCl3eVJ8mVkU
t6dxelo/ZUyzM5wiGBGr
=Qaq0
-----END PGP SIGNATURE-----

--hYooF8G/hrfVAmum--
