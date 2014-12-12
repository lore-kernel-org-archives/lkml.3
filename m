Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758778AbaLLGoc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Dec 2014 01:44:32 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:51813 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758975AbaLLGQz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Dec 2014 01:16:55 -0500
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org, "Paul Moore" <pmoore@redhat.com>,
        "Miklos Szeredi" <mszeredi@suse.cz>
Date: Fri, 12 Dec 2014 06:14:25 +0000
Message-ID: <lsq.1418364865.867196916@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [PATCH 3.2 124/164] audit: keep inode pinned
In-Reply-To: <lsq.1418364865.554543691@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:c97:8151:cc89:c28d
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.65-rc1 review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 kernel/audit_tree.c | 1 +
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
 

