Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932096Ab3INMQ7 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Sep 2013 08:16:59 -0400
Received: from mx1.redhat.com ([209.132.183.28]:62765 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752416Ab3INMQz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Sep 2013 08:16:55 -0400
From: Andrew Jones <drjones@redhat.com>
To: kvm@vger.kernel.org
Cc: gleb@redhat.com, pbonzini@redhat.com, linux-kernel@vger.kernel.org
Subject: [PATCH] [RFC] x86: kvm: remove KVM_SOFT_MAX_VCPUS
Date: Sat, 14 Sep 2013 14:16:51 +0200
Message-Id: <1379161011-28239-1-git-send-email-drjones@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch removes KVM_SOFT_MAX_VCPUS and uses num_online_cpus() for
KVM_CAP_NR_VCPUS instead, as ARM does. While the API doc simply says
KVM_CAP_NR_VCPUS should return the recommended maximum number of vcpus,
it has been returning KVM_SOFT_MAX_VCPUS, which was defined as the
maximum tested number of vcpus. As that concept could be
distro-specific, this patch uses the other recommended maximum, the
number of physical cpus, as we never recommend configuring a guest that
has more vcpus than the host has pcpus. Of course a guest can always
still be configured with up to KVM_CAP_MAX_VCPUS though anyway.

I've put RFC on this patch because I'm not sure if there are any gotchas
lurking with this change. The change now means hosts no longer return
the same number for KVM_CAP_NR_VCPUS, and that number is likely going to
generally be quite a bit less than what KVM_SOFT_MAX_VCPUS was (160). I
can't think of anything other than generating more warnings[1] from qemu
with guests that configure more vcpus than pcpus though.

[1] Actually, until 972fc544b6034a in uq/master is merged there won't be
    any warnings either.

Signed-off-by: Andrew Jones <drjones@redhat.com>
---
 arch/x86/include/asm/kvm_host.h | 1 -
 arch/x86/kvm/x86.c              | 2 +-
 2 files changed, 1 insertion(+), 2 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index c76ff74a98f2e..9236c63315a9b 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -32,7 +32,6 @@
 #include <asm/asm.h>
 
 #define KVM_MAX_VCPUS 255
-#define KVM_SOFT_MAX_VCPUS 160
 #define KVM_USER_MEM_SLOTS 125
 /* memory slots that are not exposed to userspace */
 #define KVM_PRIVATE_MEM_SLOTS 3
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index e5ca72a5cdb6d..d9d3e2ed68ee9 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -2604,7 +2604,7 @@ int kvm_dev_ioctl_check_extension(long ext)
 		r = !kvm_x86_ops->cpu_has_accelerated_tpr();
 		break;
 	case KVM_CAP_NR_VCPUS:
-		r = KVM_SOFT_MAX_VCPUS;
+		r = min(num_online_cpus(), KVM_MAX_VCPUS);
 		break;
 	case KVM_CAP_MAX_VCPUS:
 		r = KVM_MAX_VCPUS;
-- 
1.8.1.4

