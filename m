Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751927AbaJ0J0g (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Oct 2014 05:26:36 -0400
Received: from szxga03-in.huawei.com ([119.145.14.66]:4660 "EHLO
	szxga03-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751308AbaJ0J0e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Oct 2014 05:26:34 -0400
Message-ID: <544E0E1B.1060104@huawei.com>
Date: Mon, 27 Oct 2014 17:19:23 +0800
From: Li Liu <john.liuli@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: "Michael S. Tsirkin" <mst@redhat.com>
CC: <linux-kernel@vger.kernel.org>, <qemu-devel@nongnu.org>,
        <peter.huangpeng@huawei.com>, <rusty@rustcorp.com.au>,
        <virtualization@lists.linux-foundation.org>,
        <n.nikolaev@virtualopensystems.com>, <yingshiuan.pan@gmail.com>,
        <remy.gauguey@cea.fr>, <joel.schopp@amd.com>
Subject: Re: [RFC PATCH 0/2] virtio-mmio: add irqfd support for vhost-net
 based on virtio-mmio
References: <1414225494-2208-1-git-send-email-john.liuli@huawei.com> <20141026115210.GA5497@redhat.com>
In-Reply-To: <20141026115210.GA5497@redhat.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.142.143.9]
X-CFilter-Loop: Reflected
X-Mirapoint-Virus-RAPID-Raw: score=unknown(0),
	refid=str=0001.0A020203.544E0E75.019C,ss=1,re=0.000,recu=0.000,reip=0.000,cl=1,cld=1,fgs=0,
	ip=0.0.0.0,
	so=2013-05-26 15:14:31,
	dmn=2013-03-21 17:37:32
X-Mirapoint-Loop-Id: 3978984f5a295f86c7c44302a540372c
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 2014/10/26 19:52, Michael S. Tsirkin wrote:
> On Sat, Oct 25, 2014 at 04:24:52PM +0800, john.liuli wrote:
>> From: Li Liu <john.liuli@huawei.com>
>>
>> This set of patches try to implemet irqfd support of vhost-net 
>> based on virtio-mmio.
>>
>> I had posted a mail to talking about the status of vhost-net 
>> on kvm-arm refer to http://www.spinics.net/lists/kvm-arm/msg10804.html.
>> Some dependent patches are listed in the mail too. Basically the 
>> vhost-net brings great performance improvements, almost 50%+.
>>
>> It's easy to implement irqfd support with PCI MSI-X. But till 
>> now arm32 do not provide equivalent mechanism to let a device 
>> allocate multiple interrupts. And even the aarch64 provid LPI
>> but also not available in a short time.
>>
>> As Gauguey Remy said "Vhost does not emulate a complete virtio 
>> adapter but only manage virtqueue operations". Vhost module
>> don't update the ISR register, so if with only one irq then it's 
>> no way to get the interrupt reason even we can inject the 
>> irq correctly.  
> 
> Well guests don't read ISR in MSI-X mode so why does it help
> to set the ISR bit?

Yeah, vhost don't need to set ISR under MSI-X mode. But for ARM
without MSI-X kind mechanism guest can't get the interrupt reason
through the only one irq hanlder (with one gsi resource).

So I build a shared memory region to provide the interrupt reason
instead of ISR regiser by qemu without bothering vhost. Then even
there's only one irq with only one irq hanlder, it still can
distinguish why irq occur.

Li.

> 
>> To get the interrupt reason to support such VIRTIO_NET_F_STATUS 
>> features I add a new register offset VIRTIO_MMIO_ISRMEM which 
>> will help to establish a shared memory region between qemu and 
>> virtio-mmio device. Then the interrupt reason can be accessed by
>> guest driver through this region. At the same time, the virtio-mmio 
>> dirver check this region to see irqfd is supported or not during 
>> the irq handler registration, and different handler will be assigned.
>>
>> I want to know it's the right direction? Does it comply with the 
>> virtio-mmio spec.? Or anyone have more good ideas to emulate mis-x 
>> based on virtio-mmio? I hope to get feedback and guidance.
>> Thx for any help.
>>
>> Li Liu (2):
>>   Add a new register offset let interrupt reason available
>>   Assign a new irq handler while irqfd enabled
>>
>>  drivers/virtio/virtio_mmio.c |   55 +++++++++++++++++++++++++++++++++++++++---
>>  include/linux/virtio_mmio.h  |    3 +++
>>  2 files changed, 55 insertions(+), 3 deletions(-)
>>
>> -- 
>> 1.7.9.5
>>
> 
> .
> 

