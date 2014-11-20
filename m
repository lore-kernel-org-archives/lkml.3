Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757322AbaKTO13 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Nov 2014 09:27:29 -0500
Received: from mail-wg0-f46.google.com ([74.125.82.46]:58525 "EHLO
	mail-wg0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756498AbaKTO11 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Nov 2014 09:27:27 -0500
Message-ID: <546DFA04.9060901@linaro.org>
Date: Thu, 20 Nov 2014 15:26:12 +0100
From: Eric Auger <eric.auger@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Antonios Motakis <a.motakis@virtualopensystems.com>,
        Alex Williamson <alex.williamson@redhat.com>
CC: kvm-arm <kvmarm@lists.cs.columbia.edu>,
        Linux IOMMU <iommu@lists.linux-foundation.org>,
        Will Deacon <will.deacon@arm.com>,
        VirtualOpenSystems Technical Team <tech@virtualopensystems.com>,
        Christoffer Dall <christoffer.dall@linaro.org>,
        Kim Phillips <kim.phillips@freescale.com>,
        Marc Zyngier <marc.zyngier@arm.com>, VFIO DRIVER <kvm@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v9 06/19] vfio/platform: return info for bound device
References: <1414433284-31719-1-git-send-email-a.motakis@virtualopensystems.com> <1414433284-31719-7-git-send-email-a.motakis@virtualopensystems.com> <5463373C.2010202@linaro.org> <1415810168.16601.353.camel@ul30vt.home> <CAG8rG2z_iCXEDGnfuZW_g+29NjhRXzUaDG3AUEVh1zvbf298BA@mail.gmail.com>
In-Reply-To: <CAG8rG2z_iCXEDGnfuZW_g+29NjhRXzUaDG3AUEVh1zvbf298BA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/20/2014 03:10 PM, Antonios Motakis wrote:
> On Wed, Nov 12, 2014 at 5:36 PM, Alex Williamson
> <alex.williamson@redhat.com> wrote:
>> On Wed, 2014-11-12 at 11:32 +0100, Eric Auger wrote:
>>> On 10/27/2014 07:07 PM, Antonios Motakis wrote:
>>>> A VFIO userspace driver will start by opening the VFIO device
>>>> that corresponds to an IOMMU group, and will use the ioctl interface
>>>> to get the basic device info, such as number of memory regions and
>>>> interrupts, and their properties. This patch enables the
>>>> VFIO_DEVICE_GET_INFO ioctl call.
>>>>
>>>> Signed-off-by: Antonios Motakis <a.motakis@virtualopensystems.com>
>>>> ---
>>>>  drivers/vfio/platform/vfio_platform_common.c | 23 ++++++++++++++++++++---
>>>>  1 file changed, 20 insertions(+), 3 deletions(-)
>>>>
>>>> diff --git a/drivers/vfio/platform/vfio_platform_common.c b/drivers/vfio/platform/vfio_platform_common.c
>>>> index e0fdbc8..cb20526 100644
>>>> --- a/drivers/vfio/platform/vfio_platform_common.c
>>>> +++ b/drivers/vfio/platform/vfio_platform_common.c
>>>> @@ -43,10 +43,27 @@ static int vfio_platform_open(void *device_data)
>>>>  static long vfio_platform_ioctl(void *device_data,
>>>>                        unsigned int cmd, unsigned long arg)
>>>>  {
>>>> -   if (cmd == VFIO_DEVICE_GET_INFO)
>>>> -           return -EINVAL;
>>>> +   struct vfio_platform_device *vdev = device_data;
>>>> +   unsigned long minsz;
>>>> +
>>>> +   if (cmd == VFIO_DEVICE_GET_INFO) {
>>>> +           struct vfio_device_info info;
>>>> +
>>>> +           minsz = offsetofend(struct vfio_device_info, num_irqs);
>>>> +
>>>> +           if (copy_from_user(&info, (void __user *)arg, minsz))
>>>> +                   return -EFAULT;
>>>> +
>>>> +           if (info.argsz < minsz)
>>>> +                   return -EINVAL;
>>>> +
>>>> +           info.flags = vdev->flags;
>>>> +           info.num_regions = 0;
>>>> +           info.num_irqs = 0;
>>> Seems a bit weird to me to enable the modality but returning zeroed
>>> values. Shouldn't we put that patch after VFIO_DEVICE_GET_REGION_INFO
>>> and VFIO_DEVICE_GET_IRQ_INFO ones?
>>
>> I actually like how Antonios has started from a base framework, exposing
>> a device but none of the resources and then incrementally adds each
>> component.  It's also a good showcase of the VFIO ABI that we can do
>> things like this.  Thanks,
> 
> I also agree with Alex with this. But of course I'm not married with
> any particular splitting style, in case we decide to change this.

Hi Antonios,
please keep as is. I also learn each day about splitting style ;-)
Best Regards
Eric
> 
>>
>> Alex
>>

