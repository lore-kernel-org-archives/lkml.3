Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757034AbbAHRny (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Jan 2015 12:43:54 -0500
Received: from mailapp01.imgtec.com ([195.59.15.196]:47804 "EHLO
	mailapp01.imgtec.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751591AbbAHRnw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Jan 2015 12:43:52 -0500
Message-ID: <54AEC158.5070109@imgtec.com>
Date: Thu, 8 Jan 2015 14:41:44 -0300
From: Ezequiel Garcia <ezequiel.garcia@imgtec.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: Vladimir Zapolskiy <vladimir_zapolskiy@mentor.com>,
        Andrew Bresticker <abrestic@chromium.org>,
        Thierry Reding <thierry.reding@gmail.com>,
        "James Hartley" <james.hartley@imgtec.com>,
        Arnd Bergmann <arnd@arndb.de>,
        "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>
CC: <devicetree@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-pwm@vger.kernel.org>,
        Naidu Tellapati <Naidu.Tellapati@imgtec.com>,
        Sai Masarapu <Sai.Masarapu@imgtec.com>
Subject: Re: [PATCH v7 1/4] pwm: Imagination Technologies PWM DAC driver
References: <1420651215-3836-1-git-send-email-ezequiel.garcia@imgtec.com> <1420651215-3836-2-git-send-email-ezequiel.garcia@imgtec.com> <54AEA727.40100@mentor.com>
In-Reply-To: <54AEA727.40100@mentor.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.100.200.154]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 01/08/2015 12:49 PM, Vladimir Zapolskiy wrote:
> Hi Ezequiel,
> 
> On 07.01.2015 19:20, Ezequiel Garcia wrote:
>> From: Naidu Tellapati <Naidu.Tellapati@imgtec.com>
>>
>> The Pistachio SOC from Imagination Technologies includes a Pulse Width
>> Modulation DAC which produces 1 to 4 digital bit-outputs which represent
>> digital waveforms. These PWM outputs are primarily in charge of controlling
>> backlight LED devices.
>>
>> Reviewed-by: Andrew Bresticker <abrestic@chromium.org>
>> Signed-off-by: Naidu Tellapati <Naidu.Tellapati@imgtec.com>
>> Signed-off-by: Sai Masarapu <Sai.Masarapu@imgtec.com>
>> Signed-off-by: Ezequiel Garcia <ezequiel.garcia@imgtec.com>
>> ---
>>  drivers/pwm/Kconfig   |  13 +++
>>  drivers/pwm/Makefile  |   1 +
>>  drivers/pwm/pwm-img.c | 250 ++++++++++++++++++++++++++++++++++++++++++++++++++
>>  3 files changed, 264 insertions(+)
>>  create mode 100644 drivers/pwm/pwm-img.c
>>
> 
> [snip]
> 
>> +static int img_pwm_probe(struct platform_device *pdev)
>> +{
>> +	int ret;
>> +	struct resource *res;
>> +	struct img_pwm_chip *pwm;
>> +
>> +	pwm = devm_kzalloc(&pdev->dev, sizeof(*pwm), GFP_KERNEL);
>> +	if (!pwm)
>> +		return -ENOMEM;
>> +
>> +	pwm->dev = &pdev->dev;
>> +
>> +	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
>> +	pwm->base = devm_ioremap_resource(&pdev->dev, res);
>> +	if (IS_ERR(pwm->base))
>> +		return PTR_ERR(pwm->base);
>> +
>> +	pwm->periph_regs = syscon_regmap_lookup_by_phandle(pdev->dev.of_node,
>> +							   "img,cr-periph");
>> +	if (IS_ERR(pwm->periph_regs))
>> +		return PTR_ERR(pwm->periph_regs);
>> +
>> +	pwm->sys_clk = devm_clk_get(&pdev->dev, "sys");
>> +	if (IS_ERR(pwm->sys_clk)) {
>> +		dev_err(&pdev->dev, "failed to get system clock\n");
>> +		return PTR_ERR(pwm->sys_clk);
>> +	}
>> +
>> +	pwm->pwm_clk = devm_clk_get(&pdev->dev, "pwm");
>> +	if (IS_ERR(pwm->pwm_clk)) {
>> +		dev_err(&pdev->dev, "failed to get pwm clock\n");
>> +		return PTR_ERR(pwm->pwm_clk);
>> +	}
>> +
>> +	ret = clk_prepare_enable(pwm->sys_clk);
>> +	if (ret < 0) {
>> +		dev_err(&pdev->dev, "could not prepare or enable sys clock\n");
>> +		return ret;
>> +	}
>> +
>> +	ret = clk_prepare_enable(pwm->pwm_clk);
>> +	if (ret < 0) {
>> +		dev_err(&pdev->dev, "could not prepare or enable pwm clock\n");
>> +		goto disable_sysclk;
>> +	}
>> +
>> +	pwm->chip.dev = &pdev->dev;
>> +	pwm->chip.ops = &img_pwm_ops;
>> +	pwm->chip.base = -1;
>> +	pwm->chip.npwm = 4;
>> +
>> +	ret = pwmchip_add(&pwm->chip);
>> +	if (ret < 0) {
>> +		dev_err(&pdev->dev, "pwmchip_add failed: %d\n", ret);
>> +		goto disable_pwmclk;
>> +	}
>> +
>> +	platform_set_drvdata(pdev, pwm);
>> +
>> +disable_pwmclk:
>> +	clk_disable_unprepare(pwm->pwm_clk);
>> +disable_sysclk:
>> +	clk_disable_unprepare(pwm->sys_clk);
>> +
>> +	return 0;
> 
> return ret on error paths?
> 
> Also should you reenable sys and pwm clocks after successful driver
> registration?
> 

Argh, that's definitely bogus. I must have missed it.

Thanks for the catch!
-- 
Ezequiel
