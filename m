Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932097AbbANPNS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jan 2015 10:13:18 -0500
Received: from mail-ig0-f179.google.com ([209.85.213.179]:34567 "EHLO
	mail-ig0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753098AbbANPNF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jan 2015 10:13:05 -0500
MIME-Version: 1.0
In-Reply-To: <1421163897-8020-7-git-send-email-xlpang@126.com>
References: <1421163897-8020-1-git-send-email-xlpang@126.com>
	<1421163897-8020-7-git-send-email-xlpang@126.com>
Date: Wed, 14 Jan 2015 23:13:04 +0800
Message-ID: <CADcy93W3OcAN4UWLNFmf2dWehk2=90CagWtrumvqZBu4GYEN+A@mail.gmail.com>
Subject: Re: [RFC PATCH v2 6/9] rtc/mxc: Modify rtc_update_alarm() not to
 touch the alarm time
From: Xunlei Pang <pang.xunlei@linaro.org>
To: Xunlei Pang <xlpang@126.com>
Cc: lkml <linux-kernel@vger.kernel.org>, John Stultz <john.stultz@linaro.org>,
        Arnd Bergmann <arnd.bergmann@linaro.org>,
        "rtc-linux@googlegroups.com" <rtc-linux@googlegroups.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Alessandro Zummo <a.zummo@towertech.it>,
        Fabio Estevam <fabio.estevam@freescale.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Cc Fabio Estevam <fabio.estevam@freescale.com>

On 13 January 2015 at 23:44, Xunlei Pang <xlpang@126.com> wrote:
> From: Xunlei Pang <pang.xunlei@linaro.org>
>
> rtc_class_ops's set_alarm() shouldn't deal with the alarm date,
> as this is handled in the rtc core.
>
> See rtc_dev_ioctl()'s RTC_ALM_SET and RTC_WKALM_SET cases.
>
> Signed-off-by: Xunlei Pang <pang.xunlei@linaro.org>
> ---
>  drivers/rtc/rtc-mxc.c | 22 ++++------------------
>  1 file changed, 4 insertions(+), 18 deletions(-)
>
> diff --git a/drivers/rtc/rtc-mxc.c b/drivers/rtc/rtc-mxc.c
> index 3c3f8d1..a7b218f 100644
> --- a/drivers/rtc/rtc-mxc.c
> +++ b/drivers/rtc/rtc-mxc.c
> @@ -173,29 +173,18 @@ static void set_alarm_or_time(struct device *dev, int time_alarm, u32 time)
>   * This function updates the RTC alarm registers and then clears all the
>   * interrupt status bits.
>   */
> -static int rtc_update_alarm(struct device *dev, struct rtc_time *alrm)
> +static void rtc_update_alarm(struct device *dev, struct rtc_time *alrm)
>  {
> -       struct rtc_time alarm_tm, now_tm;
> -       unsigned long now, time;
> +       unsigned long time;
>         struct platform_device *pdev = to_platform_device(dev);
>         struct rtc_plat_data *pdata = platform_get_drvdata(pdev);
>         void __iomem *ioaddr = pdata->ioaddr;
>
> -       now = get_alarm_or_time(dev, MXC_RTC_TIME);
> -       rtc_time_to_tm(now, &now_tm);
> -       alarm_tm.tm_year = now_tm.tm_year;
> -       alarm_tm.tm_mon = now_tm.tm_mon;
> -       alarm_tm.tm_mday = now_tm.tm_mday;
> -       alarm_tm.tm_hour = alrm->tm_hour;
> -       alarm_tm.tm_min = alrm->tm_min;
> -       alarm_tm.tm_sec = alrm->tm_sec;
> -       rtc_tm_to_time(&alarm_tm, &time);
> +       rtc_tm_to_time(alrm, &time);
>
>         /* clear all the interrupt status bits */
>         writew(readw(ioaddr + RTC_RTCISR), ioaddr + RTC_RTCISR);
>         set_alarm_or_time(dev, MXC_RTC_ALARM, time);
> -
> -       return 0;
>  }
>
>  static void mxc_rtc_irq_enable(struct device *dev, unsigned int bit,
> @@ -346,11 +335,8 @@ static int mxc_rtc_set_alarm(struct device *dev, struct rtc_wkalrm *alrm)
>  {
>         struct platform_device *pdev = to_platform_device(dev);
>         struct rtc_plat_data *pdata = platform_get_drvdata(pdev);
> -       int ret;
>
> -       ret = rtc_update_alarm(dev, &alrm->time);
> -       if (ret)
> -               return ret;
> +       rtc_update_alarm(dev, &alrm->time);
>
>         memcpy(&pdata->g_rtc_alarm, &alrm->time, sizeof(struct rtc_time));
>         mxc_rtc_irq_enable(dev, RTC_ALM_BIT, alrm->enabled);
> --
> 1.9.1
>
>
