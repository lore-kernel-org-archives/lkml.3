Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751780AbaK1Qtv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Nov 2014 11:49:51 -0500
Received: from mail-ig0-f174.google.com ([209.85.213.174]:65364 "EHLO
	mail-ig0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751117AbaK1Qtt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Nov 2014 11:49:49 -0500
MIME-Version: 1.0
In-Reply-To: <1417089760-26848-3-git-send-email-pang.xunlei@linaro.org>
References: <1417089760-26848-1-git-send-email-pang.xunlei@linaro.org>
	<1417089760-26848-3-git-send-email-pang.xunlei@linaro.org>
Date: Sat, 29 Nov 2014 00:49:48 +0800
Message-ID: <CADcy93U6LA0RfX4yKruWpay7eT0qU3p9RvSEmxoupG5KC+u4-Q@mail.gmail.com>
Subject: Re: [RFC PATCH 2/4] rtc: Convert rtc_class_ops.set_mmss() to use time64_t
From: "pang.xunlei" <pang.xunlei@linaro.org>
To: lkml <linux-kernel@vger.kernel.org>
Cc: "rtc-linux@googlegroups.com" <rtc-linux@googlegroups.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Alessandro Zummo <a.zummo@towertech.it>,
        Sven Schnelle <svens@stackframe.org>,
        Xunlei Pang <pang.xunlei@linaro.org>,
        John Stultz <john.stultz@linaro.org>,
        Arnd Bergmann <arnd.bergmann@linaro.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 27 November 2014 at 20:02, Xunlei Pang <pang.xunlei@linaro.org> wrote:
> Currently the rtc_class_op's set_mmss() function takes a 32bit second
> value (on 32bit systems), which is problematic for dates past y2038.
>
> This patch resolves it by changing the interface and all users to use
> y2038 safe time64_t.
>
> Cc: John Stultz <john.stultz@linaro.org>
> Cc: Arnd Bergmann <arnd.bergmann@linaro.org>
> Signed-off-by: Xunlei Pang <pang.xunlei@linaro.org>
>
> diff --git a/drivers/rtc/rtc-ds2404.c b/drivers/rtc/rtc-ds2404.c
> index fc209dc..ec50757 100644
> --- a/drivers/rtc/rtc-ds2404.c
> +++ b/drivers/rtc/rtc-ds2404.c
> @@ -210,9 +210,16 @@ static int ds2404_read_time(struct device *dev, struct rtc_time *dt)
>         return rtc_valid_tm(dt);
>  }
>
> -static int ds2404_set_mmss(struct device *dev, unsigned long secs)
> +static int ds2404_set_mmss(struct device *dev, time64_t secs)
>  {
> +       /*
> +        * y2106 issue:
> +        *   On 32bit systems the time64_t secs value gets cast to
> +        *   a 32bit long, and thus we can only write a maximum value
> +        *   of y2016
> +        */
>         u32 time = cpu_to_le32(secs);
> +
>         ds2404_write_memory(dev, 0x203, 4, (u8 *)&time);

Hi Sven,

Does this rtc hardware support ds2404_write_memory() with length > 4,
i.e. y2106 safe?

Thanks,
Xunlei
>         return 0;
>  }
