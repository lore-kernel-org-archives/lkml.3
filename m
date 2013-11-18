Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751562Ab3KRMI4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Nov 2013 07:08:56 -0500
Received: from mga03.intel.com ([143.182.124.21]:21327 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751057Ab3KRMIs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Nov 2013 07:08:48 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.93,723,1378882800"; 
   d="scan'208";a="429557974"
From: "Shevchenko, Andriy" <andriy.shevchenko@intel.com>
To: Florian Meier <florian.meier@koalo.de>
CC: Liam Girdwood <lgirdwood@gmail.com>, Mark Brown <broonie@kernel.org>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Lars-Peter Clausen <lars@metafoo.de>,
        "alsa-devel@alsa-project.org" <alsa-devel@alsa-project.org>,
        linux-rpi-kernel <linux-rpi-kernel@lists.infradead.org>,
        devicetree <devicetree@vger.kernel.org>,
        dmaengine <dmaengine@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCHv3] ASoC: Add support for BCM2835
Thread-Topic: [PATCHv3] ASoC: Add support for BCM2835
Thread-Index: AQHO5FbgOGake2IIQEGiv7ZL6GqSeQ==
Date: Mon, 18 Nov 2013 12:08:22 +0000
Message-ID: <1384776479.14845.208.camel@smile>
References: <5289F9DF.8060406@koalo.de>
In-Reply-To: <5289F9DF.8060406@koalo.de>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.237.72.173]
Content-Type: text/plain; charset="utf-8"
Content-ID: <6DB828C271FD3848B21FBB4ED8069004@intel.com>
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id rAIC96Yv026932

On Mon, 2013-11-18 at 12:28 +0100, Florian Meier wrote:
> This driver adds support for digital audio (I2S)
> for the BCM2835 SoC that is used by the
> Raspberry Pi. External audio codecs can be
> connected to the Raspberry Pi via P5 header.
> 
> It relies on cyclic DMA engine support for BCM2835.

Few comments below.

[]

