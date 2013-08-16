Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757273Ab3HPWlS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Aug 2013 18:41:18 -0400
Received: from mail-ea0-f178.google.com ([209.85.215.178]:53229 "EHLO
	mail-ea0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757212Ab3HPWlI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Aug 2013 18:41:08 -0400
Date: Fri, 16 Aug 2013 22:42:24 +0100
From: "Zubair Lutfullah :" <zubair.lutfullah@gmail.com>
To: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc: Zubair Lutfullah <zubair.lutfullah@gmail.com>, jic23@cam.ac.uk,
        dmitry.torokhov@gmail.com, sameo@linux.intel.com, lee.jones@linaro.org,
        linux-iio@vger.kernel.org, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org, gregkh@linuxfoundation.org,
        Russ.Dill@ti.com
Subject: Re: [PATCH 1/4] input: ti_am335x_tsc: correct step mask update after
 IRQ
Message-ID: <20130816214224.GE2636@gmail.com>
References: <1376412499-21007-1-git-send-email-zubair.lutfullah@gmail.com>
 <1376412499-21007-2-git-send-email-zubair.lutfullah@gmail.com>
 <20130816085350.GA26895@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130816085350.GA26895@linutronix.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 16, 2013 at 10:53:50AM +0200, Sebastian Andrzej Siewior wrote:
> * Zubair Lutfullah | 2013-08-13 17:48:16 [+0100]:
> 
> >@@ -316,7 +318,7 @@ static irqreturn_t titsc_irq(int irq, void *dev)
> > 
> > 	if (irqclr) {
> > 		titsc_writel(ts_dev, REG_IRQSTATUS, irqclr);
> >-		am335x_tsc_se_update(ts_dev->mfd_tscadc);
> >+		am335x_tsc_se_set(ts_dev->mfd_tscadc, ts_dev->step_mask);
> > 		return IRQ_HANDLED;
> > 	}
> > 	return IRQ_NONE;
> 
> titsc_step_config() computes the mask once since it does not change. It
> is then assigned via am335x_tsc_se_set() to ->reg_se_cache() and later
> always udpated via am335x_tsc_se_update(). This should ensure that ADC's
> and TSC's bits are in sync and clear each other out.
> Now you call am335x_tsc_se_set() in every irq which adds the TSC's mask
> to ->reg_se_cache but why? It was never removed.
> 
> Sebastian

The problem is when ADC/TSC are used together.

reg_se_cache would get updated with masks in the se_set function in MFD core.

>From TSC driver, the TSC steps would be set in the reg_se_cache variable.
>From ADC driver, the ADC steps would be set in the reg_se_cache variable.

But the ADC masks weren't being cleared from the reg_se_cache variable
anywhere.

After a while of using ADC/TSC together, the reg_se_cache 
variable would have FFFF always. Resulting in redundant sampling 
and data in ADC FIFO0.

MFD has received fixes to update the reg_se_cache upon 
every call to the se_set functions.

Thus, the step_mask must be set every time to ensure
that it is updated correctly every time.

Hope that clears the confusion.
This TSC/ADC sharing can be pretty confusing.

Thanks
Zubair
