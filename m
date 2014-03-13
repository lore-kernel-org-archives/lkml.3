Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753355AbaCMIAK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Mar 2014 04:00:10 -0400
Received: from mail-wg0-f45.google.com ([74.125.82.45]:55281 "EHLO
	mail-wg0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753139AbaCMIAI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Mar 2014 04:00:08 -0400
Date: Thu, 13 Mar 2014 08:00:00 +0000
From: Lee Jones <lee.jones@linaro.org>
To: Robert Baldyga <r.baldyga@samsung.com>
Cc: Chanwoo Choi <cw00.choi@samsung.com>, sameo@linux.intel.com,
        myungjoo.ham@samsung.com, dmitry.torokhov@gmail.com,
        cooloney@gmail.com, rpurdie@rpsys.net, dbaryshkov@gmail.com,
        dwmw2@infradead.org, lgirdwood@gmail.com, broonie@kernel.org,
        a.zummo@towertech.it, paul.gortmaker@windriver.com,
        linux-kernel@vger.kernel.org, linux-input@vger.kernel.org,
        linux-leds@vger.kernel.org, rtc-linux@googlegroups.com,
        m.szyprowski@samsung.com, k.kozlowski@samsung.com
Subject: Re: [PATCH v2 2/3] mfd: max8997: handle IRQs using regmap
Message-ID: <20140313080000.GA8740@lee--X1>
References: <1394631466-6429-1-git-send-email-r.baldyga@samsung.com>
 <1394631466-6429-3-git-send-email-r.baldyga@samsung.com>
 <532111FA.2010706@samsung.com>
 <53216272.7050304@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <53216272.7050304@samsung.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Guys, when replying please cut out all of the unnecessary text. Paging
down though unmodified/unreviewed code is tiresome.

> >> This patch modifies mfd driver to use regmap for handling interrupts.
> >> It allows to simplify irq handling process. This modifications needed
> >> to make small changes in function drivers, which use interrupts.
> >>
> >> Signed-off-by: Robert Baldyga <r.baldyga@samsung.com>
> >> ---
> >>  drivers/extcon/extcon-max8997.c     |   35 ++--
> >>  drivers/mfd/Kconfig                 |    2 +-
> >>  drivers/mfd/Makefile                |    2 +-
> >>  drivers/mfd/max8997-irq.c           |  373 -----------------------------------
> >>  drivers/mfd/max8997.c               |  113 ++++++++++-
> >>  drivers/rtc/rtc-max8997.c           |    2 +-
> >>  include/linux/mfd/max8997-private.h |   65 +++++-
> >>  7 files changed, 183 insertions(+), 409 deletions(-)
> >>  delete mode 100644 drivers/mfd/max8997-irq.c
> >>
> >> diff --git a/drivers/extcon/extcon-max8997.c b/drivers/extcon/extcon-max8997.c
> >> index f258c08..15fc5c0 100644
> >> --- a/drivers/extcon/extcon-max8997.c
> >> +++ b/drivers/extcon/extcon-max8997.c
> >> @@ -46,15 +46,15 @@ struct max8997_muic_irq {
> >>  };
> >>  
> >>  static struct max8997_muic_irq muic_irqs[] = {
> >> -	{ MAX8997_MUICIRQ_ADCError,	"muic-ADCERROR" },
> >> -	{ MAX8997_MUICIRQ_ADCLow,	"muic-ADCLOW" },
> >> -	{ MAX8997_MUICIRQ_ADC,		"muic-ADC" },
> >> -	{ MAX8997_MUICIRQ_VBVolt,	"muic-VBVOLT" },
> >> -	{ MAX8997_MUICIRQ_DBChg,	"muic-DBCHG" },
> >> -	{ MAX8997_MUICIRQ_DCDTmr,	"muic-DCDTMR" },
> >> -	{ MAX8997_MUICIRQ_ChgDetRun,	"muic-CHGDETRUN" },
> >> -	{ MAX8997_MUICIRQ_ChgTyp,	"muic-CHGTYP" },
> >> -	{ MAX8997_MUICIRQ_OVP,		"muic-OVP" },
> >> +	{ MAX8997_MUICIRQ_ADCERROR,	"MUIC-ADCERROR" },
> >> +	{ MAX8997_MUICIRQ_ADCLOW,	"MUIC-ADCLOW" },
> >> +	{ MAX8997_MUICIRQ_ADC,		"MUIC-ADC" },
> >> +	{ MAX8997_MUICIRQ_VBVOLT,	"MUIC-VBVOLT" },
> >> +	{ MAX8997_MUICIRQ_DBCHG,	"MUIC-DBCHG" },
> >> +	{ MAX8997_MUICIRQ_DCDTMR,	"MUIC-DCDTMR" },
> >> +	{ MAX8997_MUICIRQ_CHGDETRUN,	"MUIC-CHGDETRUN" },
> >> +	{ MAX8997_MUICIRQ_CHGTYP,	"MUIC-CHGTYP" },
> >> +	{ MAX8997_MUICIRQ_OVP,		"MUIC-OVP" },
> >>  };
> > 
> > 
> > Why did you modify interrput name? Did you have some reason?
> > I think this modification don't need it.
> 
> I did it to have one naming convention in max8997-private.h file. Any
> other interrupt names uses upper case, but MUIC iqr's from some reason
> uses CamelCase. I think it's much better to have consistent style in
> entire file.

I agree with the modification. CamelCase #defines/enums are hard to
read and look awful.

<snip>

> >> +enum max8997_irq_muic {
> >>  	MAX8997_MUICIRQ_ADC,
> >> +	MAX8997_MUICIRQ_ADCLOW,
> >> +	MAX8997_MUICIRQ_ADCERROR,
> >>  
> >> -	MAX8997_MUICIRQ_VBVolt,
> >> -	MAX8997_MUICIRQ_DBChg,
> >> -	MAX8997_MUICIRQ_DCDTmr,
> >> -	MAX8997_MUICIRQ_ChgDetRun,
> >> -	MAX8997_MUICIRQ_ChgTyp,
> >> +	MAX8997_MUICIRQ_CHGTYP,
> >> +	MAX8997_MUICIRQ_CHGDETRUN,
> >> +	MAX8997_MUICIRQ_DCDTMR,
> >> +	MAX8997_MUICIRQ_DBCHG,
> >> +	MAX8997_MUICIRQ_VBVOLT,
> > 
> > ditto.
> > I don't understand why do you modify interrnut name/macro.

... because the old ones are ugly and hard to read.

> >>  	MAX8997_MUICIRQ_OVP,
> >>  
> >> -	MAX8997_IRQ_NR,
> >> +	MAX8997_MUCIRQ_NR,
> > 
> > ditto.
> 
> Here I have splitted enum into few enums, each for single interrupt
> source, to make it easier to use with regmap irq handling. So I changed
> MAX8997_IRQ_NR name to MAX8997_MUCIRQ_NR because now it's not number of
> all interrupts but number of interrupts coming form MUIC.

The new name is more inline with the remaining enums, thus is better.

<snip>

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
