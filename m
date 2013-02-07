Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757594Ab3BGEO2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Feb 2013 23:14:28 -0500
Received: from mail-wg0-f43.google.com ([74.125.82.43]:43616 "EHLO
	mail-wg0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751846Ab3BGEO1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Feb 2013 23:14:27 -0500
MIME-Version: 1.0
In-Reply-To: <1360149785-19645-1-git-send-email-jonghwa3.lee@samsung.com>
References: <1360149785-19645-1-git-send-email-jonghwa3.lee@samsung.com>
Date: Thu, 7 Feb 2013 09:44:25 +0530
Message-ID: <CAHdPZaOLJJYDwsaLadvCnLe=-Hr+_HpRPXHebm3jgQtPO4WASg@mail.gmail.com>
Subject: Re: [PATCH] rtc: max8997: Add driver for max8997 rtc.
From: "devendra.aaru" <devendra.aaru@gmail.com>
To: Jonghwa Lee <jonghwa3.lee@samsung.com>
Cc: linux-kernel@vger.kernel.org, a.zummo@towertech.it,
        Andrew Morton <akpm@linux-foundation.org>, rtc-linux@googlegroups.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Wed, Feb 6, 2013 at 4:53 PM, Jonghwa Lee <jonghwa3.lee@samsung.com> wrote:
> This patch adds rtc driver for Maxim 8997 multifunction chip.
> Max8997 has rtc module in it. and it can be used for timekeeping
> clock and system alarm. It provide various operational mode those are
> BCD/binary, 24/12hour, am/pm. Driver sets binary/24/ for default.
> Maxim 8997 also supports SMPL(Sudden Momentary Power Loss), WTSR
> (Watchdog Timeout and Software Reset).
>
> Signed-off-by: Jonghwa Lee <jonghwa3.lee@samsung.com>
> ---
>  drivers/rtc/Kconfig       |   30 +++
>  drivers/rtc/Makefile      |    1 +
>  drivers/rtc/rtc-max8997.c |  542 +++++++++++++++++++++++++++++++++++++++++++++
>  3 files changed, 573 insertions(+)
>  create mode 100644 drivers/rtc/rtc-max8997.c
>
> +
> +static int max8997_rtc_probe(struct platform_device *pdev)
> +{
> +       struct max8997_dev *max8997 = dev_get_drvdata(pdev->dev.parent);
> +       struct max8997_rtc_info *info;
> +       int ret, virq;
> +
> +       info = devm_kzalloc(&pdev->dev, sizeof(struct max8997_rtc_info),
> +                       GFP_KERNEL);
> +       if (!info)
> +               return -ENOMEM;
> +
> +       mutex_init(&info->lock);
> +       info->dev = &pdev->dev;
> +       info->max8997 = max8997;
> +       info->rtc = max8997->rtc;
> +
> +       platform_set_drvdata(pdev, info);
> +
> +       ret = max8997_rtc_init_reg(info);
> +
> +       if (ret < 0) {
> +               dev_err(&pdev->dev, "Failed to initialize RTC reg:%d\n", ret);
> +               return ret;
> +       }
> +
> +       max8997_rtc_enable_wtsr(info, true);
> +       max8997_rtc_enable_smpl(info, true);
> +
> +       device_init_wakeup(&pdev->dev, 1);
> +
> +       info->rtc_dev = rtc_device_register("max8997-rtc", &pdev->dev,
> +                       &max8997_rtc_ops, THIS_MODULE);
> +
> +       if (IS_ERR(info->rtc_dev)) {
> +               ret = PTR_ERR(info->rtc_dev);
> +               dev_err(&pdev->dev, "Failed to register RTC device: %d\n", ret);
> +               return ret;
> +       }
> +
> +       virq = irq_create_mapping(max8997->irq_domain, MAX8997_PMICIRQ_RTCA1);
> +       if (!virq) {
> +               dev_err(&pdev->dev, "Failed to create mapping alarm IRQ\n");
   +               rtc_device_unregister(&pdev->dev, &max8997_rtc_ops) ?
> +               return ret;
> +       }
> +       info->virq = virq;
> +
> +       ret = request_threaded_irq(virq, NULL, max8997_rtc_alarm_irq, 0,
> +                               "rtc-alarm0", info);
> +       if (ret < 0) {
> +               dev_err(&pdev->dev, "Failed to request alarm IRQ: %d: %d\n",
> +                       info->virq, ret);
   +               here unregistering the rtc dev too?
> +               return ret;
> +       }
> +
> +       return ret;
> +}
> +


Thanks,
