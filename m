Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756680AbaDPVP7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Apr 2014 17:15:59 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:46405 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751925AbaDPVP6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Apr 2014 17:15:58 -0400
Date: Wed, 16 Apr 2014 14:15:56 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Sebastian Ott <sebott@linux.vnet.ibm.com>
Cc: Ingo Molnar <mingo@kernel.org>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mm/mempool: warn about __GFP_ZERO usage
Message-Id: <20140416141556.d50eef60d955d724ba1b02de@linux-foundation.org>
In-Reply-To: <alpine.LFD.2.11.1404141918170.1561@denkbrett>
References: <alpine.LFD.2.11.1404141918170.1561@denkbrett>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 14 Apr 2014 19:23:34 +0200 (CEST) Sebastian Ott <sebott@linux.vnet.ibm.com> wrote:

> Memory obtained via mempool_alloc is not always zeroed even when
> called with __GFP_ZERO. Add a note and VM_BUG_ON statement to make
> that clear.
> 
> ..
>
> @@ -200,6 +201,7 @@ void * mempool_alloc(mempool_t *pool, gf
>  	wait_queue_t wait;
>  	gfp_t gfp_temp;
>  
> +	VM_BUG_ON(gfp_mask & __GFP_ZERO);
>  	might_sleep_if(gfp_mask & __GFP_WAIT);
>  
>  	gfp_mask |= __GFP_NOMEMALLOC;	/* don't allocate emergency reserves */

hm, BUG is a bit harsh.  How about

--- a/mm/mempool.c~mm-mempool-warn-about-__gfp_zero-usage-fix
+++ a/mm/mempool.c
@@ -201,7 +201,9 @@ void * mempool_alloc(mempool_t *pool, gf
 	wait_queue_t wait;
 	gfp_t gfp_temp;
 
-	VM_BUG_ON(gfp_mask & __GFP_ZERO);
+#ifdef CONFIG_DEBUG_VM
+	WARN_ON_ONCE(gfp_mask & __GFP_ZERO);	/* Where's VM_WARN_ON_ONCE()? */
+#endif
 	might_sleep_if(gfp_mask & __GFP_WAIT);
 
 	gfp_mask |= __GFP_NOMEMALLOC;	/* don't allocate emergency reserves */

?
