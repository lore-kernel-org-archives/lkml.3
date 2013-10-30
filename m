Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753547Ab3J3KlM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Oct 2013 06:41:12 -0400
Received: from mx1.redhat.com ([209.132.183.28]:58554 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751899Ab3J3KlK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Oct 2013 06:41:10 -0400
Date: Wed, 30 Oct 2013 12:40:29 +0200
From: Gleb Natapov <gleb@redhat.com>
To: Alex Williamson <alex.williamson@redhat.com>
Cc: kvm@vger.kernel.org, aik@ozlabs.ru, pbonzini@redhat.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/4] kvm: Destroy & free KVM devices on release
Message-ID: <20131030104029.GE4651@redhat.com>
References: <20131029160019.22578.16409.stgit@bling.home>
 <20131029161322.22578.18997.stgit@bling.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131029161322.22578.18997.stgit@bling.home>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 29, 2013 at 10:13:22AM -0600, Alex Williamson wrote:
> The KVM device interface allocates a struct kvm_device and calls
> kvm_device_ops.create on it from KVM VM ioctl KVM_CREATE_DEVICE.
> This returns a file descriptor to the user for them to set/get/check
> further attributes.  On closing the file descriptor, one would assume
> that kvm_device_ops.destroy is called and all traces of the device
> would go away.  One would be wrong, it actually does nothing more
> than release the struct kvm reference, waiting until the VM is
> destroyed before doing more.  This leaves devices that only want a
> single instance of themselves per VM in a tough spot.
> 
This is by design. Otherwise locking will be needed on each device access
and for interrupt controllers this is unnecessary serialization and
overhead. Device API is not designed for devices that can go away while
machine is running anyway, so after creation device is only destroyed
during VM destruction.

> To fix this, do full cleanup on release of the device file descriptor.
> It's also non-symmetric that one of the existing devices frees the
> struct kvm_device from it's .destroy function, while the other
> doesn't.  KVM-core allocates the structure and should therefore be
> responsible for freeing it.  Finally, add a missing kfree for the
> device creation error path.
> 
> Signed-off-by: Alex Williamson <alex.williamson@redhat.com>
> ---
>  arch/powerpc/kvm/book3s_xics.c |    1 -
>  virt/kvm/kvm_main.c            |    5 +++++
>  2 files changed, 5 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/powerpc/kvm/book3s_xics.c b/arch/powerpc/kvm/book3s_xics.c
> index a3a5cb8..9a82426 100644
> --- a/arch/powerpc/kvm/book3s_xics.c
> +++ b/arch/powerpc/kvm/book3s_xics.c
> @@ -1220,7 +1220,6 @@ static void kvmppc_xics_free(struct kvm_device *dev)
>  	for (i = 0; i <= xics->max_icsid; i++)
>  		kfree(xics->ics[i]);
>  	kfree(xics);
> -	kfree(dev);
>  }
>  
>  static int kvmppc_xics_create(struct kvm_device *dev, u32 type)
> diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
> index a9dd682..fec8320 100644
> --- a/virt/kvm/kvm_main.c
> +++ b/virt/kvm/kvm_main.c
> @@ -572,6 +572,7 @@ static void kvm_destroy_devices(struct kvm *kvm)
>  
>  		list_del(node);
>  		dev->ops->destroy(dev);
> +		kfree(dev);
>  	}
>  }
>  
> @@ -2231,6 +2232,9 @@ static int kvm_device_release(struct inode *inode, struct file *filp)
>  	struct kvm_device *dev = filp->private_data;
>  	struct kvm *kvm = dev->kvm;
>  
> +	list_del(&dev->vm_node);
> +	dev->ops->destroy(dev);
> +	kfree(dev);
>  	kvm_put_kvm(kvm);
>  	return 0;
>  }
> @@ -2294,6 +2298,7 @@ static int kvm_ioctl_create_device(struct kvm *kvm,
>  	ret = anon_inode_getfd(ops->name, &kvm_device_fops, dev, O_RDWR | O_CLOEXEC);
>  	if (ret < 0) {
>  		ops->destroy(dev);
> +		kfree(dev);
>  		return ret;
>  	}
>  

--
			Gleb.
