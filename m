Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964992Ab3GQXOL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Jul 2013 19:14:11 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:56624 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964897Ab3GQWzk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Jul 2013 18:55:40 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Marcin Slusarz <marcin.slusarz@gmail.com>, Ben Skeggs <bskeggs@redhat.com>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 120/145] drm/nouveau: use vmalloc for pgt allocation
Date: Wed, 17 Jul 2013 15:47:32 -0700
Message-Id: <1374101277-7915-121-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1374101277-7915-1-git-send-email-kamal@canonical.com>
References: <1374101277-7915-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.5 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Marcin Slusarz <marcin.slusarz@gmail.com>

commit d005f51eb93d71cd40ebd11dd377453fa8c8a42a upstream.

Page tables on nv50 take 48kB, which can be hard to allocate in one piece.
Let's use vmalloc.

Signed-off-by: Marcin Slusarz <marcin.slusarz@gmail.com>
Signed-off-by: Ben Skeggs <bskeggs@redhat.com>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
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
1.8.1.2

