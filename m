Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753675AbaJJKK6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Oct 2014 06:10:58 -0400
Received: from mailout3.w1.samsung.com ([210.118.77.13]:42947 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751487AbaJJKKz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Oct 2014 06:10:55 -0400
MIME-version: 1.0
Content-type: text/plain; charset=UTF-8
X-AuditID: cbfec7f4-b7f156d0000063c7-49-5437b0ac318e
Content-transfer-encoding: 8BIT
Message-id: <1412935850.4143.4.camel@AMDC1943>
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
Date: Fri, 10 Oct 2014 12:10:50 +0200
In-reply-to: <5437AF78.3060602@samsung.com>
References: <1412929322-21908-1-git-send-email-k.kozlowski@samsung.com>
 <1412929322-21908-2-git-send-email-k.kozlowski@samsung.com>
 <54379CB6.1040405@samsung.com> <1412931783.22108.2.camel@AMDC1943>
 <5437AF78.3060602@samsung.com>
X-Mailer: Evolution 3.10.4-0ubuntu2
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrPLMWRmVeSWpSXmKPExsVy+t/xK7prNpiHGNz4ZGCxccZ6VovrX56z
	WpxtesNucf/rUUaLy7vmsFmsPXKX3eJ24wo2i9PdrBYLNj5idOD0uHNtD5vHvJOBHn1bVjF6
	fN4kF8ASxWWTkpqTWZZapG+XwJUxacV/9oJGqYovi84wNjD+Fuli5OSQEDCReHqxmQXCFpO4
	cG89WxcjF4eQwFJGid+LLjOCJHgFBCV+TL4HVMTBwSwgL3HkUjZImFlAXWLSvEXMEPWfGSXa
	7u5hhajXk9g19wnYUGGBEIm7b36CzWETMJbYvHwJG4gtIqAhMfPvFUaQZmaB/UwSh09vAEuw
	CKhKXP24gw1kGaeAtsTWX2IQC14zSvS1/mAFiUsIKEs09rtNYBSYheS8WQjnzUJy3gJG5lWM
	oqmlyQXFSem5hnrFibnFpXnpesn5uZsYIYH+ZQfj4mNWhxgFOBiVeHgvyJiHCLEmlhVX5h5i
	lOBgVhLh7Z4DFOJNSaysSi3Kjy8qzUktPsTIxMEp1cCo0qPvvtZ/98zN4qfOz3TcwXo0K104
	5q/scQNZEa+Vj39674huKnTW1H5fZ37jqtKGIrEehQW7P2u8n5wlLXY9Nsme/fUj/h/Wz6uv
	ZIcFbxXoCWxkWa7vnu+3M/KMjPgCxepAz6shayW0pRUtRAosbxyY5LJ1UnEVf3nkWcflu5Z3
	X381i0eJpTgj0VCLuag4EQCde60EUgIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On pią, 2014-10-10 at 19:05 +0900, Chanwoo Choi wrote:
> On 10/10/2014 06:03 PM, Krzysztof Kozlowski wrote:
> > On pią, 2014-10-10 at 17:45 +0900, Chanwoo Choi wrote:
> >> On 10/10/2014 05:22 PM, Krzysztof Kozlowski wrote:
> >>> All interrupts coming from MUIC were ignored because interrupt source
> >>> register was masked.
> >>>
> >>> The Maxim 77693 has a "interrupt source" - a separate register and interrupts
> >>> which give information about PMIC block triggering the individual
> >>> interrupt (charger, topsys, MUIC, flash LED).
> >>>
> >>> By default bootloader could initialize this register to "mask all"
> >>> value. In such case (observed on Trats2 board) MUIC interrupts won't be
> >>> generated regardless of their mask status. Regmap irq chip was unmasking
> >>> individual MUIC interrupts but the source was masked
> >>>
> >>> Before introducing regmap irq chip this interrupt source was unmasked,
> >>> read and acked. Reading and acking is not necessary but unmasking is. Do
> >>> it in extcon driver.
> >>>
> >>> Signed-off-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>
> >>> Cc: <stable@vger.kernel.org>
> >>> Fixes: 342d669c1ee4 ("mfd: max77693: Handle IRQs using regmap")
> >>> ---
> >>>  drivers/extcon/extcon-max77693.c     | 16 ++++++++++++++++
> >>>  include/linux/mfd/max77693-private.h |  5 +++++
> >>>  2 files changed, 21 insertions(+)
> >>>
> >>> diff --git a/drivers/extcon/extcon-max77693.c b/drivers/extcon/extcon-max77693.c
> >>> index 490e27475bac..d3adacf3187f 100644
> >>> --- a/drivers/extcon/extcon-max77693.c
> >>> +++ b/drivers/extcon/extcon-max77693.c
> >>> @@ -1176,6 +1176,22 @@ static int max77693_muic_probe(struct platform_device *pdev)
> >>>  		}
> >>>  	}
> >>>  
> >>> +	if (i) {
> >>> +		/*
> >>> +		 * i>0, at least one MUIC interrupt requested so need to unmask
> >>> +		 * MUIC interrupt in INTSRC register. Without that MUIC
> >>> +		 * interrupts will not be reported.
> >>> +		 */
> >>> +		ret = regmap_update_bits(max77693->regmap,
> >>> +				MAX77693_PMIC_REG_INTSRC_MASK, SRC_IRQ_MUIC,
> >>> +				~SRC_IRQ_MUIC);
> >>> +		if (ret < 0) {
> >>> +			dev_err(&pdev->dev, "Could not unmask MUIC interrupt in INTSRC: %d\n",
> >>> +					ret);
> >>> +			return ret;
> >>> +		}
> >>> +	}
> >>> +
> >>
> >> No,
> >> The extcon-max77693 driver cannot enable IRQ_CHARGER/TOP/FLASH
> >> because MAX77693_PMIC_REG_INTSRC_MASK register is common register of MAX77693.
> >>
> >> The IRQ_CHARGER/TOP/FLASH of MAX77693_PMIC_REG_INTSRC_MASK register should be enabled
> >> in drivers/mfd/max77693.c.
> > 
> > The code above unmasks only SRC_IRQ_MUIC. Other bits are not touched.
> > Why do you think that other IRQs will be enabled?
> 
> I think that MAX77693_PMIC_REG_INTSRC_MASK common register better to be controlled
> in drivers/mfd/max77693.c. I prefer that MAX77693 extcon driver would read/write only MUIC registers.
> 
> Also, MAX77693 extcon driver have to be always unmasked.
> If IRQ_MUIC is masked, MAX77693 extcon driver could not detect any external cables.
> 
> For example,
> The max77836 enable MUIC_IRQ by un-masking MUIC_IRQ.
> You can check it on drivers/mfd/max14577.c (line 251~258)

Sure, I get it. I'll do it the same as in max14577 driver.

Thanks for feedback!
Krzysztof

