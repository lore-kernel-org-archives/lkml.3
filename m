Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755529AbaBTXwJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Feb 2014 18:52:09 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:45702 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755504AbaBTXwF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Feb 2014 18:52:05 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Jan Stancek <jstancek@redhat.com>, Rafael Aquini <aquini@redhat.com>,
        Mel Gorman <mgorman@suse.de>, Rik van Riel <riel@redhat.com>,
        Jeff Layton <jlayton@redhat.com>,
        Trond Myklebust <trond.myklebust@primarydata.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 3.12 04/82] mm: fix page leak at nfs_symlink()
Date: Thu, 20 Feb 2014 15:51:47 -0800
Message-Id: <20140220235019.617973834@linuxfoundation.org>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <20140220235019.483734207@linuxfoundation.org>
References: <20140220235019.483734207@linuxfoundation.org>
User-Agent: quilt/0.61-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.12-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/nfs/dir.c |    5 +++++
 1 file changed, 5 insertions(+)

--- a/fs/nfs/dir.c
+++ b/fs/nfs/dir.c
@@ -1852,6 +1852,11 @@ int nfs_symlink(struct inode *dir, struc
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
 


