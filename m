Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759349Ab3DAKm3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Apr 2013 06:42:29 -0400
Received: from relay.parallels.com ([195.214.232.42]:55310 "EHLO
	relay.parallels.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757783Ab3DAKm1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Apr 2013 06:42:27 -0400
Subject: [PATCH 14/14] mm: Account for WRITEBACK_TEMP in balance_dirty_pages
To: miklos@szeredi.hu
From: "Maxim V. Patlasov" <MPatlasov@parallels.com>
Cc: dev@parallels.com, xemul@parallels.com, fuse-devel@lists.sourceforge.net,
        linux-kernel@vger.kernel.org, jbottomley@parallels.com,
        viro@zeniv.linux.org.uk, linux-fsdevel@vger.kernel.org,
        devel@openvz.org
Date: Mon, 01 Apr 2013 14:42:56 +0400
Message-ID: <20130401104250.19027.27795.stgit@maximpc.sw.ru>
In-Reply-To: <20130401103749.19027.89833.stgit@maximpc.sw.ru>
References: <20130401103749.19027.89833.stgit@maximpc.sw.ru>
User-Agent: StGit/0.15
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Make balance_dirty_pages start the throttling when the WRITEBACK_TEMP
counter is high enough. This prevents us from having too many dirty
pages on fuse, thus giving the userspace part of it a chance to write
stuff properly.

Note, that the existing balance logic is per-bdi, i.e. if the fuse
user task gets stuck in the function this means, that it either
writes to the mountpoint it serves (but it can deadlock even without
the writeback) or it is writing to some _other_ dirty bdi and in the
latter case someone else will free the memory for it.

Signed-off-by: Maxim Patlasov <MPatlasov@parallels.com>
Signed-off-by: Pavel Emelyanov <xemul@openvz.org>
---
 mm/page-writeback.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/mm/page-writeback.c b/mm/page-writeback.c
index 0713bfb..c47bcd4 100644
--- a/mm/page-writeback.c
+++ b/mm/page-writeback.c
@@ -1235,7 +1235,8 @@ static void balance_dirty_pages(struct address_space *mapping,
 		 */
 		nr_reclaimable = global_page_state(NR_FILE_DIRTY) +
 					global_page_state(NR_UNSTABLE_NFS);
-		nr_dirty = nr_reclaimable + global_page_state(NR_WRITEBACK);
+		nr_dirty = nr_reclaimable + global_page_state(NR_WRITEBACK) +
+			global_page_state(NR_WRITEBACK_TEMP);
 
 		global_dirty_limits(&background_thresh, &dirty_thresh);
 

