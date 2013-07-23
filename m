Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751578Ab3GWEth (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jul 2013 00:49:37 -0400
Received: from eu1sys200aog108.obsmtp.com ([207.126.144.125]:51960 "EHLO
	eu1sys200aog108.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750720Ab3GWEtf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jul 2013 00:49:35 -0400
Message-ID: <51EE0B41.2090002@st.com>
Date: Tue, 23 Jul 2013 10:19:05 +0530
From: Pratyush Anand <pratyush.anand@st.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:13.0) Gecko/20120614 Thunderbird/13.0.1
MIME-Version: 1.0
To: Jingoo Han <jg1.han@samsung.com>,
        "'Kishon Vijay Abraham I'" <kishon@ti.com>,
        Mohit KUMAR <Mohit.KUMAR@st.com>
Cc: "'Bjorn Helgaas'" <bhelgaas@google.com>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "linux-samsung-soc@vger.kernel.org" 
	<linux-samsung-soc@vger.kernel.org>,
        "'Kukjin Kim'" <kgene.kim@samsung.com>,
        "'Arnd Bergmann'" <arnd@arndb.de>, "'Sean Cross'" <xobs@kosagi.com>,
        "'Thierry Reding'" <thierry.reding@gmail.com>,
        "'SRIKANTH TUMKUR SHIVANAND'" <ts.srikanth@samsung.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>,
        spear-devel <spear-devel@list.st.com>
Subject: Re: [PATCH V3] pci: exynos: split into two parts such as Synopsys
 part and Exynos part
References: <002801ce8376$a807dbf0$f81793d0$@samsung.com> <51ED49D6.9050209@ti.com> <000701ce8741$fe47deb0$fad79c10$@samsung.com>
In-Reply-To: <000701ce8741$fe47deb0$fad79c10$@samsung.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 7/23/2013 6:44 AM, Jingoo Han wrote:
>>> +           if (restype == IORESOURCE_MEM) {
>>> > >+                   of_pci_range_to_resource(&range, np, &pp->mem);
>>> > >+                   pp->mem.name = "MEM";
>>> > >+                   pp->config.mem_size = resource_size(&pp->mem);
>>> > >+                   pp->config.mem_bus_addr = range.pci_addr;
>>> > >+           }
>>> > >+           if (restype == 0) {
>>> > >+                   of_pci_range_to_resource(&range, np, &pp->cfg);
>>> > >+                   pp->config.cfg0_size = resource_size(&pp->cfg)/2;
>>> > >+                   pp->config.cfg1_size = resource_size(&pp->cfg)/2;
>>> > >+           }
>>> > >+   }
>>> > >+
>>> > >+   pp->dbi_base = devm_ioremap(pp->dev, pp->cfg.start,
>>> > >+                           resource_size(&pp->cfg));
>> >
>> >Why is configuraion space divided into two?
> Sorry, I don't know the exact reason.:(
> Pratyush Anand may know about this.
> Pratyush Anand, could you answer the question?
>

CfgRd1 and CfgWr1 transactions are needed when an EP is not directly 
connected to RC, rather connected through a bridge. For more detail see 
PCIe specs.
Now, if we wish to generate a CfgRd/Wr1 transaction using SNPS 
controller then we can not use same programmed viewport as that for 
CfgRd/Wr0. However, a viewport can be reprogrammed using same physical 
cfg address to generate either cfg0 or cfg1. So, in that case we can do 
with only one cfg area and no reason to divide it into two.
Current code assumes that there are only 4 viewports available (2 in 
outbound and 2 in inbound direction) and it always programs viewport 
dynamically for cfg0/1 as per need. But same can not be true for all 
implementations. There can be a case where hardware has sufficient 
number of viewports and software does not need to reprogram it 
dynamically. In that situation different physical memory area for each 
type of TLP would make the execution faster.

> Also, if you find some problems, please let me know.
>
>
>> >Why should it be same as dbi_base?
>> >AFAIK, jacinto6 has a dedicated configuration/io/memory space that is entirely
>> >different from dbi_base.
> According to the Synopsys designware PCIe datasheet,
> in chapter 5.1.1 Register Space Layout,
> 'Port Logic Registers' are placed between (config space 0x0 + 0x700)
> and (config space 0x0 + 0xFFF).
> 'dbi_base' is used for reading/writing 'Port Logic Registers'.
> Exynos are using 'dbi_base' like this. Thus, the base addresses of
> both 'dbi_base' and configuration/io/memory space are same.

Yes address space are same, but at any moment they work either as dbi 
space or as configuration/io/memory space depending on the dbi_enable 
bit of application register. Similar functionality was there in one 
older SPEAr implementation.

>
> Just now, I looked at Spear PCIe driver.
> However, in the case of Spear, the base address of configuration/io/memory
> space is defined as 0x80000000. The base address of 'Port Logic Registers'
> is defined as 0xb1000000.
> I think that the situation of 'jacinto6' is similar with Spear, right?

In SPEAr1340 PCIe memory layout is as follows:

DBI base (0xB1000000 to 0xB1001FFF): This space is used to read/write 
own PCI Configuration Header, Capability and Port Logic(PL) Registers.

ELBI space (0xB1002000 to  0xB17FFFFF): These are completely SPEAr 
specific application registers.

configuration/io/memory space(0x80000000 to 0x8FFFFFFF): These can be 
used in viewport programming to generate different type of outbound 
transaction.

Regards
Pratyush


>
> Then, I will move pp->dbi_base mapping code from pcie-designware.c
> to pci-exynos.c.


