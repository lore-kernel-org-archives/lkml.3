Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752866AbaJJJCE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Oct 2014 05:02:04 -0400
Received: from mailout4.w1.samsung.com ([210.118.77.14]:23665 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751915AbaJJJCA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Oct 2014 05:02:00 -0400
MIME-version: 1.0
Content-type: text/plain; charset=UTF-8
X-AuditID: cbfec7f5-b7f776d000003e54-7c-5437a085029f
Content-transfer-encoding: 8BIT
Message-id: <1412931716.22108.0.camel@AMDC1943>
Subject: Re: [PATCH fixes 2/2] extcon: max77693: Fix always masked MUIC
 interrupts
From: Krzysztof Kozlowski <k.kozlowski@samsung.com>
To: Lee Jones <lee.jones@linaro.org>
Cc: MyungJoo Ham <myungjoo.ham@samsung.com>,
        Chanwoo Choi <cw00.choi@samsung.com>,
        Samuel Ortiz <sameo@linux.intel.com>, linux-kernel@vger.kernel.org,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        stable@vger.kernel.org
Date: Fri, 10 Oct 2014 11:01:56 +0200
In-reply-to: <20141010085854.GC26795@lee--X1>
References: <1412929322-21908-1-git-send-email-k.kozlowski@samsung.com>
 <1412929322-21908-2-git-send-email-k.kozlowski@samsung.com>
 <20141010085854.GC26795@lee--X1>
X-Mailer: Evolution 3.10.4-0ubuntu2
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrLLMWRmVeSWpSXmKPExsVy+t/xK7qtC8xDDKatsrLYOGM9q8X1L89Z
	Lc42vWG3uP/1KKPF5V1z2CzWHrnLbnG7cQWbxeluVosFGx8xOnB63Lm2h81j3slAj74tqxg9
	Pm+SC2CJ4rJJSc3JLEst0rdL4MqYc+Q0c8FTsYr+i+uYGxibhboYOTgkBEwk3nxK6WLkBDLF
	JC7cW8/WxcjFISSwlFGisbmJDSTBKyAo8WPyPRaQemYBeYkjl7JBwswC6hKT5i1iBrGFBD4z
	Sky8JgdRri9xq+sKI4gtLBAicffNTzCbTcBYYvPyJWwgY0QEVCTOvTEHWcUscJhJ4vTmd0wg
	NSwCqhL3ty4GszkFdCXe3d/ODHHPCkaJ63uuM0LcrCzR2O82gVFgFpLrZiFcNwvJdQsYmVcx
	iqaWJhcUJ6XnGukVJ+YWl+al6yXn525ihAT51x2MS49ZHWIU4GBU4uG9IGMeIsSaWFZcmXuI
	UYKDWUmEt3sOUIg3JbGyKrUoP76oNCe1+BAjEwenVANj/dWQw49Xz5lTtjnB1naLYqGt8DvP
	+3Mu1eY0chfNzGjLfHH08rOK9ym340qusbputD0f28t1MTBW4XhOul5CyKnj+hkq96cYRXbE
	xp9S/WxcsST12Tr7Iwd8J7olGbocDb24x3hb+q8PAf8m7fzBNvHt5byHu3Qdvi1e/e/htpAF
	UrcmvVvhoMRSnJFoqMVcVJwIAN1Tw/hQAgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On pią, 2014-10-10 at 09:58 +0100, Lee Jones wrote:
> On Fri, 10 Oct 2014, Krzysztof Kozlowski wrote:
> 
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
> 
> Did you run this through checkpatch?

Yes, no complains.


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
> 

