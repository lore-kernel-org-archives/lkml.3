Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752731AbaEUOnR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 May 2014 10:43:17 -0400
Received: from mail-ee0-f45.google.com ([74.125.83.45]:52511 "EHLO
	mail-ee0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752700AbaEUOnO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 May 2014 10:43:14 -0400
Date: Wed, 21 May 2014 16:40:55 +0200
From: Thierry Reding <thierry.reding@gmail.com>
To: Benjamin Gaignard <benjamin.gaignard@linaro.org>
Cc: dri-devel@lists.freedesktop.org, airlied@linux.ie,
        linaro-mm-sig@lists.linaro.org, linux-kernel@vger.kernel.org,
        lee.jones@linaro.org
Subject: Re: [PATCH v3 01/16] drm: sti: add VTG driver
Message-ID: <20140521144051.GM2014@ulmo>
References: <1400594186-8956-1-git-send-email-benjamin.gaignard@linaro.org>
 <1400594186-8956-2-git-send-email-benjamin.gaignard@linaro.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="B9BE8dkJ1pIKavwa"
Content-Disposition: inline
In-Reply-To: <1400594186-8956-2-git-send-email-benjamin.gaignard@linaro.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--B9BE8dkJ1pIKavwa
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, May 20, 2014 at 03:56:11PM +0200, Benjamin Gaignard wrote:
> Video Time Generator drivers are used to synchronize the compositor
> and tvout hardware IPs by providing line count, sample count,
> synchronization signals (HSYNC, VSYNC) and top and bottom fields indication.
> VTG are used by pair for each data path (main or auxiliary): one for master and one for slave.

Please wrap commit messages at 72 characters.

> diff --git a/drivers/gpu/drm/sti/Makefile b/drivers/gpu/drm/sti/Makefile
[...]
> new file mode 100644
> index 0000000..33216e1
> --- /dev/null
> +++ b/drivers/gpu/drm/sti/Makefile
> @@ -0,0 +1,3 @@
> +ccflags-y := -Iinclude/drm

I don't think you need this. If you include DRM headers you should be
prefixing them with drm/ anyway.

> diff --git a/drivers/gpu/drm/sti/sti_vtg.c b/drivers/gpu/drm/sti/sti_vtg.c
[...]
> +#include <linux/component.h>
> +#include <linux/module.h>
> +#include <linux/platform_device.h>
> +#include <linux/notifier.h>

I prefer these to be sorted alphabetically.

> +#include "sti_vtg_utils.h"
> +#include "sti_vtg.h"
> +
> +#define VTG_TYPE_MASTER         0
> +#define VTG_TYPE_SLAVE_BY_EXT0  1

This is somewhat odd. I'll try to make some suggestions later on on how
to possibly improve on this.

> +/* registers offset */
> +#define VTG_MODE		0x0000
> +#define VTG_CLKLN		0x0008
> +#define VTG_HLFLN		0x000C
> +#define VTG_DRST_AUTOC		0x0010
> +#define VTG_VID_TFO		0x0040
> +#define VTG_VID_TFS		0x0044
> +#define VTG_VID_BFO		0x0048
> +#define VTG_VID_BFS		0x004C
> +
> +#define VTG_HOST_ITS		0x0078
> +#define VTG_HOST_ITS_BCLR	0x007C
> +#define VTG_HOST_ITM_BCLR	0x0088
> +#define VTG_HOST_ITM_BSET	0x008C
> +
> +#define VTG_H_HD_1		0x00C0
> +#define VTG_TOP_V_VD_1		0x00C4
> +#define VTG_BOT_V_VD_1		0x00C8
> +#define VTG_TOP_V_HD_1		0x00CC
> +#define VTG_BOT_V_HD_1		0x00D0
> +
> +#define VTG_H_HD_2		0x00E0
> +#define VTG_TOP_V_VD_2		0x00E4
> +#define VTG_BOT_V_VD_2		0x00E8
> +#define VTG_TOP_V_HD_2		0x00EC
> +#define VTG_BOT_V_HD_2		0x00F0
> +
> +#define VTG_H_HD_3		0x0100
> +#define VTG_TOP_V_VD_3		0x0104
> +#define VTG_BOT_V_VD_3		0x0108
> +#define VTG_TOP_V_HD_3		0x010C
> +#define VTG_BOT_V_HD_3		0x0110
> +
> +/* IRQ mask */

These bits are also mirrored in the status register, so "mask" isn't
entirely accurate.

> +#define VTG_IRQ_TOP_FIELD_MASK     (1L << 1)
> +#define VTG_IRQ_BOTTOM_FIELD_MASK  (1L << 0)

I think for these it's safe to leave out the _MASK suffix since they
are really just individual bits in the interrupt registers.

> +#define VTG_IRQ_MASK		   (VTG_IRQ_TOP_FIELD_MASK | \
> +				    VTG_IRQ_BOTTOM_FIELD_MASK)

