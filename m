Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754539AbaEHP3s (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 May 2014 11:29:48 -0400
Received: from mga02.intel.com ([134.134.136.20]:7678 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751776AbaEHP3q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 May 2014 11:29:46 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,1010,1389772800"; 
   d="scan'208";a="508448963"
Message-ID: <536BA2A3.50506@intel.com>
Date: Thu, 08 May 2014 23:28:35 +0800
From: Jet Chen <jet.chen@intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: Alexander Duyck <alexander.h.duyck@intel.com>,
        Dan Williams <dan.j.williams@intel.com>,
        Dave Jiang <dave.jiang@intel.com>
CC: fengguang.wu@intel.com, wei.w.lin@intel.com, linux-kernel@vger.kernel.org,
        dmaengine@vger.kernel.org
Subject: Re: [PATCH] DCA: fix over-warning in ioat3_dca_init
References: <1399542166-42985-1-git-send-email-jet.chen@intel.com> <536B9CF6.9000907@intel.com>
In-Reply-To: <536B9CF6.9000907@intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I agree with your option that it is a real BIOS bug and it puts pressure on the BIOS guys to get this fixed. However, this warning message interferes with our kernel booting tests and kernel performance tests. We have to disable CONFIG_INTEL_IOATDMA in kconfig until this issue gets fixed. Before that, code of CONFIG_INTEL_IOATDMA will not be validated in our testing system :(.
Hope this issue could get fixed soon.

Thanks,
Jet

On 05/08/2014 11:04 PM, Alexander Duyck wrote:
> I actually went to a bit of trouble to get this message added as many
> BIOSes have the annoying quality of getting this wrong, and then
> products are shipped and labeled as having the DCA feature when they
> actually don't.  One easy way to get rid of the message is to disable
> either DCA or IOAT in the BIOS since it is broken anyway.  By adding
> this we at least have some visibility and it puts pressure on the BIOS
> guys to get this fixed if we want to claim the platform does DCA.
> 
> I consider this to be a real BIOS bug as the DCA feature is crippled
> without it.  Also moving this to just a debug message is going to make
> it very difficult for us to debug this when a performance issue comes up
> on a customer platform as we will have to get them to perform extra
> steps in order to actually figure out what is going on with DCA.
> 
> Thanks,
> 
> Alex
> 
> On 05/08/2014 02:42 AM, Jet Chen wrote:
>> We keep seeing such dmesg messages on boxes
>>
>> [   16.596610] WARNING: CPU: 0 PID: 457 at drivers/dma/ioat/dca.c:697 ioat3_dca_init+0x19c/0x1b0 [ioatdma]()
>> [   16.609614] ioatdma 0000:00:04.0: APICID_TAG_MAP set incorrectly by BIOS, disabling DCA
>> ...
>> [   16.892058]  [<ffffffff8172807e>] dump_stack+0x4d/0x66
>> [   16.892061]  [<ffffffff81067f7d>] warn_slowpath_common+0x7d/0xa0
>> [   16.892064]  [<ffffffff81068034>] warn_slowpath_fmt_taint+0x44/0x50
>> [   16.892065]  [<ffffffffa00228bc>] ioat3_dca_init+0x19c/0x1b0 [ioatdma]
>> [   16.892069]  [<ffffffffa0021cd6>] ioat3_dma_probe+0x386/0x3e0 [ioatdma]
>> [   16.892071]  [<ffffffffa001a192>] ioat_pci_probe+0x122/0x1b0 [ioatdma]
>> [   16.892074]  [<ffffffff81329385>] local_pci_probe+0x45/0xa0
>> [   16.892076]  [<ffffffff81080d34>] work_for_cpu_fn+0x14/0x20
>> [   16.892077]  [<ffffffff81083c33>] process_one_work+0x183/0x490
>> [   16.892079]  [<ffffffff81084bd3>] worker_thread+0x2a3/0x410
>> [   16.892080]  [<ffffffff81084930>] ? rescuer_thread+0x410/0x410
>> [   16.892081]  [<ffffffff8108b852>] kthread+0xd2/0xf0
>> [   16.892083]  [<ffffffff8108b780>] ? kthread_create_on_node+0x180/0x180
>> [   16.892085]  [<ffffffff817396bc>] ret_from_fork+0x7c/0xb0
>> [   16.892091] fbcon: mgadrmfb (fb0) is primary device
>> [   16.892092]  [<ffffffff8108b780>] ? kthread_create_on_node+0x180/0x180
>>
>> No need to use WARN_TAINT_ONCE to generate a such big noise if this is not a critical error for kernel. DCA driver could print out a debug messages then quit quietly.
>>
>> If this is a real BIOS bug, please ignore this patch. Let's transfer this issue to BIOS guys.
>>
>> Signed-off-by: Jet Chen <jet.chen@intel.com>
>> ---
>>  drivers/dma/ioat/dca.c | 10 ++--------
>>  1 file changed, 2 insertions(+), 8 deletions(-)
>>
>> diff --git a/drivers/dma/ioat/dca.c b/drivers/dma/ioat/dca.c
>> index 9e84d5b..c0f7971 100644
>> --- a/drivers/dma/ioat/dca.c
>> +++ b/drivers/dma/ioat/dca.c
>> @@ -470,10 +470,7 @@ struct dca_provider *ioat2_dca_init(struct pci_dev *pdev, void __iomem *iobase)
>>  	}
>>  
>>  	if (!dca2_tag_map_valid(ioatdca->tag_map)) {
>> -		WARN_TAINT_ONCE(1, TAINT_FIRMWARE_WORKAROUND,
>> -				"%s %s: APICID_TAG_MAP set incorrectly by BIOS, disabling DCA\n",
>> -				dev_driver_string(&pdev->dev),
>> -				dev_name(&pdev->dev));
>> +		dev_dbg(&pdev->dev, "APICID_TAG_MAP set incorrectly by BIOS, disabling DCA\n");
>>  		free_dca_provider(dca);
>>  		return NULL;
>>  	}
>> @@ -691,10 +688,7 @@ struct dca_provider *ioat3_dca_init(struct pci_dev *pdev, void __iomem *iobase)
>>  	}
>>  
>>  	if (dca3_tag_map_invalid(ioatdca->tag_map)) {
>> -		WARN_TAINT_ONCE(1, TAINT_FIRMWARE_WORKAROUND,
>> -				"%s %s: APICID_TAG_MAP set incorrectly by BIOS, disabling DCA\n",
>> -				dev_driver_string(&pdev->dev),
>> -				dev_name(&pdev->dev));
>> +		dev_dbg(&pdev->dev, "APICID_TAG_MAP set incorrectly by BIOS, disabling DCA\n");
>>  		free_dca_provider(dca);
>>  		return NULL;
>>  	}
> 
