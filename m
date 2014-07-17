Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754966AbaGQAgx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jul 2014 20:36:53 -0400
Received: from mail-ig0-f175.google.com ([209.85.213.175]:60963 "EHLO
	mail-ig0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752627AbaGQAgw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jul 2014 20:36:52 -0400
Date: Wed, 16 Jul 2014 17:36:49 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Andrew Morton <akpm@linux-foundation.org>
cc: Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@suse.cz>,
        Rik van Riel <riel@redhat.com>, stable@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: [patch] mm, writeback: prevent race when calculating dirty limits
Message-ID: <alpine.DEB.2.02.1407161733200.23892@chino.kir.corp.google.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Setting vm_dirty_bytes and dirty_background_bytes is not protected by any 
serialization.

Therefore, it's possible for either variable to change value after the 
test in global_dirty_limits() to determine whether available_memory needs 
to be initialized or not.

Always ensure that available_memory is properly initialized.

Cc: stable@vger.kernel.org
Signed-off-by: David Rientjes <rientjes@google.com>
---
 mm/page-writeback.c | 5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff --git a/mm/page-writeback.c b/mm/page-writeback.c
--- a/mm/page-writeback.c
+++ b/mm/page-writeback.c
@@ -261,14 +261,11 @@ static unsigned long global_dirtyable_memory(void)
  */
 void global_dirty_limits(unsigned long *pbackground, unsigned long *pdirty)
 {
+	const unsigned long available_memory = global_dirtyable_memory();
 	unsigned long background;
 	unsigned long dirty;
-	unsigned long uninitialized_var(available_memory);
 	struct task_struct *tsk;
 
-	if (!vm_dirty_bytes || !dirty_background_bytes)
-		available_memory = global_dirtyable_memory();
-
 	if (vm_dirty_bytes)
 		dirty = DIV_ROUND_UP(vm_dirty_bytes, PAGE_SIZE);
 	else
