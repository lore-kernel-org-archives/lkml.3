Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754761AbaG3CyH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jul 2014 22:54:07 -0400
Received: from mail-vc0-f176.google.com ([209.85.220.176]:59833 "EHLO
	mail-vc0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754723AbaG3CyF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jul 2014 22:54:05 -0400
MIME-Version: 1.0
In-Reply-To: <53D84558.7060406@codeaurora.org>
References: <53D788A7.4020303@mm-sol.com> <3794875.CZFbAag5Sv@wuerfel>
 <53D7AA72.6010309@mm-sol.com> <20140729234522.E9FF1C40738@trevor.secretlab.ca>
 <53D84558.7060406@codeaurora.org>
From: Rob Herring <robherring2@gmail.com>
Date: Tue, 29 Jul 2014 21:53:42 -0500
Message-ID: <CAL_JsqJjH0OH+X=fzwqAPeWarjoLev7v6Nv_QhAa+nZyztMnFA@mail.gmail.com>
Subject: Re: use IORESOURCE_REG resource type for non-translatable addresses
 in DT
To: Stephen Boyd <sboyd@codeaurora.org>
Cc: Grant Likely <grant.likely@linaro.org>,
        Stanimir Varbanov <svarbanov@mm-sol.com>,
        Arnd Bergmann <arnd@arndb.de>, Rob Herring <rob.herring@linaro.org>,
        Lee Jones <lee.jones@linaro.org>,
        "linux-arm-msm@vger.kernel.org" <linux-arm-msm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Mark Brown <broonie@linaro.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 29, 2014 at 8:07 PM, Stephen Boyd <sboyd@codeaurora.org> wrote:
> On 07/29/14 16:45, Grant Likely wrote:
>> On Tue, 29 Jul 2014 17:06:42 +0300, Stanimir Varbanov <svarbanov@mm-sol.com> wrote:
>>>
>>> This was just an example. Of course it has many issues and probaly it is
>>> wrong:) The main goal was to understand does IORESOURCE_REG resource
>>> type and parsing the *reg* properties for non-translatable addresses are
>>> feasible. And also does it acceptable by community and OF platform
>>> maintainers.
>> The use case is actually very different from of_address_to_resource or
>> of_get_address() because those APIs explicitly return physical memory
>> addresses from the CPU perspective. It makes more sense to create a new
>> API that doesn't attempt to translate the reg address. Alternately, a
>> new API that only translates upto a given parent node.
>
> The most important thing is that platform_get_resource{_by_name}(&pdev,
> IORESOURCE_REG, n) returns the reg property and optional size encoded
> into a struct resource. I think Rob is suggesting we circumvent the
> entire of_address_to_resource() path and do some if
> (IS_ENABLED(CONFIG_OF) && type == IORESOURCE_REG) check in
> platform_get_resource() to package up the reg property into a struct
> resource. That should work.

No, I'm saying why are you using platform_get_resource at all and
adding a new resource type? I don't see any advantage.

You might as well do of_property_read_u32 in the below example.

Rob

> It sounds like you think partially translating addresses is risky
> though. Fair enough. Perhaps we should call WARN() if someone tries to
> call platform_get_resource() with IORESOURCE_REG and the parent node has
> a ranges property that isn't a one-to-one conversion. That way if we
> want to do something like this we can.
>
> pmic@0 {
>     #address-cells = <1>;
>     #size-cells = <0>;
>     reg = <0>;
>
>     regulators {
>         ranges;
>         #address-cells = <1>;
>         #size-cells = <0>;
>
>         regulator@40 {
>             reg = <0x40>;
>         };
>
>         regulator@50 {
>             reg = <0x50>;
>         }
>     };
> };
>
> --
> Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum,
> hosted by The Linux Foundation
>
