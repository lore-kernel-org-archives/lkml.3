Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752838AbaIIWub (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Sep 2014 18:50:31 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:38050 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751150AbaIIWu3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Sep 2014 18:50:29 -0400
Message-ID: <540F8425.70304@ti.com>
Date: Tue, 9 Sep 2014 18:50:13 -0400
From: Murali Karicheri <m-karicheri2@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
To: Arnd Bergmann <arnd@arndb.de>
CC: <linux-arm-kernel@lists.infradead.org>, <robh+dt@kernel.org>,
        <pawel.moll@arm.com>, <mark.rutland@arm.com>,
        <ijc+devicetree@hellion.org.uk>, <galak@codeaurora.org>,
        <bhelgaas@google.com>, <devicetree@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-pci@vger.kernel.org>
Subject: Re: [PATCH v2 2/2] PCI: keystone: update to support multiple pci
 ports
References: <1410293835-13050-1-git-send-email-m-karicheri2@ti.com> <9042477.aRbAhpkfQ5@wuerfel> <540F75DF.5050904@ti.com> <3967092.l9bxcqMaSa@wuerfel>
In-Reply-To: <3967092.l9bxcqMaSa@wuerfel>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/09/2014 05:52 PM, Arnd Bergmann wrote:
> On Tuesday 09 September 2014 17:49:19 Murali Karicheri wrote:
>> Actually this is an inteded. The vendor ID is in a register indicated by
>> reg offset and as per the device spec, it needs to be read and updated
>> by the software. Now since multiple instances of PCI device needs to be
>> read the same register, the reading happens in the probe() and same is
>> unmapped after that.
>>
>> +       ks_pcie->device_id = readl(reg_p)>>  16;
>> +       devm_iounmap(dev, reg_p);
>> +       devm_release_mem_region(dev, res->start, resource_size(res));
>>
>> Afetr that in ks_pcie_host_init(), it update the device_id in the RC's
>> config space.
>
> I'm not sure I understand the purpose of this. Do you mean you read
> the vendor/device ID of whichever device happens to get probed first
> and then program the same ID into all other devices as well?

My mistake. It is the device ID, not vendor ID. The PCI driver supports 
PCI h/w on K2HK, K2E and K2L SoCs for which PCI device IDs are assigned as

+#define PCIE_RC_K2HK		0xb008
+#define PCIE_RC_K2E		0xb009
+#define PCIE_RC_K2L		0xb00a
+

and the same driver code runs on all these h/w. The device ID is not 
filled in by default by the h/w, in the config space of the RC at offset 
1000h "VENDOR_DEVICE_ID Vendor and Device Identification Register". 
Same is available in a seperate SoC register whose offset is specified 
by index 2. This is read by driver and updated in the config space. The 
Vendor ID is however set by default.

There is a mrrs PCI quirk required for Keystone PCI which depends on 
this vendor ID to be filled correctly as it match vendor id/ device id 
of the bridge device to apply the quirk.

Hope this clarify your question.

Murali

>
> What if the order changes between two boots? Why does the vendor/device
> ID of the host bridge even matter at all?
>
> 	Arnd

