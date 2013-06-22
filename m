Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752333Ab3FVIZ4 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Jun 2013 04:25:56 -0400
Received: from mail-pb0-f49.google.com ([209.85.160.49]:49547 "EHLO
	mail-pb0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751256Ab3FVIZv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Jun 2013 04:25:51 -0400
Message-ID: <51C55F87.8080702@ozlabs.ru>
Date: Sat, 22 Jun 2013 18:25:43 +1000
From: Alexey Kardashevskiy <aik@ozlabs.ru>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130514 Thunderbird/17.0.6
MIME-Version: 1.0
To: Alex Williamson <alex.williamson@redhat.com>
CC: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        David Gibson <david@gibson.dropbear.id.au>,
        Alexander Graf <agraf@suse.de>, linuxppc-dev@lists.ozlabs.org,
        Paul Mackerras <paulus@samba.org>,
        "kvm@vger.kernel.org mailing list" <kvm@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>, kvm-ppc@vger.kernel.org,
        Rusty Russell <rusty@rustcorp.com.au>, Joerg Roedel <joro@8bytes.org>
Subject: Re: [PATCH 3/4] KVM: PPC: Add support for IOMMU in-kernel handling
References: <1371422343.21896.143.camel@pasglop>   <1371438800.22681.38.camel@ul30vt.home>   <1371441361.21896.152.camel@pasglop>   <1371522772.22681.140.camel@ul30vt.home> <87txkun568.fsf@rustcorp.com.au>   <1371617970.21896.232.camel@pasglop>   <E63966E3-336F-4CB8-96EC-24D2C1644E62@suse.de>   <1371653443.21896.291.camel@pasglop>   <1371656989.22659.98.camel@ul30vt.home> <51C28BEA.8050501@ozlabs.ru>   <20130620052822.GB3140@voom.redhat.com> <1371714449.3944.14.camel@pasglop>  <51C2C1CC.9000003@ozlabs.ru> <1371740113.32709.22.camel@ul30vt.home>
In-Reply-To: <1371740113.32709.22.camel@ul30vt.home>
Content-Type: text/plain; charset=KOI8-R
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/21/2013 12:55 AM, Alex Williamson wrote:
> On Thu, 2013-06-20 at 18:48 +1000, Alexey Kardashevskiy wrote:
>> On 06/20/2013 05:47 PM, Benjamin Herrenschmidt wrote:
>>> On Thu, 2013-06-20 at 15:28 +1000, David Gibson wrote:
>>>>> Just out of curiosity - would not get_file() and fput_atomic() on a
>>>> group's
>>>>> file* do the right job instead of vfio_group_add_external_user() and
>>>>> vfio_group_del_external_user()?
>>>>
>>>> I was thinking that too.  Grabbing a file reference would certainly be
>>>> the usual way of handling this sort of thing.
>>>
>>> But that wouldn't prevent the group ownership to be returned to
>>> the kernel or another user would it ?
>>
>>
>> Holding the file pointer does not let the group->container_users counter go
>> to zero
> 
> How so?  Holding the file pointer means the file won't go away, which
> means the group release function won't be called.  That means the group
> won't go away, but that doesn't mean it's attached to an IOMMU.  A user
> could call UNSET_CONTAINER.
> 
>>  and this is exactly what vfio_group_add_external_user() and
>> vfio_group_del_external_user() do. The difference is only in absolute value
>> - 2 vs. 3.
>>
>> No change in behaviour whether I use new vfio API or simply hold file* till
>> KVM closes fd created when IOMMU was connected to LIOBN.
> 
> By that notion you could open(/dev/vfio/$GROUP) and you're safe, right?
> But what about SET_CONTAINER & SET_IOMMU?  All that you guarantee
> holding the file pointer is that the vfio_group exists.
> 
>> And while this counter is not zero, QEMU cannot take ownership over the group.
>>
>> I am definitely still missing the bigger picture...
> 
> The bigger picture is that the group needs to exist AND it needs to be
> setup and maintained to have IOMMU protection.  Actually, my first stab
> at add_external_user doesn't look sufficient, it needs to look more like
> vfio_group_get_device_fd, checking group->container->iommu and
> group_viable().


This makes sense. If you did this, that would be great. Without it, I
really cannot see how the proposed inc/dec of container_users is better
than simple holding file*. Thanks.


> As written it would allow an external user after
> SET_CONTAINER without SET_IOMMU.  It should also be part of the API that
> the external user must hold the file reference between add_external_use
> and del_external_user and do cleanup on any exit paths.  Thanks,


-- 
Alexey
