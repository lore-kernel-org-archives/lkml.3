Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754643AbbAVVuj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jan 2015 16:50:39 -0500
Received: from arroyo.ext.ti.com ([192.94.94.40]:48389 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754169AbbAVVuh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jan 2015 16:50:37 -0500
Message-ID: <54C17087.7060003@ti.com>
Date: Thu, 22 Jan 2015 15:49:59 -0600
From: Suman Anna <s-anna@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.4.0
MIME-Version: 1.0
To: Grant Likely <grant.likely@linaro.org>
CC: Rob Herring <robherring2@gmail.com>, Rob Herring <robh+dt@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Pawel Moll <pawel.moll@arm.com>,
        Pantelis Antoniou <pantelis.antoniou@konsulko.com>,
        Felipe Balbi <balbi@ti.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        linux-omap <linux-omap@vger.kernel.org>
Subject: Re: [RFC PATCH 1/3] of/device: manage resources similar to platform_device_add
References: <1420651854-17768-1-git-send-email-s-anna@ti.com> <1420651854-17768-2-git-send-email-s-anna@ti.com> <CAL_Jsq+79cnCiww6g8ejki0yT59-N8eucHC3QGMbsXG4DksWuQ@mail.gmail.com> <54B58D5D.5070508@ti.com> <CAL_JsqLW9PRktHntLquohH3x_bPgJrrn2Y2_8RYA_HnKhpTDHg@mail.gmail.com> <54B5A499.7060106@ti.com>
In-Reply-To: <54B5A499.7060106@ti.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Grant,

On 01/13/2015 05:04 PM, Suman Anna wrote:
> On 01/13/2015 04:00 PM, Rob Herring wrote:
>> On Tue, Jan 13, 2015 at 3:25 PM, Suman Anna <s-anna@ti.com> wrote:
>>> Hi Rob,
>>>
>>> On 01/13/2015 02:38 PM, Rob Herring wrote:
>>>> On Wed, Jan 7, 2015 at 11:30 AM, Suman Anna <s-anna@ti.com> wrote:
>>>>> Drivers can use of_platform_populate() to create platform devices
>>>>> for children of the device main node, and a complementary API
>>>>> of_platform_depopulate() is provided to delete these child platform
>>>>> devices. The of_platform_depopulate() leverages the platform API
>>>>> for performing the cleanup of these devices.
>>>>>
>>>>> The platform device resources are managed differently between
>>>>> of_device_add and platform_device_add, and this asymmetry causes
>>>>> a kernel oops in platform_device_del during removal of the resources.
>>>>> Manage the platform device resources similar to platform_device_add
>>>>> to fix this kernel oops.
>>>>
>>>> This is a known issue and has been attempted to be fixed before (I
>>>> believe there is a revert in mainline). The problem is there are known
>>>> devicetrees which have overlapping resources and they will break with
>>>> your change.
>>>
>>> Are you referring to 02bbde7849e6 (Revert "of: use
>>> platform_device_add")?
>>
>> I believe that's the one.
>>
>>> That one seems to be in registration path, and
>>> this crash is in the unregistration path. If so, to fix the crash,
>>> should we be skipping the release_resource() for now in
>>> platform_device_del for DT nodes, or replace platform_device_unregister
>>> with of_device_unregister in of_platform_device_destroy()?
>>
>> IIRC, the problem is inserting a resource twice on add from 2
>> different nodes, not the removal path. Perhaps we could make a
>> collision non-fatal for in the DT case.
> 
> We may be talking two different things here, I understand that this
> patch would create an issue with inserting a resource twice in the
> devicetrees with overlapping resources (just like the commit that was
> reverted above), but the crash is on devices with resources whose
> parent, child, sibling pointers have never been initialized (the
> of_device_add path does not touch these at all), and get dereferenced in
> platform_device_del()->release_resource(). See the following that has a
> better explanation [1].
> 
> regards
> Suman
> 
> [1]
> http://lists.infradead.org/pipermail/linux-arm-kernel/2014-July/274412.html
> 
> 
>> Grant may have some ideas on
>> what's needed here.

Ping, any suggestions here? Do we ought to replace
platform_device_unregister() with of_device_unregister() similar to the
approach taken in 02bbde7849e6 (Revert "of: use platform_device_add")?

regards
Suman

>>
>>> This is a common crash and we cannot use of_platform_depopulate() today
>>> in drivers to complement of_platform_populate().
>>
>> Yes, I know.
>>
>>> Also, the platform_data crash is independent of this, I could reproduce
>>> that one even with using of_device_unregister in a loop in driver remove.
>>
>> Missed this one. I'll reply to that patch.
>>
>> Rob
>>
>>>
>>> regards
>>> Suman
>>>
>>>>
>>>> Rob
>>>>
>>>>>
>>>>> Signed-off-by: Suman Anna <s-anna@ti.com>
>>>>> ---
>>>>>  drivers/of/device.c | 38 +++++++++++++++++++++++++++++++++++++-
>>>>>  1 file changed, 37 insertions(+), 1 deletion(-)
>>>>>
>>>>> diff --git a/drivers/of/device.c b/drivers/of/device.c
>>>>> index 46d6c75c1404..fa27c1c71f29 100644
>>>>> --- a/drivers/of/device.c
>>>>> +++ b/drivers/of/device.c
>>>>> @@ -50,6 +50,8 @@ EXPORT_SYMBOL(of_dev_put);
>>>>>
>>>>>  int of_device_add(struct platform_device *ofdev)
>>>>>  {
>>>>> +       int i, ret;
>>>>> +
>>>>>         BUG_ON(ofdev->dev.of_node == NULL);
>>>>>
>>>>>         /* name and id have to be set so that the platform bus doesn't get
>>>>> @@ -63,7 +65,41 @@ int of_device_add(struct platform_device *ofdev)
>>>>>         if (!ofdev->dev.parent)
>>>>>                 set_dev_node(&ofdev->dev, of_node_to_nid(ofdev->dev.of_node));
>>>>>
>>>>> -       return device_add(&ofdev->dev);
>>>>> +       for (i = 0; i < ofdev->num_resources; i++) {
>>>>> +               struct resource *p, *r = &ofdev->resource[i];
>>>>> +
>>>>> +               if (!r->name)
>>>>> +                       r->name = dev_name(&ofdev->dev);
>>>>> +
>>>>> +               p = r->parent;
>>>>> +               if (!p) {
>>>>> +                       if (resource_type(r) == IORESOURCE_MEM)
>>>>> +                               p = &iomem_resource;
>>>>> +                       else if (resource_type(r) == IORESOURCE_IO)
>>>>> +                               p = &ioport_resource;
>>>>> +               }
>>>>> +
>>>>> +               if (p && insert_resource(p, r)) {
>>>>> +                       dev_err(&ofdev->dev, "failed to claim resource %d\n",
>>>>> +                               i);
>>>>> +                       ret = -EBUSY;
>>>>> +                       goto failed;
>>>>> +               }
>>>>> +       }
>>>>> +
>>>>> +       ret = device_add(&ofdev->dev);
>>>>> +       if (ret == 0)
>>>>> +               return ret;
>>>>> +
>>>>> +failed:
>>>>> +       while (--i >= 0) {
>>>>> +               struct resource *r = &ofdev->resource[i];
>>>>> +               unsigned long type = resource_type(r);
>>>>> +
>>>>> +               if (type == IORESOURCE_MEM || type == IORESOURCE_IO)
>>>>> +                       release_resource(r);
>>>>> +       }
>>>>> +       return ret;
>>>>>  }
>>>>>
>>>>>  int of_device_register(struct platform_device *pdev)
>>>>> --
>>>>> 2.2.1
>>>>>
>>>
> 

