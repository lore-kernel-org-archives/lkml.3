Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755732Ab3AWMj5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jan 2013 07:39:57 -0500
Received: from devils.ext.ti.com ([198.47.26.153]:46064 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755387Ab3AWMjz convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jan 2013 07:39:55 -0500
From: "Hebbar, Gururaja" <gururaja.hebbar@ti.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
CC: "alsa-devel@alsa-project.org" <alsa-devel@alsa-project.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "tony@atomide.com" <tony@atomide.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>,
        "Nori, Sekhar" <nsekhar@ti.com>,
        "davinci-linux-open-source@linux.davincidsp.com" 
	<davinci-linux-open-source@linux.davincidsp.com>,
        "rob@landley.net" <rob@landley.net>, "Girdwood, Liam" <lrg@ti.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: RE: [alsa-devel] [PATCH V2 2/2] ASoC: Davinci: machine: Add device
	tree binding
Thread-Topic: [alsa-devel] [PATCH V2 2/2] ASoC: Davinci: machine: Add device
	tree binding
Thread-Index: AQHN6nbFhDtsROOE2kyj5Apy+7pkh5hW9vGw
Date: Wed, 23 Jan 2013 12:39:35 +0000
Message-ID: <1BAFE6F6C881BF42822005164F1491C33EB50DCF@DBDE01.ent.ti.com>
References: <1357293277-25543-1-git-send-email-gururaja.hebbar@ti.com>
 <1357293277-25543-3-git-send-email-gururaja.hebbar@ti.com>
 <20130104122612.GM4627@opensource.wolfsonmicro.com>
In-Reply-To: <20130104122612.GM4627@opensource.wolfsonmicro.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.24.170.142]
Content-Type: text/plain; charset="Windows-1252"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 04, 2013 at 17:56:12, Mark Brown wrote:
> On Fri, Jan 04, 2013 at 03:24:37PM +0530, Hebbar Gururaja wrote:
> 
> > +		"MIC3L",                "Mic Bias 2V",
> > +		"MIC3R",                "Mic Bias 2V",
> > +		"Mic Bias 2V",          "Mic Jack",
> 
> The CODEC driver biases should be changed over to be supplies, this
> makes the above much more natural - the routing there is a hack for
> older versions of ASoc.  Otherwise this looks fine.


ON TLV320AIC3x Codec, MIC Bias power on/off share the same register bits
with Bias voltage output.

Page 0 / Register 25: MICBIAS Control Register

BIT	READ/WRITE	RESET VALUE	DESCRIPTION
D7–D6	R/W 			00 	MICBIAS Level Control
					00: MICBIAS output is powered down
					01: MICBIAS output is powered to 2.0V
					10: MICBIAS output is powered to 2.5V
					11: MICBIAS output is connected to AVDD


Because of this, I find it difficult to use SND_SOC_DAPM_SUPPLY macro.

I found a similar implementation (MIC BIAS enable + Bias voltage selection)
in 2 other platform (WM8900 & SGTL5000).

WM8900 --> Different registers for MIC BIAS enable & Bias voltage selection.
However both are implemented using different macros

static const char *mic_bias_level_txt[] = { "0.9*AVDD", "0.65*AVDD" };

static const struct soc_enum mic_bias_level =
SOC_ENUM_SINGLE(WM8900_REG_INCTL, 8, 2, mic_bias_level_txt);

...
static const struct snd_kcontrol_new wm8900_snd_controls[] = {
SOC_ENUM("Mic Bias Level", mic_bias_level),
...

SND_SOC_DAPM_SUPPLY("Mic Bias", WM8900_REG_POWER1, 4, 0, NULL, 0),



SGTL5000 --> Single register for MIC BIAS enable & output impedance of MIC
Bias. The driver uses SND_SOC_DAPM_POST_PMU & SND_SOC_DAPM_PRE_PMD macro to
handle the MIC Bias enable & disable event.


static int mic_bias_event(struct snd_soc_dapm_widget *w,
        struct snd_kcontrol *kcontrol, int event)
{
        switch (event) {
        case SND_SOC_DAPM_POST_PMU:
	...

static const struct snd_soc_dapm_widget sgtl5000_dapm_widgets[] = {
	...
        SND_SOC_DAPM_SUPPLY("Mic Bias", SGTL5000_CHIP_MIC_CTRL, 8, 0,
                            mic_bias_event,
                            SND_SOC_DAPM_POST_PMU | SND_SOC_DAPM_PRE_PMD),


Since TLV320AIC3x Codec uses single register bit-set to indicate BIA state
& Voltage level, I am not able to able to change existing code to
SND_SOC_DAPM_SUPPLY macro.


Could you please show some pointers on how to handle/implement
SND_SOC_DAPM_SUPPLY in above scenario?


Thanks & Regards, 
Gururaja
