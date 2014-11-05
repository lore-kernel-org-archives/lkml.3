Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754043AbaKEJNg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Nov 2014 04:13:36 -0500
Received: from szxga01-in.huawei.com ([119.145.14.64]:54658 "EHLO
	szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751298AbaKEJNc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Nov 2014 04:13:32 -0500
Message-ID: <5459EA0E.8020309@huawei.com>
Date: Wed, 5 Nov 2014 17:12:46 +0800
From: Shannon Zhao <zhaoshenglong@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: =?ISO-8859-1?Q?GAUGUEY_R=E9my_228890?= <remy.gauguey@cea.fr>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
CC: "mst@redhat.com" <mst@redhat.com>,
        "peter.maydell@linaro.org" <peter.maydell@linaro.org>,
        "john.liuli@huawei.com" <john.liuli@huawei.com>,
        "joel.schopp@amd.com" <joel.schopp@amd.com>,
        "qemu-devel@nongnu.org" <qemu-devel@nongnu.org>,
        "n.nikolaev@virtualopensystems.com" 
	<n.nikolaev@virtualopensystems.com>,
        "virtualization@lists.linux-foundation.org" 
	<virtualization@lists.linux-foundation.org>,
        "peter.huangpeng@huawei.com" <peter.huangpeng@huawei.com>,
        "hangaohuai@huawei.com" <hangaohuai@huawei.com>
Subject: Re: [RFC PATCH] virtio-mmio: support for multiple irqs
References: <1415093712-15156-1-git-send-email-zhaoshenglong@huawei.com> <5459D8E8.6060709@huawei.com> <022C7612790E20489F80A6F0D54B849F3B26F4F3@EXDAG0-B1.intra.cea.fr>
In-Reply-To: <022C7612790E20489F80A6F0D54B849F3B26F4F3@EXDAG0-B1.intra.cea.fr>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.177.16.142]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Rémy,

On 2014/11/5 16:26, GAUGUEY Rémy 228890 wrote:
> Hi Shannon, 
> 
>> Type of backend         bandwith(GBytes/sec)
>> virtio-net              0.66
>> vhost-net               1.49
>> vhost-net with irqfd    2.01
>>
>> Test cmd: ./iperf -c 192.168.0.2 -P 1 -i 10 -p 5001 -f G -t 60
> 
> Impressive results !
> Could you please detail your setup ? which platform are you using and which GbE controller ?

Sorry for not telling the test scenario. This test scenario is from Host to Guest. It just
compare the performance of different backends. I did this test on ARM64 platform.

The setup was based on:
1)on host kvm-arm should support ioeventfd and irqfd
	The irqfd patch is from Eric "ARM: KVM: add irqfd support".
	http://www.spinics.net/lists/kvm-arm/msg11014.html

	The ioeventfd patch is reworked by me from Antonios.
	http://www.spinics.net/lists/kvm-arm/msg08413.html

2)qemu should enable ioeventfd support for virtio-mmio
	This patch is refer to Ying-Shiuan Pan and reworked for new qemu branch.
	https://lists.gnu.org/archive/html/qemu-devel/2014-11/msg00594.html

3)qemu should enable multiple irqs for virtio-mmio
	This patch isn't sent to qemu maillist as we want to check whether this is the right direction.
	If you want to test, I'll send it to you.

4)in guest should enable support virtio-mmio to request multiple irqs
	This is what this patch do.

> As a reference, it would be good also to have result with an iperf to the HOST to see how far we are from a native configuration...
Agree!
> 
> Also, I assume a pending Qemu patch is necessary to assign multiple irqs ? I'm correct ? 
Yes, the patch is on it's way :)
> 
> Thanks a lot, 
> Best regards
> Rémy
> 
> -----Message d'origine-----
> De : Shannon Zhao [mailto:zhaoshenglong@huawei.com] 
> Envoyé : mercredi 5 novembre 2014 09:00
> À : linux-kernel@vger.kernel.org
> Cc : mst@redhat.com; peter.maydell@linaro.org; john.liuli@huawei.com; joel.schopp@amd.com; GAUGUEY Rémy 228890; qemu-devel@nongnu.org; n.nikolaev@virtualopensystems.com; virtualization@lists.linux-foundation.org; peter.huangpeng@huawei.com; hangaohuai@huawei.com
> Objet : Re: [RFC PATCH] virtio-mmio: support for multiple irqs
> 
> 
> On 2014/11/4 17:35, Shannon Zhao wrote:
>> As the current virtio-mmio only support single irq, so some advanced 
>> features such as vhost-net with irqfd are not supported. And the net 
>> performance is not the best without vhost-net and irqfd supporting.
>>
> Hi Joel, Peter, Mst,
> 
> Some virtio-net with virtio-mmio performance data on ARM added as followed:
> 
> Type of backend         bandwith(GBytes/sec)
> virtio-net              0.66
> vhost-net               1.49
> vhost-net with irqfd    2.01
> 
> Test cmd: ./iperf -c 192.168.0.2 -P 1 -i 10 -p 5001 -f G -t 60
> 
>>From this test data, irqfd has great improvement (about 30%) on performance.
> So maybe it's necessary to enable multiple irq support to make vhost-net with virtio-mmio on ARM be able to use irqfd.
> 
> How do you guys think? Look forward for your feedback.
> 
> Thanks,
> Shannon
> 
>> This patch support virtio-mmio to request multiple irqs like 
>> virtio-pci. With this patch and qemu assigning multiple irqs for 
>> virtio-mmio device, it's ok to use vhost-net with irqfd on arm/arm64.
>>
> .
> 

-- 
Shannon
