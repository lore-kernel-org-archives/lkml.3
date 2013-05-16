Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754716Ab3EPWKQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 May 2013 18:10:16 -0400
Received: from moutng.kundenserver.de ([212.227.126.186]:49895 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752097Ab3EPWKO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 May 2013 18:10:14 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: "Christian Daudt" <csd@broadcom.com>
Subject: Re: [PATCH V2 1/2] ARM: mmc: bcm281xx SDHCI driver
Date: Fri, 17 May 2013 00:09:46 +0200
User-Agent: KMail/1.12.2 (Linux/3.8.0-18-generic; KDE/4.3.2; x86_64; ; )
Cc: "Grant Likely" <grant.likely@secretlab.ca>,
        "Rob Herring" <rob.herring@calxeda.com>,
        "Rob Landley" <rob@landley.net>,
        "Russell King" <linux@arm.linux.org.uk>, "Chris Ball" <cjb@laptop.org>,
        "Stephen Warren" <swarren@nvidia.com>,
        "Olof Johansson" <olof@lixom.net>,
        "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>,
        "Wei WANG" <wei_wang@realsil.com.cn>,
        "Ludovic Desroches" <ludovic.desroches@atmel.com>,
        devicetree-discuss@lists.ozlabs.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-mmc@vger.kernel.org, csd_b@daudt.org
References: <1368200883-15668-1-git-send-email-csd@broadcom.com>
In-Reply-To: <1368200883-15668-1-git-send-email-csd@broadcom.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201305170009.46244.arnd@arndb.de>
X-Provags-ID: V02:K0:I2X/xRQH+A6JHNyCR3+FQZ7NWhYjU1QMwOsRltq1y1s
 mg8d2V6oo/uQwfkDwPZgBXLRXeRGxejKx6pYcDP2TvYCGBPveS
 a/b2dMFzRwbR2nIwr8EZaWfIQc5n5t/ODoYS2AEzVRg7TEAmyr
 m4s20KDmRBHZ/moIyjoLLnIg6j7rgiElWhJ41L31dTKjtAd0iH
 mMLPNp9Ddt4v5QzCLfH5YmKmuggAjqqXWTjEAG0exBfwMPsdgg
 a9PWLMOtFOPTP4PdLczibnvEDON4Qq2Mlzi+SHDGde7KrWNX2x
 2nYCMu9St9r5XSINTIAmOm7DJiaEb1u1x9E8HdVU9d+mWPjcPM
 823xEAIlX2ys2iD8uY04=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 10 May 2013, Christian Daudt wrote:
> +
> +struct sdhci_bcm_kona_cfg {
> +	unsigned int	max_freq;
> +	int		is_8bit;
> +	int		irq;
> +	int		cd_gpio;
> +	int		wp_gpio;
> +	int		non_removable;
> +};

I see no use for this structure to be separate: a lot of the fields are
duplicated in the sdhci_host, or should just get merged into
sdhci_bcm_kona_dev.

> +struct sdhci_bcm_kona_dev {
> +	struct sdhci_bcm_kona_cfg *cfg;
> +	struct device *dev;
> +	struct sdhci_host *host;
> +	struct clk *peri_clk;
> +	struct clk *sleep_clk;
> +};

The *dev and *host members in this structure are redundant, just
allocate it together with sdhci_host and use use container_of()
to get from the sdhci_host back it it.

> +static void sdhci_bcm_kona_sd_init(struct sdhci_host *host)
> +{
> +	unsigned int val;
> +
> +	/* enable the interrupt from the IP core */
> +	val = sdhci_readl(host, KONA_SDHOST_COREIMR);
> +	val |= KONA_SDHOST_IP;
> +	sdhci_writel(host, val, KONA_SDHOST_COREIMR);
> +
> +	/* Enable the AHB clock gating module to the host */
> +	val = sdhci_readl(host, KONA_SDHOST_CORECTRL);
> +	val |= KONA_SDHOST_EN;
> +
> +	/*
> +	 * Back-to-Back register write needs a delay of 1ms at bootup (min 10uS)
> +	 * Back-to-Back writes to same register needs delay when SD bus clock
> +	 * is very low w.r.t AHB clock, mainly during boot-time and during card
> +	 * insert-removal.
> +	 */
> +	mdelay(1);
> +	sdhci_writel(host, val, KONA_SDHOST_CORECTRL);
> +}

Why not use msleep() instead of mdelay() here?

> +static int sdhci_bcm_kona_sd_card_emulate(struct sdhci_host *host, int insert)
> +{
> +	struct sdhci_pltfm_host *pltfm_priv = sdhci_priv(host);
> +	struct sdhci_bcm_kona_dev *kona_dev = pltfm_priv->priv;
> +	u32 val;
> +	unsigned long flags;
> +
> +	/* this function can be called from various contexts including ISR */
> +	spin_lock_irqsave(&host->lock, flags);
> +	/* Ensure SD bus scanning to detect media change */
> +	host->mmc->rescan_disable = 0;
> +
> +	/*
> +	 * Back-to-Back register write needs a delay of min 10uS.
> +	 * Back-to-Back writes to same register needs delay when SD bus clock
> +	 * is very low w.r.t AHB clock, mainly during boot-time and during card
> +	 * insert-removal.
> +	 * We keep 20uS
> +	 */
> +	udelay(20);
> +	val = sdhci_readl(host, KONA_SDHOST_CORESTAT);

Does the delay have to be done with interrupts disabled? That is not particularly
nice.

I hope the hardware designers have been appropriately punished for the creating
such crap.
> +static void sdhci_bcm_kona_init_74_clocks(struct sdhci_host *host,
> +				u8 power_mode)
> +{
> +	if (power_mode == MMC_POWER_OFF)
> +		return;
> +	else
> +		mdelay(10);
> +}

This requires at the minimum a comment about why the mdelay is needed.
Maybe we can change the set_ios function so we never need to call it
in atomic context.

> +static struct sdhci_bcm_kona_cfg * __init sdhci_bcm_kona_parse_dt(
> +			struct platform_device *pdev)
> +{
> +	struct sdhci_bcm_kona_cfg *cfg;
> +	struct device_node *np = pdev->dev.of_node;
> +	u32 temp;

fold this function into probe()

> +	if (!np)
> +		return NULL;

impossible

> +	cfg = devm_kzalloc(&pdev->dev, sizeof(*cfg), GFP_KERNEL);
> +	if (!cfg) {
> +		dev_err(&pdev->dev, "Can't allocate platform cfg\n");
> +		return NULL;
> +	}

Not needed

> +static int __init sdhci_bcm_kona_probe(struct platform_device *pdev)
> +{
> +	const struct of_device_id *match;

constant, so not needed.

> +	struct sdhci_bcm_kona_cfg *kona_cfg = NULL;

No need to initialize this.

> +	const struct sdhci_pltfm_data *plat_data;

make it global.

> +	struct sdhci_bcm_kona_dev *kona_dev = NULL;

No need to initialize this.

> +	kona_dev = devm_kzalloc(dev, sizeof(*kona_dev), GFP_KERNEL);
> +	if (!kona_dev) {
> +		dev_err(dev, "Can't allocate kona_dev\n");
> +		ret = -ENOMEM;
> +		goto err_pltfm_free;
> +	}

It is rather silly to have the base sdhci code allocate extra
memory for the platform drivers but then require an extra allocation.
Better change the sdhci_pltfm_init function to let you pass the extra
allocation size.

> +MODULE_AUTHOR("Broadcom");

No person?

	Arnd
