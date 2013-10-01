Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753447Ab3JAUPN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Oct 2013 16:15:13 -0400
Received: from mx1.redhat.com ([209.132.183.28]:62617 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751024Ab3JAUPJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Oct 2013 16:15:09 -0400
Subject: [PATCH 1/4] kvm: Destroy & free KVM devices on release
To: gleb@redhat.com
From: Alex Williamson <alex.williamson@redhat.com>
Cc: aik@ozlabs.ru, linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Date: Tue, 01 Oct 2013 14:15:06 -0600
Message-ID: <20131001201506.31715.98532.stgit@bling.home>
In-Reply-To: <20131001200757.31715.22994.stgit@bling.home>
References: <20131001200757.31715.22994.stgit@bling.home>
User-Agent: StGit/0.16
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The KVM device interface allocates a struct kvm_device and calls
kvm_device_ops.create on it from KVM VM ioctl KVM_CREATE_DEVICE.
This returns a file descriptor to the user for them to set/get/check
further attributes.  On closing the file descriptor, one would assume
that kvm_device_ops.destroy is called and all traces of the device
would go away.  One would be wrong, it actually does nothing more
than release the struct kvm reference, waiting until the VM is
destroyed before doing more.  This leaves devices that only want a
single instance of themselves per VM in a tough spot.

To fix this, do full cleanup on release of the device file descriptor.
It's also non-symmetric that one of the existing devices frees the
struct kvm_device from it's .destroy function, while the other
doesn't.  KVM-core allocates the structure and should therefore be
responsible for freeing it.  Finally, add a missing kfree for the
device creation error path.

Signed-off-by: Alex Williamson <alex.williamson@redhat.com>
---
 arch/powerpc/kvm/book3s_xics.c |    1 -
 virt/kvm/kvm_main.c            |    5 +++++
 2 files changed, 5 insertions(+), 1 deletion(-)

diff --git a/arch/powerpc/kvm/book3s_xics.c b/arch/powerpc/kvm/book3s_xics.c
index a3a5cb8..9a82426 100644
--- a/arch/powerpc/kvm/book3s_xics.c
+++ b/arch/powerpc/kvm/book3s_xics.c
@@ -1220,7 +1220,6 @@ static void kvmppc_xics_free(struct kvm_device *dev)
 	for (i = 0; i <= xics->max_icsid; i++)
 		kfree(xics->ics[i]);
 	kfree(xics);
-	kfree(dev);
 }
 
 static int kvmppc_xics_create(struct kvm_device *dev, u32 type)
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 979bff4..8727820 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -572,6 +572,7 @@ static void kvm_destroy_devices(struct kvm *kvm)
 
 		list_del(node);
 		dev->ops->destroy(dev);
+		kfree(dev);
 	}
 }
 
@@ -2229,6 +2230,9 @@ static int kvm_device_release(struct inode *inode, struct file *filp)
 	struct kvm_device *dev = filp->private_data;
 	struct kvm *kvm = dev->kvm;
 
+	list_del(&dev->vm_node);
+	dev->ops->destroy(dev);
+	kfree(dev);
 	kvm_put_kvm(kvm);
 	return 0;
 }
@@ -2292,6 +2296,7 @@ static int kvm_ioctl_create_device(struct kvm *kvm,
 	ret = anon_inode_getfd(ops->name, &kvm_device_fops, dev, O_RDWR | O_CLOEXEC);
 	if (ret < 0) {
 		ops->destroy(dev);
+		kfree(dev);
 		return ret;
 	}
 

