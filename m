Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753662Ab3JLCWS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Oct 2013 22:22:18 -0400
Received: from mailout1.w1.samsung.com ([210.118.77.11]:20034 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751318Ab3JLCWI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Oct 2013 22:22:08 -0400
X-AuditID: cbfec7f4-b7f0a6d000007b1b-3b-5258b24d4fa0
From: Tomasz Figa <t.figa@samsung.com>
To: Naveen Krishna Chatradhi <ch.naveen@samsung.com>
Cc: linux-i2c@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-samsung-soc@vger.kernel.org, wsa@the-dreams.de,
        khali@linux-fr.org, ben-linux@fluff.org, grant.likely@secretlab.ca,
        devicetree-discuss@lists.ozlabs.org, sjg@chromium.org,
        naveenkrishna.ch@gmail.com, broonie@opensource.wolfsonmicro.com,
        diander@google.com, cpgs@samsung.com
Subject: Re: [PATCH] i2c: s3c2410: dont need CPU_FREQ transitions for exynos
 series
Date: Sat, 12 Oct 2013 04:22:04 +0200
Message-id: <3245175.os31ym2KFi@amdn883>
User-Agent: KMail/4.10.5 (Linux/3.8.0-31-generic; KDE/4.10.5; x86_64; ; )
In-reply-to: <1381490814-20890-1-git-send-email-ch.naveen@samsung.com>
References: <1381490814-20890-1-git-send-email-ch.naveen@samsung.com>
MIME-version: 1.0
Content-transfer-encoding: 7Bit
Content-type: text/plain; charset=us-ascii
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrJLMWRmVeSWpSXmKPExsVy+t/xq7q+myKCDHpatSwmrTvAZPFv9ik2
	i7vPDzNavDykaXFg9kNWi77uNUwWr85sZLNo/Btp0fH3C6PF5V1z2CxmnN/HZLFo239mi29b
	tjFarDwxi9mBz2N2w0UWj7+rXjB77Jx1l91jwaZSjysNJ9k8zs9YyOjxcuJvNo++LasYPX6+
	1PE4eeoJi8fnTXIB3FFcNimpOZllqUX6dglcGZ/fdLEWTOStaPjTzNLAeIGri5GTQ0LARGLz
	yX9sELaYxIV764FsLg4hgaWMEjfunmMBSQgJtDNJPLpjAmKzCahJfG54BNYgAtR8/NUZdpAG
	ZoG7TBKNN5+zgySEBUIlvr1ZygxiswioShy+9Z8JxOYV0JBYcPwdaxcjB4eogKdE91FDkDCn
	gJvE+66DjCBhIQFXie7rahDVghI/Jt8DO4FZQF5i3/6prBC2lsT6nceZJjAKzEJSNgtJ2Swk
	ZQsYmVcxiqaWJhcUJ6XnGuoVJ+YWl+al6yXn525ihETXlx2Mi49ZHWIU4GBU4uGdUBkRJMSa
	WFZcmXuIUYKDWUmE94A+UIg3JbGyKrUoP76oNCe1+BAjEwenVANj/26jW29z1myu29E2bffL
	SD4r1W+vf3Am2VjM4DOJvOFxeg7n7fXR545qzXk9ze658r/z3Ms6q88k3z6V7sv0p4b5rfnN
	hqi1Z4x+5TOHhNp9m8V9oXD1j8TFuk/jqv5ETV6+9vGK22/62wwruJPjBd0tL923mKR27UG9
	BKO5ql9omKH/reZwJZbijERDLeai4kQAwvmdBowCAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Naveen,

On Friday 11 of October 2013 16:56:54 Naveen Krishna Chatradhi wrote:
> The exynos5 i2c clock is based on a fixed 66 MHz peripheral clock, and
> therefore is completely independent of the cpu frequency.
> Thus, registering for a CPU freq notifier is very wasteful.
> 
> This patch modifes the code such that, i2c bus registers to
> cpu_freq_transition only for non Exynos SoCs.
> 
> This change should save a bunch of cpufreq transitions calls
> which does not apply to exynos SoCs.

The idea is fine, although...

> Signed-off-by: Naveen Krishna Chatradhi <ch.naveen@samsung.com>
> ---
>  drivers/i2c/busses/i2c-s3c2410.c |    4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/i2c/busses/i2c-s3c2410.c b/drivers/i2c/busses/i2c-s3c2410.c
> index cab1c91..d062fa7 100644
> --- a/drivers/i2c/busses/i2c-s3c2410.c
> +++ b/drivers/i2c/busses/i2c-s3c2410.c
> @@ -123,7 +123,7 @@ struct s3c24xx_i2c {
>  	struct s3c2410_platform_i2c	*pdata;
>  	int			gpios[2];
>  	struct pinctrl          *pctrl;
> -#ifdef CONFIG_CPU_FREQ
> +#if defined(CONFIG_CPU_FREQ) && !defined(CONFIG_ARCH_EXYNOS)

...this is not a good coding practice, especially when already having
multiplatform kernels in sight.

The best way would be to check on which SoC we are running at runtime,
but since this might need changing a lot of code, then at least I would
change this from !defined(EXYNOS) to defined(S3C24XX), so it is not being
compiled in when S3C24XX support is not enabled and if it's enabled then
the notifier will be registered as a safe fallback that will run correctly
on all platforms.

Best regards,
Tomasz

