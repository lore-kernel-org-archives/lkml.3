Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755631Ab3AYJOb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jan 2013 04:14:31 -0500
Received: from szxga02-in.huawei.com ([119.145.14.65]:38460 "EHLO
	szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754910Ab3AYJOY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jan 2013 04:14:24 -0500
Message-ID: <51024CD4.10807@huawei.com>
Date: Fri, 25 Jan 2013 17:13:56 +0800
From: Yijing Wang <wangyijing@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:17.0) Gecko/20130107 Thunderbird/17.0.2
MIME-Version: 1.0
To: Bjorn Helgaas <bhelgaas@google.com>, Jon Mason <jdmason@kudzu.us>
CC: Rob Landley <rob@landley.net>, <linux-doc@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-pci@vger.kernel.org>,
        Andrew Murray <andrew.murray@arm.com>,
        Joe Lawrence <Joe.Lawrence@stratus.com>,
        Randy Dunlap <rdunlap@infradead.org>,
        Hanjun Guo <guohanjun@huawei.com>, <jiang.liu@huawei.com>
Subject: Re: [PATCH v2] PCI: Document PCIE BUS MPS parameters
References: <1358996288-31200-1-git-send-email-wangyijing@huawei.com> <CAErSpo6suRwkRoShnNUKxxHt4D4gFnMVqesoZO3t-aC8tvOwnA@mail.gmail.com>
In-Reply-To: <CAErSpo6suRwkRoShnNUKxxHt4D4gFnMVqesoZO3t-aC8tvOwnA@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.135.76.69]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Bjorn,
   Thanks for your review and comments! Please refer to inlined comment bellow.

On 2013/1/25 12:57, Bjorn Helgaas wrote:
> [+cc Jon, can you make sure this documentation is accurate?]
> 
>>
>> diff --git a/Documentation/kernel-parameters.txt b/Documentation/kernel-parameters.txt
>> index 363e348..0bb279f 100644
>> --- a/Documentation/kernel-parameters.txt
>> +++ b/Documentation/kernel-parameters.txt
>> @@ -2227,6 +2227,22 @@ bytes respectively. Such letter suffixes can also be entirely omitted.
>>                                 This sorting is done to get a device
>>                                 order compatible with older (<= 2.4) kernels.
>>                 nobfsort        Don't sort PCI devices into breadth-first order.
>> +               pcie_bus_tune_off       Disable PCIe MPS (Max Payload Size)
>> +                               turning and using the BIOS-configured MPS defaults.
> 
> s/turning/tuning/
> s/using/use/

Will update it.

> 
>> +               pcie_bus_safe   Use the smallest common denominator MPS
>> +                               of the entire tree below a root complex for every
>> +                               device on that fabric. Can avoid inconsistent MPS
>> +                               problem caused by hotplug.
> 
> I'm not sure about this.  "smallest common denominator" is colloquial
> and not exact.  I think you probably mean "the smallest supported MPS
> of any device below a root complex."

Yes, will update it.

> 
> I'm also not sure how this will avoid MPS problems caused by hotplug.
> I think you have to assume that a hot-added device may support only a
> 128B MPS, which means the only way to guarantee that you can use that
> device is to set MPS=128 for any device that will send packets to the
> hot-added device.  Or we could reconfigure things at the time of the
> hot-add, but I don't think we do that today (except for the hot-added
> device itself).

Actually, I'm working a new patch to fix this problem. I will send out the patch as soon.
Because system default use pcie_bus_tune_off, after do pci hotplug,
we never configure newly added pcie device mps. The default mps (128B) of
added pcie device maybe smaller than upstream port mps (maybe 256B default),
so this device can not work normally.
We can separate it in two:
1、Hotplug slot directly connected to root port:
  In this case, we can reconfigure root port and newly added pcie device mps.
  We can configure their mps to largest allowable vaule or conservatively just modify
  added device mps, make it equal to mps value in root port (consider peer to peer DMA).

2、Hotplug slot not connected to root port:
  In this case, we can try to configure newly added device mps equal to upsteam port.
  If newly added device mpss smaller than mps in upstream port. We need to print warning
  info, let user know what to do next step.

> 
>> +               pcie_bus_perf   Configure pcie device MPS to the largest
> 
> Capitalize "PCIe" consistently.  Better yet, drop it completely since
> it's obvious that we're only talking about PCIe here.

Ok, drop it.

> 
>> +                               allowable MPS based on its parent bus. Also set
>> +                               MRRS (Max Read Request Size) to the largest supported
>> +                               value (no larger than the MPS that the device or bus
>> +                               can support) for Max performance.
> 
> s/Max/best/

Will update it.

> 
>> +               pcie_bus_peer2peer      Make the system-wide MPS the smallest
>> +                               possible value (128B). This configuration could prevent
>> +                               peer to peer DMA transmission from working by having
>> +                               the MPS on one root port different than the MPS on
>> +                               another.
> 
> I think the idea is that pcie_bus_peer2peer would *allow* peer-to-peer
> DMA to work, which is the opposite of what you wrote.  Maybe something
> like this would be better:
> 
>   Set every device's MPS to 128B, which every device is guaranteed to support.
>   This configuration allows peer-to-peer DMA between any pair of devices,
>   possibly at the cost of reduced performance.
This description is good.

Very sorry, that's my fault. I will update it.

> 
>>                 cbiosize=nn[KMG]        The fixed amount of bus space which is
>>                                 reserved for the CardBus bridge's IO window.
>>                                 The default value is 256 bytes.
>> --
>> 1.7.1
>>
>>
> 
> .
> 


-- 
Thanks!
Yijing

