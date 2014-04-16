Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756689AbaDPVWH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Apr 2014 17:22:07 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:46444 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753049AbaDPVWE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Apr 2014 17:22:04 -0400
Date: Wed, 16 Apr 2014 14:22:02 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Sebastian Ott <sebott@linux.vnet.ibm.com>, Ingo Molnar <mingo@kernel.org>,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mm/mempool: warn about __GFP_ZERO usage
Message-Id: <20140416142202.f9d9cffa9bf1d9e5d5ed22c4@linux-foundation.org>
In-Reply-To: <20140416141556.d50eef60d955d724ba1b02de@linux-foundation.org>
References: <alpine.LFD.2.11.1404141918170.1561@denkbrett>
	<20140416141556.d50eef60d955d724ba1b02de@linux-foundation.org>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 16 Apr 2014 14:15:56 -0700 Andrew Morton <akpm@linux-foundation.org> wrote:

> @@ -201,7 +201,9 @@ void * mempool_alloc(mempool_t *pool, gf
>  	wait_queue_t wait;
>  	gfp_t gfp_temp;
>  
> -	VM_BUG_ON(gfp_mask & __GFP_ZERO);
> +#ifdef CONFIG_DEBUG_VM
> +	WARN_ON_ONCE(gfp_mask & __GFP_ZERO);	/* Where's VM_WARN_ON_ONCE()? */
> +#endif

bah, don't be lazy.

From: Andrew Morton <akpm@linux-foundation.org>
Subject: include/linux/mmdebug.h: add VM_WARN_ON() and VM_WARN_ON_ONCE()

WARN_ON() and WARN_ON_ONCE(), dependent on CONFIG_DEBUG_VM

Cc: Sebastian Ott <sebott@linux.vnet.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mmdebug.h |    4 ++++
 1 file changed, 4 insertions(+)

diff -puN include/linux/mmdebug.h~include-linux-mmdebugh-add-vm_warn_on-and-vm_warn_on_once include/linux/mmdebug.h
--- a/include/linux/mmdebug.h~include-linux-mmdebugh-add-vm_warn_on-and-vm_warn_on_once
+++ a/include/linux/mmdebug.h
@@ -11,9 +11,13 @@ extern void dump_page_badflags(struct pa
 #define VM_BUG_ON(cond) BUG_ON(cond)
 #define VM_BUG_ON_PAGE(cond, page) \
 	do { if (unlikely(cond)) { dump_page(page, NULL); BUG(); } } while (0)
+#define VM_WARN_ON(cond) WARN_ON(cond)
+#define VM_WARN_ON_ONCE(cond) WARN_ON_ONCE(cond)
 #else
 #define VM_BUG_ON(cond) BUILD_BUG_ON_INVALID(cond)
 #define VM_BUG_ON_PAGE(cond, page) VM_BUG_ON(cond)
+#define VM_WARN_ON(cond) BUILD_BUG_ON_INVALID(cond)
+#define VM_WARN_ON_ONCE(cond) BUILD_BUG_ON_INVALID(cond)
 #endif
 
 #ifdef CONFIG_DEBUG_VIRTUAL
_

From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm-mempool-warn-about-__gfp_zero-usage-fix

use VM_WARN_ON_ONCE

Cc: Sebastian Ott <sebott@linux.vnet.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mempool.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN mm/mempool.c~mm-mempool-warn-about-__gfp_zero-usage-fix mm/mempool.c
--- a/mm/mempool.c~mm-mempool-warn-about-__gfp_zero-usage-fix
+++ a/mm/mempool.c
@@ -201,7 +201,7 @@ void * mempool_alloc(mempool_t *pool, gf
 	wait_queue_t wait;
 	gfp_t gfp_temp;
 
-	VM_BUG_ON(gfp_mask & __GFP_ZERO);
+	VM_WARN_ON_ONCE(gfp_mask & __GFP_ZERO);
 	might_sleep_if(gfp_mask & __GFP_WAIT);
 
 	gfp_mask |= __GFP_NOMEMALLOC;	/* don't allocate emergency reserves */
_

