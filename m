Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753443Ab3HVP2h (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Aug 2013 11:28:37 -0400
Received: from mx1.redhat.com ([209.132.183.28]:55405 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752563Ab3HVP2g (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Aug 2013 11:28:36 -0400
Message-ID: <1377185303.25163.13.camel@ul30vt.home>
Subject: Re: [PATCH 2/2] powerpc/iommu: check dev->iommu_group before remove
 a device from iommu_group
From: Alex Williamson <alex.williamson@redhat.com>
To: Wei Yang <weiyang@linux.vnet.ibm.com>
Cc: Alexey Kardashevskiy <aik@ozlabs.ru>, linuxppc-dev@lists.ozlabs.org,
        linux-kernel@vger.kernel.org, benh@au1.ibm.com, paulus@au1.ibm.com
Date: Thu, 22 Aug 2013 09:28:23 -0600
In-Reply-To: <20130822075237.GA14479@weiyang.vnet.ibm.com>
References: <1376647687-20550-1-git-send-email-weiyang@linux.vnet.ibm.com>
	 <1376647687-20550-3-git-send-email-weiyang@linux.vnet.ibm.com>
	 <520DFBC8.4040509@ozlabs.ru> <20130819012945.GA8342@weiyang.vnet.ibm.com>
	 <52117765.7010205@ozlabs.ru> <20130819015538.GB8342@weiyang.vnet.ibm.com>
	 <5215BC76.10105@ozlabs.ru> <20130822075237.GA14479@weiyang.vnet.ibm.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2013-08-22 at 15:52 +0800, Wei Yang wrote:
> On Thu, Aug 22, 2013 at 05:23:34PM +1000, Alexey Kardashevskiy wrote:
> >On 08/19/2013 11:55 AM, Wei Yang wrote:
> >> On Mon, Aug 19, 2013 at 11:39:49AM +1000, Alexey Kardashevskiy wrote:
> >>> On 08/19/2013 11:29 AM, Wei Yang wrote:
> >>>> On Fri, Aug 16, 2013 at 08:15:36PM +1000, Alexey Kardashevskiy wrote:
> >>>>> On 08/16/2013 08:08 PM, Wei Yang wrote:
> >>>>>> ---
> >>>>>>  arch/powerpc/kernel/iommu.c |    3 ++-
> >>>>>>  1 files changed, 2 insertions(+), 1 deletions(-)
> >>>>>>
> >>>>>> diff --git a/arch/powerpc/kernel/iommu.c b/arch/powerpc/kernel/iommu.c
> >>>>>> index b20ff17..5abf7c3 100644
> >>>>>> --- a/arch/powerpc/kernel/iommu.c
> >>>>>> +++ b/arch/powerpc/kernel/iommu.c
> >>>>>> @@ -1149,7 +1149,8 @@ static int iommu_bus_notifier(struct notifier_block *nb,
> >>>>>>  	case BUS_NOTIFY_ADD_DEVICE:
> >>>>>>  		return iommu_add_device(dev);
> >>>>>>  	case BUS_NOTIFY_DEL_DEVICE:
> >>>>>> -		iommu_del_device(dev);
> >>>>>> +		if (dev->iommu_group)
> >>>>>> +			iommu_del_device(dev);
> >>>>>>  		return 0;
> >>>>>>  	default:
> >>>>>>  		return 0;
> >>>>>>
> >>>>>
> >>>>> This one seems redundant, no?
> >>>>
> >>>> Sorry for the late.
> >>>>
> >>>> Yes, these two patches have the same purpose to guard the system, while in two
> >>>> different places.  One is in powernv platform, the other is in the generic iommu 
> >>>> driver.
> >>>>
> >>>> The one in powernv platform is used to correct the original logic.
> >>>>
> >>>> The one in generic iommu driver is to keep system safe in case other platform to
> >>>> call iommu_group_remove_device() without the check.
> >>>
> >>>
> >>> But I am moving bus notifier to powernv code (posted a patch last week,
> >>> otherwise Freescale's IOMMU conflicted) so this won't be the case.
> >> 
> >> Yes, I see the patch.
> >> 
> >> This means other platforms, besides powernv, will check the dev->iommu_group
> >> before remove the device? This would be a convention?
> >> 
> >> If this is the case, the second patch is enough. We don't need to check it in
> >> generic iommu driver.
> >> 
> >> Since I am not very familiar with the code convention, I post these two
> >> patches together. This doesn't mean I need to push both of them. Your comments
> >> are welcome, lets me understand which one is more suitable in this case.
> >
> >
> >Ok. So. I included the check in the bus notifier which I moved to powernv
> >platform, I guess I'll repost the series soon.
> 
> Thanks, this check will guard the powernv platform.
> 
> >
> >Good luck with pushing the fix for drivers/iommu/iommu.c :)
> >
> 
> Alex,
> 
> Sorry for not including you in the very beginning, which may spend you more
> efforts to track previous mails in this thread.
> 
> Do you think it is reasonable to check the dev->iommu_group in
> iommu_group_remove_device()? Or we can count on the bus notifier to check it?
> 
> Welcome your suggestions~

I don't really see the point of patch 1/2. iommu_group_remove_device()
is specifically to remove a device from an iommu_group, so why would you
call it on a device that's not part of an iommu_group.  If you want to
avoid testing dev->iommu_group, then implement the .remove_device
callback rather than using the notifier.  Thanks,

Alex

