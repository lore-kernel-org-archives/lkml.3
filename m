Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752964AbaAXVOl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Jan 2014 16:14:41 -0500
Received: from relay.parallels.com ([195.214.232.42]:50470 "EHLO
	relay.parallels.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752397AbaAXVOk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Jan 2014 16:14:40 -0500
Message-ID: <52E2D7BB.7080801@parallels.com>
Date: Sat, 25 Jan 2014 01:14:35 +0400
From: Vladimir Davydov <vdavydov@parallels.com>
MIME-Version: 1.0
To: Dave Jones <davej@redhat.com>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: slab: clean up kmem_cache_create_memcg() error handling
References: <20140124033341.3FD106611CC@gitolite.kernel.org> <20140124182048.GA31147@redhat.com>
In-Reply-To: <20140124182048.GA31147@redhat.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.24.25.82]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/24/2014 10:20 PM, Dave Jones wrote:
> On Fri, Jan 24, 2014 at 03:33:41AM +0000, Linux Kernel wrote:
>  > Gitweb:     http://git.kernel.org/linus/;a=commit;h=3965fc3652244651006ebb31c8c45318ce84818f
>  > Commit:     3965fc3652244651006ebb31c8c45318ce84818f
>  > Parent:     309381feaee564281c3d9e90fbca8963bb7428ad
>  > Author:     Vladimir Davydov <vdavydov@parallels.com>
>  > AuthorDate: Thu Jan 23 15:52:55 2014 -0800
>  > Committer:  Linus Torvalds <torvalds@linux-foundation.org>
>  > CommitDate: Thu Jan 23 16:36:50 2014 -0800
>  > 
>  >     slab: clean up kmem_cache_create_memcg() error handling
>  >     
>  >     Currently kmem_cache_create_memcg() backoffs on failure inside
>  >     conditionals, without using gotos.  This results in the rollback code
>  >     duplication, which makes the function look cumbersome even though on
>  >     error we should only free the allocated cache.  Since in the next patch
>  >     I am going to add yet another rollback function call on error path
>  >     there, let's employ labels instead of conditionals for undoing any
>  >     changes on failure to keep things clean.
>
> ...
>
>  > +out_unlock:
>  >  	mutex_unlock(&slab_mutex);
>  >  	put_online_cpus();
>  >  
>  >  	if (err) {
>  > -
>  >  		if (flags & SLAB_PANIC)
>  >  			panic("kmem_cache_create: Failed to create slab '%s'. Error %d\n",
>  >  				name, err);
>  > @@ -236,11 +230,14 @@ out_locked:
>  >  				name, err);
>  >  			dump_stack();
>  >  		}
>  > -
>  >  		return NULL;
>  >  	}
>  > -
>  >  	return s;
>  > +
>  > +out_free_cache:
>  > +	kfree(s->name);
>  > +	kmem_cache_free(kmem_cache, s);
>  > +	goto out_unlock;
>  >  }
>
> This is now returning a freed pointer as 's' if an error occurs.

If we go to out_free_cache, we set err, and since under out_unlock we have:

> if (err) {
...
>     return NULL
>}

we will return NULL, which is right.

However this behavior was broken by another my 'fix' :-(

commit    f717eb3abb5ea38f60e671dbfdbf512c2c93d22e
slab: do not panic if we fail to create memcg cache
> -    if (err) {
> +    /*
> +     * There is no point in flooding logs with warnings or especially
> +     * crashing the system if we fail to create a cache for a memcg. In
> +     * this case we will be accounting the memcg allocation to the root
> +     * cgroup until we succeed to create its own cache, but it isn't that
> +     * critical.
> +     */
> +    if (err && !memcg) {
>          if (flags & SLAB_PANIC)
>              panic("kmem_cache_create: Failed to create slab '%s'.
> Error %d\n",
>                  name, err);

In case memcg != NULL we can return crap on error. So you are right in
the end. Thank you for catching this!

> Perhaps the patch below ?
>
> diff --git a/mm/slab_common.c b/mm/slab_common.c
> index 8e40321da091..2c62294cee23 100644
> --- a/mm/slab_common.c
> +++ b/mm/slab_common.c
> @@ -257,6 +257,7 @@ out_free_cache:
>  	memcg_free_cache_params(s);
>  	kfree(s->name);
>  	kmem_cache_free(kmem_cache, s);
> +	s = NULL;
>  	goto out_unlock;
>  }

This one looks correct to me. I'll send it on behalf of you.

Thanks!
