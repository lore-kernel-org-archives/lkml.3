Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965351AbaCSOej (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Mar 2014 10:34:39 -0400
Received: from mail-qc0-f175.google.com ([209.85.216.175]:58248 "EHLO
	mail-qc0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965188AbaCSOeN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Mar 2014 10:34:13 -0400
Message-ID: <5329AAE1.7030705@gmail.com>
Date: Wed, 19 Mar 2014 09:34:09 -0500
From: Dinh Nguyen <dinh.linux@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: Arnd Bergmann <arnd@arndb.de>
CC: Dinh Nguyen <dinguyen@altera.com>,
        Srinivas Kandagatla <srinivas.kandagatla@st.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Hans de Goede <hdegoede@redhat.com>, arm@kernel.org,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        "David S. Miller" <davem@davemloft.net>,
        linux-arm-kernel@lists.infradead.org
Subject: Re: stmmac-socfpga breakage in arm-soc
References: <201403191333.01095.arnd@arndb.de> <53299CA8.607@gmail.com> <4337501.shzGE38xmF@wuerfel>
In-Reply-To: <4337501.shzGE38xmF@wuerfel>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Arnd,

On 03/19/2014 09:05 AM, Arnd Bergmann wrote:
> On Wednesday 19 March 2014 08:33:28 Dinh Nguyen wrote:
>> On 03/19/2014 07:33 AM, Arnd Bergmann wrote:
>>>
>>> * Replaced the parent/child DT nodes with a combined node
>>> * Renamed the device node from 'ethernet0' to 'ethernet'
>>>     as the standard name.
>>> * Removed interrupt-names and clock-names properties that
>>>     are not documented in the binding and not used.
>>> * Added a new DWMAC_SOCFPGA Kconfig symbol to control
>>>     compilation of this driver
>>
>> The v1 of this patch had this had this Kconfig symbol and is
>> similar to your proposed fix.
>>
>> http://marc.info/?l=linux-netdev&m=139167062725242&w=2
>
> I don't understand. So you got parts of it right at first, but then
> changed it in a different way from what Peppe asked you to do?
>
>>> diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_platform.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_platform.c
>>> index 8fb32a8..46aef510 100644
>>> --- a/drivers/net/ethernet/stmicro/stmmac/stmmac_platform.c
>>> +++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_platform.c
>>> @@ -38,6 +38,9 @@ static const struct of_device_id stmmac_dt_ids[] = {
>>>    	{ .compatible = "st,stih416-dwmac", .data = &sti_gmac_data},
>>>    	{ .compatible = "st,stid127-dwmac", .data = &sti_gmac_data},
>>>    #endif
>>> +#ifdef CONFIG_DWMAC_SOCFPGA
>>> +	{ .compatible = "altr,socfpga-stmmac", .data = &socfpga_gmac_data },
>>> +#endif
>>>    	/* SoC specific glue layers should come before generic bindings */
>>>    	{ .compatible = "st,spear600-gmac"},
>>>    	{ .compatible = "snps,dwmac-3.610"},
>>
>>
>> If it's okay with you Arnd, can I take this patch and add on top of it
>> as it is also breaking dtb builds:
>>
>> Error: arch/arm/boot/dts/socfpga_arria5_socdk.dts:51.2-3 label or path,
>> 'ethernet1', not found
>> FATAL ERROR: Syntax error parsing input tree
>> Error: arch/arm/boot/dts/socfpga_cyclone5_socdk.dts:44.2-3 label or
>> path, 'ethernet1', not found
>> FATAL ERROR: Syntax error parsing input tree
>> make[1]: *** [arch/arm/boot/dts/socfpga_arria5_socdk.dtb] Error 1
>> make[1]: *** Waiting for unfinished jobs....
>> make[1]: *** [arch/arm/boot/dts/socfpga_cyclone5_socdk.dtb] Error 1
>> Error: arch/arm/boot/dts/socfpga_cyclone5_sockit.dts:44.2-3 label or
>> path, 'ethernet1', not found
>> FATAL ERROR: Syntax error parsing input tree
>> make[1]: *** [arch/arm/boot/dts/socfpga_cyclone5_sockit.dtb] Error 1
>> Error: arch/arm/boot/dts/socfpga_vt.dts:92.2-3 label or path,
>> 'ethernet0', not found
>
> I have found the same problems and fixed it up locally already with
> the additional change below.
>
> 	Arnd
>
>
> diff --git a/arch/arm/boot/dts/socfpga_arria5_socdk.dts b/arch/arm/boot/dts/socfpga_arria5_socdk.dts
> index 2d6b38b..a87ee1c 100644
> --- a/arch/arm/boot/dts/socfpga_arria5_socdk.dts
> +++ b/arch/arm/boot/dts/socfpga_arria5_socdk.dts
> @@ -46,11 +46,8 @@
>   	};
>   };
>
> -&ethernet1 {
> -	status = "okay";
> -};
> -
>   &gmac1 {
> +	status = "okay";
>   	phy-mode = "rgmii";
>
>   	rxd0-skew-ps = <0>;
> diff --git a/arch/arm/boot/dts/socfpga_cyclone5_socdk.dts b/arch/arm/boot/dts/socfpga_cyclone5_socdk.dts
> index 26c63a0..ae16d97 100644
> --- a/arch/arm/boot/dts/socfpga_cyclone5_socdk.dts
> +++ b/arch/arm/boot/dts/socfpga_cyclone5_socdk.dts
> @@ -39,11 +39,8 @@
>   	};
>   };
>
> -&ethernet1 {
> -	status = "okay";
> -};
> -
>   &gmac1 {
> +	status = "okay";
>   	phy-mode = "rgmii";
>
>   	rxd0-skew-ps = <0>;
> diff --git a/arch/arm/boot/dts/socfpga_cyclone5_sockit.dts b/arch/arm/boot/dts/socfpga_cyclone5_sockit.dts
> index 469bb5c..b79e2a2 100644
> --- a/arch/arm/boot/dts/socfpga_cyclone5_sockit.dts
> +++ b/arch/arm/boot/dts/socfpga_cyclone5_sockit.dts
> @@ -39,11 +39,8 @@
>   	};
>   };
>
> -&ethernet1 {
> -	status = "okay";
> -};
> -
>   &gmac1 {
> +	status = "okay";
>   	phy-mode = "rgmii";
>
>   	rxd0-skew-ps = <0>;
> diff --git a/arch/arm/boot/dts/socfpga_vt.dts b/arch/arm/boot/dts/socfpga_vt.dts
> index 91f6ccf..0f33f2f 100644
> --- a/arch/arm/boot/dts/socfpga_vt.dts
> +++ b/arch/arm/boot/dts/socfpga_vt.dts
> @@ -87,10 +87,7 @@
>   	};
>   };
>
> -&ethernet0 {
> -        status = "okay";
> -};
> -
>   &gmac0 {
> +        status = "okay";
>   	phy-mode = "gmii";
>   };
>

I found that you also need this:


diff --git a/arch/arm/boot/dts/socfpga.dtsi 
b/arch/arm/boot/dts/socfpga.dtsi
index 5f1e256..953801c 100644
--- a/arch/arm/boot/dts/socfpga.dtsi
+++ b/arch/arm/boot/dts/socfpga.dtsi
@@ -456,8 +456,10 @@
                         altr,sysmgr-syscon = <&sysmgr 0x60>;
                         reg = <0xff700000 0x2000>;
                         interrupts = <0 115 4>;
+                       interrupt-names = "macirq";
                         mac-address = [00 00 00 00 00 00];/* Filled in 
by U-Boot */
                         clocks = <&emac0_clk>;
+                       clock-names = "stmmaceth";
                 };

                 gmac1: ethernet@ff702000 {
@@ -466,8 +468,10 @@
                         altr,sysmgr-syscon = <&sysmgr 0x60>;
                         reg = <0xff702000 0x2000>;
                         interrupts = <0 120 4>;
+                       interrupt-names = "macirq";
                         mac-address = [00 00 00 00 00 00];/* Filled in 
by U-Boot */
                         clocks = <&emac1_clk>;
+                       clock-names = "stmmaceth";
                 };

                 L2: l2-cache@fffef000 {
