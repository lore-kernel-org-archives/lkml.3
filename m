Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933375AbaJVLhg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Oct 2014 07:37:36 -0400
Received: from mail-ie0-f179.google.com ([209.85.223.179]:48528 "EHLO
	mail-ie0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932984AbaJVLhd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Oct 2014 07:37:33 -0400
Date: Wed, 22 Oct 2014 12:37:27 +0100
From: Lee Jones <lee.jones@linaro.org>
To: Krzysztof Kozlowski <k.kozlowski@samsung.com>
Cc: MyungJoo Ham <myungjoo.ham@samsung.com>,
        Chanwoo Choi <cw00.choi@samsung.com>,
        Samuel Ortiz <sameo@linux.intel.com>, linux-kernel@vger.kernel.org,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        stable@vger.kernel.org
Subject: Re: [PATCH fixes v2] mfd: max77693: Fix always masked MUIC interrupts
Message-ID: <20141022113727.GK4939@x1>
References: <1412938115-11606-1-git-send-email-k.kozlowski@samsung.com>
 <20141010105600.GL26795@lee--X1>
 <1413970123.2504.2.camel@AMDC1943>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1413970123.2504.2.camel@AMDC1943>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 22 Oct 2014, Krzysztof Kozlowski wrote:

> On pią, 2014-10-10 at 11:56 +0100, Lee Jones wrote:
> > On Fri, 10 Oct 2014, Krzysztof Kozlowski wrote:
> > 
> > > All interrupts coming from MUIC were ignored because interrupt source
> > > register was masked.
> > > 
> > > The Maxim 77693 has a "interrupt source" - a separate register and interrupts
> > > which give information about PMIC block triggering the individual
> > > interrupt (charger, topsys, MUIC, flash LED).
> > > 
> > > By default bootloader could initialize this register to "mask all"
> > > value. In such case (observed on Trats2 board) MUIC interrupts won't be
> > > generated regardless of their mask status. Regmap irq chip was unmasking
> > > individual MUIC interrupts but the source was masked
> > > 
> > > Before introducing regmap irq chip this interrupt source was unmasked,
> > > read and acked. Reading and acking is not necessary but unmasking is.
> > > 
> > > Signed-off-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>
> > > Cc: <stable@vger.kernel.org>
> > > Fixes: 342d669c1ee4 ("mfd: max77693: Handle IRQs using regmap")
> > 
> > Applied to -fixes until someone complains.
> 
> Hi Lee,
> 
> I cannot find this patch on gitweb (MFD tree), have you applied it?
> 
> If not then could you squash it with:
> mfd: max77693: Fix a truncate warning
> https://lkml.org/lkml/2014/10/14/161
> 
> If you wish I could resend it.

It as applied, just not pushed.

I can squash that commit into it yes.

> > > ---
> > > 
> > > Changes since v1:
> > > 1. Do the unmasking in main MFD driver. Additionally unmask all
> > >    interrupts, not only MUIC. Suggested by Chanwoo Choi.
> > > ---
> > >  drivers/mfd/max77693.c               | 12 ++++++++++++
> > >  include/linux/mfd/max77693-private.h |  7 +++++++
> > >  2 files changed, 19 insertions(+)
> > > 
> > > diff --git a/drivers/mfd/max77693.c b/drivers/mfd/max77693.c
> > > index 4b54da1ff7ab..4e4e6a1a6301 100644
> > > --- a/drivers/mfd/max77693.c
> > > +++ b/drivers/mfd/max77693.c
> > > @@ -253,6 +253,17 @@ static int max77693_i2c_probe(struct i2c_client *i2c,
> > >  		goto err_irq_muic;
> > >  	}
> > >  
> > > +	/* Unmask interrupts from all blocks in interrupt source register */
> > > +	ret = regmap_update_bits(max77693->regmap,
> > > +				MAX77693_PMIC_REG_INTSRC_MASK,
> > > +				SRC_IRQ_ALL, ~SRC_IRQ_ALL);
> > > +	if (ret < 0) {
> > > +		dev_err(max77693->dev,
> > > +			"Could not unmask interrupts in INTSRC: %d\n",
> > > +			ret);
> > > +		goto err_intsrc;
> > > +	}
> > > +
> > >  	pm_runtime_set_active(max77693->dev);
> > >  
> > >  	ret = mfd_add_devices(max77693->dev, -1, max77693_devs,
> > > @@ -264,6 +275,7 @@ static int max77693_i2c_probe(struct i2c_client *i2c,
> > >  
> > >  err_mfd:
> > >  	mfd_remove_devices(max77693->dev);
> > > +err_intsrc:
> > >  	regmap_del_irq_chip(max77693->irq, max77693->irq_data_muic);
> > >  err_irq_muic:
> > >  	regmap_del_irq_chip(max77693->irq, max77693->irq_data_charger);
> > > diff --git a/include/linux/mfd/max77693-private.h b/include/linux/mfd/max77693-private.h
> > > index e1b2b61285b9..15fed5365a20 100644
> > > --- a/include/linux/mfd/max77693-private.h
> > > +++ b/include/linux/mfd/max77693-private.h
> > > @@ -438,6 +438,13 @@ enum max77693_irq_source {
> > >  	MAX77693_IRQ_GROUP_NR,
> > >  };
> > >  
> > > +#define SRC_IRQ_CHARGER			BIT(0)
> > > +#define SRC_IRQ_TOP			BIT(1)
> > > +#define SRC_IRQ_FLASH			BIT(2)
> > > +#define SRC_IRQ_MUIC			BIT(3)
> > > +#define SRC_IRQ_ALL			(SRC_IRQ_CHARGER | SRC_IRQ_TOP \
> > > +						| SRC_IRQ_FLASH | SRC_IRQ_MUIC)
> > > +
> > >  #define LED_IRQ_FLED2_OPEN		BIT(0)
> > >  #define LED_IRQ_FLED2_SHORT		BIT(1)
> > >  #define LED_IRQ_FLED1_OPEN		BIT(2)
> > 
> 

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
