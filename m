Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752221AbaIGDFg (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Sep 2014 23:05:36 -0400
Received: from mga02.intel.com ([134.134.136.20]:52838 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752082AbaIGDFe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Sep 2014 23:05:34 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,480,1406617200"; 
   d="scan'208";a="599128698"
From: Huang Ying <ying.huang@intel.com>
To: Jaegeuk Kim <jaegeuk@kernel.org>, Changman Lee <cm224.lee@samsung.com>
Cc: linux-f2fs-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org,
        Huang Ying <ying.huang@intel.com>
Subject: [PATCH] f2fs: Avoid node page to be written twice in gc_node_segment
Date: Sun,  7 Sep 2014 11:05:20 +0800
Message-Id: <1410059120-9096-1-git-send-email-ying.huang@intel.com>
X-Mailer: git-send-email 2.0.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In gc_node_segment, if node page gc is run concurrently with node page
writeback, and check_valid_map and get_node_page run after page locked
and before cur_valid_map is updated as below, it is possible for the
page to be written twice unnecessarily.

			sync_node_pages
			  try_lock_page
			  ...
check_valid_map		  f2fs_write_node_page
			    ...
			    write_node_page
			      do_write_page
			        allocate_data_block
				  ...
				  refresh_sit_entry /* update cur_valid_map */
				  ...
			    ...
			    unlock_page
get_node_page
...
set_page_dirty
...
f2fs_put_page
  unlock_page

This can be solved via calling check_valid_map after get_node_page again.

Signed-off-by: Huang, Ying <ying.huang@intel.com>
---
 fs/f2fs/gc.c |    6 ++++++
 1 file changed, 6 insertions(+)

--- a/fs/f2fs/gc.c
+++ b/fs/f2fs/gc.c
@@ -421,6 +421,12 @@ next_step:
 		if (IS_ERR(node_page))
 			continue;
 
+		/* block may become invalid during get_node_page */
+		if (check_valid_map(sbi, segno, off) == 0) {
+			f2fs_put_page(node_page, 1);
+			continue;
+		}
+
 		/* set page dirty and write it */
 		if (gc_type == FG_GC) {
 			f2fs_wait_on_page_writeback(node_page, NODE);
