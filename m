Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754099Ab3JBLCw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Oct 2013 07:02:52 -0400
Received: from relay.parallels.com ([195.214.232.42]:34650 "EHLO
	relay.parallels.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753331Ab3JBLCu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Oct 2013 07:02:50 -0400
Subject: [PATCH 4/5] fuse: writepage: update bdi writeout when deleting
 secondary request
To: miklos@szeredi.hu
From: Maxim Patlasov <MPatlasov@parallels.com>
Cc: fuse-devel@lists.sourceforge.net, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date: Wed, 02 Oct 2013 15:02:49 +0400
Message-ID: <20131002110239.26932.34194.stgit@dhcp-10-30-17-2.sw.ru>
In-Reply-To: <20131002105815.26932.46041.stgit@dhcp-10-30-17-2.sw.ru>
References: <20131002105815.26932.46041.stgit@dhcp-10-30-17-2.sw.ru>
User-Agent: StGit/0.16
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

BDI_WRITTEN counter is used to estimate bdi bandwidth. It must be incremented
every time as bdi ends page writeback. No matter whether it was fulfilled by
actual write or by discarding the request (due to shrunk i_size).

Note that even before writepages patches, the case "Got truncated off
completely" was handled in fuse_send_writepage() by calling
fuse_writepage_finish() which updated BDI_WRITTEN unconditionally.

Signed-off-by: Maxim Patlasov <MPatlasov@parallels.com>
---
 fs/fuse/file.c |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/fs/fuse/file.c b/fs/fuse/file.c
index 036fcf3..06d6099 100644
--- a/fs/fuse/file.c
+++ b/fs/fuse/file.c
@@ -1444,6 +1444,7 @@ static void fuse_drop_writepage(struct fuse_conn *fc, struct fuse_req *req)
 		struct fuse_req *next = req->misc.write.next;
 		dec_bdi_stat(bdi, BDI_WRITEBACK);
 		dec_zone_page_state(req->pages[0], NR_WRITEBACK_TEMP);
+		bdi_writeout_inc(bdi);
 		fuse_writepage_free(fc, req);
 		fuse_put_request(fc, req);
 		req = next;
@@ -1736,9 +1737,12 @@ static bool fuse_writepage_in_flight(struct fuse_req *new_req,
 
 	if (page_copied ||
 	    new_req->misc.write.in.offset >= fuse_req_end_pos(old_req)) {
+		struct backing_dev_info *bdi = page->mapping->backing_dev_info;
+
 		spin_unlock(&fc->lock);
-		dec_bdi_stat(page->mapping->backing_dev_info, BDI_WRITEBACK);
+		dec_bdi_stat(bdi, BDI_WRITEBACK);
 		dec_zone_page_state(page, NR_WRITEBACK_TEMP);
+		bdi_writeout_inc(bdi);
 		fuse_writepage_free(fc, new_req);
 		fuse_request_free(new_req);
 		goto out;

