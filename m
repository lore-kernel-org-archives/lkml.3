Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757102AbaHHUnt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Aug 2014 16:43:49 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:40244 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753000AbaHHUnq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Aug 2014 16:43:46 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Mikulas Patocka <mpatocka@redhat.com>, Pekka Enberg <penberg@kernel.org>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.13 154/259] slab_common: fix the check for duplicate slab names
Date: Fri,  8 Aug 2014 13:39:37 -0700
Message-Id: <1407530482-4483-155-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1407530482-4483-1-git-send-email-kamal@canonical.com>
References: <1407530482-4483-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.13
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13.11.6 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mikulas Patocka <mpatocka@redhat.com>

commit 694617474e33b8603fc76e090ed7d09376514b1a upstream.

The patch 3e374919b314f20e2a04f641ebc1093d758f66a4 is supposed to fix the
problem where kmem_cache_create incorrectly reports duplicate cache name
and fails. The problem is described in the header of that patch.

However, the patch doesn't really fix the problem because of these
reasons:

* the logic to test for debugging is reversed. It was intended to perform
  the check only if slub debugging is enabled (which implies that caches
  with the same parameters are not merged). Therefore, there should be
  #if !defined(CONFIG_SLUB) || defined(CONFIG_SLUB_DEBUG_ON)
  The current code has the condition reversed and performs the test if
  debugging is disabled.

* slub debugging may be enabled or disabled based on kernel command line,
  CONFIG_SLUB_DEBUG_ON is just the default settings. Therefore the test
  based on definition of CONFIG_SLUB_DEBUG_ON is unreliable.

This patch fixes the problem by removing the test
"!defined(CONFIG_SLUB_DEBUG_ON)". Therefore, duplicate names are never
checked if the SLUB allocator is used.

Note to stable kernel maintainers: when backporint this patch, please
backport also the patch 3e374919b314f20e2a04f641ebc1093d758f66a4.

Acked-by: David Rientjes <rientjes@google.com>
Acked-by: Christoph Lameter <cl@linux.com>
Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
Signed-off-by: Pekka Enberg <penberg@kernel.org>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 mm/slab_common.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/mm/slab_common.c b/mm/slab_common.c
index 0b7bb39..08ded33 100644
--- a/mm/slab_common.c
+++ b/mm/slab_common.c
@@ -56,7 +56,7 @@ static int kmem_cache_sanity_check(struct mem_cgroup *memcg, const char *name,
 			continue;
 		}
 
-#if !defined(CONFIG_SLUB) || !defined(CONFIG_SLUB_DEBUG_ON)
+#if !defined(CONFIG_SLUB)
 		/*
 		 * For simplicity, we won't check this in the list of memcg
 		 * caches. We have control over memcg naming, and if there
-- 
1.9.1

