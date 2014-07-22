Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933616AbaGVWlV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jul 2014 18:41:21 -0400
Received: from mail-ig0-f178.google.com ([209.85.213.178]:49668 "EHLO
	mail-ig0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932724AbaGVWlR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jul 2014 18:41:17 -0400
Date: Tue, 22 Jul 2014 15:41:14 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Andrew Morton <akpm@linux-foundation.org>,
        Mike Snitzer <snitzer@redhat.com>
cc: Pekka Enberg <penberg@iki.fi>, Christoph Lameter <cl@linux.com>,
        Pekka Enberg <penberg@kernel.org>, linux-mm@kvack.org,
        dm-devel@redhat.com, linux-kernel@vger.kernel.org,
        "Alasdair G. Kergon" <agk@redhat.com>,
        Mikulas Patocka <mpatocka@redhat.com>,
        Zdenek Kabelac <zkabelac@redhat.com>
Subject: [patch] slab_common: fix the check for duplicate slab names
In-Reply-To: <20140722221421.GA11318@redhat.com>
Message-ID: <alpine.DEB.2.02.1407221539020.5814@chino.kir.corp.google.com>
References: <alpine.LRH.2.02.1403041711300.29476@file01.intranet.prod.int.rdu2.redhat.com> <20140325170324.GC580@redhat.com> <alpine.DEB.2.10.1403251306260.26471@nuc> <20140523201632.GA16013@redhat.com> <537FBD6F.1070009@iki.fi>
 <20140722221421.GA11318@redhat.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Mikulas Patocka <mpatocka@redhat.com>

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

Cc: stable@vger.kernel.org	# 3.6+
Acked-by: Christoph Lameter <cl@linux.com>
Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
Signed-off-by: Pekka Enberg <penberg@kernel.org>
Signed-off-by: David Rientjes <rientjes@google.com>
---
 Andrew, this is in Pekka's tree but has not managed to be pushed for 
 3.16, mind picking it up?

 I'll check to see if there's anything else in Pekka's tree that you need.

 mm/slab_common.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/mm/slab_common.c b/mm/slab_common.c
--- a/mm/slab_common.c
+++ b/mm/slab_common.c
@@ -55,7 +55,7 @@ static int kmem_cache_sanity_check(const char *name, size_t size)
 			continue;
 		}
 
-#if !defined(CONFIG_SLUB) || !defined(CONFIG_SLUB_DEBUG_ON)
+#if !defined(CONFIG_SLUB)
 		if (!strcmp(s->name, name)) {
 			pr_err("%s (%s): Cache name already exists.\n",
 			       __func__, name);
