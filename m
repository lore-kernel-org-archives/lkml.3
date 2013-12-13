Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754229Ab3LMW2V (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Dec 2013 17:28:21 -0500
Received: from mail-pa0-f42.google.com ([209.85.220.42]:36732 "EHLO
	mail-pa0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754103Ab3LMW2O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Dec 2013 17:28:14 -0500
From: John Stultz <john.stultz@linaro.org>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Greg KH <gregkh@linuxfoundation.org>,
        Android Kernel Team <kernel-team@android.com>,
        Sumit Semwal <sumit.semwal@linaro.org>,
        Jesse Barker <jesse.barker@arm.com>, Colin Cross <ccross@android.com>,
        John Stultz <john.stultz@linaro.org>
Subject: [PATCH 082/115] gpu: ion: delete ion_system_mapper.c
Date: Fri, 13 Dec 2013 14:24:56 -0800
Message-Id: <1386973529-4884-83-git-send-email-john.stultz@linaro.org>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1386973529-4884-1-git-send-email-john.stultz@linaro.org>
References: <1386973529-4884-1-git-send-email-john.stultz@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Colin Cross <ccross@android.com>

The mapper abstraction layer was removed before the initial ion
commit, but a stray ion_system_mapper.c file was left in.  Delete
it.

Signed-off-by: Colin Cross <ccross@android.com>
Signed-off-by: John Stultz <john.stultz@linaro.org>
---
 drivers/staging/android/ion/ion_system_mapper.c | 114 ------------------------
 1 file changed, 114 deletions(-)
 delete mode 100644 drivers/staging/android/ion/ion_system_mapper.c

diff --git a/drivers/staging/android/ion/ion_system_mapper.c b/drivers/staging/android/ion/ion_system_mapper.c
deleted file mode 100644
index 285430d..0000000
--- a/drivers/staging/android/ion/ion_system_mapper.c
+++ /dev/null
@@ -1,114 +0,0 @@
-/*
- * drivers/staging/android/ion/ion_system_mapper.c
- *
- * Copyright (C) 2011 Google, Inc.
- *
- * This software is licensed under the terms of the GNU General Public
- * License version 2, as published by the Free Software Foundation, and
- * may be copied, distributed, and modified under those terms.
- *
- * This program is distributed in the hope that it will be useful,
- * but WITHOUT ANY WARRANTY; without even the implied warranty of
- * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
- * GNU General Public License for more details.
- *
- */
-
-#include <linux/err.h>
-#include <linux/memory.h>
-#include <linux/mm.h>
-#include <linux/slab.h>
-#include <linux/vmalloc.h>
-#include "ion.h"
-#include "ion_priv.h"
-/*
- * This mapper is valid for any heap that allocates memory that already has
- * a kernel mapping, this includes vmalloc'd memory, kmalloc'd memory,
- * pages obtained via io_remap, etc.
- */
-static void *ion_kernel_mapper_map(struct ion_mapper *mapper,
-				   struct ion_buffer *buffer,
-				   struct ion_mapping **mapping)
-{
-	if (!((1 << buffer->heap->type) & mapper->heap_mask)) {
-		pr_err("%s: attempting to map an unsupported heap\n", __func__);
-		return ERR_PTR(-EINVAL);
-	}
-	/* XXX REVISIT ME!!! */
-	*((unsigned long *)mapping) = (unsigned long)buffer->priv;
-	return buffer->priv;
-}
-
-static void ion_kernel_mapper_unmap(struct ion_mapper *mapper,
-				    struct ion_buffer *buffer,
-				    struct ion_mapping *mapping)
-{
-	if (!((1 << buffer->heap->type) & mapper->heap_mask))
-		pr_err("%s: attempting to unmap an unsupported heap\n",
-		       __func__);
-}
-
-static void *ion_kernel_mapper_map_kernel(struct ion_mapper *mapper,
-					struct ion_buffer *buffer,
-					struct ion_mapping *mapping)
-{
-	if (!((1 << buffer->heap->type) & mapper->heap_mask)) {
-		pr_err("%s: attempting to unmap an unsupported heap\n",
-		       __func__);
-		return ERR_PTR(-EINVAL);
-	}
-	return buffer->priv;
-}
-
-static int ion_kernel_mapper_map_user(struct ion_mapper *mapper,
-				      struct ion_buffer *buffer,
-				      struct vm_area_struct *vma,
-				      struct ion_mapping *mapping)
-{
-	int ret;
-
-	switch (buffer->heap->type) {
-	case ION_HEAP_KMALLOC:
-	{
-		unsigned long pfn = __phys_to_pfn(virt_to_phys(buffer->priv));
-		ret = remap_pfn_range(vma, vma->vm_start, pfn + vma->vm_pgoff,
-				      vma->vm_end - vma->vm_start,
-				      vma->vm_page_prot);
-		break;
-	}
-	case ION_HEAP_VMALLOC:
-		ret = remap_vmalloc_range(vma, buffer->priv, vma->vm_pgoff);
-		break;
-	default:
-		pr_err("%s: attempting to map unsupported heap to userspace\n",
-		       __func__);
-		return -EINVAL;
-	}
-
-	return ret;
-}
-
-static struct ion_mapper_ops ops = {
-	.map = ion_kernel_mapper_map,
-	.map_kernel = ion_kernel_mapper_map_kernel,
-	.map_user = ion_kernel_mapper_map_user,
-	.unmap = ion_kernel_mapper_unmap,
-};
-
-struct ion_mapper *ion_system_mapper_create(void)
-{
-	struct ion_mapper *mapper;
-	mapper = kzalloc(sizeof(struct ion_mapper), GFP_KERNEL);
-	if (!mapper)
-		return ERR_PTR(-ENOMEM);
-	mapper->type = ION_SYSTEM_MAPPER;
-	mapper->ops = &ops;
-	mapper->heap_mask = (1 << ION_HEAP_VMALLOC) | (1 << ION_HEAP_KMALLOC);
-	return mapper;
-}
-
-void ion_system_mapper_destroy(struct ion_mapper *mapper)
-{
-	kfree(mapper);
-}
-
-- 
1.8.3.2

