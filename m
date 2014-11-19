Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757036AbaKSVhx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Nov 2014 16:37:53 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:57283 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933270AbaKSVOg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Nov 2014 16:14:36 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Miklos Szeredi <mszeredi@suse.cz>, Paul Moore <pmoore@redhat.com>
Subject: [PATCH 3.10 14/70] audit: keep inode pinned
Date: Wed, 19 Nov 2014 12:52:05 -0800
Message-Id: <20141119205211.388444721@linuxfoundation.org>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <20141119205210.913169042@linuxfoundation.org>
References: <20141119205210.913169042@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Miklos Szeredi <mszeredi@suse.cz>

commit 799b601451b21ebe7af0e6e8f6e2ccd4683c5064 upstream.

Audit rules disappear when an inode they watch is evicted from the cache.
This is likely not what we want.

The guilty commit is "fsnotify: allow marks to not pin inodes in core",
which didn't take into account that audit_tree adds watches with a zero
mask.

Adding any mask should fix this.

Fixes: 90b1e7a57880 ("fsnotify: allow marks to not pin inodes in core")
Signed-off-by: Miklos Szeredi <mszeredi@suse.cz>
Signed-off-by: Paul Moore <pmoore@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

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
 


