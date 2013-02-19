Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934783Ab3BSWcz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Feb 2013 17:32:55 -0500
Received: from mail-we0-f180.google.com ([74.125.82.180]:52214 "EHLO
	mail-we0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933911Ab3BSWcx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Feb 2013 17:32:53 -0500
Date: Tue, 19 Feb 2013 23:32:55 +0100
From: Marcin Slusarz <marcin.slusarz@gmail.com>
To: Jiri Slaby <jslaby@suse.cz>, bskeggs@redhat.com
Cc: dri-devel@lists.freedesktop.org, LKML <linux-kernel@vger.kernel.org>,
        stable <stable@vger.kernel.org>
Subject: Re: WARNING: at drivers/gpu/drm/nouveau/core/core/mm.c:242
Message-ID: <20130219223255.GA13522@joi.lan>
References: <5122021F.1060207@suse.cz>
 <20130218232335.GA9730@joi.lan>
 <5122BC8A.6040503@suse.cz>
 <20130219070744.GA3032@joi.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130219070744.GA3032@joi.lan>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 19, 2013 at 08:07:44AM +0100, Marcin Slusarz wrote:
> On Tue, Feb 19, 2013 at 12:43:06AM +0100, Jiri Slaby wrote:
> > On 02/19/2013 12:23 AM, Marcin Slusarz wrote:
> > > On Mon, Feb 18, 2013 at 11:27:43AM +0100, Jiri Slaby wrote:
> > >> Hi,
> > >>
> > >> we have a report of WARNING from 3.7.6 in nouveau at
> > >> drivers/gpu/drm/nouveau/core/core/mm.c:242 here:
> > >> https://bugzilla.novell.com/show_bug.cgi?id=802347#c11
> > >>
> > >> There is an order 4 allocation failure in nouveau_drm_open ->
> > >> nouveau_vm_create, i.e. this one failed:
> > >> vm->pgt  = kcalloc(vm->lpde - vm->fpde + 1, sizeof(*vm->pgt), GFP_KERNEL);
> > >>
> > >> Then, on the error path in still in nouveau_drm_open, it is followed by
> > >> a call to nouveau_cli_destroy. But that one calls nouveau_vm_ref ->
> > >> nouveau_mm_fini -> nouveau_vm_del -> nouveau_mm_fini which triggers the
> > >> warning.
> > >>
> > >> Any ideas?
> > > 
> > > Crash/warning should be fixed by commit cfd376b6bfccf33782a0748a9c70f7f752f8b869
> > > "drm/nouveau/vm: fix memory corruption when pgt allocation fails".
> > 
> > Oh, thanks for the pointer. Could that bug cause real "memory
> > corruption"? As we're hunting one there...
> 
> Yes.
> 
> > Isn't this a stable-3.7 candidate?
> 
> Should have been :/.
> 
> > > Tomorrow I'll post a patch for page allocation failure.
> > 
> > What do you mean -- what kind of patch?
> 
> A patch which will change pgt allocation to use vmalloc.

---
From: Marcin Slusarz <marcin.slusarz@gmail.com>
Subject: [PATCH] drm/nouveau: use vmalloc for pgt allocation

Page tables on nv50 take 48kB, which can be hard to allocate in one piece.
Let's use vmalloc.

Signed-off-by: Marcin Slusarz <marcin.slusarz@gmail.com>
Cc: stable@vger.kernel.org
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
