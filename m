Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752546AbaAZEjK (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 Jan 2014 23:39:10 -0500
Received: from mail-bk0-f42.google.com ([209.85.214.42]:51877 "EHLO
	mail-bk0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752396AbaAZEjI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 Jan 2014 23:39:08 -0500
Date: Sat, 25 Jan 2014 20:39:02 -0800 (PST)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Vladimir Davydov <vdavydov@parallels.com>
cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, Dave Jones <davej@redhat.com>,
        Pekka Enberg <penberg@kernel.org>, Christoph Lameter <cl@linux.com>
Subject: Re: [PATCH] slab: fix wrong retval on kmem_cache_create_memcg error
 path
In-Reply-To: <1390598126-4332-1-git-send-email-vdavydov@parallels.com>
Message-ID: <alpine.DEB.2.02.1401252036410.10325@chino.kir.corp.google.com>
References: <1390598126-4332-1-git-send-email-vdavydov@parallels.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 25 Jan 2014, Vladimir Davydov wrote:

> diff --git a/mm/slab_common.c b/mm/slab_common.c
> index 8e40321..499b53c 100644
> --- a/mm/slab_common.c
> +++ b/mm/slab_common.c
> @@ -249,7 +249,6 @@ out_unlock:
>  				name, err);
>  			dump_stack();
>  		}
> -		return NULL;
>  	}
>  	return s;
>  
> @@ -257,6 +256,7 @@ out_free_cache:
>  	memcg_free_cache_params(s);
>  	kfree(s->name);
>  	kmem_cache_free(kmem_cache, s);
> +	s = NULL;
>  	goto out_unlock;
>  }
>  

I thought I left spaghetti code back in my BASIC 2.0 days.  It should be 
much more readable to just do

diff --git a/mm/slab_common.c b/mm/slab_common.c
--- a/mm/slab_common.c
+++ b/mm/slab_common.c
@@ -233,14 +233,15 @@ out_unlock:
 	mutex_unlock(&slab_mutex);
 	put_online_cpus();
 
-	/*
-	 * There is no point in flooding logs with warnings or especially
-	 * crashing the system if we fail to create a cache for a memcg. In
-	 * this case we will be accounting the memcg allocation to the root
-	 * cgroup until we succeed to create its own cache, but it isn't that
-	 * critical.
-	 */
-	if (err && !memcg) {
+	if (err) {
+		/*
+		 * There is no point in flooding logs with warnings or
+		 * especially crashing the system if we fail to create a cache
+		 * for a memcg.
+		 */
+		if (memcg)
+			return NULL;
+
 		if (flags & SLAB_PANIC)
 			panic("kmem_cache_create: Failed to create slab '%s'. Error %d\n",
 				name, err);

and stop trying to remember what err, memcg, and s are in all possible 
contexts.  Sheesh.
