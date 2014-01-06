Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756650AbaAFWiJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jan 2014 17:38:09 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:47316 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756381AbaAFWiC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jan 2014 17:38:02 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Milosz Tanski <milosz@adfin.com>, Sage Weil <sage@inktank.com>
Subject: [PATCH 3.12 002/144] ceph: hung on ceph fscache invalidate in some cases
Date: Mon,  6 Jan 2014 14:36:03 -0800
Message-Id: <20140106223745.399441955@linuxfoundation.org>
X-Mailer: git-send-email 1.8.5.1.163.gd7aced9
In-Reply-To: <20140106223745.326293132@linuxfoundation.org>
References: <20140106223745.326293132@linuxfoundation.org>
User-Agent: quilt/0.61-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Milosz Tanski <milosz@adfin.com>

commit ffc79664d15841025d90afdd902c4112ffe168d6 upstream.

In some cases I'm on my ceph client cluster I'm seeing hunk kernel tasks in
the invalidate page code path. This is due to the fact that we don't check if
the page is marked as cache before calling fscache_wait_on_page_write().

This is the log from the hang

INFO: task XXXXXX:12034 blocked for more than 120 seconds.
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
 ...
Call Trace:
[<ffffffff81568d09>] schedule+0x29/0x70
[<ffffffffa01d4cbd>] __fscache_wait_on_page_write+0x6d/0xb0 [fscache]
[<ffffffff81083520>] ? add_wait_queue+0x60/0x60
[<ffffffffa029a3e9>] ceph_invalidate_fscache_page+0x29/0x50 [ceph]
[<ffffffffa027df00>] ceph_invalidatepage+0x70/0x190 [ceph]
[<ffffffff8112656f>] ? delete_from_page_cache+0x5f/0x70
[<ffffffff81133cab>] truncate_inode_page+0x8b/0x90
[<ffffffff81133ded>] truncate_inode_pages_range.part.12+0x13d/0x620
[<ffffffff8113431d>] truncate_inode_pages_range+0x4d/0x60
[<ffffffff811343b5>] truncate_inode_pages+0x15/0x20
[<ffffffff8119bbf6>] evict+0x1a6/0x1b0
[<ffffffff8119c3f3>] iput+0x103/0x190
 ...

Signed-off-by: Milosz Tanski <milosz@adfin.com>
Reviewed-by: Sage Weil <sage@inktank.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/ceph/cache.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/fs/ceph/cache.c
+++ b/fs/ceph/cache.c
@@ -324,6 +324,9 @@ void ceph_invalidate_fscache_page(struct
 {
 	struct ceph_inode_info *ci = ceph_inode(inode);
 
+	if (!PageFsCache(page))
+		return;
+
 	fscache_wait_on_page_write(ci->fscache, page);
 	fscache_uncache_page(ci->fscache, page);
 }


