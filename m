Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755462Ab3GQNoc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Jul 2013 09:44:32 -0400
Received: from kanga.kvack.org ([205.233.56.17]:34183 "EHLO kanga.kvack.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754804Ab3GQNoa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Jul 2013 09:44:30 -0400
Date: Wed, 17 Jul 2013 09:44:28 -0400
From: Benjamin LaHaise <bcrl@kvack.org>
To: Gu Zheng <guz.fnst@cn.fujitsu.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Mel Gorman <mgorman@suse.de>,
        Al Viro <viro@zeniv.linux.org.uk>, tangchen <tangchen@cn.fujitsu.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>, linux-mm@kvack.org,
        Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>,
        linux-aio@kvack.org
Subject: Re: [PATCH V2 2/2] fs/aio: Add support to aio ring pages migration
Message-ID: <20130717134428.GB19643@kvack.org>
References: <51E518C0.2020908@cn.fujitsu.com> <20130716133450.GD5403@kvack.org> <51E66256.9020203@cn.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <51E66256.9020203@cn.fujitsu.com>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 17, 2013 at 05:22:30PM +0800, Gu Zheng wrote:
> As the aio job will pin the ring pages, that will lead to mem migrated
> failed. In order to fix this problem we use an anon inode to manage the aio ring
> pages, and  setup the migratepage callback in the anon inode's address space, so
> that when mem migrating the aio ring pages will be moved to other mem node safely.
> 
> v1->v2:
> 	Fix build failed issue if CONFIG_MIGRATION disabled.
> 	Fix some minor issues under Benjamin's comments.

I don't know what you did with this patch, but it doesn't apply to any of 
the trees I can find, and interdiff isn't able to compare it against your 
original patch.  Since the first version of the patch was already applied 
it is generally more appropriate to provide an incremental fix.  I've 
added the following to my tree (git://git.kvack.org/~bcrl/aio-next.git/) 
to fix the build issue.  I've tested this with CONFIG_MIGRATION enabled 
and disabled on x86.

		-ben
-- 
"Thought is the essence of where you are now."


>From 0c45355fc7c48c82db151bf0e7ca305d513e639e Mon Sep 17 00:00:00 2001
From: Benjamin LaHaise <bcrl@kvack.org>
Date: Wed, 17 Jul 2013 09:34:24 -0400
Subject: [PATCH] aio: fix build when migration is disabled

When "fs/aio: Add support to aio ring pages migration" was applied, it
broke the build when CONFIG_MIGRATION was disabled.  Wrap the migration
code with a test for CONFIG_MIGRATION to fix this and save a few bytes
when migration is disabled.

Signed-off-by: Benjamin LaHaise <bcrl@kvack.org>
---
 fs/aio.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/fs/aio.c b/fs/aio.c
index cbd0afe..dedeea0 100644
--- a/fs/aio.c
+++ b/fs/aio.c
@@ -181,6 +181,7 @@ static int aio_set_page_dirty(struct page *page)
 	return 0;
 }
 
+#if IS_ENABLED(CONFIG_MIGRATION)
 static int aio_migratepage(struct address_space *mapping, struct page *new,
 			struct page *old, enum migrate_mode mode)
 {
@@ -208,10 +209,13 @@ static int aio_migratepage(struct address_space *mapping, struct page *new,
 
 	return rc;
 }
+#endif
 
 static const struct address_space_operations aio_ctx_aops = {
 	.set_page_dirty = aio_set_page_dirty,
+#if IS_ENABLED(CONFIG_MIGRATION)
 	.migratepage	= aio_migratepage,
+#endif
 };
 
 static int aio_setup_ring(struct kioctx *ctx)
-- 
1.8.2.1

