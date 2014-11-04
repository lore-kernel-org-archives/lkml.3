Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751667AbaKDK10 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Nov 2014 05:27:26 -0500
Received: from mail-wi0-f174.google.com ([209.85.212.174]:61169 "EHLO
	mail-wi0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750758AbaKDK1W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Nov 2014 05:27:22 -0500
Date: Tue, 4 Nov 2014 11:27:12 +0100
From: Miklos Szeredi <miklos@szeredi.hu>
To: Eric Paris <eparis@redhat.com>, Al Viro <viro@zeniv.linux.org.uk>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [PATCH] audit_tree: keep inode pinned
Message-ID: <20141104102712.GA7088@tucsk.piliscsaba.szeredi.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Miklos Szeredi <mszeredi@suse.cz>

Audit rules disappear when an inode they watch is evicted from the cache.
This is likely not what we want.

The guilty commit is "fsnotify: allow marks to not pin inodes in core",
which didn't take into account that audit_tree adds watches with a zero
mask.

Adding any mask should fix this.

Fixes: 90b1e7a57880 ("fsnotify: allow marks to not pin inodes in core")
Signed-off-by: Miklos Szeredi <mszeredi@suse.cz>
Cc: stable@vger.kernel.org # 2.6.36+
---
 kernel/audit_tree.c |    1 +
 1 file changed, 1 insertion(+)

--- a/kernel/audit_tree.c
+++ b/kernel/audit_tree.c
@@ -154,6 +154,7 @@ static struct audit_chunk *alloc_chunk(i
 		chunk->owners[i].index = i;
 	}
 	fsnotify_init_mark(&chunk->mark, audit_tree_destroy_watch);
+	chunk->mark.mask = FS_IN_IGNORED;
 	return chunk;
 }
 
