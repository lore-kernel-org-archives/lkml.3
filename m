Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755908Ab3CMGdR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Mar 2013 02:33:17 -0400
Received: from LGEMRELSE1Q.lge.com ([156.147.1.111]:52149 "EHLO
	LGEMRELSE1Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755279Ab3CMGdK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Mar 2013 02:33:10 -0400
X-AuditID: 9c93016f-b7bfaae000003db8-ee-51401da3fc5b
From: Joonsoo Kim <iamjoonsoo.kim@lge.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        Dave Anderson <anderson@redhat.com>,
        Atsushi Kumagai <kumagai-atsushi@mxc.nes.nec.co.jp>,
        Vivek Goyal <vgoyal@redhat.com>, Bob Liu <lliubbo@gmail.com>,
        Pekka Enberg <penberg@kernel.org>, kexec@lists.infradead.org,
        Joonsoo Kim <js1304@gmail.com>, Joonsoo Kim <iamjoonsoo.kim@lge.com>
Subject: [PATCH v2 3/8] mm, vmalloc: protect va->vm by vmap_area_lock
Date: Wed, 13 Mar 2013 15:32:55 +0900
Message-Id: <1363156381-2881-4-git-send-email-iamjoonsoo.kim@lge.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1363156381-2881-1-git-send-email-iamjoonsoo.kim@lge.com>
References: <1363156381-2881-1-git-send-email-iamjoonsoo.kim@lge.com>
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Joonsoo Kim <js1304@gmail.com>

Inserting and removing an entry to vmlist is linear time complexity, so
it is inefficient. Following patches will try to remove vmlist entirely.
This patch is preparing step for it.

For removing vmlist, iterating vmlist codes should be changed to iterating
a vmap_area_list. Before implementing that, we should make sure that
when we iterate a vmap_area_list, accessing to va->vm doesn't cause a race
condition. This patch ensure that when iterating a vmap_area_list,
there is no race condition for accessing to vm_struct.

Signed-off-by: Joonsoo Kim <js1304@gmail.com>
Signed-off-by: Joonsoo Kim <iamjoonsoo.kim@lge.com>

diff --git a/mm/vmalloc.c b/mm/vmalloc.c
index 1d9878b..1bf94ad 100644
--- a/mm/vmalloc.c
+++ b/mm/vmalloc.c
@@ -1290,12 +1290,14 @@ struct vm_struct *vmlist;
 static void setup_vmalloc_vm(struct vm_struct *vm, struct vmap_area *va,
 			      unsigned long flags, const void *caller)
 {
+	spin_lock(&vmap_area_lock);
 	vm->flags = flags;
 	vm->addr = (void *)va->va_start;
 	vm->size = va->va_end - va->va_start;
 	vm->caller = caller;
 	va->vm = vm;
 	va->flags |= VM_VM_AREA;
+	spin_unlock(&vmap_area_lock);
 }
 
 static void insert_vmalloc_vmlist(struct vm_struct *vm)
@@ -1447,6 +1449,11 @@ struct vm_struct *remove_vm_area(const void *addr)
 	if (va && va->flags & VM_VM_AREA) {
 		struct vm_struct *vm = va->vm;
 
+		spin_lock(&vmap_area_lock);
+		va->vm = NULL;
+		va->flags &= ~VM_VM_AREA;
+		spin_unlock(&vmap_area_lock);
+
 		if (!(vm->flags & VM_UNLIST)) {
 			struct vm_struct *tmp, **p;
 			/*
-- 
1.7.9.5

