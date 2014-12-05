Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751453AbaLEKeM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Dec 2014 05:34:12 -0500
Received: from mout.kundenserver.de ([212.227.126.131]:57317 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750924AbaLEKeK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Dec 2014 05:34:10 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: linux-arm-kernel@lists.infradead.org
Cc: vishnupatekar <vishnupatekar0510@gmail.com>,
        maxime.ripard@free-electrons.com, linux-sunxi@googlegroups.com,
        devicetree@vger.kernel.org, dmitry.torokhov@gmail.com,
        benh@kernel.crashing.org, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org, ralf@linux-mips.org, robh+dt@kernel.org,
        msalter@redhat.com, vishnupatekar <VishnuPatekar0510@gmail.com>,
        jdelvare@suse.de
Subject: Re: [PATCH 2/3] drivers:input:ps2 Added sunxi A20 ps2 driver, changed makefile and Kconfig
Date: Fri, 05 Dec 2014 11:33:11 +0100
Message-ID: <12237550.afophX20rO@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.16.0-10-generic; KDE/4.11.5; x86_64; ; )
In-Reply-To: <1417647224-27950-1-git-send-email-VishnuPatekar0510@gmail.com>
References: <1417647224-27950-1-git-send-email-VishnuPatekar0510@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V03:K0:oAji2892+rNnFiG9YIn7YdqO/WqW52wLs7HkyxTpEIUYY8fF7qo
 XPvVL/wz3yDCPKE6TAw8rRd1itNOM8c8Al7Qckl3CeiTteq2G/hkJ0mBdy9BQPihgMrPnSm
 3fcvd1+6xILEyNfH3Kn2H/dKdmeTXMv/K7BSSa95P009I/YCNsZwxH1qr7zgdzAg9qZwUg+
 9Kq0aWFzAS5xwO6l8VCFw==
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 04 December 2014 04:23:44 vishnupatekar wrote:
> +
> +#define DRIVER_NAME		"sunxi-ps2"
> +
> +#define RESSIZE(res)        (((res)->end - (res)->start)+1)

Remove this and use the existing resource_size() function

> +
> +struct sunxips2data {
> +	int irq;
> +	spinlock_t ps2_lock;
> +	void __iomem *base_address;	/* virt address of control registers*/
> +	struct serio *serio;		/* serio*/
> +	struct device *dev;
> +	struct	clk	*pclk;
> +};

As this is dynamically allocated, better embed the serio member
directly to avoid allocating both separately.

> +static int sunxips2_open(struct serio *pserio)
> +{
> +	struct sunxips2data *drvdata = pserio->port_data;
> +	u32 src_clk = 0;
> +	u32 clk_scdf;
> +	u32 clk_pcdf;
> +	u32 rval;
> +
> +	/*Set Line Control And Enable Interrupt*/
> +	rval = SWPS2_LCTL_TXDTOEN|SWPS2_LCTL_STOPERREN|SWPS2_LCTL_ACKERREN|SWPS2_LCTL_PARERREN|SWPS2_LCTL_RXDTOEN;
> +	writel(rval, drvdata->base_address + SW_PS2_LCTRL);
> +
> +	/*Reset FIFO*/
> +	writel(0x3<<16 | 0x607, drvdata->base_address + SW_PS2_FCTRL);
> +
> +	src_clk = clk_get_rate(drvdata->pclk);
> +
> +	if (!src_clk) {
> +		dev_info(drvdata->dev, "w_ps2c_set_sclk error, source clock is 0.");
> +		return -1;
> +	}
> +
> +	/*Set Clock Divider Register*/
> +	clk_scdf = ((src_clk + (SW_PS2_SAMPLE_CLK>>1)) / SW_PS2_SAMPLE_CLK - 1);
> +	clk_pcdf = ((SW_PS2_SAMPLE_CLK + (SW_PS2_SCLK>>1)) / SW_PS2_SCLK - 1);
> +	rval = (clk_scdf<<8) | clk_pcdf;/* | (PS2_DEBUG_SEL<<16);*/
> +	writel(rval, drvdata->base_address + SW_PS2_CLKDR);
> +
> +	/*Set Global Control Register*/
> +	rval = SWPS2_RESET|SWPS2_INTEN|SWPS2_MASTER|SWPS2_BUSEN;
> +	writel(rval, drvdata->base_address + SW_PS2_GCTRL);
> +
> +	udelay(100);

100 microseconds is a rather long time to block the CPU for, so this
needs a comment explaining why the particular delay is needed and why
you can't use usleep_range() instead.

> +static void sunxips2_close(struct serio *pserio)
> +{
> +       struct sunxips2data *drvdata = pserio->port_data;
> +
> +       spin_lock(&drvdata->ps2_lock);
> +       /* Disable the PS2 interrupts */
> +       writel(0, drvdata->base_address + SW_PS2_GCTRL);
> +       spin_unlock(&drvdata->ps2_lock);
> +}

The locking is wrong here: you take the lock without disabling the
interrupts first, so if the interrupt happens between the spin_lock()
call and the writel(), the kernel will deadlock.

You will either have to use spin_lock_irq() here, or find a justification
for dropping the lock entirely.

> +static int sunxips2_write(struct serio *pserio, unsigned char val)
> +{
> +	struct sunxips2data *drvdata = (struct sunxips2data *)pserio->port_data;
> +	u32 timeout = 10000;
> +
> +	do {
> +		if (readl(drvdata->base_address + SW_PS2_FSTAT) & SWPS2_FSTA_TXRDY) {
> +			writel(val, drvdata->base_address + SW_PS2_DATA);
> +			return 0;
> +		}
> +	} while (timeout--);
> +
> +	return -1;
> +}

We never return '-1' from in-kernel functions. Either make this a bool
argument, or return a proper errno.h value. This should probably return
-EIO.

> +	drvdata->irq = irq;
> +	drvdata->serio = serio;
> +	drvdata->dev = dev;
> +	error = devm_request_any_context_irq(drvdata->dev, drvdata->irq, &sunxips2_interrupt, 0,
> +				DRIVER_NAME, drvdata);
> +	if (error) {
> +		dev_err(drvdata->dev,
> +			"Couldn't allocate interrupt %d : error: %d\n", drvdata->irq, error);
> +		return error;
> +	}
> +	return 0;		/* success */
> +}

Why any_context?

	Arnd
