Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752401AbaAXSVG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Jan 2014 13:21:06 -0500
Received: from mx1.redhat.com ([209.132.183.28]:27111 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752289AbaAXSVD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Jan 2014 13:21:03 -0500
Date: Fri, 24 Jan 2014 13:20:48 -0500
From: Dave Jones <davej@redhat.com>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Cc: vdavydov@parallels.com
Subject: Re: slab: clean up kmem_cache_create_memcg() error handling
Message-ID: <20140124182048.GA31147@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	vdavydov@parallels.com
References: <20140124033341.3FD106611CC@gitolite.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140124033341.3FD106611CC@gitolite.kernel.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 24, 2014 at 03:33:41AM +0000, Linux Kernel wrote:
 > Gitweb:     http://git.kernel.org/linus/;a=commit;h=3965fc3652244651006ebb31c8c45318ce84818f
 > Commit:     3965fc3652244651006ebb31c8c45318ce84818f
 > Parent:     309381feaee564281c3d9e90fbca8963bb7428ad
 > Author:     Vladimir Davydov <vdavydov@parallels.com>
 > AuthorDate: Thu Jan 23 15:52:55 2014 -0800
 > Committer:  Linus Torvalds <torvalds@linux-foundation.org>
 > CommitDate: Thu Jan 23 16:36:50 2014 -0800
 > 
 >     slab: clean up kmem_cache_create_memcg() error handling
 >     
 >     Currently kmem_cache_create_memcg() backoffs on failure inside
 >     conditionals, without using gotos.  This results in the rollback code
 >     duplication, which makes the function look cumbersome even though on
 >     error we should only free the allocated cache.  Since in the next patch
 >     I am going to add yet another rollback function call on error path
 >     there, let's employ labels instead of conditionals for undoing any
 >     changes on failure to keep things clean.

...

 > +out_unlock:
 >  	mutex_unlock(&slab_mutex);
 >  	put_online_cpus();
 >  
 >  	if (err) {
 > -
 >  		if (flags & SLAB_PANIC)
 >  			panic("kmem_cache_create: Failed to create slab '%s'. Error %d\n",
 >  				name, err);
 > @@ -236,11 +230,14 @@ out_locked:
 >  				name, err);
 >  			dump_stack();
 >  		}
 > -
 >  		return NULL;
 >  	}
 > -
 >  	return s;
 > +
 > +out_free_cache:
 > +	kfree(s->name);
 > +	kmem_cache_free(kmem_cache, s);
 > +	goto out_unlock;
 >  }

This is now returning a freed pointer as 's' if an error occurs.
Perhaps the patch below ?

	Dave


diff --git a/mm/slab_common.c b/mm/slab_common.c
index 8e40321da091..2c62294cee23 100644
--- a/mm/slab_common.c
+++ b/mm/slab_common.c
@@ -257,6 +257,7 @@ out_free_cache:
 	memcg_free_cache_params(s);
 	kfree(s->name);
 	kmem_cache_free(kmem_cache, s);
+	s = NULL;
 	goto out_unlock;
 }
 
