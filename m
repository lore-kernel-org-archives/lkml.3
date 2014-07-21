Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932887AbaGUQTj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jul 2014 12:19:39 -0400
Received: from mail-pa0-f46.google.com ([209.85.220.46]:53451 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932647AbaGUQTg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jul 2014 12:19:36 -0400
Date: Mon, 21 Jul 2014 09:19:32 -0700
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: linux-arm-kernel@lists.infradead.org, mark.rutland@arm.com,
        devicetree@vger.kernel.org, kgene.kim@samsung.com, pawel.moll@arm.com,
        ijc+devicetree@hellion.org.uk, linux-iio@vger.kernel.org,
        t.figa@samsung.com, rdunlap@infradead.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, robh+dt@kernel.org,
        Chanwoo Choi <cw00.choi@samsung.com>, kyungmin.park@samsung.com,
        linux-samsung-soc@vger.kernel.org, Jonathan Cameron <jic23@kernel.org>,
        Ben Dooks <ben-linux@fluff.org>, galak@codeaurora.org,
        ch.naveen@samsung.com, linux-input <linux-input@vger.kernel.org>,
        heiko.stuebner@bq.com
Subject: Re: [PATCH 2/2] iio: exynos-adc: add experimental touchscreen support
Message-ID: <20140721161932.GA12180@core.coreip.homeip.net>
References: <1405663186-26464-1-git-send-email-cw00.choi@samsung.com>
 <5158672.dMAnnUQc7Z@wuerfel>
 <20140721144442.GB9112@core.coreip.homeip.net>
 <6569004.FG0IRy8WyL@wuerfel>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6569004.FG0IRy8WyL@wuerfel>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 21, 2014 at 05:11:27PM +0200, Arnd Bergmann wrote:
> On Monday 21 July 2014 07:44:42 Dmitry Torokhov wrote:
> > > > 
> > > > It would be nice to actually close the device even if someone is
> > > > touching screen. Please implement open/close methods and have them set a
> > > > flag that you would check here.
> > > 
> > > Ok. I think it's even better to move the request_irq() into the open function,
> > > which will avoid the flag and defer the error handling into the actual opening,
> > > as well as syncing the running irq with the close function.
> > 
> > I do not quite like acquiring resources needed in open. I think drivers should
> > do all resource acquisition in probe() and leave open()/close() to
> > activate/quiesce devices.
> 
> Ok, I'll move it back then. I'm not sure what I'm supposed to do
> in open/close then. Isn't it enough to check info->input->users
> like this?
> 
> static irqreturn_t exynos_ts_isr(int irq, void *dev_id)
> {
>         struct exynos_adc *info = dev_id;
>         struct iio_dev *dev = dev_get_drvdata(info->dev);
>         u32 x, y;
>         bool pressed;
>         int ret;
> 
>         while (info->input->users) {
>                 ret = exynos_read_s3c64xx_ts(dev, &x, &y);
>                 if (ret == -ETIMEDOUT)
>                         break;
> 
>                 pressed = x & y & ADC_DATX_PRESSED;
>                 if (!pressed) {
>                         input_report_key(info->input, BTN_TOUCH, 0);
>                         input_sync(info->input);
>                         break;
>                 }
> 
>                 input_report_abs(info->input, ABS_X, x & ADC_DATX_MASK);
>                 input_report_abs(info->input, ABS_Y, y & ADC_DATY_MASK);
>                 input_report_key(info->input, BTN_TOUCH, 1);
>                 input_sync(info->input);
> 
>                 msleep(1);
>         };
> 
>         writel(0, ADC_V1_CLRINTPNDNUP(info->regs));
> 
>         return IRQ_HANDLED;
> }
> 
> I could do enable_irq()/disable_irq(), but that leaves a small
> race at startup where we request the irq line and then immediately
> disable it again.

I think the above (or a separate flag in driver structure) coupled with
enable/disable IRQ is fine - input core can deal with calls to input_report_*
on devices that have been properly allocated but have not been registered yet.

drivers/input/keyboard/samsung-keypad.c does similar handling.

Thanks.

-- 
Dmitry
