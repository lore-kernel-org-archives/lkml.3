Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751419AbaEWJkR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 May 2014 05:40:17 -0400
Received: from mail-wi0-f177.google.com ([209.85.212.177]:55109 "EHLO
	mail-wi0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750971AbaEWJkN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 May 2014 05:40:13 -0400
MIME-Version: 1.0
X-Originating-IP: [95.23.101.217]
In-Reply-To: <537F03C8.3070101@ti.com>
References: <1400671264-10702-1-git-send-email-rogerq@ti.com>
	<20140521160818.GA1150@arch.cereza>
	<537DB17A.6060608@ti.com>
	<CABxcv=nbgGhVN+XYO8s=mYOpoLU9-kWuEqc+FLMaSbWS7BJNyQ@mail.gmail.com>
	<20140522144600.GA1785@arch.cereza>
	<537F03C8.3070101@ti.com>
Date: Fri, 23 May 2014 11:40:11 +0200
Message-ID: <CABxcv=kJA-kWpvcU0Jiy-gJYZP7W0kJjGtq3Fjr0VUBBC_znHg@mail.gmail.com>
Subject: Re: [RFC PATCH 00/16] OMAP: GPMC: Restructure OMAP GPMC driver (NAND)
 : DT binding change proposal
From: Javier Martinez Canillas <javier@dowhile0.org>
To: Roger Quadros <rogerq@ti.com>
Cc: Ezequiel Garcia <ezequiel.garcia@free-electrons.com>,
        Tony Lindgren <tony@atomide.com>,
        Brian Norris <computersforpeace@gmail.com>,
        "Gupta, Pekon" <pekon@ti.com>, Robert Nelson <robertcnelson@gmail.com>,
        Jingoo Han <jg1.han@samsung.com>,
        David Woodhouse <dwmw2@infradead.org>, nsekhar@ti.com,
        "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
        linux-mtd@lists.infradead.org,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <robh+dt@kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Roger,

On Fri, May 23, 2014 at 10:16 AM, Roger Quadros <rogerq@ti.com> wrote:
> Ezequiel & Javier,
>
> On 05/22/2014 05:46 PM, Ezequiel Garcia wrote:
>> On 22 May 01:51 PM, Javier Martinez Canillas wrote:
>>> On Thu, May 22, 2014 at 10:12 AM, Roger Quadros <rogerq@ti.com> wrote:
>>>>> On 21 May 02:20 PM, Roger Quadros wrote:
>>>>>>
>>>>>> For DT boot:
>>>>>> - The GPMC controller node should have a chip select (CS) node for each used
>>>>>>   chip select. The CS node must have a child device node for each device
>>>>>>   attached to that chip select. Properties for that child are GPMC agnostic.
>>>>>>
>>>>>>   i.e.
>>>>>>      gpmc {
>>>>>>              cs0 {
>>>>>>                      nand0 {
>>>>>>                      }
>>>>>>              };
>>>>>>
>>>>>>              cs1 {
>>>>>>                      nor0 {
>>>>>>                      }
>>>>>>              }
>>>>>>              ...
>>>>>>      };
>>>>>>
>>>>>
>>>>> While I agree that the GPMC driver is a bit messy, I'm not sure it's possible
>>>>> to go through such a complete devicetree binding re-design (breaking backwards
>>>>> compatibility) now that the binding is already in production.
>>>>
>>>> Why not? especially if the existing bindings are poorly dones. Is anyone using these
>>>> bindings burning the DT into ROM and can't change it when they update the kernel?
>>>>
>>>
>>> While I do agree that your DT bindings are much better than the
>>> current ones, there is a policy that DT bindings are an external API
>>> and once are released with a kernel are set in stone and can't be
>>> changed.
>>>
>>
>> Exactly. The DT binding is considered an ABI. Thus, invariant across kernel
>> versions. Users can't be coherced into a DTB update after a kernel update.
>>
>> That said, I don't really care if you break compatilibity in this case.
>> Rather, I'm suggesting that you make sure this change is going to be accepted
>> upstream, before doing any more work. The DT maintainers are reluctant to do
>> so.
>
> Appreciate your concern.
>
> Would be really nice if you can review patches 1-12. They have nothing to do with DT changes.
> Thanks.
>

Overall your patches looks good to me. But I think it's better to wait
until Tony removes the legacy board files for OMAP2+ since AFAIU at
least the following patches could be dropped or trimmed down when
board files are gone:

[RFC PATCH 04/16] ARM: OMAP2+: gpmc: use platform data to configure CS
space and poplulate
[RFC PATCH 06/16] ARM: OMAP2+: gpmc: add NAND specific setup
[RFC PATCH 07/16] ARM: OMAP2+: nand: Update gpmc_nand_init() to use
generic_gpmc_init()

Patches 1-3 and 5 are independent and can be applied in the meantime
as a preparation for further changes following board files removal.

I really like patches 9-12 since those moves some NAND add-hoc code to
the NAND driver where it really belongs. I think that similar changes
can be made for OneNAND and push the special case handling code from
GPMC driver to drivers/mtd/onenand/omap2.c.

Other devices (nor, ethernet, uart, etc) are already using
gpmc_probe_generic_child() so I hope we can isolate the NAND and
OneNAND specific changes and just use a single probe function for all
child devices and possibly get even need the enum gpmc_omap_type you
are adding on your struct gpmc_omap_cs_data.

So what do you think if as a first step we add the platform data as
you propose with all the commons timings and settings there, move all
the possible code to NAND and OneNAND drivers and try to use a single
configuration function for all child devices?

Then once board files are gone we can do further cleanup in the driver
and then we can discuss about changing the DT bindings. Maybe we can
even change it while keeping backwards compatibility? Although I'm not
sure about the last point I think that at least is worth to discuss
it.

> cheers,
> -roger
>

Thanks a lot and best regards,
Javier

>>
>> On the other side, I guess you will also break bisectability while breaking
>> backward compatibility. Doesn't sound very nice.
>>
>
