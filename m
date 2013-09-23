Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753516Ab3IWIYo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Sep 2013 04:24:44 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:50511 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752638Ab3IWIYl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Sep 2013 04:24:41 -0400
Message-ID: <523FFAAC.3050907@ti.com>
Date: Mon, 23 Sep 2013 11:24:12 +0300
From: Roger Quadros <rogerq@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:16.0) Gecko/20121011 Thunderbird/16.0.1
MIME-Version: 1.0
To: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>, <kishon@ti.com>
CC: <balbi@ti.com>, <bcousson@baylibre.com>, <tony@atomide.com>,
        <balajitk@ti.com>, <linux-omap@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <linux-ide@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <devicetree@vger.kernel.org>
Subject: Re: [RFC PATCH 15/15] arm: dts: dra7: add sata node
References: <1379595943-14622-1-git-send-email-rogerq@ti.com> <1379597059-15405-1-git-send-email-rogerq@ti.com> <523B05FD.7020200@cogentembedded.com> <523C214A.30406@ti.com> <523F3AE4.5050709@cogentembedded.com>
In-Reply-To: <523F3AE4.5050709@cogentembedded.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/22/2013 09:45 PM, Sergei Shtylyov wrote:
> On 09/20/2013 02:19 PM, Roger Quadros wrote:
> 
>>>> From: Balaji T K <balajitk@ti.com>
> 
>>>> Add support for sata controller.
> 
>>>> [Roger Q] Clean up.
> 
>>>> CC: Benoit Cousson <bcousson@baylibre.com>
>>>> Signed-off-by: Balaji T K <balajitk@ti.com>
>>>> Signed-off-by: Roger Quadros <rogerq@ti.com>
>>>> ---
>>>>    arch/arm/boot/dts/dra7.dtsi |   49 +++++++++++++++++++++++++++++++++++++++++++
>>>>    1 files changed, 49 insertions(+), 0 deletions(-)
> 
>>>> diff --git a/arch/arm/boot/dts/dra7.dtsi b/arch/arm/boot/dts/dra7.dtsi
>>>> index ce9a0f0..545545d 100644
>>>> --- a/arch/arm/boot/dts/dra7.dtsi
>>>> +++ b/arch/arm/boot/dts/dra7.dtsi
>>>> @@ -426,6 +426,55 @@
> [...]
> 
>>>> +        sata: sata@4a141100 {
>>>> +            compatible = "ti,sata";
>>>> +            ti,hwmods = "sata";
>>>> +            reg = <0x4a141100 0x7>;
> 
>    Not 0x8 BTW?

You are right. Two 32 bit registers are used.
However, in the instance summary, the reference manual says 256 bytes.
So I think we should use 0x100.

> 
>>>> +            #address-cells = <1>;
>>>> +            #size-cells = <1>;
>>>> +            ranges;
>>>> +            dwc-ahci@4a140000 {
> 
>>>     Hm, ePAPR spec. [1] says that "the name of a node should be somewhat generic, reflecting the function of the device and not its precise programming model", so it looks like the name should be "sata" as well. I'm a bit at a loss here, not sure why you had to use the nested device nodes.
> 
>> ok. will fix it to sata.
>> I've nested it because the wrapper registers are not part of the AHCI sata controller.
>> They are TI specific registers for power management.
>> Similar setup is on the USB controller. Please see omap_dwc3 node.
> 
>> But if you have better idea, please let me know.
> 
>     Don't know, it seems to me that you're over-complicating it by using the nested nodes. You could just have AHCI regs as a first tuple of the "regs" prop, and PM regs as a second tuple.
> 

Yes that is possible, and in fact it was that way in Balaji's original code.
However in that case, won't TI specific handling be need to be done in the ahci_platform driver?

As of now, that is limited to using pm_runtime to enable/disable the hardware module so it is generic enough.
However in the future it would mean reading/writing to the TI wrapper register. If this can be done in ahci_platform
driver then I don't see any issue and can combine the 2 nodes.

>>>> +                  compatible = "snps,dwc-ahci";
>>>> +                  reg = <0x4a140000 0x1100>;
>>>> +                  interrupts = <0 54 0x4>;
>>>> +                  phys = <&sata_phy>;
> 
>>>     Hm, it's the third PHY related generic property I'm encountering. First, there was "phy-handle", then "phy", now "phys"... Seems like a bit too much. :-)
> 
>> I'm afraid but this is how the designers have made it.
> 
>> 1) control-phy-pipe3 is that part of the PHY which sits in control module space and is different
>> from the sata-phy space and hence needs a different node. If it were to me, I would just put this
>> resource in sata-phy node, but there was a discussion about this earlier to do it otherwise [1].
> 
>> 2) sata-phy (sataphy) is the actual SATA PHY device.
> 
>> 3) phys is just a reference to the sata_phy and is used via the generic PHY framework.
>> It is upto the sata driver to power up/down the phy.
> 
>    I understand that it's a reference but why have 3 variants of such phandle containing prop? Is it really possible for a device to have multiple PHYs? Well, remembering our customer's USB, it's indeed possible, however, there 2 PHYs out of 3 are not software controllable...
> 

If I understand right, are you asking that we don't need "phy-names" property if there can be only one PHY?
I too think it is redundant. Maybe the PHY framework should be modified to allow users to use phy_get() whithout
any phy name string. In such case it should return the first PHY. 
Kishon, any thoughts?

>>>> +                  phy-names = "sata-phy";
>>>> +                  clocks = <&sata_ref_clk>;
>>>> +                  clock-names = "optclk";
>>>> +            };
>>>> +        };
> 
>>> [1] http://www.power.org/resources/downloads/Power_ePAPR_APPROVED_v1.0.pdf
> 

cheers,
-roger
