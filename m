Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753066AbaJJJDM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Oct 2014 05:03:12 -0400
Received: from mailout1.w1.samsung.com ([210.118.77.11]:41347 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752005AbaJJJDI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Oct 2014 05:03:08 -0400
MIME-version: 1.0
Content-type: text/plain; charset=UTF-8
X-AuditID: cbfec7f5-b7f776d000003e54-a5-5437a0c899c4
Content-transfer-encoding: 8BIT
Message-id: <1412931783.22108.2.camel@AMDC1943>
Subject: Re: [PATCH fixes 2/2] extcon: max77693: Fix always masked MUIC
 interrupts
From: Krzysztof Kozlowski <k.kozlowski@samsung.com>
To: Chanwoo Choi <cw00.choi@samsung.com>
Cc: MyungJoo Ham <myungjoo.ham@samsung.com>,
        Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>,
        linux-kernel@vger.kernel.org,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        stable@vger.kernel.org
Date: Fri, 10 Oct 2014 11:03:03 +0200
In-reply-to: <54379CB6.1040405@samsung.com>
References: <1412929322-21908-1-git-send-email-k.kozlowski@samsung.com>
 <1412929322-21908-2-git-send-email-k.kozlowski@samsung.com>
 <54379CB6.1040405@samsung.com>
X-Mailer: Evolution 3.10.4-0ubuntu2
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrALMWRmVeSWpSXmKPExsVy+t/xy7onFpiHGFzebWixccZ6VovrX56z
	WpxtesNucf/rUUaLy7vmsFmsPXKX3eJ24wo2i9PdrBYLNj5idOD0uHNtD5vHvJOBHn1bVjF6
	fN4kF8ASxWWTkpqTWZZapG+XwJXRf2UDU8FDyYp93Z+YGxiPinQxcnJICJhITNt3mxHCFpO4
	cG89WxcjF4eQwFJGiSeX77KBJHgFBCV+TL7H0sXIwcEsIC9x5FI2SJhZQF1i0rxFzBD1nxkl
	mr72sUPU60tMalwKZgsLhEjcffMTbAGbgLHE5uVLwGaKCGhIzPx7hRGkmVlgP5PE4dMbwBIs
	AqoSB3v3g9mcAtoS+5tOMUJsWMYoMXXNdiaQKyQElCUa+90mMArMQnLfLIT7ZiG5bwEj8ypG
	0dTS5ILipPRcI73ixNzi0rx0veT83E2MkFD/uoNx6TGrQ4wCHIxKPLwXZMxDhFgTy4orcw8x
	SnAwK4nwds8BCvGmJFZWpRblxxeV5qQWH2Jk4uCUamBMYnsqP1Nvc1hH3/sU659TOo0Vxe4I
	3PcU3+k8++66zVmbziZKqkV2efBtD5r3rqs06vOt8iDTxGuOD9YLSKccKOHcUfnKe+naCucT
	/JxTmjzuNe0zYsgT3WHQo7rd7a3B/4aww5e5OV/ENmtzSPO+0fSy8zx+7chBf8cEGfUzaXen
	WEy/NFOJpTgj0VCLuag4EQC5oiykUwIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On pią, 2014-10-10 at 17:45 +0900, Chanwoo Choi wrote:
> On 10/10/2014 05:22 PM, Krzysztof Kozlowski wrote:
> > All interrupts coming from MUIC were ignored because interrupt source
> > register was masked.
> > 
> > The Maxim 77693 has a "interrupt source" - a separate register and interrupts
> > which give information about PMIC block triggering the individual
> > interrupt (charger, topsys, MUIC, flash LED).
> > 
> > By default bootloader could initialize this register to "mask all"
> > value. In such case (observed on Trats2 board) MUIC interrupts won't be
> > generated regardless of their mask status. Regmap irq chip was unmasking
> > individual MUIC interrupts but the source was masked
> > 
> > Before introducing regmap irq chip this interrupt source was unmasked,
> > read and acked. Reading and acking is not necessary but unmasking is. Do
> > it in extcon driver.
> > 
> > Signed-off-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>
> > Cc: <stable@vger.kernel.org>
> > Fixes: 342d669c1ee4 ("mfd: max77693: Handle IRQs using regmap")
> > ---
> >  drivers/extcon/extcon-max77693.c     | 16 ++++++++++++++++
> >  include/linux/mfd/max77693-private.h |  5 +++++
> >  2 files changed, 21 insertions(+)
> > 
> > diff --git a/drivers/extcon/extcon-max77693.c b/drivers/extcon/extcon-max77693.c
> > index 490e27475bac..d3adacf3187f 100644
> > --- a/drivers/extcon/extcon-max77693.c
> > +++ b/drivers/extcon/extcon-max77693.c
> > @@ -1176,6 +1176,22 @@ static int max77693_muic_probe(struct platform_device *pdev)
> >  		}
> >  	}
> >  
> > +	if (i) {
> > +		/*
> > +		 * i>0, at least one MUIC interrupt requested so need to unmask
> > +		 * MUIC interrupt in INTSRC register. Without that MUIC
> > +		 * interrupts will not be reported.
> > +		 */
> > +		ret = regmap_update_bits(max77693->regmap,
> > +				MAX77693_PMIC_REG_INTSRC_MASK, SRC_IRQ_MUIC,
> > +				~SRC_IRQ_MUIC);
> > +		if (ret < 0) {
> > +			dev_err(&pdev->dev, "Could not unmask MUIC interrupt in INTSRC: %d\n",
> > +					ret);
> > +			return ret;
> > +		}
> > +	}
> > +
> 
> No,
> The extcon-max77693 driver cannot enable IRQ_CHARGER/TOP/FLASH
> because MAX77693_PMIC_REG_INTSRC_MASK register is common register of MAX77693.
> 
> The IRQ_CHARGER/TOP/FLASH of MAX77693_PMIC_REG_INTSRC_MASK register should be enabled
> in drivers/mfd/max77693.c.

The code above unmasks only SRC_IRQ_MUIC. Other bits are not touched.
Why do you think that other IRQs will be enabled?

Best regards,
Krzysztof

> 
> >  	/* Initialize extcon device */
> >  	info->edev = devm_extcon_dev_allocate(&pdev->dev,
> >  					      max77693_extcon_cable);
> > diff --git a/include/linux/mfd/max77693-private.h b/include/linux/mfd/max77693-private.h
> > index e1b2b61285b9..4f1a80b66ecf 100644
> > --- a/include/linux/mfd/max77693-private.h
> > +++ b/include/linux/mfd/max77693-private.h
> > @@ -438,6 +438,11 @@ enum max77693_irq_source {
> >  	MAX77693_IRQ_GROUP_NR,
> >  };
> >  
> > +#define SRC_IRQ_CHARGER			BIT(0)
> > +#define SRC_IRQ_TOP			BIT(1)
> > +#define SRC_IRQ_FLASH			BIT(2)
> > +#define SRC_IRQ_MUIC			BIT(3)
> > +
> >  #define LED_IRQ_FLED2_OPEN		BIT(0)
> >  #define LED_IRQ_FLED2_SHORT		BIT(1)
> >  #define LED_IRQ_FLED1_OPEN		BIT(2)
> > 

