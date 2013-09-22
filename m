Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753242Ab3IVSqE (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Sep 2013 14:46:04 -0400
Received: from mail-lb0-f175.google.com ([209.85.217.175]:43166 "EHLO
	mail-lb0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753205Ab3IVSqB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Sep 2013 14:46:01 -0400
Message-ID: <523F3AE4.5050709@cogentembedded.com>
Date: Sun, 22 Sep 2013 22:45:56 +0400
From: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
Organization: Cogent Embedded
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130801 Thunderbird/17.0.8
MIME-Version: 1.0
To: Roger Quadros <rogerq@ti.com>
CC: balbi@ti.com, bcousson@baylibre.com, tony@atomide.com, balajitk@ti.com,
        kishon@ti.com, linux-omap@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-ide@vger.kernel.org,
        linux-kernel@vger.kernel.org, devicetree@vger.kernel.org
Subject: Re: [RFC PATCH 15/15] arm: dts: dra7: add sata node
References: <1379595943-14622-1-git-send-email-rogerq@ti.com> <1379597059-15405-1-git-send-email-rogerq@ti.com> <523B05FD.7020200@cogentembedded.com> <523C214A.30406@ti.com>
In-Reply-To: <523C214A.30406@ti.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/20/2013 02:19 PM, Roger Quadros wrote:

>>> From: Balaji T K <balajitk@ti.com>

>>> Add support for sata controller.

>>> [Roger Q] Clean up.

>>> CC: Benoit Cousson <bcousson@baylibre.com>
>>> Signed-off-by: Balaji T K <balajitk@ti.com>
>>> Signed-off-by: Roger Quadros <rogerq@ti.com>
>>> ---
>>>    arch/arm/boot/dts/dra7.dtsi |   49 +++++++++++++++++++++++++++++++++++++++++++
>>>    1 files changed, 49 insertions(+), 0 deletions(-)

>>> diff --git a/arch/arm/boot/dts/dra7.dtsi b/arch/arm/boot/dts/dra7.dtsi
>>> index ce9a0f0..545545d 100644
>>> --- a/arch/arm/boot/dts/dra7.dtsi
>>> +++ b/arch/arm/boot/dts/dra7.dtsi
>>> @@ -426,6 +426,55 @@
[...]

>>> +        sata: sata@4a141100 {
>>> +            compatible = "ti,sata";
>>> +            ti,hwmods = "sata";
>>> +            reg = <0x4a141100 0x7>;

    Not 0x8 BTW?

>>> +            #address-cells = <1>;
>>> +            #size-cells = <1>;
>>> +            ranges;
>>> +            dwc-ahci@4a140000 {

>>     Hm, ePAPR spec. [1] says that "the name of a node should be somewhat generic, reflecting the function of the device and not its precise programming model", so it looks like the name should be "sata" as well. I'm a bit at a loss here, not sure why you had to use the nested device nodes.

> ok. will fix it to sata.
> I've nested it because the wrapper registers are not part of the AHCI sata controller.
> They are TI specific registers for power management.
> Similar setup is on the USB controller. Please see omap_dwc3 node.

> But if you have better idea, please let me know.

     Don't know, it seems to me that you're over-complicating it by using the 
nested nodes. You could just have AHCI regs as a first tuple of the "regs" 
prop, and PM regs as a second tuple.

>>> +                  compatible = "snps,dwc-ahci";
>>> +                  reg = <0x4a140000 0x1100>;
>>> +                  interrupts = <0 54 0x4>;
>>> +                  phys = <&sata_phy>;

>>     Hm, it's the third PHY related generic property I'm encountering. First, there was "phy-handle", then "phy", now "phys"... Seems like a bit too much. :-)

> I'm afraid but this is how the designers have made it.

> 1) control-phy-pipe3 is that part of the PHY which sits in control module space and is different
> from the sata-phy space and hence needs a different node. If it were to me, I would just put this
> resource in sata-phy node, but there was a discussion about this earlier to do it otherwise [1].

> 2) sata-phy (sataphy) is the actual SATA PHY device.

> 3) phys is just a reference to the sata_phy and is used via the generic PHY framework.
> It is upto the sata driver to power up/down the phy.

    I understand that it's a reference but why have 3 variants of such phandle 
containing prop? Is it really possible for a device to have multiple PHYs? 
Well, remembering our customer's USB, it's indeed possible, however, there 2 
PHYs out of 3 are not software controllable...

>>> +                  phy-names = "sata-phy";
>>> +                  clocks = <&sata_ref_clk>;
>>> +                  clock-names = "optclk";
>>> +            };
>>> +        };

>> [1] http://www.power.org/resources/downloads/Power_ePAPR_APPROVED_v1.0.pdf

> cheers,
> -roger

> [1] - https://lkml.org/lkml/2012/9/10/399

WBR, Sergei