> +static void bcm2835_i2s_stop_clock(struct bcm2835_i2s_dev *dev)
> +{
> +	uint32_t clkreg;
> +	int timeout = 1000;
> +
> +	/* Stop clock */
> +	regmap_update_bits(dev->clk_regmap, BCM2835_CLK_PCMCTL_REG,
> +			BCM2835_CLK_PASSWD_MASK | BCM2835_CLK_ENAB,
> +			BCM2835_CLK_PASSWD);
> +
> +	/* Wait for the BUSY flag going down */
> +	while (timeout > 0) {
> +		timeout--;

while (--timeout) {

> +
> +		regmap_read(dev->clk_regmap, BCM2835_CLK_PCMCTL_REG, &clkreg);
> +		if (!(clkreg & BCM2835_CLK_BUSY))
> +			break;
> +	}
> +
> +	if (timeout <= 0) {

if (!timeout) {

[]

> +static void bcm2835_i2s_clear_fifos(struct bcm2835_i2s_dev *dev,
> +				    bool tx, bool rx)
> +{

[]

> +	/* Wait for the SYNC flag changing it's state */
> +	while (timeout > 0) {
> +		timeout--;

while (--timeout) {

> +		regmap_read(dev->i2s_regmap, BCM2835_I2S_CS_A_REG, &csreg);
> +		if ((csreg & BCM2835_I2S_SYNC) != syncval)
> +			break;
> +	}
> +
> +	if (timeout <= 0)

if (!timeout)

[]

> +static int bcm2835_i2s_hw_params(struct snd_pcm_substream *substream,
> +				 struct snd_pcm_hw_params *params,
> +				 struct snd_soc_dai *dai)
> +{
> +	struct bcm2835_i2s_dev *dev = snd_soc_dai_get_drvdata(dai);
> +
> +	unsigned int sampling_rate = params_rate(params);
> +	unsigned int data_length, data_delay, bclk_ratio;
> +	unsigned int ch1pos, ch2pos, mode, format;
> +	unsigned int mash = BCM2835_CLK_MASH_1;
> +	unsigned int divi, divf, target_frequency;
> +	int clk_src = -1;
> +	unsigned int master = dev->fmt & SND_SOC_DAIFMT_MASTER_MASK;
> +	uint32_t bit_master =	(master == SND_SOC_DAIFMT_CBS_CFS
> +					|| master == SND_SOC_DAIFMT_CBS_CFM);

bool ?

> +
> +	uint32_t frame_master =	(master == SND_SOC_DAIFMT_CBS_CFS

So, if master == SND_SOC_DAIFMT_CBS_CFS both bit_master and frame_master
will be true. Is it correct?

> +					|| master == SND_SOC_DAIFMT_CBM_CFS);

Ditto.

> +	uint32_t csreg;
> +
> +	/*
> +	 * If a stream is already enabled,
> +	 * the registers are already set properly.
> +	 */
> +	regmap_read(dev->i2s_regmap, BCM2835_I2S_CS_A_REG, &csreg);
> +
> +	if (csreg & (BCM2835_I2S_TXON | BCM2835_I2S_RXON))
> +		return 0;
> +

> +	if (bcm2835_clk_freq[clk_src] % target_frequency == 0
> +			&& bit_master && frame_master) {
> +		divi = bcm2835_clk_freq[clk_src]/target_frequency;
> +		divf = 0;
> +	} else {
> +		uint64_t dividend;
> +
> +		if (!dev->bclk_ratio) {
> +			/*
> +			 * Overwrite bclk_ratio, because the
> +			 * above trick is not needed or can
> +			 * not be used.
> +			 */
> +			bclk_ratio = 2*data_length;

= 2 * data_length;

> +		}
> +
> +		target_frequency = sampling_rate*bclk_ratio;
> +
> +		clk_src = BCM2835_CLK_SRC_PLLD;
> +		mash = BCM2835_CLK_MASH_1;
> +
> +		dividend = bcm2835_clk_freq[clk_src];
> +		dividend *= 1024;
> +		do_div(dividend, target_frequency);
> +		divi = dividend / 1024;
> +		divf = dividend % 1024;

1024 is a magic number?
Could you use shifts and bitwise ANDs here?

> +	ch1pos = data_delay;
> +	ch2pos = bclk_ratio/2+data_delay;

' / 2 + '

[]

> +	mode |= BCM2835_I2S_FLEN(bclk_ratio-1);
> +	mode |= BCM2835_I2S_FSLEN(bclk_ratio/2);

Ditto. Spaces are missed.

[]

> +	case SND_SOC_DAIFMT_IB_IF:
> +		/* Both - therefore, none for BCM*/

'M */'

> +		break;
> +	case SND_SOC_DAIFMT_NB_IF:
> +		/*
> +		 * Invert only frame sync - therefore,
> +		 * Invert only bit clock for BCM

Something wrong with casing in the commentary.

> +		 */
> +		mode |= BCM2835_I2S_CLKI;
> +		break;
> +	case SND_SOC_DAIFMT_IB_NF:
> +		/*
> +		 * Invert only bit clock - therefore,
> +		 * Invert only frame sync for BCM

Ditto.

> +		 */
> +		mode |= BCM2835_I2S_FSI;
> +		break;
> +	default:
> +		return -EINVAL;
> +	}
> +
> +	regmap_write(dev->i2s_regmap, BCM2835_I2S_MODE_A_REG, mode);
> +
> +

Redundant empty line.

[]

> +
> +	return 0;
> +}
> +
> +

Ditto.

[]

> +static int bcm2835_i2s_startup(struct snd_pcm_substream *substream,
> +			       struct snd_soc_dai *dai)
> +{
> +	struct bcm2835_i2s_dev *dev = snd_soc_dai_get_drvdata(dai);
> +
> +	if (!dai->active) {
> +		/* Should this still be running stop it */
> +		bcm2835_i2s_stop_clock(dev);
> +
> +		/* Enable PCM block */
> +		regmap_update_bits(dev->i2s_regmap, BCM2835_I2S_CS_A_REG,
> +				BCM2835_I2S_EN, BCM2835_I2S_EN);
> +
> +		/*
> +		 * Disable STBY

Dot is missing?

> +		 * Requires at least 4 PCM clock cycles to take effect
> +		 */
> +		regmap_update_bits(dev->i2s_regmap, BCM2835_I2S_CS_A_REG,
> +				BCM2835_I2S_STBY, BCM2835_I2S_STBY);
> +	}
> +
> +	return 0;
> +}



> +static void bcm2835_i2s_shutdown(struct snd_pcm_substream *substream,
> +		struct snd_soc_dai *dai)
> +{
> +	struct bcm2835_i2s_dev *dev = snd_soc_dai_get_drvdata(dai);
> +
> +	bcm2835_i2s_stop(dev, substream, dai);
> +
> +	/* If both streams are stopped, disable module and clock */
> +	if (!dai->active) {

if (dai->active)
 return;

> +		/* Disable the module */
> +		regmap_update_bits(dev->i2s_regmap, BCM2835_I2S_CS_A_REG,
> +				BCM2835_I2S_EN, 0);
> +
> +		/*
> +		 * Stopping clock is necessary, because stop does
> +		 * not stop the clock when SND_SOC_DAIFMT_CONT
> +		 */
> +		bcm2835_i2s_stop_clock(dev);
> +	}
> +}
> +

[]

> +static int bcm2835_i2s_probe(struct platform_device *pdev)
> +{
> +	struct bcm2835_i2s_dev *dev;
> +	int i;
> +	int ret;
> +	struct regmap *regmap[2];
> +	struct resource *mem[2];
> +
> +	/* Request both ioareas */
> +	for (i = 0; i <= 1; i++) {
> +		void __iomem *base;
> +
> +		mem[i] = platform_get_resource(pdev, IORESOURCE_MEM, i);

> +		if (!mem[i]) {
> +			dev_err(&pdev->dev, "I2S probe: Memory resource could not be found.\n");
> +			return -ENODEV;
> +		}

Unneeded messaging and check.

> +
> +		base = devm_ioremap_resource(&pdev->dev, mem[i]);
> +		if (!base) {

It returns ERR_PTR.
Thus,

if (IS_ERR(base)
return PTR_ERR(base)


> +			dev_err(&pdev->dev, "I2S probe: ioremap failed.\n");

Unneeded messaging.

> +			return -ENOMEM;

Wrong error code. See above.


-- 
Andy Shevchenko <andriy.shevchenko@intel.com>
Intel Finland Oy
---------------------------------------------------------------------
Intel Finland Oy
Registered Address: PL 281, 00181 Helsinki 
Business Identity Code: 0357606 - 4 
Domiciled in Helsinki 

This e-mail and any attachments may contain confidential material for
the sole use of the intended recipient(s). Any review or distribution
by others is strictly prohibited. If you are not the intended
recipient, please contact the sender and delete all copies.
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
