Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932982AbaJXWJI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Oct 2014 18:09:08 -0400
Received: from homie.mail.dreamhost.com ([208.97.132.208]:39225 "EHLO
	homiemail-a38.g.dreamhost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755971AbaJXWGu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Oct 2014 18:06:50 -0400
From: Davidlohr Bueso <dave@stgolabs.net>
To: akpm@linux-foundation.org
Cc: hughd@google.com, riel@redhat.com, mgorman@suse.de, peterz@infradead.org,
        mingo@kernel.org, linux-kernel@vger.kernel.org, dbueso@suse.de,
        linux-mm@kvack.org, Davidlohr Bueso <dave@stgolabs.net>
Subject: [PATCH 05/10] uprobes: share the i_mmap_rwsem
Date: Fri, 24 Oct 2014 15:06:15 -0700
Message-Id: <1414188380-17376-6-git-send-email-dave@stgolabs.net>
X-Mailer: git-send-email 1.8.4.5
In-Reply-To: <1414188380-17376-1-git-send-email-dave@stgolabs.net>
References: <1414188380-17376-1-git-send-email-dave@stgolabs.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Both register and unregister call build_map_info() in order
to create the list of mappings before installing or removing
breakpoints for every mm which maps file backed memory. As
such, there is no reason to hold the i_mmap_rwsem exclusively,
so share it and allow concurrent readers to build the mapping
data.

Signed-off-by: Davidlohr Bueso <dbueso@suse.de>
---
 kernel/events/uprobes.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/kernel/events/uprobes.c b/kernel/events/uprobes.c
index 045b649..7a9e620 100644
--- a/kernel/events/uprobes.c
+++ b/kernel/events/uprobes.c
@@ -724,7 +724,7 @@ build_map_info(struct address_space *mapping, loff_t offset, bool is_register)
 	int more = 0;
 
  again:
-	i_mmap_lock_write(mapping);
+	i_mmap_lock_read(mapping);
 	vma_interval_tree_foreach(vma, &mapping->i_mmap, pgoff, pgoff) {
 		if (!valid_vma(vma, is_register))
 			continue;
@@ -755,7 +755,7 @@ build_map_info(struct address_space *mapping, loff_t offset, bool is_register)
 		info->mm = vma->vm_mm;
 		info->vaddr = offset_to_vaddr(vma, offset);
 	}
-	i_mmap_unlock_write(mapping);
+	i_mmap_unlock_read(mapping);
 
 	if (!more)
 		goto out;
-- 
1.8.4.5

