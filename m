Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756128AbaAJA2v (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Jan 2014 19:28:51 -0500
Received: from cpsmtpb-ews04.kpnxchange.com ([213.75.39.7]:62095 "EHLO
	cpsmtpb-ews04.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751266AbaAJA2t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Jan 2014 19:28:49 -0500
Message-ID: <1389313726.2039.9.camel@x220>
Subject: [PATCH] kvm: vfio: silence GCC warning
From: Paul Bolle <pebolle@tiscali.nl>
To: Gleb Natapov <gleb@redhat.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Fri, 10 Jan 2014 01:28:46 +0100
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.3 (3.10.3-1.fc20) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 10 Jan 2014 00:28:47.0689 (UTC) FILETIME=[ED72EB90:01CF0D9A]
X-RcptDomain: vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Building vfio.o triggers a GCC warning (when building for 32 bits x86):
    arch/x86/kvm/../../../virt/kvm/vfio.c: In function 'kvm_vfio_set_group':
    arch/x86/kvm/../../../virt/kvm/vfio.c:104:22: warning: cast to pointer from integer of different size [-Wint-to-pointer-cast]
      void __user *argp = (void __user *)arg;
                          ^

Silence this warning by casting arg to unsigned long.

argp's current type, "void __user *", is always casted to "int32_t
__user *". So its type might as well be changed to "int32_t __user *".

Signed-off-by: Paul Bolle <pebolle@tiscali.nl>
---
Compile tested on both 32 and 64 bits x86. I've no KVM capable hardware
that is already running v3.13-rc* at hand. Besides, I wouldn't know how
to test the codepaths I'm changing here.

 virt/kvm/vfio.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/virt/kvm/vfio.c b/virt/kvm/vfio.c
index ca4260e..b4f9507 100644
--- a/virt/kvm/vfio.c
+++ b/virt/kvm/vfio.c
@@ -101,14 +101,14 @@ static int kvm_vfio_set_group(struct kvm_device *dev, long attr, u64 arg)
 	struct kvm_vfio *kv = dev->private;
 	struct vfio_group *vfio_group;
 	struct kvm_vfio_group *kvg;
-	void __user *argp = (void __user *)arg;
+	int32_t __user *argp = (int32_t __user *)(unsigned long)arg;
 	struct fd f;
 	int32_t fd;
 	int ret;
 
 	switch (attr) {
 	case KVM_DEV_VFIO_GROUP_ADD:
-		if (get_user(fd, (int32_t __user *)argp))
+		if (get_user(fd, argp))
 			return -EFAULT;
 
 		f = fdget(fd);
@@ -148,7 +148,7 @@ static int kvm_vfio_set_group(struct kvm_device *dev, long attr, u64 arg)
 		return 0;
 
 	case KVM_DEV_VFIO_GROUP_DEL:
-		if (get_user(fd, (int32_t __user *)argp))
+		if (get_user(fd, argp))
 			return -EFAULT;
 
 		f = fdget(fd);
-- 
1.8.4.2