You should be using tabs and spaces more consistently. The general rule
of thumb is to indent using tabs and use spaces only to pad and align.

> +
> +/* Delay introduced by the AWG in nb of pixels */

What's an AWG?

> +#define AWG_DELAY_HD            (-9)
> +#define AWG_DELAY_ED            (-8)
> +#define AWG_DELAY_SD            (-7)
> +
> +static const struct of_device_id vtg_match_types[];

It's more typical to avoid this kind of forward declaration. Instead you
can move the vtg_match_types table right before the first reference
(i.e. vtg_compositor_probe()). Also _types is an odd suffix. Maybe
vtg_of_match?

> +/*
> + * STI VTG data structure
> + *
> + * @nb_reg: number of memory resources to register
> + * @reg_names: names of the memory resources to register
> + * @regs: ioremapped registers
> + */
> +#define MAX_MEM_REGION 2
> +#define VTG_MASTER  0
> +#define VTG_SLAVE   1
> +struct sti_vtg_data {
> +	int nb_reg;
> +	char *reg_names[MAX_MEM_REGION];
> +	void __iomem *regs[MAX_MEM_REGION];
> +};

The primary reason why I dislike this is that it requires you to clutter
your code with conditionals as to the type of VTG. On the other hand, if
you can expose both master and slave VTGs as separate devices you can
handle them more uniformly.

> +/*
> + * STI VTG structure
> + *
> + * @dev: pointer to device driver
> + * @data: data associated to the device
> + * @irq: VTG irq
> + * @type: VTG type (main or aux)
> + * @notifier_list: notifier callback
> + */
> +struct sti_vtg {
> +	struct device *dev;
> +	struct sti_vtg_data data;
> +	int irq;
> +	int type;
> +	struct raw_notifier_head notifier_list;
> +};
> +
> +/*
> + * STiH416:
> + * --------
> + * VTG slave is connected to the VTG master by the ext0 input (ext1 input is
> + * left unconnected).
> + *
> + *                  MPE               !   !             SAS

What are MPE and SAS?

> + *    ________                        !   !                        ________
> + *   |        |                       !   !                  ext0 |        |
> + *   |        |              _________!   !_________        ----->|        |
> + *   |  VTG   |    hsync    |         !   !         | hsync |     |  VTG   |
> + *   |        |------------>| VTAC Tx !==>! VTAC Rx |--------     |        |
> + *   | master |    vsync    |_________!   !_________| vsync       | slave  |
> + *   |        |                       !   !                  ---->|        |
> + *   |________|                       !   !                  ext1 |________|
> + *                                    !   !                            |
> + *                                    !   !                       synchro_irq
> + * */
> +struct sti_vtg_data stih416_vtg_data = {
> +	.nb_reg = 2,
> +	.reg_names = {"master", "slave"},
> +};

It seems to me like a better representation might be to split this into
two separate devices, one being the master, the other the slave. That
only works if the register spaces are reasonably well separated.

> +/*
> + * STiH407:
> + * --------
> + * Only VTG master is used. There is no MPE and SAS domain => only one domain.
> + *
> + *                  MPE
> + *    ________
> + *   |        |
> + *   |        |
> + *   |  VTG   |    hsync
> + *   |        |------------>
> + *   | master |    vsync
> + *   |        |
> + *   |________|
> + *        |
> + *  synchro_irq
> + * */
> +struct sti_vtg_data stih407_vtg_data = {
> +	.nb_reg = 1,
> +	.reg_names = {"master"},
> +};
> +
> +static int vtg_reset(void __iomem *regs)
> +{
> +	writel(1, regs + VTG_DRST_AUTOC);
> +	return 0;
> +}

This can't fail, so no need to make it return an int. Also I think this
would be more consistent if it took a struct sti_vtg * instead of a
pointer to the registers.

