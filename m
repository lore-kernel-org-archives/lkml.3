Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755625Ab3HXUV1 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 Aug 2013 16:21:27 -0400
Received: from smtpfb2-g21.free.fr ([212.27.42.10]:57233 "EHLO
	smtpfb2-g21.free.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754761Ab3HXUVZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 Aug 2013 16:21:25 -0400
From: Yann Droneaud <ydroneaud@opteya.com>
To: Gleb Natapov <gleb@redhat.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: Yann Droneaud <ydroneaud@opteya.com>,
        Alex Williamson <alex.williamson@redhat.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 1/2] kvm: use anon_inode_getfd() with O_CLOEXEC flag
Date: Sat, 24 Aug 2013 22:14:07 +0200
Message-Id: <16c6c5380d543aca2aab13fdcbacaf12fdbca168.1377372576.git.ydroneaud@opteya.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <cover.1377372576.git.ydroneaud@opteya.com>
References: <cover.1377372576.git.ydroneaud@opteya.com>
In-Reply-To: <cover.1377372576.git.ydroneaud@opteya.com>
References: <cover.1377372576.git.ydroneaud@opteya.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

KVM uses anon_inode_get() to allocate file descriptors as part
of some of its ioctls. But those ioctls are lacking a flag argument
allowing userspace to choose options for the newly opened file descriptor.

In such case it's advised to use O_CLOEXEC by default so that
userspace is allowed to choose, without race, if the file descriptor
is going to be inherited across exec().

This patch set O_CLOEXEC flag on all file descriptors created
with anon_inode_getfd() to not leak file descriptors across exec().

Signed-off-by: Yann Droneaud <ydroneaud@opteya.com>
Link: http://lkml.kernel.org/r/cover.1377372576.git.ydroneaud@opteya.com
---
 virt/kvm/kvm_main.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 89f74d1..d65cc0c 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -1896,7 +1896,7 @@ static struct file_operations kvm_vcpu_fops = {
  */
 static int create_vcpu_fd(struct kvm_vcpu *vcpu)
 {
-	return anon_inode_getfd("kvm-vcpu", &kvm_vcpu_fops, vcpu, O_RDWR);
+	return anon_inode_getfd("kvm-vcpu", &kvm_vcpu_fops, vcpu, O_RDWR | O_CLOEXEC);
 }
 
 /*
@@ -2306,7 +2306,7 @@ static int kvm_ioctl_create_device(struct kvm *kvm,
 		return ret;
 	}
 
-	ret = anon_inode_getfd(ops->name, &kvm_device_fops, dev, O_RDWR);
+	ret = anon_inode_getfd(ops->name, &kvm_device_fops, dev, O_RDWR | O_CLOEXEC);
 	if (ret < 0) {
 		ops->destroy(dev);
 		return ret;
@@ -2590,7 +2590,7 @@ static int kvm_dev_ioctl_create_vm(unsigned long type)
 		return r;
 	}
 #endif
-	r = anon_inode_getfd("kvm-vm", &kvm_vm_fops, kvm, O_RDWR);
+	r = anon_inode_getfd("kvm-vm", &kvm_vm_fops, kvm, O_RDWR | O_CLOEXEC);
 	if (r < 0)
 		kvm_put_kvm(kvm);
 
-- 
1.8.3.1

