Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932747AbaGUPNJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jul 2014 11:13:09 -0400
Received: from mout.kundenserver.de ([212.227.126.130]:52866 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932509AbaGUPNH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jul 2014 11:13:07 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: linux-arm-kernel@lists.infradead.org
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>, mark.rutland@arm.com,
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
Date: Mon, 21 Jul 2014 17:11:27 +0200
Message-ID: <6569004.FG0IRy8WyL@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.11.0-18-generic; KDE/4.11.5; x86_64; ; )
In-Reply-To: <20140721144442.GB9112@core.coreip.homeip.net>
References: <1405663186-26464-1-git-send-email-cw00.choi@samsung.com> <5158672.dMAnnUQc7Z@wuerfel> <20140721144442.GB9112@core.coreip.homeip.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:FI92xTEVgExzpgMOBp/t47NF9R/AH+z1XNV/xU7fC8N
 unlJHUJPVDMRq7mSxqgfc3nM84a3Fnn43gc2DLo5hkRbdJyx4V
 eMCGBEUlvOeFbljN5/NoTkwl7OfAt1Y+T10PQpwJE/IfUg8dz7
 i/x0HfYpCWlvp6KlnF2SUmYa3poz9jcn5QwUk66CxAFFXcNWqG
 QHJ5lnMDEdz0GBAOw4sjmzIoA79jV3Au7Wk8djBfZA8X4XVYcn
 nl/IuAiMViZ783L7Z7XZzW70S6JknG5MmMl2mTFF/F8So7OezP
 yfm5CcTeVPWY3n03ncAEmJs015KzF3ReS9onP9yb9QLxyPGHoF
 NpGo36sVL8GKz/uUwBJI=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 21 July 2014 07:44:42 Dmitry Torokhov wrote:
> > > 
> > > It would be nice to actually close the device even if someone is
> > > touching screen. Please implement open/close methods and have them set a
> > > flag that you would check here.
> > 
> > Ok. I think it's even better to move the request_irq() into the open function,
> > which will avoid the flag and defer the error handling into the actual opening,
> > as well as syncing the running irq with the close function.
> 
> I do not quite like acquiring resources needed in open. I think drivers should
> do all resource acquisition in probe() and leave open()/close() to
> activate/quiesce devices.

Ok, I'll move it back then. I'm not sure what I'm supposed to do
in open/close then. Isn't it enough to check info->input->users
like this?

static irqreturn_t exynos_ts_isr(int irq, void *dev_id)
{
        struct exynos_adc *info = dev_id;
        struct iio_dev *dev = dev_get_drvdata(info->dev);
        u32 x, y;
        bool pressed;
        int ret;

        while (info->input->users) {
                ret = exynos_read_s3c64xx_ts(dev, &x, &y);
                if (ret == -ETIMEDOUT)
                        break;

                pressed = x & y & ADC_DATX_PRESSED;
                if (!pressed) {
                        input_report_key(info->input, BTN_TOUCH, 0);
                        input_sync(info->input);
                        break;
                }

                input_report_abs(info->input, ABS_X, x & ADC_DATX_MASK);
                input_report_abs(info->input, ABS_Y, y & ADC_DATY_MASK);
                input_report_key(info->input, BTN_TOUCH, 1);
                input_sync(info->input);

                msleep(1);
        };

        writel(0, ADC_V1_CLRINTPNDNUP(info->regs));

        return IRQ_HANDLED;
}

I could do enable_irq()/disable_irq(), but that leaves a small
race at startup where we request the irq line and then immediately
disable it again.

	Arnd