> +static int vtg_reg_dump(struct device *dev, void __iomem *regs)
> +{
> +	dev_dbg(dev, "regs %p\n", regs);
> +	dev_dbg(dev, "VTG_MODE 0x%x\n", readl(regs + VTG_MODE));
> +	dev_dbg(dev, "VTG_CLKLN 0x%x\n", readl(regs + VTG_CLKLN));
> +	dev_dbg(dev, "VTG_HLFLN 0x%x\n", readl(regs + VTG_HLFLN));
> +	dev_dbg(dev, "VTG_VID_TFO 0x%x\n", readl(regs + VTG_VID_TFO));
> +	dev_dbg(dev, "VTG_VID_BFO 0x%x\n", readl(regs + VTG_VID_BFO));
> +	dev_dbg(dev, "VTG_VID_TFS 0x%x\n", readl(regs + VTG_VID_TFS));
> +	dev_dbg(dev, "VTG_VID_BFS 0x%x\n", readl(regs + VTG_VID_BFS));
> +	dev_dbg(dev, "VTG_H_HD_1 0x%x\n", readl(regs + VTG_H_HD_1));
> +	dev_dbg(dev, "VTG_TOP_V_VD_1 0x%x\n", readl(regs + VTG_TOP_V_VD_1));
> +	dev_dbg(dev, "VTG_BOT_V_VD_1 0x%x\n", readl(regs + VTG_BOT_V_VD_1));
> +	dev_dbg(dev, "VTG_TOP_V_HD_1 0x%x\n", readl(regs + VTG_TOP_V_HD_1));
> +	dev_dbg(dev, "VTG_BOT_V_HD_1 0x%x\n", readl(regs + VTG_BOT_V_HD_1));
> +	dev_dbg(dev, "VTG_H_HD_2 0x%x\n", readl(regs + VTG_H_HD_2));
> +	dev_dbg(dev, "VTG_TOP_V_VD_2 0x%x\n", readl(regs + VTG_TOP_V_VD_2));
> +	dev_dbg(dev, "VTG_BOT_V_VD_2 0x%x\n", readl(regs + VTG_BOT_V_VD_2));
> +	dev_dbg(dev, "VTG_TOP_V_HD_2 0x%x\n", readl(regs + VTG_TOP_V_HD_2));
> +	dev_dbg(dev, "VTG_BOT_V_HD_2 0x%x\n", readl(regs + VTG_BOT_V_HD_2));
> +	dev_dbg(dev, "VTG_H_HD_3 0x%x\n", readl(regs + VTG_H_HD_3));
> +	dev_dbg(dev, "VTG_TOP_V_VD_3 0x%x\n", readl(regs + VTG_TOP_V_VD_3));
> +	dev_dbg(dev, "VTG_BOT_V_VD_3 0x%x\n", readl(regs + VTG_BOT_V_VD_3));
> +	dev_dbg(dev, "VTG_TOP_V_HD_3 0x%x\n", readl(regs + VTG_TOP_V_HD_3));
> +	dev_dbg(dev, "VTG_BOT_V_HD_3 0x%x\n", readl(regs + VTG_BOT_V_HD_3));
> +	return 0;
> +}

Maybe this should be exposed via debugfs?

> +static int vtg_write_reg(void __iomem *regs,
> +			 int type, const struct drm_display_mode *mode)

Perhaps this should be called something like vtg_set_mode() since it's
evidently doing a whole lot more than just writing a register. Also it
should take a struct sti_vtg *, in which case you can leave drop the
type parameter as well.

