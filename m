Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756619Ab3H3O0t (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Aug 2013 10:26:49 -0400
Received: from kanga.kvack.org ([205.233.56.17]:48562 "EHLO kanga.kvack.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753058Ab3H3O0s (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Aug 2013 10:26:48 -0400
Date: Fri, 30 Aug 2013 10:26:46 -0400
From: Benjamin LaHaise <bcrl@kvack.org>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Waiman Long <Waiman.Long@hp.com>,
        Linus <torvalds@linux-foundation.org>
Subject: Re: linux-next: build failure after merge of the aio tree
Message-ID: <20130830142646.GH13330@kvack.org>
References: <20130830175509.39d7fbfd96a4e726ba739d26@canb.auug.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130830175509.39d7fbfd96a4e726ba739d26@canb.auug.org.au>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Stephen,

On Fri, Aug 30, 2013 at 05:55:09PM +1000, Stephen Rothwell wrote:
> Hi Benjamin,
> 
> After merging the aio tree, today's linux-next build (powerpc
> ppc64_defconfig) failed like this:
> 
> In file included from include/linux/kernel.h:13:0,
>                  from fs/aio.c:13:
> fs/aio.c: In function 'aio_free_ring':
> fs/aio.c:188:32: error: 'struct dentry' has no member named 'd_count'
>     aio_ring_file->f_path.dentry->d_count,
>                                 ^
> include/linux/printk.h:246:38: note: in definition of macro 'pr_debug'
>   no_printk(KERN_DEBUG pr_fmt(fmt), ##__VA_ARGS__)

Ah, this is unnecessary debugging code that got changed.  I've committed 
the following to my aio-next tree to just delete the code since it is not 
required.

		-ben
-- 
"Thought is the essence of where you are now."


commit 79bd1bcf1ab22ea723da7d5854a9e72a350ecbf8
Author: Benjamin LaHaise <bcrl@kvack.org>
Date:   Fri Aug 30 10:22:04 2013 -0400

    aio: remove unnecessary debugging from aio_free_ring()
    
    The commit 36bc08cc0170 ("fs/aio: Add support to aio ring pages migration")
    added some debugging code that is not required and resulted in a build error
    when 98474236f72e ("vfs: make the dentry cache use the lockref infrastructure")
    was added to the tree.  The code is not required, so just delete it.
    
    Signed-off-by: Benjamin LaHaise <bcrl@kvack.org>

diff --git a/fs/aio.c b/fs/aio.c
index c3f005d..d0defcb 100644
--- a/fs/aio.c
+++ b/fs/aio.c
@@ -183,11 +183,6 @@ static void aio_free_ring(struct kioctx *ctx)
 
 	if (aio_ring_file) {
 		truncate_setsize(aio_ring_file->f_inode, 0);
-		pr_debug("pid(%d) i_nlink=%u d_count=%d d_unhashed=%d i_count=%d\n",
-			current->pid, aio_ring_file->f_inode->i_nlink,
-			aio_ring_file->f_path.dentry->d_count,
-			d_unhashed(aio_ring_file->f_path.dentry),
-			atomic_read(&aio_ring_file->f_inode->i_count));
 		fput(aio_ring_file);
 		ctx->aio_ring_file = NULL;
 	}
