Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935063Ab3GWWfv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jul 2013 18:35:51 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:41836 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934837Ab3GWW1x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jul 2013 18:27:53 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Marcin Slusarz <marcin.slusarz@gmail.com>,
        Ben Skeggs <bskeggs@redhat.com>
Subject: [ 083/103] drm/nouveau: use vmalloc for pgt allocation
Date: Tue, 23 Jul 2013 15:26:34 -0700
Message-Id: <20130723220429.742078997@linuxfoundation.org>
X-Mailer: git-send-email 1.8.3.rc0.20.gb99dd2e
In-Reply-To: <20130723220418.532514378@linuxfoundation.org>
References: <20130723220418.532514378@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Marcin Slusarz <marcin.slusarz@gmail.com>

commit d005f51eb93d71cd40ebd11dd377453fa8c8a42a upstream.

Page tables on nv50 take 48kB, which can be hard to allocate in one piece.
Let's use vmalloc.

Signed-off-by: Marcin Slusarz <marcin.slusarz@gmail.com>
Signed-off-by: Ben Skeggs <bskeggs@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpu/drm/nouveau/core/subdev/vm/base.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/drivers/gpu/drm/nouveau/core/subdev/vm/base.c
+++ b/drivers/gpu/drm/nouveau/core/subdev/vm/base.c
@@ -362,7 +362,7 @@ nouveau_vm_create(struct nouveau_vmmgr *
 	vm->fpde = offset >> (vmm->pgt_bits + 12);
 	vm->lpde = (offset + length - 1) >> (vmm->pgt_bits + 12);
 
-	vm->pgt  = kcalloc(vm->lpde - vm->fpde + 1, sizeof(*vm->pgt), GFP_KERNEL);
+	vm->pgt  = vzalloc((vm->lpde - vm->fpde + 1) * sizeof(*vm->pgt));
 	if (!vm->pgt) {
 		kfree(vm);
 		return -ENOMEM;
@@ -371,7 +371,7 @@ nouveau_vm_create(struct nouveau_vmmgr *
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
 


