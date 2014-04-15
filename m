Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753471AbaDOT7l (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Apr 2014 15:59:41 -0400
Received: from mail-ve0-f180.google.com ([209.85.128.180]:43263 "EHLO
	mail-ve0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751022AbaDOT7i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Apr 2014 15:59:38 -0400
MIME-Version: 1.0
In-Reply-To: <534D7A5D.9090707@wwwdotorg.org>
References: <1397526163-20126-1-git-send-email-abrestic@chromium.org>
	<1397526163-20126-4-git-send-email-abrestic@chromium.org>
	<534D7A5D.9090707@wwwdotorg.org>
Date: Tue, 15 Apr 2014 12:59:37 -0700
X-Google-Sender-Auth: oLHDrdnUBvD6Gz8UEwaAWqInk2k
Message-ID: <CAL1qeaEGpz-9rOtp4fAHFz8KG2fCscFsqu1tbi2d9mxTM8yHQQ@mail.gmail.com>
Subject: Re: [PATCH 3/4] mmc: sdhci: defer probing on regulator_get_optional() failures
From: Andrew Bresticker <abrestic@chromium.org>
To: Stephen Warren <swarren@wwwdotorg.org>
Cc: Thierry Reding <thierry.reding@gmail.com>, Chris Ball <chris@printf.net>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        "linux-mmc@vger.kernel.org" <linux-mmc@vger.kernel.org>,
        linux-tegra@vger.kernel.org,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 15, 2014 at 11:28 AM, Stephen Warren <swarren@wwwdotorg.org> wrote:
> On 04/14/2014 07:42 PM, Andrew Bresticker wrote:
>> If regulator_get_optional() returns EPROBE_DEFER, it indicates
>> that the regulator may show up later (e.g. the DT property is
>> present but the corresponding regulator may not have probed).
>> Instead of continuing without the regulator, return EPROBE_DEFER
>> from sdhci_add_host().  Also, fix regulator leaks in the error
>> paths in sdhci_add_host().
>
>> diff --git a/drivers/mmc/host/sdhci.c b/drivers/mmc/host/sdhci.c
>
>>       if (IS_ERR_OR_NULL(host->vqmmc)) {
>
> This is a pre-existing condition, but ick: Why doesn't this test either
> IS_ERR() /or/ == NULL, but not both. On error, the regulator API should
> either return and error-point or return NULL, so that client code
> shouldn't need to check for both.

Unfortunately, this is necessary.  regulator_get() returns NULL if
!CONFIG_REGULATOR and we do not want to call
regulator_is_supported_voltage() in this case since it will always
return false, causing sdhci_add_host() to disable UHS modes.
Alternatively, we could put the regulator_is_supported_voltage() check
wihin an #ifdef CONFIG_REGULATOR, as is done when checking supported
vmmc voltages below.

>
>> +put_vmmc:
>> +     if (host->vmmc)
>> +             regulator_put(host->vmmc);
>> +put_vqmmc:
>> +     if (host->vqmmc)
>> +             regulator_put(host->vqmmc);
>
> If IS_ERR_OR_NULL() really is required above, it should be used here
> too. More likely, I hope you need to replace if (host->vmmc) with if
> (!IS_ERR(host->vmmc)).

host->vmmc and host->vqmmc are set to NULL in the case of IS_ERR(), so
the IS_ERR() check here isn't necessary.

>
> I wonder if fixing this would help solve the crashes that Alex saw?

I believe the crash Alex is seeing is due to a race between tearing
down the sdhci driver on probe deferral and the card-detect IRQ.
Looking at it now.
