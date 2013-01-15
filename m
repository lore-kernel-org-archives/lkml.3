Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932586Ab3AOWex (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jan 2013 17:34:53 -0500
Received: from mail.kernel.org ([198.145.19.201]:43268 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757588Ab3AOWeu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jan 2013 17:34:50 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Aleksi Torhamo <aleksi@torhamo.net>,
        Roy Spliet <r.spliet@student.tudelft.nl>,
        Ben Skeggs <bskeggs@redhat.com>
Subject: [ 169/221] drm/nvc0/fb: fix crash when different mutex is used to protect same list
Date: Tue, 15 Jan 2013 10:51:36 -0800
Message-Id: <20130115185010.240198388@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.336.g94702dd
In-Reply-To: <20130115184958.025580322@linuxfoundation.org>
References: <20130115184958.025580322@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Aleksi Torhamo <aleksi@torhamo.net>

commit 43f789792e2c7ea2bff37195e4c4b4239e9e02b7 upstream.

Fixes regression introduced in commit 861d2107
"drm/nouveau/fb: merge fb/vram and port to subdev interfaces"

nv50_fb_vram_{new,del} functions were changed to use
nouveau_subdev->mutex instead of the old nouveau_mm->mutex.
nvc0_fb_vram_new still uses the nouveau_mm->mutex, but nvc0 doesn't
have its own fb_vram_del function, using nv50_fb_vram_del instead.
Because of this, on nvc0 a different mutex ends up being used to protect
additions and deletions to the same list.

This patch is a -stable candidate for 3.7.

Signed-off-by: Aleksi Torhamo <aleksi@torhamo.net>
Reported-by: Roy Spliet <r.spliet@student.tudelft.nl>
Tested-by: Roy Spliet <r.spliet@student.tudelft.nl>
Signed-off-by: Ben Skeggs <bskeggs@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpu/drm/nouveau/core/subdev/fb/nvc0.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/drivers/gpu/drm/nouveau/core/subdev/fb/nvc0.c
+++ b/drivers/gpu/drm/nouveau/core/subdev/fb/nvc0.c
@@ -86,14 +86,14 @@ nvc0_fb_vram_new(struct nouveau_fb *pfb,
 	mem->memtype = type;
 	mem->size = size;
 
-	mutex_lock(&mm->mutex);
+	mutex_lock(&pfb->base.mutex);
 	do {
 		if (back)
 			ret = nouveau_mm_tail(mm, 1, size, ncmin, align, &r);
 		else
 			ret = nouveau_mm_head(mm, 1, size, ncmin, align, &r);
 		if (ret) {
-			mutex_unlock(&mm->mutex);
+			mutex_unlock(&pfb->base.mutex);
 			pfb->ram.put(pfb, &mem);
 			return ret;
 		}
@@ -101,7 +101,7 @@ nvc0_fb_vram_new(struct nouveau_fb *pfb,
 		list_add_tail(&r->rl_entry, &mem->regions);
 		size -= r->length;
 	} while (size);
-	mutex_unlock(&mm->mutex);
+	mutex_unlock(&pfb->base.mutex);
 
 	r = list_first_entry(&mem->regions, struct nouveau_mm_node, rl_entry);
 	mem->offset = (u64)r->offset << 12;


