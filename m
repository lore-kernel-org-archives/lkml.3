Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757331AbbA2NxT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Jan 2015 08:53:19 -0500
Received: from bhuna.collabora.co.uk ([93.93.135.160]:47235 "EHLO
	bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755610AbbA2NxR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Jan 2015 08:53:17 -0500
Message-ID: <54CA3B46.20204@collabora.co.uk>
Date: Thu, 29 Jan 2015 14:53:10 +0100
From: Javier Martinez Canillas <javier.martinez@collabora.co.uk>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Icedove/31.2.0
MIME-Version: 1.0
To: Ulf Hansson <ulf.hansson@linaro.org>
CC: Kukjin Kim <kgene@kernel.org>, Doug Anderson <dianders@chromium.org>,
        Olof Johansson <olof@lixom.net>, Arend van Spriel <arend@broadcom.com>,
        Srinivas Kandagatla <srinivas.kandagatla@linaro.org>,
        linux-samsung-soc <linux-samsung-soc@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        linux-mmc <linux-mmc@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2 4/6] mmc: pwrseq_simple: Add optional reference clock
 support
References: <1422468953-7594-1-git-send-email-javier.martinez@collabora.co.uk>	<1422468953-7594-5-git-send-email-javier.martinez@collabora.co.uk> <CAPDyKFommNu7oscgmhwMpT-5KYN9b6d1xvt513_0qWE=HEGbow@mail.gmail.com>
In-Reply-To: <CAPDyKFommNu7oscgmhwMpT-5KYN9b6d1xvt513_0qWE=HEGbow@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Ulf,

Thanks a lot for your feedback.

On 01/29/2015 02:05 PM, Ulf Hansson wrote:
>>
>>  struct mmc_pwrseq_simple {
>>         struct mmc_pwrseq pwrseq;
>> +       struct clk *ext_clk;
> 
> You need to add a bool, maybe call it clk_enabled;  See why below.
>

Ok
 
>>         int nr_gpios;
>>         struct gpio_desc *reset_gpios[0];
>>  };
>> @@ -39,6 +41,9 @@ static void mmc_pwrseq_simple_pre_power_on(struct mmc_host *host)
>>         struct mmc_pwrseq_simple *pwrseq = container_of(host->pwrseq,
>>                                         struct mmc_pwrseq_simple, pwrseq);
>>
>> +       if (!IS_ERR(pwrseq->ext_clk))
>> +               clk_prepare_enable(pwrseq->ext_clk);
>> +
> 
> There are no guarantee that the ->mmc_pwrseq_simple_pre_power_on()
> will be invoked prior ->mmc_pwrseq_simple_power_off().
>

Got it, I didn't know that mmc_pwrseq_simple_power_off() could be invoked.
without mmc_pwrseq_simple_pre_power_on() not being called before.

> That means you need to keep track of if you have gated/ungated the
> clock. In other words check pwrseq->clk_enabled. That will prevent
> potential clk unbalance issues.

Yes, I'll change to check for the boolean in _simple_power_off() and
_post_power_on() then.

>> @@ -85,6 +104,14 @@ int mmc_pwrseq_simple_alloc(struct mmc_host *host, struct device *dev)
>>         if (!pwrseq)
>>                 return -ENOMEM;
>>
>> +       pwrseq->ext_clk = clk_get(dev, "ext_clock");
>> +       if (IS_ERR(pwrseq->ext_clk) &&
>> +           PTR_ERR(pwrseq->ext_clk) != -ENOENT &&
>> +           PTR_ERR(pwrseq->ext_clk) != -ENOSYS) {
> 
> I don't think you can get -ENOSYS.
> 

You are right, I'll remove that.

Best regards,
Javier
