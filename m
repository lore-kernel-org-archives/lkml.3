Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754820Ab3HPIyA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Aug 2013 04:54:00 -0400
Received: from www.linutronix.de ([62.245.132.108]:38227 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754136Ab3HPIxz convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Aug 2013 04:53:55 -0400
Date: Fri, 16 Aug 2013 10:53:50 +0200
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
To: Zubair Lutfullah <zubair.lutfullah@gmail.com>
Cc: jic23@cam.ac.uk, dmitry.torokhov@gmail.com, sameo@linux.intel.com,
        lee.jones@linaro.org, linux-iio@vger.kernel.org,
        linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
        gregkh@linuxfoundation.org, Russ.Dill@ti.com
Subject: Re: [PATCH 1/4] input: ti_am335x_tsc: correct step mask update
 after IRQ
Message-ID: <20130816085350.GA26895@linutronix.de>
References: <1376412499-21007-1-git-send-email-zubair.lutfullah@gmail.com>
 <1376412499-21007-2-git-send-email-zubair.lutfullah@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
In-Reply-To: <1376412499-21007-2-git-send-email-zubair.lutfullah@gmail.com>
X-Key-Id: 97C4700B
X-Key-Fingerprint: 09E2 D1F3 9A3A FF13 C3D3  961C 0688 1C1E 97C4 700B
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Zubair Lutfullah | 2013-08-13 17:48:16 [+0100]:

>diff --git a/drivers/input/touchscreen/ti_am335x_tsc.c b/drivers/input/touchscreen/ti_am335x_tsc.c
>index e1c5300..e165fcb 100644
>--- a/drivers/input/touchscreen/ti_am335x_tsc.c
>+++ b/drivers/input/touchscreen/ti_am335x_tsc.c
>@@ -52,6 +52,7 @@ struct titsc {
> 	u32			config_inp[4];
> 	u32			bit_xp, bit_xn, bit_yp, bit_yn;
> 	u32			inp_xp, inp_xn, inp_yp, inp_yn;
>+	u32			step_mask;
> };
> 
> static unsigned int titsc_readl(struct titsc *ts, unsigned int reg)
>@@ -196,7 +197,8 @@ static void titsc_step_config(struct titsc *ts_dev)
> 
> 	/* The steps1 … end and bit 0 for TS_Charge */
> 	stepenable = (1 << (end_step + 2)) - 1;
>-	am335x_tsc_se_set(ts_dev->mfd_tscadc, stepenable);
>+	ts_dev->step_mask = stepenable;
>+	am335x_tsc_se_set(ts_dev->mfd_tscadc, ts_dev->step_mask);
> }
> 
> static void titsc_read_coordinates(struct titsc *ts_dev,
>@@ -316,7 +318,7 @@ static irqreturn_t titsc_irq(int irq, void *dev)
> 
> 	if (irqclr) {
> 		titsc_writel(ts_dev, REG_IRQSTATUS, irqclr);
>-		am335x_tsc_se_update(ts_dev->mfd_tscadc);
>+		am335x_tsc_se_set(ts_dev->mfd_tscadc, ts_dev->step_mask);
> 		return IRQ_HANDLED;
> 	}
> 	return IRQ_NONE;

titsc_step_config() computes the mask once since it does not change. It
is then assigned via am335x_tsc_se_set() to ->reg_se_cache() and later
always udpated via am335x_tsc_se_update(). This should ensure that ADC's
and TSC's bits are in sync and clear each other out.
Now you call am335x_tsc_se_set() in every irq which adds the TSC's mask
to ->reg_se_cache but why? It was never removed.

Sebastian
