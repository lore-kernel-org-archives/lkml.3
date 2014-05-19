Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753399AbaESIWI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 May 2014 04:22:08 -0400
Received: from [207.46.163.190] ([207.46.163.190]:57121 "EHLO
	na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-FAIL-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752757AbaESIWG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 May 2014 04:22:06 -0400
Message-ID: <5379BC4A.6080908@freescale.com>
Date: Mon, 19 May 2014 16:09:46 +0800
From: Liu Ying <Ying.Liu@freescale.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: Sascha Hauer <s.hauer@pengutronix.de>
CC: <linux-pwm@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <thierry.reding@gmail.com>, <shawn.guo@freescale.com>,
        <LW@KARO-electronics.de>, <linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH v3] pwm: i.MX: Avoid sample FIFO overflow for i.MX PWM
 version2
References: <1400217068-22642-1-git-send-email-Ying.Liu@freescale.com>
 <20140519071105.GZ5858@pengutronix.de>
In-Reply-To: <20140519071105.GZ5858@pengutronix.de>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:192.88.158.2;CTRY:US;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(6009001)(479174003)(377454003)(51704005)(24454002)(199002)(189002)(102836001)(6806004)(68736004)(64706001)(69596002)(47776003)(76176999)(46102001)(50466002)(83072002)(76482001)(87266999)(4396001)(81342001)(81156002)(20776003)(85852003)(99396002)(23756003)(77096999)(36756003)(87936001)(92726001)(50986999)(64126003)(54356999)(65816999)(81542001)(33656001)(84676001)(86362001)(92566001)(83506001)(74662001)(83322001)(21056001)(65956001)(80022001)(79102001)(77982001)(31966008)(44976005)(74502001)(59896001)(80316001);DIR:OUT;SFP:;SCL:1;SRVR:BY2PR03MB348;H:az84smr01.freescale.net;FPR:;MLV:sfv;PTR:InfoDomainNonexistent;A:1;MX:1;LANG:en;
X-Forefront-PRVS: 021670B4D2
Authentication-Results: spf=fail (sender IP is 192.88.158.2)
 smtp.mailfrom=Ying.Liu@freescale.com; 
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Sascha,

Thanks for your comments.

On 05/19/2014 03:11 PM, Sascha Hauer wrote:
> On Fri, May 16, 2014 at 01:11:08PM +0800, Liu Ying wrote:
>> The i.MX PWM version2 is embedded in several i.MX SoCs,
>> such as i.MX27, i.MX51 and i.MX6SL.  There are four 16bit
>> sample FIFOs in this IP, each of which determines the duty
>> period of a PWM waveform in one full cycle.  The IP spec
>> mentions that we should not write a fourth sample because
>> the FIFOs will become full and trigger a FIFO write error
>> (FWE) which will prevent the PWM from starting once it is
>> enabled.  In order to avoid any sample FIFO overflow issue,
>> this patch clears all sample FIFOs or waits for a rollover
>> event to consume a FIFO slot when necessary.  In this way,
>> only the first FIFO slot will be loaded at most.
>>
>> Note that the PWM controller will not generate any rollover
>> event if the duty period is zero.  This makes the logic a
>> bit complicated to determine if we clear the sample FIFOs
>> or wait for a rollover event.
>>
>> The FIFO overflow issue can be reproduced by the following
>> commands on the i.MX6SL EVK platform, assuming we use PWM2
>> for the debug LED which is driven by the pin HSIC_STROBE
>> and the maximal brightness is 255.
>> echo 0   > /sys/class/leds/user/brightness
>> echo 0   > /sys/class/leds/user/brightness
>> echo 0   > /sys/class/leds/user/brightness
>> echo 0   > /sys/class/leds/user/brightness
>> echo 255 > /sys/class/leds/user/brightness
>> Here, FWE happens(PWMSR register reads 0x58) and the LED
>> can not be lighten.
> 
> I find this overly complicated. It adds 89 lines to a 300 lines driver
> for a single workaround. Wouldn't it be sufficient to add a delay
> of period_ns in imx_pwm_config_v2 when the FIFO is full?

The delay approach looks ok if the engine is enabled.
But, if the engine is disabled, adding delay does not make sense, since
the engine will not consume any FIFO slot.
So, two cases should be handled separately at least:
1) The engine is enabled and the FIFO is full, we delay for period_ns.
2) The engine is disabled and the FIFO is full, we reset the engine?

I like the rollover interrupt approach better, because it may avoid
the potential unnecessary lag the delay approach introduces(when the
engine is enabled, the FIFO is full and one FIFO slot is consumed at
the time we delay).
Moreover, IMHO, a delay approach is somewhat the last choice for a driver.

> 
> Sascha
> 

-- 
Liu Ying
