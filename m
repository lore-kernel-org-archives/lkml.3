Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755897Ab3AKWM1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jan 2013 17:12:27 -0500
Received: from mail-ee0-f43.google.com ([74.125.83.43]:48472 "EHLO
	mail-ee0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754607Ab3AKWMZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jan 2013 17:12:25 -0500
Message-ID: <50F08E44.3050500@gmail.com>
Date: Fri, 11 Jan 2013 23:12:20 +0100
From: Sylwester Nawrocki <sylvester.nawrocki@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:11.0) Gecko/20120412 Thunderbird/11.0.1
MIME-Version: 1.0
To: Doug Anderson <dianders@chromium.org>
CC: linux-i2c@vger.kernel.org,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Kukjin Kim <kgene.kim@samsung.com>, Olof Johansson <olof@lixom.net>,
        Thomas Abraham <thomas.abraham@linaro.org>,
        Padmavathi Venna <padma.v@samsung.com>,
        Ben Dooks <ben-linux@fluff.org>, Wolfram Sang <w.sang@pengutronix.de>,
        linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org,
        Haojian Zhuang <haojian.zhuang@gmail.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Karol Lewandowski <k.lewandowsk@samsung.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [REPOST PATCH 2/2] i2c: pxa: Use i2c-core to get bus number now
References: <1353522362-25519-2-git-send-email-dianders@chromium.org> <1357927027-4857-1-git-send-email-dianders@chromium.org> <1357927027-4857-3-git-send-email-dianders@chromium.org>
In-Reply-To: <1357927027-4857-3-git-send-email-dianders@chromium.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On 01/11/2013 06:57 PM, Doug Anderson wrote:
> The commit: "i2c-core: dt: Pick i2c bus number from i2c alias if
> present" adds support for automatically picking the bus number based
> on the alias ID.  Remove the now unnecessary code from i2c-pxa that
> did the same thing.
>
> Signed-off-by: Doug Anderson<dianders@chromium.org>
> Acked-by: Haojian Zhuang<haojian.zhuang@gmail.com>
> ---
>   drivers/i2c/busses/i2c-pxa.c |    8 +-------
>   1 files changed, 1 insertions(+), 7 deletions(-)
>
> diff --git a/drivers/i2c/busses/i2c-pxa.c b/drivers/i2c/busses/i2c-pxa.c
> index 1034d93..8ee9fa0 100644
> --- a/drivers/i2c/busses/i2c-pxa.c
> +++ b/drivers/i2c/busses/i2c-pxa.c
> @@ -1053,16 +1053,10 @@ static int i2c_pxa_probe_dt(struct platform_device *pdev, struct pxa_i2c *i2c,
>   	struct device_node *np = pdev->dev.of_node;
>   	const struct of_device_id *of_id =
>   			of_match_device(i2c_pxa_dt_ids,&pdev->dev);
> -	int ret;
>
>   	if (!of_id)
>   		return 1;
> -	ret = of_alias_get_id(np, "i2c");
> -	if (ret<  0) {
> -		dev_err(&pdev->dev, "failed to get alias id, errno %d\n", ret);
> -		return ret;
> -	}
> -	pdev->id = ret;
> +	pdev->id = -1;

I think assignments like this are illegal. At this point the device is
already registered and modifying pdev->id can cause issues at the core
code.

It might be better to have the bus number stored in struct pxa_i2c,
initialized with pdev->id value for non-dt and now with -1 for dt case.

I realize it is not something your patch is intended to deal with,
but since you're touching this code maybe it's worth to fix that issue
as well ?

--

Thanks,
Sylwester
