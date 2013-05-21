Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752748Ab3EUIWa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 May 2013 04:22:30 -0400
Received: from mms3.broadcom.com ([216.31.210.19]:4179 "EHLO mms3.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750712Ab3EUIW1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 May 2013 04:22:27 -0400
X-Server-Uuid: B86B6450-0931-4310-942E-F00ED04CA7AF
Message-ID: <519B2EAD.4000208@broadcom.com>
Date: Tue, 21 May 2013 01:22:05 -0700
From: "Christian Daudt" <csd@broadcom.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130510
 Thunderbird/17.0.6
MIME-Version: 1.0
To: "Arnd Bergmann" <arnd@arndb.de>
cc: "Grant Likely" <grant.likely@secretlab.ca>,
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
Subject: Re: [PATCH V2 1/2] ARM: mmc: bcm281xx SDHCI driver
References: <1368200883-15668-1-git-send-email-csd@broadcom.com>
 <201305170009.46244.arnd@arndb.de>
In-Reply-To: <201305170009.46244.arnd@arndb.de>
X-WSS-ID: 7D85F3382L819670493-01-01
Content-Type: text/plain;
 charset=iso-8859-15;
 format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Arnd,
  Thanks for the review. See below for comments.

On 13-05-16 03:09 PM, Arnd Bergmann wrote:
> On Friday 10 May 2013, Christian Daudt wrote:
>> +
>> +struct sdhci_bcm_kona_cfg {
>> +	unsigned int	max_freq;
>> +	int		is_8bit;
>> +	int		irq;
>> +	int		cd_gpio;
>> +	int		wp_gpio;
>> +	int		non_removable;
>> +};
> I see no use for this structure to be separate: a lot of the fields are
> duplicated in the sdhci_host, or should just get merged into
> sdhci_bcm_kona_dev.
ok. Will do
>> +struct sdhci_bcm_kona_dev {
>> +	struct sdhci_bcm_kona_cfg *cfg;
>> +	struct device *dev;
>> +	struct sdhci_host *host;
>> +	struct clk *peri_clk;
>> +	struct clk *sleep_clk;
>> +};
> The *dev and *host members in this structure are redundant, just
> allocate it together with sdhci_host and use use container_of()
> to get from the sdhci_host back it it.
ok.
>> +static void sdhci_bcm_kona_sd_init(struct sdhci_host *host)
>> +{
>> +	unsigned int val;
>> +
>> +	/* enable the interrupt from the IP core */
>> +	val = sdhci_readl(host, KONA_SDHOST_COREIMR);
>> +	val |= KONA_SDHOST_IP;
>> +	sdhci_writel(host, val, KONA_SDHOST_COREIMR);
>> +
>> +	/* Enable the AHB clock gating module to the host */
>> +	val = sdhci_readl(host, KONA_SDHOST_CORECTRL);
>> +	val |= KONA_SDHOST_EN;
>> +
>> +	/*
>> +	 * Back-to-Back register write needs a delay of 1ms at bootup (min 10uS)
>> +	 * Back-to-Back writes to same register needs delay when SD bus clock
>> +	 * is very low w.r.t AHB clock, mainly during boot-time and during card
>> +	 * insert-removal.
>> +	 */
>> +	mdelay(1);
>> +	sdhci_writel(host, val, KONA_SDHOST_CORECTRL);
>> +}
> Why not use msleep() instead of mdelay() here?
I don't think that there's any reason. will replace.
>
>> +static int sdhci_bcm_kona_sd_card_emulate(struct sdhci_host *host, int insert)
>> +{
>> +	struct sdhci_pltfm_host *pltfm_priv = sdhci_priv(host);
>> +	struct sdhci_bcm_kona_dev *kona_dev = pltfm_priv->priv;
>> +	u32 val;
>> +	unsigned long flags;
>> +
>> +	/* this function can be called from various contexts including ISR */
>> +	spin_lock_irqsave(&host->lock, flags);
>> +	/* Ensure SD bus scanning to detect media change */
>> +	host->mmc->rescan_disable = 0;
>> +
>> +	/*
>> +	 * Back-to-Back register write needs a delay of min 10uS.
>> +	 * Back-to-Back writes to same register needs delay when SD bus clock
>> +	 * is very low w.r.t AHB clock, mainly during boot-time and during card
>> +	 * insert-removal.
>> +	 * We keep 20uS
>> +	 */
>> +	udelay(20);
>> +	val = sdhci_readl(host, KONA_SDHOST_CORESTAT);
> Does the delay have to be done with interrupts disabled? That is not particularly
> nice.
>
> I hope the hardware designers have been appropriately punished for the creating
> such crap.
I had some internal discussions on this one, and the code was originally 
written for non-threaded irqs. Now that it is only called as 
threaded_irq thread_fn, it is safe to replace the spinlock that includes 
the delay with a mutex instead.

>> +static void sdhci_bcm_kona_init_74_clocks(struct sdhci_host *host,
>> +				u8 power_mode)
>> +{
>> +	if (power_mode == MMC_POWER_OFF)
>> +		return;
>> +	else
>> +		mdelay(10);
>> +}
> This requires at the minimum a comment about why the mdelay is needed.
> Maybe we can change the set_ios function so we never need to call it
> in atomic context.
I'll look into this one.
>> +static struct sdhci_bcm_kona_cfg * __init sdhci_bcm_kona_parse_dt(
>> +			struct platform_device *pdev)
>> +{
>> +	struct sdhci_bcm_kona_cfg *cfg;
>> +	struct device_node *np = pdev->dev.of_node;
>> +	u32 temp;
> fold this function into probe()
ok.
>> +	if (!np)
>> +		return NULL;
> impossible
ok
>> +	cfg = devm_kzalloc(&pdev->dev, sizeof(*cfg), GFP_KERNEL);
>> +	if (!cfg) {
>> +		dev_err(&pdev->dev, "Can't allocate platform cfg\n");
>> +		return NULL;
>> +	}
> Not needed
what is not needed ?
>> +static int __init sdhci_bcm_kona_probe(struct platform_device *pdev)
>> +{
>> +	const struct of_device_id *match;
> constant, so not needed.
I'll remove it.
>> +	struct sdhci_bcm_kona_cfg *kona_cfg = NULL;
> No need to initialize this.
ok
>> +	const struct sdhci_pltfm_data *plat_data;
> make it global.
why make this global ?
>
>> +	struct sdhci_bcm_kona_dev *kona_dev = NULL;
> No need to initialize this.
ok.
>> +	kona_dev = devm_kzalloc(dev, sizeof(*kona_dev), GFP_KERNEL);
>> +	if (!kona_dev) {
>> +		dev_err(dev, "Can't allocate kona_dev\n");
>> +		ret = -ENOMEM;
>> +		goto err_pltfm_free;
>> +	}
> It is rather silly to have the base sdhci code allocate extra
> memory for the platform drivers but then require an extra allocation.
> Better change the sdhci_pltfm_init function to let you pass the extra
> allocation size.
ok, I'll look into this.
>> +MODULE_AUTHOR("Broadcom");
> No person?
>
A collective effort :)


  Thanks,
    csd


