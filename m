Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934003AbaD2Rgi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Apr 2014 13:36:38 -0400
Received: from mail-ve0-f179.google.com ([209.85.128.179]:64609 "EHLO
	mail-ve0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932491AbaD2Rge (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Apr 2014 13:36:34 -0400
MIME-Version: 1.0
In-Reply-To: <CAAYSxhpr5rvfrsihYLCv4YK5sYZ96f6rWkzW9Vp_iBqqGhGXCA@mail.gmail.com>
References: <1398451211-19693-1-git-send-email-tim.kryger@linaro.org>
	<CAL1qeaFFpVNRBqmS4j1Vx1-NKX3VjJuDrVNYTsT91nB_bQ7HJA@mail.gmail.com>
	<CAAYSxhpr5rvfrsihYLCv4YK5sYZ96f6rWkzW9Vp_iBqqGhGXCA@mail.gmail.com>
Date: Tue, 29 Apr 2014 10:36:33 -0700
X-Google-Sender-Auth: PqZXhwsqFfqEMqK5S6QUsRpLl4A
Message-ID: <CAL1qeaH6uzMX-3P7D5aZRx1aZyHyMX0wz=zKPrBOxPcQJedYdw@mail.gmail.com>
Subject: Re: [PATCH RESEND] mmc: core: Improve support for deferred regulators
From: Andrew Bresticker <abrestic@chromium.org>
To: Tim Kryger <tim.kryger@linaro.org>
Cc: Chris Ball <chris@printf.net>, Ulf Hansson <ulf.hansson@linaro.org>,
        Mike Looijmans <mike.looijmans@topic.nl>,
        Linux MMC List <linux-mmc@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 29, 2014 at 10:00 AM, Tim Kryger <tim.kryger@linaro.org> wrote:
> On Fri, Apr 25, 2014 at 2:33 PM, Andrew Bresticker
> <abrestic@chromium.org> wrote:
>>>
>>> -       if (IS_ERR(supply))
>>> -               return PTR_ERR(supply);
>>> +       if (IS_ERR(mmc->supply.vmmc)) {
>>> +               if (PTR_ERR(mmc->supply.vmmc) == -EPROBE_DEFER)
>>> +                       return -EPROBE_DEFER;
>>> +               dev_info(dev, "No vmmc regulator found\n");
>>> +       } else {
>>> +               ret = mmc_regulator_get_ocrmask(mmc->supply.vmmc);
>>> +               if (ret > 0)
>>> +                       mmc->ocr_avail = ret;
>>> +               else
>>> +                       dev_warn(dev, "Failed getting OCR mask: %d\n", ret);
>>> +       }
>>
>> I think we also need to handle the case where supply is NULL, i.e.
>> !CONFIG_REGULATOR.  The SDHCI driver, for example, calls
>> regulator_is_supported_voltage() which will always return false on
>> NULL regulators.  Perhaps we should set the supplies to
>> ERR_PTR(-ENODEV) in that case?
>
> As of v3.15-rc3, this function would do the right thing because
> df7926f modified the regulator get optional stubs to return -ENODEV in
> the !CONFIG_REGULATOR case.  However, this implementation of
> mmc_regulator_get_supply doesn't actually get built for that case.  A
> stub implementation is used instead.  Presently that stub
> mmc_regulator_get_supply does nothing other than return zero but
> perhaps it should initialize the supplies as you suggest.
> Alternatively, the stub could be eliminated such that this
> implementation is used in all cases.  Do you have a preference?

Since this now behaves correctly regardless of CONFIG_REGULATOR, then
perhaps it's best to eliminate the stub.

Thanks,
Andrew

>
> -Tim
