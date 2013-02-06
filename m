Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756608Ab3BFCt2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Feb 2013 21:49:28 -0500
Received: from avon.wwwdotorg.org ([70.85.31.133]:59347 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753390Ab3BFCtZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Feb 2013 21:49:25 -0500
Message-ID: <5111C4B2.70007@wwwdotorg.org>
Date: Tue, 05 Feb 2013 19:49:22 -0700
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130106 Thunderbird/17.0.2
MIME-Version: 1.0
To: Sean Paul <seanpaul@chromium.org>
CC: linux-arm-kernel@lists.infradead.org, linux-samsung-soc@vger.kernel.org,
        devicetree-discuss@lists.ozlabs.org, dri-devel@lists.freedesktop.org,
        Tomasz Stanislawski <t.stanislaws@samsung.com>,
        "kgene.kim" <kgene.kim@samsung.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Tomasz Figa <tomasz.figa@gmail.com>, InKi Dae <inki.dae@samsung.com>,
        Sylwester Nawrocki <sylvester.nawrocki@gmail.com>,
        Olof Johansson <olofj@chromium.org>,
        RAHUL SHARMA <rahul.sharma@samsung.com>
Subject: Re: [PATCH v3 1/3] drm/exynos: Get HDMI version from device tree
References: <1360107777-17490-1-git-send-email-seanpaul@chromium.org> <1360107777-17490-2-git-send-email-seanpaul@chromium.org> <5111A23F.50300@wwwdotorg.org> <CAOw6vb+W3phFDJXp3gCx7y0N7mF4o2DpEfTGuNT1pGdKqiCGTg@mail.gmail.com> <5111A6D9.7090700@wwwdotorg.org> <CAOw6vbKhsWp7VnqgvECd-P4e5okX6dwKn3P8+phfpG29rA+h7g@mail.gmail.com>
In-Reply-To: <CAOw6vbKhsWp7VnqgvECd-P4e5okX6dwKn3P8+phfpG29rA+h7g@mail.gmail.com>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/05/2013 05:56 PM, Sean Paul wrote:
> On Tue, Feb 5, 2013 at 4:42 PM, Stephen Warren <swarren@wwwdotorg.org> wrote:
>> On 02/05/2013 05:37 PM, Sean Paul wrote:
>>> On Tue, Feb 5, 2013 at 4:22 PM, Stephen Warren <swarren@wwwdotorg.org> wrote:
>>>> n 02/05/2013 04:42 PM, Sean Paul wrote:
>>>>> Use the compatible string in the device tree to determine which
>>>>> registers/functions to use in the HDMI driver. Also changes the
>>>>> references from v13 to 4210 and v14 to 4212 to reflect the IP
>>>>> block version instead of the HDMI version.
>>>>
>>>>> diff --git a/Documentation/devicetree/bindings/drm/exynos/hdmi.txt b/Documentation/devicetree/bindings/drm/exynos/hdmi.txt
>>>>
>>>> Binding looks sane to me.
>>>>
>>>>> diff --git a/drivers/gpu/drm/exynos/exynos_hdmi.c b/drivers/gpu/drm/exynos/exynos_hdmi.c
>>>>
>>>>>  #ifdef CONFIG_OF
>>>>>  static struct of_device_id hdmi_match_types[] = {
>>>>>       {
>>>>> -             .compatible = "samsung,exynos5-hdmi",
>>>>> -             .data   = (void *)HDMI_TYPE14,
>>>>> +             .compatible = "samsung,exynos4-hdmi",
>>>>>       }, {
>>>>>               /* end node */
>>>>>       }
>>>>
>>>> Why not fill in all the "base" compatible values there (I think you need
>>>> this anyway so that DTs don't all have to be compatible with
>>>> samsung,exynos4-hdmi), with .data containing the HDMI_VER_EXYNOS*
>>>> values, then ...
>>>>
>>>
>>> At the moment, all DTs have to be compatible with exynos4-hdmi since
>>> it provides the base for the current driver. The driver uses 4210 and
>>> 4212 to differentiate between different register addresses and
>>> features, but most things are just exynos4-hdmi compatible.
>>
>> The DT nodes should include only the compatible values that the HW is
>> actually compatible with. If the HW isn't compatible with exynos4-hdmi,
>> that value shouldn't be in the compatible property, but instead whatever
>> the "base" value that the HW really is compatible with. The driver can
>> support multiple "base" compatible values from this table.
> 
> All devices that use this driver are compatible, at some level, with
> exynos4-hdmi, so I think its usage is correct here.

But can a driver that only knows about the original exynos4-hdmi operate
any of the HW correctly without any additional knowledge? If not, the
new HW isn't compatible with the old.

>>>>> @@ -2218,17 +2217,18 @@ static int hdmi_probe(struct platform_device *pdev)
>>>>
>>>>> +
>>>>> +     if (of_device_is_compatible(dev->of_node, "samsung,exynos4210-hdmi"))
>>>>> +             hdata->version |= HDMI_VER_EXYNOS4210;
>>>>> +     if (of_device_is_compatible(dev->of_node, "samsung,exynos4212-hdmi"))
>>>>> +             hdata->version |= HDMI_VER_EXYNOS4212;
>>>>> +     if (of_device_is_compatible(dev->of_node, "samsung,exynos5250-hdmi"))
>>>>> +             hdata->version |= HDMI_VER_EXYNOS5250;
>>>>
>>>> Instead of that, do roughly:
>>>>
>>>>     match = of_match_device(hdmi_match_types, &pdev->dev);
>>>>     if (match)
>>>>         hdata->version |= (int)match->data;
>>>>
>>>> That way, it's all table-based. Any future additions to
>>>> hdmi_match_types[] won't require another if statement to be added to
>>>> probe().
>>>
>>> I don't think it's that easy. of_match_device returns the first match
>>> from the device table, so I'd still need to iterate through the
>>> matches. I could still break this out into a table, but I don't think
>>> of_match_device is the right way to probe it.
>>
>> You shouldn't have to iterate over multiple matches. of_match_device()
>> is supposed to return the match for the first entry in the compatible
>> property, then if there was no match, move on to looking at the next
>> entry in the compatible property, etc. In practice, I think it's still
>> not implemented quite correctly for this, but you can make it work by
>> putting the newest compatible value first in the match table.
> 
> I think the only way that works is if you hardcode the compatible
> versions in the driver, like this:
> 
> static struct of_device_id hdmi_match_types[] = {
>         {
>                 .compatible = "samsung,exynos5250-hdmi",
>                 .data = (void *)(HDMI_VER_EXYNOS5250 | HDMI_VER_EXYNOS4212);
>         }, {
>                 .compatible = "samsung,exynos4212-hdmi",
>                 .data = (void *)HDMI_VER_EXYNOS4212;
>         }, {
>                 .compatible = "samsung,exynos4210-hdmi",
>                 .data = (void *)HDMI_VER_EXYNOS4210;
>         }, {
>                 /* end node */
>         }
> };
> 
> In that case, it eliminates the benefit of using device tree to
> determine the compatible bits. I hope I'm just being thick and missing
> something.

The table above looks /almost/ exactly correct to me, although I'm
unsure why samsung,exynos5250-hdmi has *two* version values; surely
there's a 1:1 mapping between the compatible values and the HW
compatibility they represent? That's certainly the intent.

Perhaps the "two values" think is because you're representing quirks or
features rather than HW versions? Compatible is supposed to represent HW
versions. Each HW version has a set of features/quirks, and multiple HW
versions can have intersecting sets of features/quirks. However,
features/quirks aren't HW versions.
