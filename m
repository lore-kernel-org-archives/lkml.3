Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752773AbaESGta (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 May 2014 02:49:30 -0400
Received: from mail-bn1lp0140.outbound.protection.outlook.com ([207.46.163.140]:9633
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750740AbaESGt2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 May 2014 02:49:28 -0400
Message-ID: <5379AA13.4000904@freescale.com>
Date: Mon, 19 May 2014 14:52:03 +0800
From: Liu Ying <Ying.Liu@freescale.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: =?UTF-8?B?TG90aGFyIFdhw59tYW5u?= <LW@KARO-electronics.de>
CC: <linux-pwm@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <thierry.reding@gmail.com>, <s.hauer@pengutronix.de>,
        <shawn.guo@freescale.com>, <linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH v3] pwm: i.MX: Avoid sample FIFO overflow for i.MX PWM
 version2
References: <1400217068-22642-1-git-send-email-Ying.Liu@freescale.com>
 <20140519075328.7f2ef0c5@ipc1.ka-ro>
In-Reply-To: <20140519075328.7f2ef0c5@ipc1.ka-ro>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:192.88.158.2;CTRY:US;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(6009001)(199002)(189002)(377454003)(24454002)(51704005)(479174003)(92566001)(92726001)(85852003)(102836001)(21056001)(80316001)(6806004)(77096999)(54356999)(50986999)(86362001)(68736004)(44976005)(81542001)(83072002)(74502001)(83322001)(47776003)(20776003)(74662001)(4396001)(33656001)(50466002)(87266999)(64706001)(31966008)(79102001)(575784001)(83506001)(99396002)(81156002)(46102001)(76482001)(84676001)(23676002)(65816999)(76176999)(69596002)(80022001)(65956001)(36756003)(87936001)(59896001)(77982001)(64126003)(81342001);DIR:OUT;SFP:;SCL:1;SRVR:DM2PR03MB350;H:az84smr01.freescale.net;FPR:;MLV:sfv;PTR:InfoDomainNonexistent;A:1;MX:1;LANG:en;
X-Forefront-PRVS: 021670B4D2
Authentication-Results: spf=fail (sender IP is 192.88.158.2)
 smtp.mailfrom=Ying.Liu@freescale.com; 
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Lothar,

Thanks for your review.

On 05/19/2014 01:53 PM, Lothar Waßmann wrote:
> Hi,
> 
> Liu Ying wrote:
> [...]
>> @@ -30,6 +32,7 @@
>>  /* i.MX27, i.MX31, i.MX35 share the same PWM function block: */
>>  
>>  #define MX3_PWMCR                 0x00    /* PWM Control Register */
>> +#define MX3_PWMIR                 0x08    /* PWM Interrupt Register */
>>  #define MX3_PWMSAR                0x0C    /* PWM Sample Register */
>>  #define MX3_PWMPR                 0x10    /* PWM Period Register */
>>  #define MX3_PWMCR_PRESCALER(x)    (((x - 1) & 0xFFF) << 4)
>> @@ -38,7 +41,12 @@
>>  #define MX3_PWMCR_DBGEN			(1 << 22)
>>  #define MX3_PWMCR_CLKSRC_IPG_HIGH (2 << 16)
>>  #define MX3_PWMCR_CLKSRC_IPG      (1 << 16)
>> +#define MX3_PWMCR_SWR		  (1 << 3)
>>  #define MX3_PWMCR_EN              (1 << 0)
>> +#define MX3_PWMSR_ROV             (1 << 4)
>> +#define MX3_PWMIR_RIE             (1 << 1)
>> +
> You should decide whether to use tabs or spaces for indentation.
> And probably cleanup the indentation of the existing definitions to use
> all the same indentation style.

Ok, I will generate a separate patch to cleanup the indentation for
the existing register definitions of both i.MX PWMv1 and PWMv2.

> 
>> @@ -128,6 +160,13 @@ static int imx_pwm_config_v2(struct pwm_chip *chip,
>>  	else
>>  		period_cycles = 0;
>>  
>> +	if (!enable || duty_cycles == 0)
>> +		imx_pwm_software_reset_v2(chip);
>> +	else if (readl(imx->mmio_base + MX3_PWMSAR))
>> +		/* No rollover irq generated if duty peroid is zero. */
> typo: 'period'.

I will fix this.

> 
>> @@ -135,27 +174,55 @@ static int imx_pwm_config_v2(struct pwm_chip *chip,
>>  		MX3_PWMCR_DOZEEN | MX3_PWMCR_WAITEN |
>>  		MX3_PWMCR_DBGEN | MX3_PWMCR_CLKSRC_IPG_HIGH;
>>  
>> -	if (test_bit(PWMF_ENABLED, &pwm->flags))
>> +	if (enable)
>>  		cr |= MX3_PWMCR_EN;
>>  
>>  	writel(cr, imx->mmio_base + MX3_PWMCR);
>>  
>> +	if (enable && duty_cycles)
>> +		/* No rollover irq generated if duty peroid is zero. */
> dto.

I will fix this.

> 
> 
> Lothar Waßmann
> 

-- 
Liu Ying
