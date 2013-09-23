Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753012Ab3IWWui (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Sep 2013 18:50:38 -0400
Received: from mail-ea0-f172.google.com ([209.85.215.172]:43309 "EHLO
	mail-ea0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752095Ab3IWWuf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Sep 2013 18:50:35 -0400
Message-ID: <5240C5B5.4090702@gmail.com>
Date: Tue, 24 Sep 2013 00:50:29 +0200
From: Sylwester Nawrocki <sylvester.nawrocki@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:11.0) Gecko/20120412 Thunderbird/11.0.1
MIME-Version: 1.0
To: Andrew Bresticker <abrestic@chromium.org>
CC: Tomasz Figa <tomasz.figa@gmail.com>, Mark Rutland <mark.rutland@arm.com>,
        Yadwinder Singh Brar <yadi.brar@samsung.com>,
        linux-doc@vger.kernel.org, Padmavathi Venna <padma.v@samsung.com>,
        Tomasz Figa <t.figa@samsung.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Tushar Behera <tushar.behera@linaro.org>,
        linux-samsung-soc <linux-samsung-soc@vger.kernel.org>,
        Russell King <linux@arm.linux.org.uk>,
        Sachin Kamat <sachin.kamat@linaro.org>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Grant Likely <grant.likely@linaro.org>, devicetree@vger.kernel.org,
        Pawel Moll <pawel.moll@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Rob Herring <rob.herring@calxeda.com>,
        Kukjin Kim <kgene.kim@samsung.com>,
        Mike Turquette <mturquette@linaro.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Rahul Sharma <rahul.sharma@samsung.com>, Jiri Kosina <jkosina@suse.cz>
Subject: Re: [PATCH 1/6] clk: exynos-audss: convert to platform device
References: <1379711637-5226-1-git-send-email-abrestic@chromium.org> <1530327.jvk44KuFQA@flatron> <CAL1qeaGjUTrfDaAr1rgsgDaZscjaV7tqi3Jd_-zo2sMtCCFSAQ@mail.gmail.com>
In-Reply-To: <CAL1qeaGjUTrfDaAr1rgsgDaZscjaV7tqi3Jd_-zo2sMtCCFSAQ@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On 09/23/2013 11:25 PM, Andrew Bresticker wrote:
>>> +static int exynos_audss_clk_remove(struct platform_device *pdev)
>>> +{
>>> +     of_clk_del_provider(pdev->dev.of_node);
>>> +
>>> +     return 0;
>>>   }
>>
>> Don't we need to unregister all the registered clocks in remove? This also
>> leads to another question: Do we even need removal support for this
>> driver?
>
> Agreed - I don't think we should support removal of this device, but
> it looks like __device_release_driver() just ignores the lack of a
> remove callback or the return value from remove.  I suppose we could
> just yell that removal is not supported if it is ever attempted.

That might be a good idea, without proper remove() method deferred
probing will also not work. I'd assume there should be only, e.g.
WARN() in the remove() callback or it should be properly implemented,
with clk_unregister() call for each currently registered clock.

Note that clk_unregister() is currently not implemented and removal
of this driver cannot be properly supported at the moment anyway.

Not sure what's more appropriate, it's probably better to add
clk_unregister() calls. This would be effectively a dead code though,
as long as core_initcall is used.

>>> +static int __init exynos_audss_clk_init(void)
>>> +{
>>> +     return platform_driver_register(&exynos_audss_clk_driver);
>>> +}
>>> +core_initcall(exynos_audss_clk_init);
>>
>> Does it need to be core_initcall? Drivers depending on clocks provided by
>> this driver should be able to defer probing if they are probed before this
>> driver.
>
> Unfortunately there are a couple of issues with making this a module_initcall:
>      1. On the Exynos5420, the AudioSS block provides the apb_pclk gate
> for the ADMA bus, which is probed at postcore_initcall time and does
> not support deferred probing, and
>      2. the common clock framework doesn't differentiate between the
> clock not being specified at all and the clock being specified, but
> the provider not being registered yet (i.e. the case where probe
> deferral would be appropriate) - it just returns ENOENT in both cases.

AFAICS this shouldn't be difficult to improve. I guess it has not been
properly addressed so far because there is currently no properly working
modular clock provider drivers, using the common clock framework, yet.
Unless someone bits me to it, I might have a look at that, as I also found
it a bit it inconvenient.

--
Regards,
Sylwester
