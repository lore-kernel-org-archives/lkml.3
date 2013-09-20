Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754495Ab3ITKU1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Sep 2013 06:20:27 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:51087 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754221Ab3ITKUX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Sep 2013 06:20:23 -0400
Message-ID: <523C214A.30406@ti.com>
Date: Fri, 20 Sep 2013 13:19:54 +0300
From: Roger Quadros <rogerq@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:16.0) Gecko/20121011 Thunderbird/16.0.1
MIME-Version: 1.0
To: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
CC: <balbi@ti.com>, <bcousson@baylibre.com>, <tony@atomide.com>,
        <balajitk@ti.com>, <kishon@ti.com>, <linux-omap@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <linux-ide@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <devicetree@vger.kernel.org>
Subject: Re: [RFC PATCH 15/15] arm: dts: dra7: add sata node
References: <1379595943-14622-1-git-send-email-rogerq@ti.com> <1379597059-15405-1-git-send-email-rogerq@ti.com> <523B05FD.7020200@cogentembedded.com>
In-Reply-To: <523B05FD.7020200@cogentembedded.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On 09/19/2013 05:11 PM, Sergei Shtylyov wrote:
> Hello.
> 
> On 09/19/2013 05:24 PM, Roger Quadros wrote:
> 
>> From: Balaji T K <balajitk@ti.com>
> 
>> Add support for sata controller.
> 
>> [Roger Q] Clean up.
> 
>> CC: Benoit Cousson <bcousson@baylibre.com>
>> Signed-off-by: Balaji T K <balajitk@ti.com>
>> Signed-off-by: Roger Quadros <rogerq@ti.com>
>> ---
>>   arch/arm/boot/dts/dra7.dtsi |   49 +++++++++++++++++++++++++++++++++++++++++++
>>   1 files changed, 49 insertions(+), 0 deletions(-)
> 
>> diff --git a/arch/arm/boot/dts/dra7.dtsi b/arch/arm/boot/dts/dra7.dtsi
>> index ce9a0f0..545545d 100644
>> --- a/arch/arm/boot/dts/dra7.dtsi
>> +++ b/arch/arm/boot/dts/dra7.dtsi
>> @@ -426,6 +426,55 @@
>>               dma-names = "tx", "rx";
>>           };
>>
>> +        omap_control_sata: control-phy@4a002374 {
>> +            compatible = "ti,control-phy-pipe3";
>> +            reg = <0x4a002374 0x4>;
>> +            reg-names = "power";
>> +            clocks = <&sys_clkin1>;
>> +            clock-names = "sysclk";
>> +        };
>> +
>> +        ocp2scp3: ocp2scp3@4a090000 {
>> +            compatible = "ti,omap-ocp2scp";
>> +            #address-cells = <1>;
>> +            #size-cells = <1>;
>> +            ranges;
>> +            ti,hwmods = "ocp2scp3";
>> +            reg = <0x4a090000 0x1f>; /* ocp2scp3 */
>> +            reg-names = "ocp2scp3";
>> +            sata_phy: sataphy@4A096000 {
> 
>    It's better to name the PHY nodes uniformly after already standard "ethernet-phy" and your "control-phy".

OK. will fix it to sata-phy.

> 
>> +                compatible = "ti,phy-pipe3-sata";
>> +                reg = <0x4A096000 0x80>, /* phy_rx */
>> +                      <0x4A096400 0x64>, /* phy_tx */
>> +                      <0x4A096800 0x40>; /* pll_ctrl */
>> +                reg-names = "phy_rx", "phy_tx", "pll_ctrl";
>> +                ctrl-module = <&omap_control_sata>;
>> +                clocks = <&sata_ref_clk>,
>> +                     <&sys_clkin1>;
>> +                clock-names = "optclk", "sysclk";
>> +                #phy-cells = <0>;
>> +            };
>> +        };
>> +
>> +        sata: sata@4a141100 {
>> +            compatible = "ti,sata";
>> +            ti,hwmods = "sata";
>> +            reg = <0x4a141100 0x7>;
>> +            #address-cells = <1>;
>> +            #size-cells = <1>;
>> +            ranges;
>> +            dwc-ahci@4a140000 {
> 
>    Hm, ePAPR spec. [1] says that "the name of a node should be somewhat generic, reflecting the function of the device and not its precise programming model", so it looks like the name should be "sata" as well. I'm a bit at a loss here, not sure why you had to use the nested device nodes.
> 

ok. will fix it to sata.
I've nested it because the wrapper registers are not part of the AHCI sata controller.
They are TI specific registers for power management. 
Similar setup is on the USB controller. Please see omap_dwc3 node.

But if you have better idea, please let me know.

>> +                  compatible = "snps,dwc-ahci";
>> +                  reg = <0x4a140000 0x1100>;
>> +                  interrupts = <0 54 0x4>;
>> +                  phys = <&sata_phy>;
> 
>    Hm, it's the third PHY related generic property I'm encountering. First, there was "phy-handle", then "phy", now "phys"... Seems like a bit too much. :-)

I'm afraid but this is how the designers have made it.

1) control-phy-pipe3 is that part of the PHY which sits in control module space and is different
from the sata-phy space and hence needs a different node. If it were to me, I would just put this
resource in sata-phy node, but there was a discussion about this earlier to do it otherwise [1].

2) sata-phy (sataphy) is the actual SATA PHY device.

3) phys is just a reference to the sata_phy and is used via the generic PHY framework.
It is upto the sata driver to power up/down the phy.

> 
>> +                  phy-names = "sata-phy";
>> +                  clocks = <&sata_ref_clk>;
>> +                  clock-names = "optclk";
>> +            };
>> +        };
> 
> [1] http://www.power.org/resources/downloads/Power_ePAPR_APPROVED_v1.0.pdf
> 

cheers,
-roger

[1] - https://lkml.org/lkml/2012/9/10/399
