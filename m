Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754745Ab3J3OjE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Oct 2013 10:39:04 -0400
Received: from mx1.redhat.com ([209.132.183.28]:2353 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752763Ab3J3OjB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Oct 2013 10:39:01 -0400
Message-ID: <1383143422.4097.170.camel@ul30vt.home>
Subject: Re: [PATCH 1/4] kvm: Destroy & free KVM devices on release
From: Alex Williamson <alex.williamson@redhat.com>
To: Gleb Natapov <gleb@redhat.com>
Cc: kvm@vger.kernel.org, aik@ozlabs.ru, pbonzini@redhat.com,
        linux-kernel@vger.kernel.org
Date: Wed, 30 Oct 2013 08:30:22 -0600
In-Reply-To: <20131030104029.GE4651@redhat.com>
References: <20131029160019.22578.16409.stgit@bling.home>
	 <20131029161322.22578.18997.stgit@bling.home>
	 <20131030104029.GE4651@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2013-10-30 at 12:40 +0200, Gleb Natapov wrote:
> On Tue, Oct 29, 2013 at 10:13:22AM -0600, Alex Williamson wrote:
> > The KVM device interface allocates a struct kvm_device and calls
> > kvm_device_ops.create on it from KVM VM ioctl KVM_CREATE_DEVICE.
> > This returns a file descriptor to the user for them to set/get/check
> > further attributes.  On closing the file descriptor, one would assume
> > that kvm_device_ops.destroy is called and all traces of the device
> > would go away.  One would be wrong, it actually does nothing more
> > than release the struct kvm reference, waiting until the VM is
> > destroyed before doing more.  This leaves devices that only want a
> > single instance of themselves per VM in a tough spot.
> > 
> This is by design. Otherwise locking will be needed on each device access
> and for interrupt controllers this is unnecessary serialization and
> overhead. Device API is not designed for devices that can go away while
> machine is running anyway, so after creation device is only destroyed
> during VM destruction.

Hmm, ok.  In that case I can drop this patch and I think the rest just
boils down to userspace use of the device.  I had been close()'ing the
kvm device fd when all QEMU vfio devices are detached, but I can just as
easily leave it open in case a new device is added later.  I'll send out
a new series after doing some more review and testing.  Do you have any
comments on the rest of the series?  Thanks,

Alex

> > To fix this, do full cleanup on release of the device file descriptor.
> > It's also non-symmetric that one of the existing devices frees the
> > struct kvm_device from it's .destroy function, while the other
> > doesn't.  KVM-core allocates the structure and should therefore be
> > responsible for freeing it.  Finally, add a missing kfree for the
> > device creation error path.
> > 
> > Signed-off-by: Alex Williamson <alex.williamson@redhat.com>
> > ---
> >  arch/powerpc/kvm/book3s_xics.c |    1 -
> >  virt/kvm/kvm_main.c            |    5 +++++
> >  2 files changed, 5 insertions(+), 1 deletion(-)
> > 
> > diff --git a/arch/powerpc/kvm/book3s_xics.c b/arch/powerpc/kvm/book3s_xics.c
> > index a3a5cb8..9a82426 100644
> > --- a/arch/powerpc/kvm/book3s_xics.c
> > +++ b/arch/powerpc/kvm/book3s_xics.c
> > @@ -1220,7 +1220,6 @@ static void kvmppc_xics_free(struct kvm_device *dev)
> >  	for (i = 0; i <= xics->max_icsid; i++)
> >  		kfree(xics->ics[i]);
> >  	kfree(xics);
> > -	kfree(dev);
> >  }
> >  
> >  static int kvmppc_xics_create(struct kvm_device *dev, u32 type)
> > diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
> > index a9dd682..fec8320 100644
> > --- a/virt/kvm/kvm_main.c
> > +++ b/virt/kvm/kvm_main.c
> > @@ -572,6 +572,7 @@ static void kvm_destroy_devices(struct kvm *kvm)
> >  
> >  		list_del(node);
> >  		dev->ops->destroy(dev);
> > +		kfree(dev);
> >  	}
> >  }
> >  
> > @@ -2231,6 +2232,9 @@ static int kvm_device_release(struct inode *inode, struct file *filp)
> >  	struct kvm_device *dev = filp->private_data;
> >  	struct kvm *kvm = dev->kvm;
> >  
> > +	list_del(&dev->vm_node);
> > +	dev->ops->destroy(dev);
> > +	kfree(dev);
> >  	kvm_put_kvm(kvm);
> >  	return 0;
> >  }
> > @@ -2294,6 +2298,7 @@ static int kvm_ioctl_create_device(struct kvm *kvm,
> >  	ret = anon_inode_getfd(ops->name, &kvm_device_fops, dev, O_RDWR | O_CLOEXEC);
> >  	if (ret < 0) {
> >  		ops->destroy(dev);
> > +		kfree(dev);
> >  		return ret;
> >  	}
> >  
> 
> --
> 			Gleb.



