Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755829Ab3HXUV5 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 Aug 2013 16:21:57 -0400
Received: from smtpfb1-g21.free.fr ([212.27.42.9]:41526 "EHLO
	smtpfb1-g21.free.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755758Ab3HXUVy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 Aug 2013 16:21:54 -0400
From: Yann Droneaud <ydroneaud@opteya.com>
To: Alexander Graf <agraf@suse.de>, Gleb Natapov <gleb@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>
Cc: Yann Droneaud <ydroneaud@opteya.com>,
        Alex Williamson <alex.williamson@redhat.com>, kvm-ppc@vger.kernel.org,
        kvm@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 2/2] ppc: kvm: use anon_inode_getfd() with O_CLOEXEC flag
Date: Sat, 24 Aug 2013 22:14:08 +0200
Message-Id: <b7ae23be3a3d4a2f57eca6cfc7f9361da883ceca.1377372576.git.ydroneaud@opteya.com>
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
 arch/powerpc/kvm/book3s_64_mmu_hv.c | 2 +-
 arch/powerpc/kvm/book3s_64_vio.c    | 2 +-
 arch/powerpc/kvm/book3s_hv.c        | 2 +-
 3 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/arch/powerpc/kvm/book3s_64_mmu_hv.c b/arch/powerpc/kvm/book3s_64_mmu_hv.c
index 710d313..f7c9e8a 100644
--- a/arch/powerpc/kvm/book3s_64_mmu_hv.c
+++ b/arch/powerpc/kvm/book3s_64_mmu_hv.c
@@ -1579,7 +1579,7 @@ int kvm_vm_ioctl_get_htab_fd(struct kvm *kvm, struct kvm_get_htab_fd *ghf)
 	ctx->first_pass = 1;
 
 	rwflag = (ghf->flags & KVM_GET_HTAB_WRITE) ? O_WRONLY : O_RDONLY;
-	ret = anon_inode_getfd("kvm-htab", &kvm_htab_fops, ctx, rwflag);
+	ret = anon_inode_getfd("kvm-htab", &kvm_htab_fops, ctx, rwflag | O_CLOEXEC);
 	if (ret < 0) {
 		kvm_put_kvm(kvm);
 		return ret;
diff --git a/arch/powerpc/kvm/book3s_64_vio.c b/arch/powerpc/kvm/book3s_64_vio.c
index b2d3f3b..54cf9bc 100644
--- a/arch/powerpc/kvm/book3s_64_vio.c
+++ b/arch/powerpc/kvm/book3s_64_vio.c
@@ -136,7 +136,7 @@ long kvm_vm_ioctl_create_spapr_tce(struct kvm *kvm,
 	mutex_unlock(&kvm->lock);
 
 	return anon_inode_getfd("kvm-spapr-tce", &kvm_spapr_tce_fops,
-				stt, O_RDWR);
+				stt, O_RDWR | O_CLOEXEC);
 
 fail:
 	if (stt) {
diff --git a/arch/powerpc/kvm/book3s_hv.c b/arch/powerpc/kvm/book3s_hv.c
index e8d51cb..3503829 100644
--- a/arch/powerpc/kvm/book3s_hv.c
+++ b/arch/powerpc/kvm/book3s_hv.c
@@ -1556,7 +1556,7 @@ long kvm_vm_ioctl_allocate_rma(struct kvm *kvm, struct kvm_allocate_rma *ret)
 	if (!ri)
 		return -ENOMEM;
 
-	fd = anon_inode_getfd("kvm-rma", &kvm_rma_fops, ri, O_RDWR);
+	fd = anon_inode_getfd("kvm-rma", &kvm_rma_fops, ri, O_RDWR | O_CLOEXEC);
 	if (fd < 0)
 		kvm_release_rma(ri);
 
-- 
1.8.3.1

