Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758091Ab3LFTPo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Dec 2013 14:15:44 -0500
Received: from kanga.kvack.org ([205.233.56.17]:39905 "EHLO kanga.kvack.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753223Ab3LFTPm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Dec 2013 14:15:42 -0500
Date: Fri, 6 Dec 2013 14:15:41 -0500
From: Benjamin LaHaise <bcrl@kvack.org>
To: stable@vger.kernel.org
Cc: linux-aio@kvack.org, linux-fsdevel@vger.kernel.org,
        Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [3.12] aio fixes to pull into 3.12
Message-ID: <20131206191541.GA27931@kvack.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Greg,

Please pull the following changes into 3.12 from Linus' tree.  They fix 
several important issues found since 3.12 was released.  None of these 
are needed in 3.11 or earlier.  Thanks!

		-ben

commit d1b9432712a25eeb06114fb4b587133525a47de5
Author: Gu Zheng <guz.fnst@cn.fujitsu.com>
Date:   Wed Dec 4 18:19:06 2013 +0800

    aio: clean up aio ring in the fail path
    
    Clean up the aio ring file in the fail path of aio_setup_ring
    and ioctx_alloc. And maybe it can fix the GPF issue reported by
    Dave Jones:
    https://lkml.org/lkml/2013/11/25/898
    
    Signed-off-by: Gu Zheng <guz.fnst@cn.fujitsu.com>
    Signed-off-by: Benjamin LaHaise <bcrl@kvack.org>

commit ddb8c45ba15149ebd41d7586261c05f7ca37f9a1
Author: Sasha Levin <sasha.levin@oracle.com>
Date:   Tue Nov 19 17:33:03 2013 -0500

    aio: nullify aio->ring_pages after freeing it
    
    After freeing ring_pages we leave it as is causing a dangling pointer. This
    has already caused an issue so to help catching any issues in the future
    NULL it out.
    
    Signed-off-by: Sasha Levin <sasha.levin@oracle.com>
    Signed-off-by: Benjamin LaHaise <bcrl@kvack.org>

commit d558023207e008a4476a3b7bb8706b2a2bf5d84f
Author: Sasha Levin <sasha.levin@oracle.com>
Date:   Tue Nov 19 17:33:02 2013 -0500

    aio: prevent double free in ioctx_alloc
    
    ioctx_alloc() calls aio_setup_ring() to allocate a ring. If aio_setup_ring()
    fails to do so it would call aio_free_ring() before returning, but
    ioctx_alloc() would call aio_free_ring() again causing a double free of
    the ring.
    
    This is easily reproducible from userspace.
    
    Signed-off-by: Sasha Levin <sasha.levin@oracle.com>
    Signed-off-by: Benjamin LaHaise <bcrl@kvack.org>

commit 7f62656be8a8ef14c168db2d98021fb9c8cc1076
Author: Dan Carpenter <dan.carpenter@oracle.com>
Date:   Wed Nov 13 10:49:40 2013 +0300

    aio: checking for NULL instead of IS_ERR
    
    alloc_anon_inode() returns an ERR_PTR(), it doesn't return NULL.
    
    Fixes: 71ad7490c1f3 ('rework aio migrate pages to use aio fs')
    Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
    Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>

commit 71ad7490c1f32bd7829df76360f9fa17829868f3
Author: Benjamin LaHaise <bcrl@kvack.org>
Date:   Tue Sep 17 10:18:25 2013 -0400

    rework aio migrate pages to use aio fs
    
    Don't abuse anon_inodes.c to host private files needed by aio;
    we can bloody well declare a mini-fs of our own instead of
    patching up what anon_inodes can create for us.
    
    Tested-by: Benjamin LaHaise <bcrl@kvack.org>
    Acked-by: Benjamin LaHaise <bcrl@kvack.org>
    Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>

commit e34ecee2ae791df674dfb466ce40692ca6218e43
Author: Kent Overstreet <kmo@daterainc.com>
Date:   Thu Oct 10 19:31:47 2013 -0700

    aio: Fix a trinity splat
    
    aio kiocb refcounting was broken - it was relying on keeping track of
    the number of available ring buffer entries, which it needs to do
    anyways; then at shutdown time it'd wait for completions to be delivered
    until the # of available ring buffer entries equalled what it was
    initialized to.
    
    Problem with  that is that the ring buffer is mapped writable into
    userspace, so userspace could futz with the head and tail pointers to
    cause the kernel to see extra completions, and cause free_ioctx() to
    return while there were still outstanding kiocbs. Which would be bad.
    
    Fix is just to directly refcount the kiocbs - which is more
    straightforward, and with the new percpu refcounting code doesn't cost
    us any cacheline bouncing which was the whole point of the original
    scheme.
    
    Also clean up ioctx_alloc()'s error path and fix a bug where it wasn't
    subtracting from aio_nr if ioctx_add_table() failed.
    
    Signed-off-by: Kent Overstreet <kmo@daterainc.com>

-- 
"Thought is the essence of where you are now."