> +{
> +	int fo, fs, h_hd, v_vd, v_hd;

These should be u32. And you can probably get away with just a single
one.

> +
> +	writel(mode->htotal, regs + VTG_CLKLN);
> +	writel(mode->vtotal * 2, regs + VTG_HLFLN);
> +
> +	fo = (mode->vtotal - mode->vsync_start + 1) << 16;
> +	fo |= mode->htotal - mode->hsync_start;
> +	writel(fo, regs + VTG_VID_TFO);
> +	writel(fo, regs + VTG_VID_BFO);
> +
> +	fs = (mode->vdisplay + mode->vtotal - mode->vsync_start + 1) << 16;
> +	fs |= mode->hdisplay + mode->htotal - mode->hsync_start;
> +	writel(fs, regs + VTG_VID_TFS);
> +	writel(fs, regs + VTG_VID_BFS);
> +
> +	/* Prepare VTG set 1 for HDMI and VTG set 3 for HD DAC */
> +	h_hd = (mode->hsync_end - mode->hsync_start) << 16;
> +	writel(h_hd, regs + VTG_H_HD_1);
> +
> +	v_vd = (mode->vsync_end - mode->vsync_start + 1) << 16;
> +	v_vd |= 1;
> +	writel(v_vd, regs + VTG_TOP_V_VD_1);
> +	writel(v_vd, regs + VTG_BOT_V_VD_1);
> +	writel(0, regs + VTG_TOP_V_HD_1);
> +	writel(0, regs + VTG_BOT_V_HD_1);
> +
> +	/* Prepare VTG set 2 for for HD DCS */
> +	writel(h_hd, regs + VTG_H_HD_2);
> +	writel(v_vd, regs + VTG_TOP_V_VD_2);
> +	writel(v_vd, regs + VTG_BOT_V_VD_2);
> +	writel(0, regs + VTG_TOP_V_HD_2);
> +	writel(0, regs + VTG_BOT_V_HD_2);

Does the ordering matter here? Otherwise the writes of the same value
could be moved together and save a register.

> +	/* Prepare VTG set 3 for HD Analog in HD mode */
> +	h_hd = (mode->hsync_end - mode->hsync_start + AWG_DELAY_HD) << 16;
> +	h_hd |= mode->htotal + AWG_DELAY_HD;
> +	writel(h_hd, regs + VTG_H_HD_3);
> +
> +	v_vd = (mode->vsync_end - mode->vsync_start) << 16;
> +	v_vd |= mode->vtotal;
> +	writel(v_vd, regs + VTG_TOP_V_VD_3);
> +	writel(v_vd, regs + VTG_BOT_V_VD_3);
> +
> +	v_hd = (mode->htotal + AWG_DELAY_HD) << 16;
> +	v_hd |= mode->htotal + AWG_DELAY_HD;
> +	writel(v_hd, regs + VTG_TOP_V_HD_3);
> +	writel(v_hd, regs + VTG_BOT_V_HD_3);

It's somewhat odd that many of these TOP/BOT pairs are written with the
same values, but since I have no idea what each of them is supposed to
do I can't really say if that's intentional or might be wrong. I assume
that you've tested this code and therefore it works as expected, but it
is still odd to write the same value into so many different registers.

> +	/* Mode */
> +	writel(type, regs + VTG_MODE);
> +	return 0;
> +}
> +
> +static int vtg_disable_irq(void __iomem *regs)
> +{
> +	/* Clear interrupt status and mask */
> +	writel(0xFFFF, regs + VTG_HOST_ITS_BCLR);
> +	writel(0xFFFF, regs + VTG_HOST_ITM_BCLR);

I think typically "disabling an interrupt" only means clearing (or
setting, depending on the hardware) the mask. If you clear the interrupt
status at the same time you're also dropping any pending interrupts.

Also I think a more common pattern would be to disable interrupts first
to make sure that clearing them won't immediately trigger a new
interrupt.

This should also take a struct sti_vtg * and not return anything since
it will never fail.

> +	return 0;
> +}
> +
> +static int vtg_enable_irq(void __iomem *regs)
> +{
> +	vtg_disable_irq(regs);
> +	writel(VTG_IRQ_MASK, regs + VTG_HOST_ITM_BSET);
> +	return 0;
> +}

I think in this case it would probably be useful to open-code this
rather than reuse vtg_disable_irq(). For instance when interrupts are to
be enabled, why do they need to disable them first? It sounds like if
that's what you really want, then you should do it using something
explicit like this:

	vtg_disable_irq(...);
	vtg_enable_irq(...);

