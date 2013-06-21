Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423627Ab3FUS5W (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Jun 2013 14:57:22 -0400
Received: from ip4-83-240-18-99.cust.nbox.cz ([83.240.18.99]:43910 "EHLO
	anemoi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1423424Ab3FUS5V (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Jun 2013 14:57:21 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, Marcin Slusarz <marcin.slusarz@gmail.com>,
        stable@vger.kernel.org, Frederic Crozat <fcrozat@suse.com>,
        Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH -resend] drm/nouveau: use vmalloc for pgt allocation
Date: Fri, 21 Jun 2013 20:57:14 +0200
Message-Id: <1371841034-24893-1-git-send-email-jslaby@suse.cz>
X-Mailer: git-send-email 1.8.3.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Marcin Slusarz <marcin.slusarz@gmail.com>

Page tables on nv50 take 48kB, which can be hard to allocate in one piece.
Let's use vmalloc.

[js] It is a pain for opensuse users as they see it on a daily basis.
Let's fix it for good. One example of a trace is as follows:

firefox: page allocation failure. order:3, mode:0x2000d0
Pid: 5068, comm: firefox Not tainted 3.7.9-3-desktop #1
Call Trace:
...
 [<ffffffff81114a52>] warn_alloc_failed+0x102/0x1b0
 [<ffffffff811189f3>] __alloc_pages_nodemask+0x793/0x9f0
 [<ffffffff811597f7>] kmem_getpages+0x57/0x1b0
 [<ffffffff8115a3e4>] fallback_alloc+0x174/0x270
 [<ffffffff8115abd9>] __kmalloc+0x1d9/0x240
 [<ffffffffa00ffb2b>] nouveau_vm_create+0xbb/0x160 [nouveau]
 [<ffffffffa0149110>] nouveau_drm_open+0xb0/0x140 [nouveau]
 [<ffffffffa0066a32>] drm_open+0x222/0x640 [drm]
...
SLAB: Unable to allocate memory on node 0 (gfp=0xd0)
  cache: size-65536, object size: 65536, order: 4
  node -1: slabs: 9/9, objs: 9/9, free: 0

References: https://bugzilla.novell.com/show_bug.cgi?id=802347
Signed-off-by: Marcin Slusarz <marcin.slusarz@gmail.com>
Cc: stable@vger.kernel.org
Cc: Frederic Crozat <fcrozat@suse.com>
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 drivers/gpu/drm/nouveau/core/subdev/vm/base.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/gpu/drm/nouveau/core/subdev/vm/base.c b/drivers/gpu/drm/nouveau/core/subdev/vm/base.c
index 77c67fc..e66fb77 100644
--- a/drivers/gpu/drm/nouveau/core/subdev/vm/base.c
+++ b/drivers/gpu/drm/nouveau/core/subdev/vm/base.c
@@ -362,7 +362,7 @@ nouveau_vm_create(struct nouveau_vmmgr *vmm, u64 offset, u64 length,
 	vm->fpde = offset >> (vmm->pgt_bits + 12);
 	vm->lpde = (offset + length - 1) >> (vmm->pgt_bits + 12);
 
-	vm->pgt  = kcalloc(vm->lpde - vm->fpde + 1, sizeof(*vm->pgt), GFP_KERNEL);
+	vm->pgt  = vzalloc((vm->lpde - vm->fpde + 1) * sizeof(*vm->pgt));
 	if (!vm->pgt) {
 		kfree(vm);
 		return -ENOMEM;
@@ -371,7 +371,7 @@ nouveau_vm_create(struct nouveau_vmmgr *vmm, u64 offset, u64 length,
 	ret = nouveau_mm_init(&vm->mm, mm_offset >> 12, mm_length >> 12,
 			      block >> 12);
 	if (ret) {
-		kfree(vm->pgt);
+		vfree(vm->pgt);
 		kfree(vm);
 		return ret;
 	}
@@ -446,7 +446,7 @@ nouveau_vm_del(struct nouveau_vm *vm)
 	}
 
 	nouveau_mm_fini(&vm->mm);
-	kfree(vm->pgt);
+	vfree(vm->pgt);
 	kfree(vm);
 }
 
-- 
1.8.3.1

