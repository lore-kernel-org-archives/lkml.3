Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753018Ab3JRKaB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Oct 2013 06:30:01 -0400
Received: from mail-pa0-f54.google.com ([209.85.220.54]:50710 "EHLO
	mail-pa0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752675Ab3JRK37 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Oct 2013 06:29:59 -0400
MIME-Version: 1.0
X-Originating-IP: [2a01:e35:2434:4600:25c7:e66d:2918:62ac]
In-Reply-To: <20131014170719.GR10491@mudshark.cambridge.arm.com>
References: <1381497887-14586-1-git-send-email-a.motakis@virtualopensystems.com>
	<20131014124815.GC10491@mudshark.cambridge.arm.com>
	<CAG8rG2wftreREPnCbH8cKtsHD4TXBFAYGfY0ZMmsX3UW757r4Q@mail.gmail.com>
	<20131014170719.GR10491@mudshark.cambridge.arm.com>
Date: Fri, 18 Oct 2013 12:29:59 +0200
Message-ID: <CAG8rG2wC-O=5quLHT_7vHvTOk-ymRsbYqoVG8YU742wWWRMSKA@mail.gmail.com>
Subject: Re: [PATCH 1/2] ARM: SMMU: add devices attached to the SMMU to an
 IOMMU group
From: Antonios Motakis <a.motakis@virtualopensystems.com>
To: Will Deacon <will.deacon@arm.com>
Cc: Joerg Roedel <joro@8bytes.org>,
        "moderated list:ARM SMMU DRIVER" 
	<linux-arm-kernel@lists.infradead.org>,
        "open list:IOMMU DRIVERS" <iommu@lists.linux-foundation.org>,
        open list <linux-kernel@vger.kernel.org>,
        "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>,
        "tech@virtualopensystems.com" <tech@virtualopensystems.com>,
        "agraf@suse.de" <agraf@suse.de>,
        "B08248@freescale.com" <B08248@freescale.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 14, 2013 at 7:07 PM, Will Deacon <will.deacon@arm.com> wrote:
> On Mon, Oct 14, 2013 at 04:13:15PM +0100, Antonios Motakis wrote:
>> On Mon, Oct 14, 2013 at 2:48 PM, Will Deacon <will.deacon@arm.com> wrote:
>> > > diff --git a/drivers/iommu/arm-smmu.c b/drivers/iommu/arm-smmu.c
>> > > index 0f45a48..8b71332 100644
>> > > --- a/drivers/iommu/arm-smmu.c
>> > > +++ b/drivers/iommu/arm-smmu.c
>> > > @@ -1502,6 +1502,8 @@ static int arm_smmu_add_device(struct device *dev)
>> > >  {
>> > >       struct arm_smmu_device *child, *parent, *smmu;
>> > >       struct arm_smmu_master *master = NULL;
>> > > +     struct iommu_group *group;
>> > > +     int ret;
>> > >
>> > >       spin_lock(&arm_smmu_devices_lock);
>> > >       list_for_each_entry(parent, &arm_smmu_devices, list) {
>> > > @@ -1534,13 +1536,27 @@ static int arm_smmu_add_device(struct device *dev)
>> > >       if (!master)
>> > >               return -ENODEV;
>> > >
>> > > +     group = iommu_group_get(dev);
>> >
>> > I'm not especially familiar with IOMMU groups (I understand them as the
>> > minimum translation granularity, which would mean single StreamID for the
>> > ARM SMMU), but under what circumstances would you expect to receive a
>> > non-NULL group here? I can't see any other code adding devices to groups
>> > (outside of other drivers)...
>> >
>>
>> You are right, only other IOMMU drivers will add a device to a group.
>> There was a discussion about this when I posted a similar patch for
>> the Exynos System MMU driver, see
>> http://lists.infradead.org/pipermail/linux-arm-kernel/2013-July/185675.html
>>
>> The idea is to check in the case of add_device() being called multiple
>> times, which is not the case most of the time, but still a sane
>> safeguard.
>
> Ok, but it feels a bit weird. The current code (arm_smmu_add_device)
> basically does a bunch of sanity checking against the DT data in order to
> find where the master sits in the device topology. Then it updates
> dev->archdata.iommu to point at the relevant SMMU instance.
>
> So, the interesting case is where the device was previously associated with
> a *different* IOMMU. In that case, the current code clobbers the iommu field
> with the new smmu, whereas the new code could end up getting very confused
> with respect to IOMMU groups.
>
> A better way is probably to check that dev->archdata.iommu is NULL before we
> assign to it. If not, then spit out a warning and return an error. That
> would also mean you could get rid of the group get/put calls.
>

Good point, this is a better way to handle this. I'll respin based on this.

> Will