> +int vtg_set_config(struct device *dev, const struct drm_display_mode *mode)
> +{
> +	struct sti_vtg *vtg = dev_get_drvdata(dev);

This seems somewhat brittle. I'd recommend you turn this into something
more robust. Just to illustrate, and I haven't looked at any other
patches yet, so I may be completely wrong here, here's what I'd imagine
the device tree for this to look like:

	/ {
		/* master VTG */
		vtg@00000000 {
			reg = <0x00000000 0x1000>;

			st,slave = <&slave>;
		};

		/* slave VTG */
		slave: vtg@00001000 {
			reg = <0x00001000 0x1000>;
		};

		...
	};

Then the VTG driver could register each of the devices as VTG and the
master could look the slave up using something like:

	struct platform_device *pdev; /* from .probe() */
	struct sti_vtg *vtg; /* allocated earlier */
	struct device_node *np;
	int err;

	np = of_parse_phandle(pdev->dev.of_node, "st,slave", 0);
	if (np) {
		/* VTG is a master, lookup slave */
		vtg->slave = of_vtg_find(np);
		/*
		 * This could be -EPROBE_DEFER if the slave hasn't been
		 * registered yet.
		 */
		if (IS_ERR(vtg->slave))
			return PTR_ERR(vtg->slave);
	} else {
		/* VTG is a slave */
	}

	...

	err = vtg_register(vtg);
	if (err < 0) {
		...
	}

vtg_register() could simply add a VTG into a global list, which
of_vtg_find() could traverse to find a VTG matching the device node
parsed from the phandle.

> +	struct sti_vtg_data *data = &vtg->data;
> +
> +	if (!vtg)
> +		return 1;
> +
> +	if (!data->regs[VTG_MASTER])
> +		return 1;

With the above these additional checks become mostly unnecessary.

> +
> +	/* write slave / master configuration */
> +	if (data->regs[VTG_SLAVE])
> +		vtg_write_reg(data->regs[VTG_SLAVE],
> +			      VTG_TYPE_SLAVE_BY_EXT0, mode);
> +
> +	vtg_write_reg(data->regs[VTG_MASTER], VTG_TYPE_MASTER, mode);

And this would become something like:

	if (vtg->slave)
		vtg_set_mode(vtg->slave, mode);

	vtg_set_mode(vtg, mode);

> +	/* reset slave and then master */
> +	if (data->regs[VTG_SLAVE])
> +		vtg_reset(data->regs[VTG_SLAVE]);
> +
> +	vtg_reset(data->regs[VTG_MASTER]);

	if (vtg->slave)
		vtg_reset(vtg->slave);

	vtg_reset(vtg);

> +	/* Enable irq for the vtg vblank synchro */
> +	if (data->regs[VTG_SLAVE])
> +		vtg_enable_irq(data->regs[VTG_SLAVE]);
> +	else
> +		vtg_enable_irq(data->regs[VTG_MASTER]);

	if (vtg->slave)
		vtg_enable_irq(vtg->slave);
	else
		vtg_enable_irq(vtg);

> +	if (data->regs[VTG_SLAVE])
> +		vtg_reg_dump(dev, data->regs[VTG_SLAVE]);
> +
> +	vtg_reg_dump(dev, data->regs[VTG_MASTER]);

	if (vtg->slave)
		vtg_reg_dump(vtg);

	vtg_reg_dump(vtg);

Of course this in particular wouldn't be present in the final driver but
rather exposed via each VTG's debugfs tree.

> +int vtg_register_client(struct device *dev, struct notifier_block *nb)
> +{
> +	struct sti_vtg *vtg = dev_get_drvdata(dev);
> +	return raw_notifier_chain_register(&vtg->notifier_list, nb);
> +}
> +
> +int vtg_unregister_client(struct device *dev, struct notifier_block *nb)
> +{
> +	struct sti_vtg *vtg = dev_get_drvdata(dev);
> +	return raw_notifier_chain_unregister(&vtg->notifier_list, nb);
> +}

Can you explain what you need the notifier for? I suppose I'll see in
some later patch, but at this rate it'll take me a while to get there.
=) My gut tells me that we won't be needing it though.

