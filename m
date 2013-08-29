Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756012Ab3H2JZn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Aug 2013 05:25:43 -0400
Received: from mail-ee0-f50.google.com ([74.125.83.50]:46106 "EHLO
	mail-ee0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755968Ab3H2JZk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Aug 2013 05:25:40 -0400
Date: Thu, 29 Aug 2013 11:25:33 +0200
From: Miklos Szeredi <miklos@szeredi.hu>
To: Maxim Patlasov <MPatlasov@parallels.com>
Cc: xemul@parallels.com, fuse-devel@lists.sourceforge.net, bfoster@redhat.com,
        linux-kernel@vger.kernel.org, jbottomley@parallels.com,
        linux-fsdevel@vger.kernel.org, devel@openvz.org
Subject: Re: [PATCH] fuse: hotfix truncate_pagecache() issue
Message-ID: <20130829092533.GA18044@tucsk.piliscsaba.szeredi.hu>
References: <20130828121920.23965.78383.stgit@maximpc.sw.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130828121920.23965.78383.stgit@maximpc.sw.ru>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 28, 2013 at 04:21:46PM +0400, Maxim Patlasov wrote:
> The way how fuse calls truncate_pagecache() from fuse_change_attributes()
> is completely wrong. Because, w/o i_mutex held, we never sure whether
> 'oldsize' and 'attr->size' are valid by the time of execution of
> truncate_pagecache(inode, oldsize, attr->size). In fact, as soon as we
> released fc->lock in the middle of fuse_change_attributes(), we completely
> loose control of actions which may happen with given inode until we reach
> truncate_pagecache. The list of potentially dangerous actions includes mmap-ed
> reads and writes, ftruncate(2) and write(2) extending file size.
> 
> The typical outcome of doing truncate_pagecache() with outdated arguments is
> data corruption from user point of view. This is (in some sense) acceptable
> in cases when the issue is triggered by a change of the file on the server
> (i.e. externally wrt fuse operation), but it is absolutely intolerable in
> scenarios when a single fuse client modifies a file without any external
> intervention. A real life case I discovered by fsx-linux looked like this:
> 
> 1. Shrinking ftruncate(2) comes to fuse_do_setattr(). The latter sends
> FUSE_SETATTR to the server synchronously, but before getting fc->lock ...
> 2. fuse_dentry_revalidate() is asynchronously called. It sends FUSE_LOOKUP
> to the server synchronously, then calls fuse_change_attributes(). The latter
> updates i_size, releases fc->lock, but before comparing oldsize vs attr->size..
> 3. fuse_do_setattr() from the first step proceeds by acquiring fc->lock and
> updating attributes and i_size, but now oldsize is equal to outarg.attr.size
> because i_size has just been updated (step 2). Hence, fuse_do_setattr()
> returns w/o calling truncate_pagecache().
> 4. As soon as ftruncate(2) completes, the user extends file size by write(2)
> making a hole in the middle of file, then reads data from the hole either by
> read(2) or mmap-ed read. The user expects to get zero data from the hole, but
> gets stale data because truncate_pagecache() is not executed yet.
> 
> The patch is a hotfix resolving the issue in a simplistic way: let's skip
> dangerous i_size update and truncate_pagecache if an operation changing file
> size is in progress. This simplistic approach looks correct for the cases
> w/o external changes. And to handle them properly, more sophisticated and
> intrusive techniques (e.g. NFS-like one) would be required. I'd like
> to postpone it until the issue is well discussed on the mailing list(s).

Thanks for the analysis!

Okay, what about this even more simplistic approach?

Not tested, but I think it addresses the very crux of the issue: not truncating
the page cache even though we should.

AFAICS there's no such issue with write(2) or fallocate(2).  But I haven't
thought about this very deeply.

And indeed, handling external changes even half way sanely is "fun".

Thanks,
Miklos

diff --git a/fs/fuse/dir.c b/fs/fuse/dir.c
index 72a5d5b..fdb5036 100644
--- a/fs/fuse/dir.c
+++ b/fs/fuse/dir.c
@@ -1675,7 +1675,8 @@ int fuse_do_setattr(struct inode *inode, struct iattr *attr,
 	 * Only call invalidate_inode_pages2() after removing
 	 * FUSE_NOWRITE, otherwise fuse_launder_page() would deadlock.
 	 */
-	if (S_ISREG(inode->i_mode) && oldsize != outarg.attr.size) {
+	if ((S_ISREG(inode->i_mode) && oldsize != outarg.attr.size) ||
+	    is_truncate) {
 		truncate_pagecache(inode, oldsize, outarg.attr.size);
 		invalidate_inode_pages2(inode->i_mapping);
 	}
