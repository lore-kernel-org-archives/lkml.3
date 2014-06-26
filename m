Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754965AbaFZIZJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jun 2014 04:25:09 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:37761 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751765AbaFZIZG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jun 2014 04:25:06 -0400
Message-ID: <53ABD8B8.5030200@ti.com>
Date: Thu, 26 Jun 2014 13:54:24 +0530
From: Kishon Vijay Abraham I <kishon@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: Pratyush Anand <pratyush.anand@st.com>
CC: Pratyush Anand <pratyush.anand@gmail.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        Jingoo Han <jg1.han@samsung.com>, Bjorn Helgaas <bhelgaas@google.com>,
        Mohit KUMAR DCG <Mohit.KUMAR@st.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "grant.likely@linaro.org" <grant.likely@linaro.org>,
        Jason Gunthorpe <jgunthorpe@obsidianresearch.com>,
        Marek Vasut <marex@denx.de>, Arnd Bergmann <arnd@arndb.de>
Subject: Re: [PATCH 2/3] PCI: designware: use untranslated address while programming
 ATU
References: <1403719007-9352-1-git-send-email-kishon@ti.com> <1403719007-9352-3-git-send-email-kishon@ti.com> <CAHM4w1mMT5een4pAFb9s1JENm=j1W2yMPYdO+OdBhAy0wcRdjw@mail.gmail.com> <53ABB93A.8070301@ti.com> <20140626063336.GA6166@pratyush-vbox>
In-Reply-To: <20140626063336.GA6166@pratyush-vbox>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Pratyush,

On Thursday 26 June 2014 12:03 PM, Pratyush Anand wrote:
> Hi Kishon,
> 
> On Thu, Jun 26, 2014 at 02:10:02PM +0800, Kishon Vijay Abraham I wrote:
>> Hi Pratyush,
>>
>> On Thursday 26 June 2014 11:07 AM, Pratyush Anand wrote:
>>> Hi Kishon,
>>>
>>>  Few things, if you can help me to understand:
>>>
>>> On Wed, Jun 25, 2014 at 11:26 PM, Kishon Vijay Abraham I <kishon@ti.com> wrote:
>>>> In DRA7, the cpu sees 32bit address, but the pcie controller can see only 28bit
>>>> address. So whenever the cpu issues a read/write request, the 4 most
>>>> significant bits are used by L3 to determine the target controller.
>>>> For example, the cpu reserves 0x2000_0000 - 0x2FFF_FFFF for PCIe controller but
>>>> the PCIe controller will see only (0x000_0000 - 0xFFF_FFF). So for programming
>>>> the outbound translation window the *base* should be programmed as 0x000_0000.
>>>> Whenever we try to write to say 0x2000_0000, it will be translated to whatever
>>>> we have programmed in the translation window with base as 0x000_0000.
>>>>
>>>> This is needed when the dt node is modelled something like below
>>>> axi {
>>>>         compatible = "simple-bus";
>>>>         #size-cells = <1>;
>>>>         #address-cells = <1>;
>>>>         ranges = <0x0        0x20000000 0x10000000 // 28-bit bus
>>>>                   0x51000000 0x51000000 0x3000>;
>>>>         pcie@51000000 {
>>>>                 reg = <0x1000 0x2000>, <0x51002000 0x14c>, <0x51000000 0x2000>;
>>>>                 reg-names = "config", "ti_conf", "rc_dbics";
>>>
>>> So for DRA7, config base which will be coming from reg property should
>>> be 0x1000 and size 0x2000, no?
>>
>> right. The first element in 'reg' and 'reg-names' specify exactly that.
>>>
>>>>                 #address-cells = <3>;
>>>>                 #size-cells = <2>;
>>>>                 ranges = <0x81000000 0 0          0x03000 0 0x00010000
>>>
>>> range type 0x81000000 tells that it is IO
>>>
>>>>                           0x82000000 0 0x20013000 0x13000 0 0xffed000>;
>>>
>>> range type 0x81000000 tells that it is mem
>>>
>>>
>>>>         };
>>>> };
>>>>
>>>> Here the CPU address for configuration space is 0x20013000 and the controller
>>>> address for configuration space is 0x13000. The controller address should
>>> be
>>>
>>> If above understanding is correct then:
>>>
>>> Aren't these addresses(0x20013000  and 0x13000) from mem space
>>> instead of configuration space.
>>
>> Sorry. I didn't get you. Configuration space is different from mem space and IO
>> space. We specify only the configuration space in "reg", the IO space and
>> memory space should be specified in ranges.
>>
>> In my case
>> configuration space range: 0x20001000 - 0x20002fff
>> IO space range:            0x20003000 - 0x20012fff
>> Mem space range:           0x20013000 - 0x2fffffff
>>
>> Here only the configuration space is obtained from 'reg' and 'IO' and 'MEM'
>> space is obtained from ranges.
>>>
>>> If yes, then how can you get two addresses (CPU and Controller address)
>>> from reg property for configuration space?
>>
>> I used platform_get_resource_byname() to get CPU address and of_get_address()
>> to get the untranslated controller address.
> 
> This is what I am not able to understand that how does
> platform_get_resource_byname gives correct CPU address from reg =
> <0x1000 0x2000>?
> 
> cfg_res = platform_get_resource_byname(pdev, IORESOURCE_MEM, "config");
> 
> how cfg_res->start is now 0x20001000? Shouldn't cfg_res->start be
> 0x1000?
> 
> What am I missing?

IIUC, converting to the cpu address happens long back when the platform device
is created from dt node.

See if the following makes sense to you.

starting from drivers/of/platform.c
of_device_alloc() -> of_address_to_resource() -> __of_address_to_resource() ->
of_translate_address() -> __of_translate_address() -> of_translate_one() ->
of_bus_default_translate()

So the 'resource' in 'struct platform_device' already holds the translated
address. platform_get_resource_byname() just returns the resource from this
platform device.

Cheers
Kishon
