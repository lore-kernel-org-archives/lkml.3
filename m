Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423572Ab3FVB0f (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Jun 2013 21:26:35 -0400
Received: from mx1.redhat.com ([209.132.183.28]:55316 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161553Ab3FVB0e (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Jun 2013 21:26:34 -0400
Message-ID: <1371864389.30572.142.camel@ul30vt.home>
Subject: Re: [PATCH] vfio: Limit group opens
From: Alex Williamson <alex.williamson@redhat.com>
To: Alexey Kardashevskiy <aik@ozlabs.ru>
Cc: linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>
Date: Fri, 21 Jun 2013 19:26:29 -0600
In-Reply-To: <51C4FAF4.5090509@ozlabs.ru>
References: <20130621211144.8237.7370.stgit@bling.home>
	 <51C4FAF4.5090509@ozlabs.ru>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2013-06-22 at 11:16 +1000, Alexey Kardashevskiy wrote:
> Cool, thanks!
> 
> So we will need only this (to be called from KVM), and that will be it, right?

For what?  This is not the external lock you're looking for.  As I've
mentioned, the file can only hold the group, but that doesn't give you
any guarantee that the group is protected by the IOMMU.  Thanks,

Alex

> int vfio_group_iommu_id_from_file(struct file *filep)
> ...
> 
> 
> 
> On 06/22/2013 07:12 AM, Alex Williamson wrote:
> > vfio_group_fops_open attempts to limit concurrent sessions by
> > disallowing opens once group->container is set.  This really doesn't
> > do what we want and allow for inconsistent behavior, for instance a
> > group can be opened twice, then a container set giving the user two
> > file descriptors to the group.  But then it won't allow more to be
> > opened.  There's not much reason to have the group opened multiple
> > times since most access is through devices or the container, so
> > complete what the original code intended and only allow a single
> > instance.
> > 
> > Signed-off-by: Alex Williamson <alex.williamson@redhat.com>
> > ---
> >  drivers/vfio/vfio.c |   14 ++++++++++++++
> >  1 file changed, 14 insertions(+)
> > 
> > diff --git a/drivers/vfio/vfio.c b/drivers/vfio/vfio.c
> > index 6d78736..d30f44d 100644
> > --- a/drivers/vfio/vfio.c
> > +++ b/drivers/vfio/vfio.c
> > @@ -76,6 +76,7 @@ struct vfio_group {
> >  	struct notifier_block		nb;
> >  	struct list_head		vfio_next;
> >  	struct list_head		container_next;
> > +	atomic_t			opened;
> >  };
> >  
> >  struct vfio_device {
> > @@ -206,6 +207,7 @@ static struct vfio_group *vfio_create_group(struct iommu_group *iommu_group)
> >  	INIT_LIST_HEAD(&group->device_list);
> >  	mutex_init(&group->device_lock);
> >  	atomic_set(&group->container_users, 0);
> > +	atomic_set(&group->opened, 0);
> >  	group->iommu_group = iommu_group;
> >  
> >  	group->nb.notifier_call = vfio_iommu_group_notifier;
> > @@ -1236,12 +1238,22 @@ static long vfio_group_fops_compat_ioctl(struct file *filep,
> >  static int vfio_group_fops_open(struct inode *inode, struct file *filep)
> >  {
> >  	struct vfio_group *group;
> > +	int opened;
> >  
> >  	group = vfio_group_get_from_minor(iminor(inode));
> >  	if (!group)
> >  		return -ENODEV;
> >  
> > +	/* Do we need multiple instances of the group open?  Seems not. */
> > +	opened = atomic_cmpxchg(&group->opened, 0, 1);
> > +	if (opened) {
> > +		vfio_group_put(group);
> > +		return -EBUSY;
> > +	}
> > +
> > +	/* Is something still in use from a previous open? */
> >  	if (group->container) {
> > +		atomic_dec(&group->opened);
> >  		vfio_group_put(group);
> >  		return -EBUSY;
> >  	}
> > @@ -1259,6 +1271,8 @@ static int vfio_group_fops_release(struct inode *inode, struct file *filep)
> >  
> >  	vfio_group_try_dissolve_container(group);
> >  
> > +	atomic_dec(&group->opened);
> > +
> >  	vfio_group_put(group);
> >  
> >  	return 0;
> > 
> 
> 



