Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933843Ab3CIAlK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Mar 2013 19:41:10 -0500
Received: from dcvr.yhbt.net ([64.71.152.64]:59993 "EHLO dcvr.yhbt.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933426Ab3CIAlI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Mar 2013 19:41:08 -0500
Date: Sat, 9 Mar 2013 00:41:07 +0000
From: Eric Wong <normalperson@yhbt.net>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Davide Libenzi <davidel@xmailserver.org>,
        Al Viro <viro@ZenIV.linux.org.uk>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] epoll: comment + BUILD_BUG_ON to prevent epitem bloat
Message-ID: <20130309004107.GA31085@dcvr.yhbt.net>
References: <20130304112941.GA16284@dcvr.yhbt.net>
 <20130306143741.d5e56f13c94d2d6b2c1ea449@linux-foundation.org>
 <20130307103240.GA24132@dcvr.yhbt.net>
 <20130308155410.3c63f24ee28e6532006cb0d4@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130308155410.3c63f24ee28e6532006cb0d4@linux-foundation.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This will prevent us from accidentally introducing a memory bloat
regression here in the future.

Signed-off-by: Eric Wong <normalperson@yhbt.net>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Davide Libenzi <davidel@xmailserver.org>,
Cc: Al Viro <viro@ZenIV.linux.org.uk>
---
  Andrew Morton <akpm@linux-foundation.org> wrote:
  > On Thu, 7 Mar 2013 10:32:40 +0000 Eric Wong <normalperson@yhbt.net> wrote:
  > 
  > > Andrew Morton <akpm@linux-foundation.org> wrote:
  > > > It's going to be hard to maintain this - someone will change something
  > > > sometime and break it.  I suppose we could add a runtime check if we
  > > > cared enough.  Adding a big fat comment to struct epitem might help.
  > > 
  > > Thanks for looking at this patch.  I'll send a patch with a comment
  > > about keeping epitem size in check.  Also, would adding (with comments):
  > > 
  > > 	BUILD_BUG_ON(sizeof(struct epitem) > 128);
  > > 
  > > ...be too heavy-handed?  I used that in my testing.  I'll check for:
  > > sizeof(void *) <= 8 too; in case 128-bit machines appear...
  > 
  > I guess such a check might avoid accidents in the future.  If it
  > becomes a problem, we can always delete it.

 fs/eventpoll.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/fs/eventpoll.c b/fs/eventpoll.c
index 9fec183..55028da 100644
--- a/fs/eventpoll.c
+++ b/fs/eventpoll.c
@@ -128,6 +128,8 @@ struct nested_calls {
 /*
  * Each file descriptor added to the eventpoll interface will
  * have an entry of this type linked to the "rbr" RB tree.
+ * Avoid increasing the size of this struct, there can be many thousands
+ * of these on a server and we do not want this to take another cache line.
  */
 struct epitem {
 	/* RB tree node used to link this structure to the eventpoll RB tree */
@@ -1964,6 +1966,12 @@ static int __init eventpoll_init(void)
 	/* Initialize the structure used to perform file's f_op->poll() calls */
 	ep_nested_calls_init(&poll_readywalk_ncalls);
 
+	/*
+	 * We can have many thousands of epitems, so prevent this from
+	 * using an extra cache line on 64-bit (and smaller) CPUs
+	 */
+	BUILD_BUG_ON(sizeof(void *) <= 8 && sizeof(struct epitem) > 128);
+
 	/* Allocates slab cache used to allocate "struct epitem" items */
 	epi_cache = kmem_cache_create("eventpoll_epi", sizeof(struct epitem),
 			0, SLAB_HWCACHE_ALIGN | SLAB_PANIC, NULL);
-- 
Eric Wong
