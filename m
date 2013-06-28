Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754476Ab3F1ChQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Jun 2013 22:37:16 -0400
Received: from mx1.redhat.com ([209.132.183.28]:23749 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754291Ab3F1ChP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Jun 2013 22:37:15 -0400
Message-ID: <1372387020.30572.719.camel@ul30vt.home>
Subject: Re: [PATCH v2] vfio: add external user support
From: Alex Williamson <alex.williamson@redhat.com>
To: Alexey Kardashevskiy <aik@ozlabs.ru>
Cc: linuxppc-dev@lists.ozlabs.org, David Gibson <david@gibson.dropbear.id.au>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date: Thu, 27 Jun 2013 20:37:00 -0600
In-Reply-To: <51CCE927.4090606@ozlabs.ru>
References: <20130627164752.657c165ec4492e5248945a51@canb.auug.org.au>
	   <1372317260-6438-1-git-send-email-aik@ozlabs.ru>
	  <1372347850.30572.659.camel@ul30vt.home> <51CCC353.7030905@ozlabs.ru>
	 <1372380089.30572.689.camel@ul30vt.home> <51CCE927.4090606@ozlabs.ru>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2013-06-28 at 11:38 +1000, Alexey Kardashevskiy wrote:
> On 06/28/2013 10:41 AM, Alex Williamson wrote:
> > On Fri, 2013-06-28 at 08:57 +1000, Alexey Kardashevskiy wrote:
> >> On 06/28/2013 01:44 AM, Alex Williamson wrote:
> >>> On Thu, 2013-06-27 at 17:14 +1000, Alexey Kardashevskiy wrote:
> >>>> VFIO is designed to be used via ioctls on file descriptors
> >>>> returned by VFIO.
> >>>>
> >>>> However in some situations support for an external user is required.
> >>>> The first user is KVM on PPC64 (SPAPR TCE protocol) which is going to
> >>>> use the existing VFIO groups for exclusive access in real/virtual mode
> >>>> in the host kernel to avoid passing map/unmap requests to the user
> >>>> space which would made things pretty slow.
> >>>>
> >>>> The proposed protocol includes:
> >>>>
> >>>> 1. do normal VFIO init stuff such as opening a new container, attaching
> >>>> group(s) to it, setting an IOMMU driver for a container. When IOMMU is
> >>>> set for a container, all groups in it are considered ready to use by
> >>>> an external user.
> >>>>
> >>>> 2. pass a fd of the group we want to accelerate to KVM. KVM calls
> >>>> vfio_group_iommu_id_from_file() to verify if the group is initialized
> >>>> and IOMMU is set for it. The current TCE IOMMU driver marks the whole
> >>>> IOMMU table as busy when IOMMU is set for a container what this prevents
> >>>> other DMA users from allocating from it so it is safe to pass the group
> >>>> to the user space.
> >>>>
> >>>> 3. KVM increases the container users counter via
> >>>> vfio_group_add_external_user(). This prevents the VFIO group from
> >>>> being disposed prior to exiting KVM.
> >>>>
> >>>> 4. When KVM is finished and doing cleanup, it releases the group file
> >>>> and decrements the container users counter. Everything gets released.
> >>>>
> >>>> 5. KVM also keeps the group file as otherwise its fd might have been
> >>>> closed at the moment of KVM finish so vfio_group_del_external_user()
> >>>> call will not be possible.
> >>>
> >>> This is the wrong order in my mind.  An external user has no business
> >>> checking or maintaining any state of a group until it calls
> >>> add_external_user().  Only after that call is successful can the user
> >>> assume the filep to group relationship is static and get the iommu_id.
> >>> Any use of the "external user" API should start with "add" and end with
> >>> "del".
> >>
> >> Yes, this is what I actually do, just wrong commit message, will fix.
> >>
> >>>
> >>>> The "vfio: Limit group opens" patch is also required for the consistency.
> >>>>
> >>>> Signed-off-by: Alexey Kardashevskiy <aik@ozlabs.ru>
> >>>> ---
> >>>>
> >>>> v1->v2: added definitions to vfio.h :)
> >>>> Should not compile but compiled. Hm.
> >>>>
> >>>> ---
> >>>>  drivers/vfio/vfio.c  |   54 ++++++++++++++++++++++++++++++++++++++++++++++++++
> >>>>  include/linux/vfio.h |    7 +++++++
> >>>>  2 files changed, 61 insertions(+)
> >>>>
> >>>> diff --git a/drivers/vfio/vfio.c b/drivers/vfio/vfio.c
> >>>> index c488da5..40875d2 100644
> >>>> --- a/drivers/vfio/vfio.c
> >>>> +++ b/drivers/vfio/vfio.c
> >>>> @@ -1370,6 +1370,60 @@ static const struct file_operations vfio_device_fops = {
> >>>>  };
> >>>>  
> >>>>  /**
> >>>> + * External user API, exported by symbols to be linked dynamically.
> >>>> + */
> >>>> +
> >>>> +/* Allows an external user (for example, KVM) to lock an IOMMU group */
> >>>> +int vfio_group_add_external_user(struct file *filep)
> >>>> +{
> >>>> +	struct vfio_group *group = filep->private_data;
> >>>> +
> >>>> +	if (filep->f_op != &vfio_group_fops)
> >>>> +		return -EINVAL;
> >>>> +
> >>>> +	if (!atomic_inc_not_zero(&group->container_users))
> >>>> +		return -EINVAL;
> >>>
> >>> This is the place where I was suggesting we need tests to match
> >>> get_device_fd.  It's not clear what the external user is holding if the
> >>> group has no iommu or is not viable here.
> >>
> >>
> >> In my mind this test must include test for iommu id so I would merge it
> >> with vfio_group_iommu_id_from_file().
> > 
> > I'm not sure what that means.
> 
> Sorry. Still a mess in my head :( I'll to explain.
> 
> vfio_group_add_external_user() should tell if the group is viable and has
> iommu

Agreed

> (does not the latter include check for viable?).

Mostly paranoia

> vfio_group_iommu_id_from_file() tells the group id which has to be compared
> by KVM with what KVM got from the userspace and KVM should reject if the
> group id is wrong.
> 
> So there are 3 checks. KVM can continue if all three passed.

That's KVM's business, but what does it prove for userspace to give KVM
both a vfio group file descriptor and a group id?  It seems redundant
since the group id from vfio needs to take precedence.  More paranoia?

> >> Till I check iommu id, I still cannot
> >> use this group so where to put check for iommu/viable does not really
> >> matter (for me).
> > 
> > The difference is that getting the group id may just be the first of
> > several external user API interfaces.  The idea of external user
> > interface is that from add->del the group is maintained in the same
> > state as if a device was opened.
> 
> Good point.
> 
> > If we disassemble that so that add
> > sets up some stuff and getting the group id does a little more, what
> > happens if we start adding more external user API callbacks?  A user of
> > the interface shouldn't need to know the internals to know which
> > interface allows what aspect of use.  Besides, I don't want to have to
> > worry about managing another state slightly different from that used by
> > the device fd.
> 
> 
> 
> >>>
> >>>
> >>> if (!group->container->iommu_driver || !vfio_group_viable(group)) {
> >>> 	vfio_group_try_dissolve_container(group);
> >>> 	return -EINVAL;
> >>> }
> >>>
> >>>> +
> >>>> +	return 0;
> >>>> +}
> >>>> +EXPORT_SYMBOL_GPL(vfio_group_add_external_user);
> >>>> +
> >>>> +/* Allows an external user (for example, KVM) to unlock an IOMMU group */
> >>>> +void vfio_group_del_external_user(struct file *filep)
> >>>> +{
> >>>> +	struct vfio_group *group = filep->private_data;
> >>>> +
> >>>> +	if (WARN_ON(filep->f_op != &vfio_group_fops))
> >>>> +		return;
> >>>
> >>> How about we make this return int so we can return 0/-EINVAL and the
> >>> caller can decide the severity of the response?
> >>
> >> And what can the caller possibly do on !0?
> > 
> > What if the caller is just passing a filep from userspace, should they
> > be allowed to fill the logs by hitting this WARN_ON?  I don't know where
> > it comes from here and whether the caller can return an error to
> > userspace.  If this is the same filep that the caller used on add, they
> > they can legitimately WARN_ON, but we can't tell if that's the case
> > here.  Thanks,
> 
> Well, we say that holding file* is a part of API.

You're right, we should call vfio_group_get/put explicitly from add/del.
An open device increments the group reference count as well, so again
it's just making it look more like an open device.  This may favor a
get/put interface like below.

>  Why would anyone call
> vfio_group_del_external_user() on something but the file* it got when
> opened a group fd?

Is "Why" irrelevant?  WARN makes more sense to me if the release is done
from an object we provide.  If both the add and del are just
dereferencing a field of another object, we don't know where the object
comes from for release and we don't know how serious it is.  So another
way we could do the interface would be:

struct vfio_group *vfio_group_get_external_user(struct file *filep)
void vfio_group_put_external_user(struct vfio_group *group)
int vfio_external_user_iommu_id(struct vfio_group *group)

group would of course be opaque externally.

Thanks,
Alex

