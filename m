Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757053Ab3E1Jvr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 May 2013 05:51:47 -0400
Received: from mail-bk0-f47.google.com ([209.85.214.47]:50614 "EHLO
	mail-bk0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932290Ab3E1Jvq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 May 2013 05:51:46 -0400
MIME-Version: 1.0
Date: Tue, 28 May 2013 17:51:44 +0800
Message-ID: <CAPgLHd_3SYA3UiZ0yAvNgAMv2jRiQXmEKibqTwJpsNF47EsX9g@mail.gmail.com>
Subject: [PATCH -next] drm/i915: fix error return code in init_pipe_control()
From: Wei Yongjun <weiyj.lk@gmail.com>
To: daniel.vetter@ffwll.ch, airlied@linux.ie
Cc: yongjun_wei@trendmicro.com.cn, intel-gfx@lists.freedesktop.org,
        dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Wei Yongjun <yongjun_wei@trendmicro.com.cn>

Fix to return -ENOMEM in the kmap() error handling case
instead of 0, as done elsewhere in this function.

Signed-off-by: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
---
 drivers/gpu/drm/i915/intel_ringbuffer.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/i915/intel_ringbuffer.c b/drivers/gpu/drm/i915/intel_ringbuffer.c
index 5698fae..9b97cf6 100644
--- a/drivers/gpu/drm/i915/intel_ringbuffer.c
+++ b/drivers/gpu/drm/i915/intel_ringbuffer.c
@@ -464,9 +464,11 @@ init_pipe_control(struct intel_ring_buffer *ring)
 		goto err_unref;
 
 	pc->gtt_offset = obj->gtt_offset;
-	pc->cpu_page =  kmap(sg_page(obj->pages->sgl));
-	if (pc->cpu_page == NULL)
+	pc->cpu_page = kmap(sg_page(obj->pages->sgl));
+	if (pc->cpu_page == NULL) {
+		ret = -ENOMEM;
 		goto err_unpin;
+	}
 
 	DRM_DEBUG_DRIVER("%s pipe control offset: 0x%08x\n",
 			 ring->name, pc->gtt_offset);

