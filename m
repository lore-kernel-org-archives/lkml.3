Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755317AbaGIJjI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jul 2014 05:39:08 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:34837 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753660AbaGIJjF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jul 2014 05:39:05 -0400
Message-ID: <53BD0D8D.9000108@ti.com>
Date: Wed, 9 Jul 2014 15:08:21 +0530
From: Kishon Vijay Abraham I <kishon@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: Jingoo Han <jg1.han@samsung.com>, <mohit.kumar@st.com>
CC: <devicetree@vger.kernel.org>, <linux-doc@vger.kernel.org>,
        <linux-pci@vger.kernel.org>, <bhelgaas@google.com>,
        <linux-kernel@vger.kernel.org>, <grant.likely@linaro.org>,
        "'Jason Gunthorpe'" <jgunthorpe@obsidianresearch.com>,
        "'Marek Vasut'" <marex@denx.de>, "'Arnd Bergmann'" <arnd@arndb.de>
Subject: Re: [PATCH 2/3] PCI: designware: use untranslated address while programming
 ATU
References: <1403719007-9352-1-git-send-email-kishon@ti.com> <1403719007-9352-3-git-send-email-kishon@ti.com> <53BBE492.4070904@ti.com> <001201cf9aae$f2e080a0$d8a181e0$%han@samsung.com>
In-Reply-To: <001201cf9aae$f2e080a0$d8a181e0$%han@samsung.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jingoo,

On Tuesday 08 July 2014 06:47 PM, Jingoo Han wrote:
> On Tuesday, July 08, 2014 9:31 PM, Kishon Vijay Abraham I wrote:
>>
>> Hi Mohit, Jingoo,
>>
>> On Wednesday 25 June 2014 11:26 PM, Kishon Vijay Abraham I wrote:
>>> In DRA7, the cpu sees 32bit address, but the pcie controller can see only 28bit
>>> address. So whenever the cpu issues a read/write request, the 4 most
>>> significant bits are used by L3 to determine the target controller.
>>> For example, the cpu reserves 0x2000_0000 - 0x2FFF_FFFF for PCIe controller but
>>> the PCIe controller will see only (0x000_0000 - 0xFFF_FFF). So for programming
>>> the outbound translation window the *base* should be programmed as 0x000_0000.
>>> Whenever we try to write to say 0x2000_0000, it will be translated to whatever
>>> we have programmed in the translation window with base as 0x000_0000.
>>>
>>> This is needed when the dt node is modelled something like below
>>> axi {
>>> 	compatible = "simple-bus";
>>> 	#size-cells = <1>;
>>> 	#address-cells = <1>;
>>> 	ranges = <0x0        0x20000000 0x10000000 // 28-bit bus
>>> 		  0x51000000 0x51000000 0x3000>;
>>> 	pcie@51000000 {
>>> 		reg = <0x1000 0x2000>, <0x51002000 0x14c>, <0x51000000 0x2000>;
>>> 		reg-names = "config", "ti_conf", "rc_dbics";
>>> 		#address-cells = <3>;
>>> 		#size-cells = <2>;
>>> 		ranges = <0x81000000 0 0          0x03000 0 0x00010000
>>> 			  0x82000000 0 0x20013000 0x13000 0 0xffed000>;
>>> 	};
>>> };
>>>
>>> Here the CPU address for configuration space is 0x20013000 and the controller
>>> address for configuration space is 0x13000. The controller address should be
>>> used while programming the ATU (in order for translation to happen properly in
>>> DRA7xx).
>>
>> Are you okay with this patch? Can you give your Reviewed-by/Acked-by?
> 
> Sorry, I cannot understand fully what this patch does. :-(
> However, I have some questions as below.
> 
> 1. io_mod_addr
> The 'io_mod_addr' variable is not used. Then, how about removing
> 'io_mod_addr' from this patch?

Actually I missed using it in io_outbound(). Will fix it.
> 
> 2. ranges
> In the case of Exynos PCIe, there is no limitation such as 28bit for
> access. Then, when there is no 'ranges' property in DT file, is there
> no side effect? I mean the compatibility with other SoC's PCIe drivers.

It shouldn't break anything. The ranges is used to resolve cpu address while
adding resources to the device. So in other SoCs it'll use use the parent
'ranges' which is usually ocp/simple-bus to resolve cpu address. In my case it
has to use the axi ranges. So other SoCs shouldn't be impacted.
> 
> 3. _addr post fix
> 
> How about renaming 'cfg0_mod_addr', 'mem_mod_addr' as below?

sure.

Thanks
Kishon
