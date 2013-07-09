Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753686Ab3GIOIS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Jul 2013 10:08:18 -0400
Received: from mx1.redhat.com ([209.132.183.28]:4002 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752727Ab3GIOIQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Jul 2013 10:08:16 -0400
Message-ID: <1373378884.2602.205.camel@ul30vt.home>
Subject: Re: [PATCH 3/8] vfio: add external user support
From: Alex Williamson <alex.williamson@redhat.com>
To: Alexey Kardashevskiy <aik@ozlabs.ru>
Cc: linuxppc-dev@lists.ozlabs.org, David Gibson <david@gibson.dropbear.id.au>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>, Alexander Graf <agraf@suse.de>,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        kvm-ppc@vger.kernel.org
Date: Tue, 09 Jul 2013 08:08:04 -0600
In-Reply-To: <51DBA239.9000303@ozlabs.ru>
References: <1373123227-22969-1-git-send-email-aik@ozlabs.ru>
	  <1373123227-22969-4-git-send-email-aik@ozlabs.ru>
	 <1373320371.2602.159.camel@ul30vt.home> <51DBA239.9000303@ozlabs.ru>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2013-07-09 at 15:40 +1000, Alexey Kardashevskiy wrote:
> On 07/09/2013 07:52 AM, Alex Williamson wrote:
> > On Sun, 2013-07-07 at 01:07 +1000, Alexey Kardashevskiy wrote:
> >> VFIO is designed to be used via ioctls on file descriptors
> >> returned by VFIO.
> >>
> >> However in some situations support for an external user is required.
> >> The first user is KVM on PPC64 (SPAPR TCE protocol) which is going to
> >> use the existing VFIO groups for exclusive access in real/virtual mode
> >> on a host to avoid passing map/unmap requests to the user space which
> >> would made things pretty slow.
> >>
> >> The proposed protocol includes:
> >>
> >> 1. do normal VFIO init stuff such as opening a new container, attaching
> >> group(s) to it, setting an IOMMU driver for a container. When IOMMU is
> >> set for a container, all groups in it are considered ready to use by
> >> an external user.
> >>
> >> 2. pass a fd of the group we want to accelerate to KVM. KVM calls
> >> vfio_group_get_external_user() to verify if the group is initialized,
> >> IOMMU is set for it and increment the container user counter to prevent
> >> the VFIO group from disposal prior to KVM exit.
> >> The current TCE IOMMU driver marks the whole IOMMU table as busy when
> >> IOMMU is set for a container what prevents other DMA users from
> >> allocating from it so it is safe to grant user space access to it.
> >>
> >> 3. KVM calls vfio_external_user_iommu_id() to obtian an IOMMU ID which
> >> KVM uses to get an iommu_group struct for later use.
> >>
> >> 4. When KVM is finished, it calls vfio_group_put_external_user() to
> >> release the VFIO group by decrementing the container user counter.
> >> Everything gets released.
> >>
> >> The "vfio: Limit group opens" patch is also required for the consistency.
> >>
> >> Signed-off-by: Alexey Kardashevskiy <aik@ozlabs.ru>
> >> ---
> >> diff --git a/drivers/vfio/vfio.c b/drivers/vfio/vfio.c
> >> index c488da5..57aa191 100644
> >> --- a/drivers/vfio/vfio.c
> >> +++ b/drivers/vfio/vfio.c
> >> @@ -1370,6 +1370,62 @@ static const struct file_operations vfio_device_fops = {
> >>  };
> >>  
> >>  /**
> >> + * External user API, exported by symbols to be linked dynamically.
> >> + *
> >> + * The protocol includes:
> >> + *  1. do normal VFIO init operation:
> >> + *	- opening a new container;
> >> + *	- attaching group(s) to it;
> >> + *	- setting an IOMMU driver for a container.
> >> + * When IOMMU is set for a container, all groups in it are
> >> + * considered ready to use by an external user.
> >> + *
> >> + * 2. The user space passed a group fd which we want to accelerate in
> >> + * KVM. KVM uses vfio_group_get_external_user() to verify that:
> >> + *	- the group is initialized;
> >> + *	- IOMMU is set for it.
> >> + * Then vfio_group_get_external_user() increments the container user
> >> + * counter to prevent the VFIO group from disposal prior to KVM exit.
> >> + *
> >> + * 3. KVM calls vfio_external_user_iommu_id() to know an IOMMU ID which
> >> + * KVM uses to get an iommu_group struct for later use.
> >> + *
> >> + * 4. When KVM is finished, it calls vfio_group_put_external_user() to
> >> + * release the VFIO group by decrementing the container user counter.
> > 
> > nit, the interface is for any external user, not just kvm.
> 
> s/KVM/An external user/ ?
> Or add "the description below uses KVM just as an example of an external user"?

Give a generic API description, KVM is just an example.

> >> + */
> >> +struct vfio_group *vfio_group_get_external_user(struct file *filep)
> >> +{
> >> +	struct vfio_group *group = filep->private_data;
> >> +
> >> +	if (filep->f_op != &vfio_group_fops)
> >> +		return NULL;
> > 
> > ERR_PTR(-EINVAL)
> > 
> > There also needs to be a vfio_group_get(group) here and put in error
> > cases.
> 
> 
> Is that because I do not hold a reference to the file anymore?

We were debating whether it was needed even with the file reference
because we weren't sure that we wanted to trust the user to hold the
reference.  Since we're now passing an object, we absolutely must
increase the reference count on the object for this user.  Thanks,

Alex

> >> +
> >> +	if (!atomic_inc_not_zero(&group->container_users))
> >> +		return NULL;
> > 
> > ERR_PTR(-EINVAL)
> > 
> >> +
> >> +	if (!group->container->iommu_driver ||
> >> +			!vfio_group_viable(group)) {
> >> +		atomic_dec(&group->container_users);
> >> +		return NULL;
> > 
> > ERR_PTR(-EINVAL)
> > 
> >> +	}
> >> +
> >> +	return group;
> >> +}
> >> +EXPORT_SYMBOL_GPL(vfio_group_get_external_user);
> >> +
> >> +void vfio_group_put_external_user(struct vfio_group *group)
> >> +{
> >> +	vfio_group_try_dissolve_container(group);
> > 
> > And a vfio_group_put(group) here
> > 
> >> +}
> >> +EXPORT_SYMBOL_GPL(vfio_group_put_external_user);
> >> +
> >> +int vfio_external_user_iommu_id(struct vfio_group *group)
> >> +{
> >> +	return iommu_group_id(group->iommu_group);
> >> +}
> >> +EXPORT_SYMBOL_GPL(vfio_external_user_iommu_id);
> >> +
> >> +/**
> >>   * Module/class support
> >>   */
> >>  static char *vfio_devnode(struct device *dev, umode_t *mode)
> >> diff --git a/include/linux/vfio.h b/include/linux/vfio.h
> >> index ac8d488..24579a0 100644
> >> --- a/include/linux/vfio.h
> >> +++ b/include/linux/vfio.h
> >> @@ -90,4 +90,11 @@ extern void vfio_unregister_iommu_driver(
> >>  	TYPE tmp;						\
> >>  	offsetof(TYPE, MEMBER) + sizeof(tmp.MEMBER); })		\
> >>  
> >> +/*
> >> + * External user API
> >> + */
> >> +extern struct vfio_group *vfio_group_get_external_user(struct file *filep);
> >> +extern void vfio_group_put_external_user(struct vfio_group *group);
> >> +extern int vfio_external_user_iommu_id(struct vfio_group *group);
> >> +
> >>  #endif /* VFIO_H */
> > 
> > 
> > 
> 
> 



