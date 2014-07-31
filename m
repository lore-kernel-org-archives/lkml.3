Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751679AbaGaNWN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jul 2014 09:22:13 -0400
Received: from mail-ob0-f178.google.com ([209.85.214.178]:52316 "EHLO
	mail-ob0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751277AbaGaNWK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jul 2014 09:22:10 -0400
MIME-Version: 1.0
In-Reply-To: <53DA37EA.7010306@gmail.com>
References: <1406805732-17372-1-git-send-email-hsnaves@gmail.com>
 <1406805732-17372-2-git-send-email-hsnaves@gmail.com> <53DA37EA.7010306@gmail.com>
From: Humberto Naves <hsnaves@gmail.com>
Date: Thu, 31 Jul 2014 15:13:37 +0200
Message-ID: <CAEe5pB-FnkY8E9qPjy+6R5ausEEx-pO2wupWYZO8Lscb2BAwiw@mail.gmail.com>
Subject: Re: [PATCHv2 1/5] clk: samsung: exynos5410: Add NULL pointer checks
 in clock init
To: Tomasz Figa <tomasz.figa@gmail.com>
Cc: linux-samsung-soc <linux-samsung-soc@vger.kernel.org>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-doc@vger.kernel.org, devicetree@vger.kernel.org,
        Kukjin Kim <kgene.kim@samsung.com>, Tomasz Figa <t.figa@samsung.com>,
        Thomas Abraham <ta.omasab@gmail.com>,
        Andreas Farber <afaerber@suse.de>,
        Randy Dunlap <rdunlap@infradead.org>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I am bit confused by your response: first you mentioned that I should
remove the NULL check for variable np, but later on you suggested that
I should rearrange the conditional statement to avoid adding more
indentation. My guess is that I should remove that if statement
altogether?

Regarding the ctx variable, should I still remove the NULL check? As
you said, in the near future samsung_clk_init() won't panic anymore,
and keeping the check in place won't hurt anybody.

Best,
Humberto

On Thu, Jul 31, 2014 at 2:34 PM, Tomasz Figa <tomasz.figa@gmail.com> wrote:
> Hi Humberto,
>
> Please see my comments inline.
>
> On 31.07.2014 13:22, Humberto Silva Naves wrote:
>> Added NULL pointer checks for device_node input parameter and
>> for the samsung_clk_provider context returned by samsung_clk_init.
>> Even though the *current* samsung_clk_init function never returns
>> a NULL pointer, it is good to keep this check in place to avoid
>> possible problems in the future due to changes in implementation.
>> That way, we also improve the consistency of the code that performs
>> clock initialization across the different SoCs.
>>
>> Signed-off-by: Humberto Silva Naves <hsnaves@gmail.com>
>> ---
>>  drivers/clk/samsung/clk-exynos5410.c |   12 +++++++++---
>>  1 file changed, 9 insertions(+), 3 deletions(-)
>>
>> diff --git a/drivers/clk/samsung/clk-exynos5410.c b/drivers/clk/samsung/clk-exynos5410.c
>> index 231475b..bf57c80 100644
>> --- a/drivers/clk/samsung/clk-exynos5410.c
>> +++ b/drivers/clk/samsung/clk-exynos5410.c
>> @@ -188,11 +188,17 @@ static void __init exynos5410_clk_init(struct device_node *np)
>>       struct samsung_clk_provider *ctx;
>>       void __iomem *reg_base;
>>
>> -     reg_base = of_iomap(np, 0);
>> -     if (!reg_base)
>> -             panic("%s: failed to map registers\n", __func__);
>> +     if (np) {
>
> Since all Exynos-based boards are always booted using DT, this function
> will never be called if there is no node for the clock controller and so
> there is no way this pointer can end up being NULL. I don't see a point
> in complicating this code with useless checks.
>
>> +             reg_base = of_iomap(np, 0);
>> +             if (!reg_base)
>> +                     panic("%s: failed to map registers\n", __func__);
>> +     } else {
>> +             panic("%s: unable to determine soc\n", __func__);
>> +     }
>
> As a side note, since panic() does not return, the code above could be
> changed to follow rest of checks in this function:
>
>         if (!np)
>                 panic("%s: unable to determine soc\n", __func__);
>
>         reg_base = of_iomap(np, 0);
>         ...
>
> leading to more readable code with less indentation and less changes to
> existing code.
>
>>
>>       ctx = samsung_clk_init(np, reg_base, CLK_NR_CLKS);
>> +     if (!ctx)
>> +             panic("%s: unable to allocate context.\n", __func__);
>
> samsung_clk_init() already panics on any error, although now as I think
> of it, it probably should be changed with a patch to just error out and
> let the caller handle the error. However callers don't need to be
> changed before this is done.
>
> Best regards,
> Tomasz
