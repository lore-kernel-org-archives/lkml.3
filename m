Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752505AbaJFFSl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Oct 2014 01:18:41 -0400
Received: from bh-25.webhostbox.net ([208.91.199.152]:58646 "EHLO
	bh-25.webhostbox.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752232AbaJFFSi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Oct 2014 01:18:38 -0400
Message-ID: <54322627.3060803@roeck-us.net>
Date: Sun, 05 Oct 2014 22:18:31 -0700
From: Guenter Roeck <linux@roeck-us.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.0
MIME-Version: 1.0
To: Greg KH <gregkh@linuxfoundation.org>
CC: Jason Noakes <jjnoakes@gmail.com>,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: kobject_init and the zeroed-out-memory requirement
References: <CAN2+FEJY29jDF2PkGAYcG_0z=VQ4T+y7Ro56aeqrhSPYQ6ZEdw@mail.gmail.com> <20141005202843.GA1282@kroah.com> <CAN2+FEKsVyjV8v98R+V-xHseH1E2NKPquo6Z9nQc0M8d0Z620A@mail.gmail.com> <20141005215100.GA20426@kroah.com> <20141005232457.GA22525@kroah.com> <20141006020950.GA29722@roeck-us.net> <20141006032505.GD2722@kroah.com>
In-Reply-To: <20141006032505.GD2722@kroah.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
X-Authenticated_sender: linux@roeck-us.net
X-OutGoing-Spam-Status: No, score=-1.0
X-CTCH-PVer: 0000001
X-CTCH-Spam: Unknown
X-CTCH-VOD: Unknown
X-CTCH-Flags: 0
X-CTCH-RefID: str=0001.0A020206.5432262D.0032,ss=1,re=0.000,recu=0.000,reip=0.000,cl=1,cld=1,fgs=0
X-CTCH-Score: 0.000
X-CTCH-ScoreCust: 0.000
X-CTCH-Rules: 
X-CTCH-SenderID: linux@roeck-us.net
X-CTCH-SenderID-Flags: 0
X-CTCH-SenderID-TotalMessages: 1
X-CTCH-SenderID-TotalSpam: 0
X-CTCH-SenderID-TotalSuspected: 0
X-CTCH-SenderID-TotalConfirmed: 0
X-CTCH-SenderID-TotalBulk: 0
X-CTCH-SenderID-TotalVirus: 0
X-CTCH-SenderID-TotalRecipients: 0
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - bh-25.webhostbox.net
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - roeck-us.net
X-Get-Message-Sender-Via: bh-25.webhostbox.net: mailgid no entry from get_relayhosts_entry
X-Source: 
X-Source-Args: 
X-Source-Dir: 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/05/2014 08:25 PM, Greg KH wrote:
> On Sun, Oct 05, 2014 at 07:09:50PM -0700, Guenter Roeck wrote:
>> On Sun, Oct 05, 2014 at 04:24:57PM -0700, Greg KH wrote:
>>> On Sun, Oct 05, 2014 at 06:13:05PM -0400, Jason Noakes wrote:
>>>>> No driver should be working with "raw" kobjects.
>>>>
>>>> I don't agree, but it's irrelevant.
>>>
>>> Not at all.  I'd wager that if a driver is messing around with a "raw"
>>> kobject, it is doing something seriously wrong.  Of course there are
>>> exceptions, but those are very rare, and exceptions.  A driver should be
>>> using the driver core, and the functions and objects provided there, and
>>> provided by the bus it lives on.
>>>
>>> So, have a pointer to some driver code that is calling
>>> kobject_initialize()?  I'd love to see it.
>>>
>>
>> Lots to choose from. In drivers/:
>>
>> $ git grep kobject_init | wc
>>       65     289    4880
>> $ git grep kobject_init | grep -v base | wc
>>       62     277    4694
>> $ git grep kobject_init_and_add | grep -v base | wc
>>       47     232    3698
>> $ git grep kobject_add | grep -v base | wc
>>       20     111    1486
>
> Well, you hit firmware layer, and block devices, which have to deal with
> kobjects directly at times.  But these files look "suspicious":
> 	edac/edac_device_sysfs.c
> 	edac/edac_pci_sysfs.c
> 	gpu/drm/ttm/ttm_bo.c
> 	gpu/drm/ttm/ttm_memory.c
> 	gpu/drm/ttm/ttm_page_alloc.c
> 	gpu/drm/ttm/ttm_page_alloc_dma.c
> 	infiniband/core/cm.c
> 	infiniband/core/sysfs.c
> 	infiniband/core/user_mad.c
> 	infiniband/hw/mlx4/sysfs.c
> 	infiniband/hw/qib/qib_sysfs.c
> 	infiniband/hw/usnic/usnic_ib_sysfs.c
> 	iommu/iommu.c
> 	parisc/pdc_stable.c
> 	pci/slot.c
> 	power/ab8500_fg.c
> 	power/abx500_chargalg.c
> 	scsi/iscsi_boot_sysfs.c
> 	uio/uio.c
> 	video/fbdev/omap2/dss/manager-sysfs.c
> 	video/fbdev/omap2/dss/overlay-sysfs.c
>
> I'll look into them tomorrow...
>
> But that's still a very small minority compared to the tens of thousands
> of drivers we have, so I still say it's wrong to have a driver deal with
> raw kobjects.
>

I agree. Just wanted to point out that there _are_ drivers out there
using it. I had actually looked into the power and video files,
and they looked suspicious to me as well.

Guenter