> +static irqreturn_t vtg_irq_thread(int irq, void *arg)
> +{
> +	struct sti_vtg *vtg = arg;
> +	struct sti_vtg_data *data = &vtg->data;
> +	void __iomem *regs;
> +	u32 status;
> +
> +	if (data->regs[VTG_SLAVE])
> +		regs = data->regs[VTG_SLAVE];
> +	else
> +		regs = data->regs[VTG_MASTER];
> +
> +	status = readl(regs + VTG_HOST_ITS);
> +
> +	writel(status, regs + VTG_HOST_ITS_BCLR);
> +	/* TODO: check why this sync bus write solves the problem which
> +	 * is that without this line, the handler is sometimes called twice,
> +	 * first with status = 1 or 2, and immediately after with status=0
> +	 */
> +	/* sync bus write */
> +	readl(regs + VTG_HOST_ITS);

I suspect this could be caused by wrongly writing the interrupt mask and
status registers.

> +static int vtg_compositor_bind(struct device *dev, struct device *master,
> +	void *d)
> +{
> +	return 0;
> +}
> +
> +static void vtg_compositor_unbind(struct device *dev, struct device *master,
> +	void *data)
> +{
> +	/* do nothing */
> +}

Why do you even need these if they're no-ops? How are you going to get
at them from other drivers if you don't hook them up with something
here? Perhaps that will be added in some subsequent patch, though.

> +static const struct component_ops vtg_compositor_ops = {
> +	.bind	= vtg_compositor_bind,
> +	.unbind	= vtg_compositor_unbind,
> +};
> +
> +static int vtg_compositor_probe(struct platform_device *pdev)
> +{
> +	struct device *dev = &pdev->dev;
> +	struct device_node *np = dev->of_node;
> +	struct sti_vtg *vtg;
> +	struct resource *res;
> +	char irq_name[32];
> +	struct sti_vtg_data *data;
> +	int i;

This can be unsigned.

> +	int ret;
> +
> +	DRM_INFO("%s\n", __func__);

I don't think DRM_INFO is the loglevel you want here.

> +
> +	if (!np)
> +		return -ENXIO;

If the driver doesn't support non-OF configurations it's safe to assume
that this will never be NULL.

> +
> +	vtg = devm_kzalloc(dev, sizeof(*vtg), GFP_KERNEL);
> +	if (!vtg) {
> +		DRM_ERROR("Failed to allocate VTG context\n");
> +		return -ENOMEM;
> +	}

There's no need for the error message, since allocation failures will
already be noisily reported by the allocator.

> +
> +	vtg->dev = dev;
> +
> +	/* populate data structure depending on compatibility */
> +	BUG_ON(!of_match_node(vtg_match_types, np)->data);

This is kind of pointless since the memcpy() below will oops equally
well if ->data == NULL. I don't think you need to check this at all. If
the device can't be matched in the table this function won't be called.
And if .data has been set for the matching entry in the table this won't
be NULL. Leaving the .data field unset doesn't make any sense for this
driver.

> +
> +	memcpy(&vtg->data, of_match_node(vtg_match_types, np)->data,
> +	       sizeof(struct sti_vtg_data));

Also maybe a good idea would be to store the result of of_match_node()
in a temporary variable to help with readability.

Why copy memory here in the first place? This kind of data is supposed
to be static configuration data, which is why it's typically static
const. I've suggested some changes above to make the design somewhat
more straightforward.

> +
> +	data = &vtg->data;
> +
> +	/* Get resources */
> +	for (i = 0; i < data->nb_reg; i++) {
> +		res = platform_get_resource_byname(pdev, IORESOURCE_MEM,
> +						   data->reg_names[i]);
> +		if (!res) {
> +			DRM_ERROR("Invalid resource\n");
> +			return -ENOMEM;
> +		}
> +		data->regs[i] = devm_ioremap_nocache(dev,
> +						     res->start,
> +						     resource_size(res));

You're supposed to also request regions to make them for exclusive use
by this driver (to avoid other drivers to access the same registers
without proper synchronization).

Also the canonical way to do this is using devm_ioremap_resource().

> +		if (IS_ERR(data->regs[i]))
> +			return PTR_ERR(data->regs[i]);
> +	}
> +
> +	vtg->irq = platform_get_irq_byname(pdev, "synchro_irq");
> +	if (IS_ERR_VALUE(vtg->irq)) {

That's an odd way to write this. if (vtg->irq < 0) should be good
enough.

> +		DRM_ERROR("Failed to get VTG interrupt\n");
> +		return vtg->irq;
> +	}
> +
> +	snprintf(irq_name, sizeof(irq_name), "vsync-%s", vtg_get_name(vtg));

I think it would be just fine to use dev_name(vtg->dev) instead of
generating this name, but meh.

> +	RAW_INIT_NOTIFIER_HEAD(&vtg->notifier_list);
> +
> +	ret = devm_request_threaded_irq(dev, vtg->irq, NULL, vtg_irq_thread,
> +					IRQF_ONESHOT, irq_name, vtg);
> +	if (IS_ERR_VALUE(ret)) {
> +		DRM_ERROR("Failed to register VTG interrupt\n");
> +		return ret;
> +	}
> +
> +	if (of_property_read_bool(np, "vtg-aux")) {
> +		vtg->type = VTG_AUX;
> +		vtg_aux = dev;
> +	} else {
> +		vtg->type = VTG_MAIN;
> +		vtg_main = dev;
> +	}

I wonder if these couldn't be made dyna

> +
> +	platform_set_drvdata(pdev, vtg);
> +
> +	DRM_INFO("%s VTG %s\n", __func__, vtg_get_name(vtg));

This also looks like a leftover debug message.

> +	return component_add(&pdev->dev, &vtg_compositor_ops);
> +}
> +
> +static int vtg_compositor_remove(struct platform_device *pdev)
> +{
> +	component_del(&pdev->dev, &vtg_compositor_ops);
> +	return 0;
> +}
> +
> +static const struct of_device_id vtg_match_types[] = {
> +	{
> +	 .compatible = "st,stih416-vtg",
> +	 .data = &stih416_vtg_data,
> +	 },
> +	{
> +	 .compatible = "st,stih407-vtg",
> +	 .data = &stih407_vtg_data,
> +	 },
> +	{ /* end node */ }

There's some funky indentation here.

> +};
> +MODULE_DEVICE_TABLE(of, vtg_match_types);
> +
> +struct platform_driver sti_vtg_driver = {
> +	.driver = {
> +		   .name = "sti-vtg",
> +		   .owner = THIS_MODULE,
> +		   .of_match_table = vtg_match_types,
> +		   },

Indentation is odd here again.

> +	.probe = vtg_compositor_probe,
> +	.remove = vtg_compositor_remove,
> +};
> +
> +module_platform_driver(sti_vtg_driver);
> diff --git a/drivers/gpu/drm/sti/sti_vtg.h b/drivers/gpu/drm/sti/sti_vtg.h
> new file mode 100644
> index 0000000..da67eb3
> --- /dev/null
> +++ b/drivers/gpu/drm/sti/sti_vtg.h
> @@ -0,0 +1,20 @@
> +/*
> + * Copyright (C) STMicroelectronics SA 2013
> + * Author: Benjamin Gaignard <benjamin.gaignard@st.com> for STMicroelectronics.
> + * License terms:  GNU General Public License (GPL), version 2
> + */
> +
> +#ifndef _STI_VTG_H_
> +#define _STI_VTG_H_
> +
> +#include <linux/platform_device.h>

Why do you need this include? I don't see anything in this file that's
defined in platform_device.h.

> +#include <drm/drmP.h>

You don't actually need to include these here. You can simply forward
declare the structures (which works because you only pass around
pointers to them) like so:

	struct drm_display_mode;
	struct notifier_block;

> +
> +extern struct device *vtg_main;
> +extern struct device *vtg_aux;
> +
> +int vtg_set_config(struct device *dev, const struct drm_display_mode *mode);
> +int vtg_register_client(struct device *dev, struct notifier_block *nb);
> +int vtg_unregister_client(struct device *dev, struct notifier_block *nb);
> +
> +#endif
> diff --git a/drivers/gpu/drm/sti/sti_vtg_utils.c b/drivers/gpu/drm/sti/sti_vtg_utils.c
> new file mode 100644
> index 0000000..06bb4b4
> --- /dev/null
> +++ b/drivers/gpu/drm/sti/sti_vtg_utils.c
> @@ -0,0 +1,99 @@
> +/*
> + * Copyright (C) STMicroelectronics SA 2013
> + * Author: Benjamin Gaignard <benjamin.gaignard@st.com> for STMicroelectronics.
> + * License terms:  GNU General Public License (GPL), version 2
> + */
> +
> +#include <linux/platform_device.h>
> +
> +#include "sti_vtg_utils.h"
> +#include "sti_vtg.h"
> +
> +struct device *vtg_main;
> +struct device *vtg_aux;

I don't think these should be here. There is always a better way than
globals.

> +int sti_vtg_setconfig(int main_aux, const struct drm_display_mode *mode)
> +{
> +	if (main_aux == VTG_MAIN && vtg_main)
> +		return vtg_set_config(vtg_main, mode);
> +
> +	if (main_aux == VTG_AUX && vtg_aux)
> +		return vtg_set_config(vtg_aux, mode);
> +
> +	return 1;
> +}
> +
> +int sti_vtg_register_client(int main_aux, struct notifier_block *nb)
> +{
> +	if (main_aux == VTG_MAIN && vtg_main)
> +		return vtg_register_client(vtg_main, nb);
> +
> +	if (main_aux == VTG_AUX && vtg_aux)
> +		return vtg_register_client(vtg_aux, nb);
> +
> +	return 1;
> +}
> +
> +int sti_vtg_unregister_client(int main_aux, struct notifier_block *nb)
> +{
> +	if (main_aux == VTG_MAIN && vtg_main)
> +		return vtg_unregister_client(vtg_main, nb);
> +
> +	if (main_aux == VTG_AUX && vtg_aux)
> +		return vtg_unregister_client(vtg_aux, nb);
> +
> +	return 1;
> +}
> +
> +/*
> + *       Active        Front        Sync       Back          Active
> + *       Region        Porch                  Porch          Region
> + * <---------------><-------->0<---------><--------><----------------->
> + *
> + *   ///////////////|                               |  ///////////////|
> + *  /////////////// |                               | /////////////// |
> + * ///////////////  |.........            ..........|///////////////  |
> + *                            0___________      x/ymin           x/ymax
> + *
> + * <--[hv]display-->                                 <--[hv]display-->
> + * <--[hv]sync_start--------->                       <--[hv]sync_start-
> + * <--[hv]sync_end----------------------->           <--[hv]sync_end---
> + * <--[hv]total------------------------------------> <--[hv]total------
> + */
> +
> +/*
> + * sti_vtg_get_line_number
> + *
> + * @mode: display mode to be used
> + * @y:    line
> + *
> + * Return the line number according to the display mode taking
> + * into account the Sync and Back Porch information.
> + * Video frame line numbers start at 1, y starts at 0.
> + * In interlaced modes the start line is the field line number of the odd
> + * field, but y is still defined as a progressive frame.
> + */
> +u32 sti_vtg_get_line_number(struct drm_display_mode mode, int y)
> +{
> +	int start_line = mode.vtotal - mode.vsync_start + 1;
> +
> +	if (mode.flags & DRM_MODE_FLAG_INTERLACE)
> +		start_line *= 2;
> +
> +	return start_line + y;
> +}
> +
> +/*
> + * sti_vtg_get_pixel_number
> + *
> + * @mode: display mode to be used
> + * @x:    row
> + *
> + * Return the pixel number according to the display mode taking
> + * into account the Sync and Back Porch information.
> + * Pixels are counted from 0.
> + */
> +u32 sti_vtg_get_pixel_number(struct drm_display_mode mode, int x)
> +{
> +	return mode.htotal - mode.hsync_start + x;
> +}

It's somewhat unclear as to what the purpose is of these. Perhaps it
will become clearer when I see them used in a subsequent patch.

Also it looks like the comments are supposed to be kernel-doc, but they
aren't really.

> diff --git a/drivers/gpu/drm/sti/sti_vtg_utils.h b/drivers/gpu/drm/sti/sti_vtg_utils.h
> new file mode 100644
> index 0000000..fea2852
> --- /dev/null
> +++ b/drivers/gpu/drm/sti/sti_vtg_utils.h
> @@ -0,0 +1,29 @@
> +/*
> + * Copyright (C) STMicroelectronics SA 2013
> + * Authors: Benjamin Gaignard <benjamin.gaignard@st.com>
> + *          Fabien Dessenne <fabien.dessenne@st.com>
> + *          for STMicroelectronics.
> + * License terms:  GNU General Public License (GPL), version 2
> + */
> +
> +#ifndef _STI_VTG_UTILS_H_
> +#define _STI_VTG_UTILS_H_
> +
> +#include <drm/drmP.h>
> +
> +#define WAIT_NEXT_VSYNC_MS      50 /*ms*/

What is this used for?

> +#define VTG_MAIN                0
> +#define VTG_AUX                 1
> +
> +#define VTG_TOP_FIELD_EVENT     1
> +#define VTG_BOTTOM_FIELD_EVENT  2

I would hope that we can get rid of these somehow.

> +int sti_vtg_setconfig(int main_aux, const struct drm_display_mode *mode);
> +int sti_vtg_register_client(int main_aux, struct notifier_block *nb);
> +int sti_vtg_unregister_client(int main_aux, struct notifier_block *nb);

And these.

It's intriguing hardware I must say, and certainly a challenge since
it's so different from other DRM drivers. And it's taken quite some time
to go through this one file, so I won't be able to review all patches in
one go.

Thierry

--B9BE8dkJ1pIKavwa
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJTfLrzAAoJEN0jrNd/PrOheZQP/0bYjkeVFS+Uhien21q+dzUn
miIJuG8+GSvsBOB4kKEm7HtDyiZSz8NHtv/axIOhvYifNcE9pgwbZ4M/m/NrKO69
lu08JgcLS2bgyVLUAI/UV4lFAn3TaAJxdd6Il5Cashi/jydMkn9CsBZyylv5AfWQ
UZ3NimZM5c/mjHnkcqGb6oka5c2j/xMfWpWDS4JwneY3pQCN10Gfgq9DFqYs+T1i
L4mG9Z03PXlm0LDcUMjijsCsLWLP5oZRmRXVpFtjX7neLShwYmfGco8gvE7t2smc
Ps7L+Z0gwaXgFBahM9Yq9q9cn06qiCWXWQEmzhK+utfZYP+DwIuKnxpAwDAM2B/q
MZgSNQWjrj6arOswa6SEjRTurOSQpQBRUisteo3LYvGgIv6LNjaKcneb182Ymj3w
0jYHYCrP66DwWP2WlZzrJXAHkZ/HPBOpP1xmEvsGvbGWNqn2BbXU3yPoG5bKCZW5
1ZGldBSBBHD+0cCwwn2o8Qq0Jy8jU3nEo178RxR5OBkJ34RLChCmrMPk5p79ftwv
g6cltNDOdSHF9QFLgbQUqD4Cl+LVDMTvsKQUm0MOm0OZNsUga8nrS93+R3oFqeKT
HFQRs9TkwiFzW45H2i63AKK1uBIwzujdI3X/j4/xQofTO5UdjvjK4Ocjo3gjy1Qu
ABNPfLAeQabvseGzA3n7
=q9Mr
-----END PGP SIGNATURE-----

--B9BE8dkJ1pIKavwa--
