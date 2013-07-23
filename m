Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754088Ab3GWGaK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jul 2013 02:30:10 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:59086 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751935Ab3GWGaI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jul 2013 02:30:08 -0400
Message-ID: <51EE22DF.6090902@ti.com>
Date: Tue, 23 Jul 2013 11:59:51 +0530
From: Kishon Vijay Abraham I <kishon@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130510 Thunderbird/17.0.6
MIME-Version: 1.0
To: Jingoo Han <jg1.han@samsung.com>
CC: "'Pratyush Anand'" <pratyush.anand@st.com>,
        "'Bjorn Helgaas'" <bhelgaas@google.com>, <linux-pci@vger.kernel.org>,
        <linux-samsung-soc@vger.kernel.org>,
        "'Kukjin Kim'" <kgene.kim@samsung.com>,
        "'Mohit KUMAR'" <Mohit.KUMAR@st.com>,
        "'Arnd Bergmann'" <arnd@arndb.de>, "'Sean Cross'" <xobs@kosagi.com>,
        "'Thierry Reding'" <thierry.reding@gmail.com>,
        "'SRIKANTH TUMKUR SHIVANAND'" <ts.srikanth@samsung.com>,
        <linux-kernel@vger.kernel.org>, <devicetree@vger.kernel.org>
Subject: Re: [PATCH V3] pci: exynos: split into two parts such as Synopsys
 part and Exynos part
References: <002801ce8376$a807dbf0$f81793d0$@samsung.com> <51ED49D6.9050209@ti.com> <000701ce8741$fe47deb0$fad79c10$@samsung.com>
In-Reply-To: <000701ce8741$fe47deb0$fad79c10$@samsung.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Tuesday 23 July 2013 06:44 AM, Jingoo Han wrote:
> On Tuesday, July 23, 2013 12:04 AM, Kishon Vijay Abraham I wrote:
>> On Thursday 18 July 2013 10:51 AM, Jingoo Han wrote:
>>> Exynos PCIe IP consists of Synopsys specific part and Exynos
>>> specific part. Only core block is a Synopsys designware part;
>>> other parts are Exynos specific.
>>> Also, the Synopsys designware part can be shared with other
>>> platforms; thus, it can be split two parts such as Synopsys
>>> designware part and Exynos specific part.
>>
>> some more queries and comments..
> 
.
.
<snip>
.
.
>>> +			of_pci_range_to_resource(&range, np, &pp->cfg);
>>> +			pp->config.cfg0_size = resource_size(&pp->cfg)/2;
>>> +			pp->config.cfg1_size = resource_size(&pp->cfg)/2;
>>> +		}
>>> +	}
>>> +
>>> +	pp->dbi_base = devm_ioremap(pp->dev, pp->cfg.start,
>>> +				resource_size(&pp->cfg));
>>
>> Why is configuraion space divided into two?
> 
> Sorry, I don't know the exact reason. :(
> Pratyush Anand may know about this.
> Pratyush Anand, could you answer the question?
> 
> Also, if you find some problems, please let me know.
> 
> 
>> Why should it be same as dbi_base?
>> AFAIK, jacinto6 has a dedicated configuration/io/memory space that is entirely
>> different from dbi_base.
> 
> According to the Synopsys designware PCIe datasheet,
> in chapter 5.1.1 Register Space Layout,
> 'Port Logic Registers' are placed between (config space 0x0 + 0x700)
> and (config space 0x0 + 0xFFF).
> 'dbi_base' is used for reading/writing 'Port Logic Registers'.
> Exynos are using 'dbi_base' like this. Thus, the base addresses of
> both 'dbi_base' and configuration/io/memory space are same.
> 
> Just now, I looked at Spear PCIe driver.
> However, in the case of Spear, the base address of configuration/io/memory
> space is defined as 0x80000000. The base address of 'Port Logic Registers'
> is defined as 0xb1000000.
> I think that the situation of 'jacinto6' is similar with Spear, right?
> 
> Then, I will move pp->dbi_base mapping code from pcie-designware.c
> to pci-exynos.c.

I think you need not move this to exynos (since registers in dbi_base is common
for all platforms) but modify the pcie-designware.c to use different address
space for dbi_base. In your case, you'll duplicate the address space for
dbi_base and configuration space.

Also I have one more query.
In your dt binding, your pci address and cpu address is the same. But the pci
address should start at 0x00000000 and end at 0xffffffff (for 32bit). Shouldn't
the cpu address map to something within this range of pci address?

Thanks
Kishon
