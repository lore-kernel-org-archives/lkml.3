Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932535AbaBUMvW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Feb 2014 07:51:22 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:47192 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932518AbaBUMvU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Feb 2014 07:51:20 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Jan Stancek <jstancek@redhat.com>, Rafael Aquini <aquini@redhat.com>,
        Jeff Layton <jlayton@redhat.com>,
        Trond Myklebust <trond.myklebust@primarydata.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 093/121] mm: fix page leak at nfs_symlink()
Date: Fri, 21 Feb 2014 12:48:37 +0000
Message-Id: <1392986945-9693-94-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <1392986945-9693-1-git-send-email-luis.henriques@canonical.com>
References: <1392986945-9693-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11.10.5 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Rafael Aquini <aquini@redhat.com>

commit a0b54adda3fe4b4cc6d28f2a9217cd35d1aa888c upstream.

Changes in commit a0b8cab3b9b2 ("mm: remove lru parameter from
__pagevec_lru_add and remove parts of pagevec API") have introduced a
call to add_to_page_cache_lru() which causes a leak in nfs_symlink() as
now the page gets an extra refcount that is not dropped.

Jan Stancek observed and reported the leak effect while running test8
from Connectathon Testsuite.  After several iterations over the test
case, which creates several symlinks on a NFS mountpoint, the test
system was quickly getting into an out-of-memory scenario.

This patch fixes the page leak by dropping that extra refcount
add_to_page_cache_lru() is grabbing.

Signed-off-by: Jan Stancek <jstancek@redhat.com>
Signed-off-by: Rafael Aquini <aquini@redhat.com>
Acked-by: Mel Gorman <mgorman@suse.de>
Acked-by: Rik van Riel <riel@redhat.com>
Cc: Jeff Layton <jlayton@redhat.com>
Cc: Trond Myklebust <trond.myklebust@primarydata.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 fs/nfs/dir.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/fs/nfs/dir.c b/fs/nfs/dir.c
index e474ca2b..7d9261a 100644
--- a/fs/nfs/dir.c
+++ b/fs/nfs/dir.c
@@ -1813,6 +1813,11 @@ int nfs_symlink(struct inode *dir, struct dentry *dentry, const char *symname)
 							GFP_KERNEL)) {
 		SetPageUptodate(page);
 		unlock_page(page);
+		/*
+		 * add_to_page_cache_lru() grabs an extra page refcount.
+		 * Drop it here to avoid leaking this page later.
+		 */
+		page_cache_release(page);
 	} else
 		__free_page(page);
 
-- 
1.9.0

