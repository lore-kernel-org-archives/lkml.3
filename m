Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755334Ab3JBRiq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Oct 2013 13:38:46 -0400
Received: from relay.parallels.com ([195.214.232.42]:39824 "EHLO
	relay.parallels.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754838Ab3JBRio (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Oct 2013 13:38:44 -0400
Subject: [PATCH 3/4] fuse: writepage: update bdi writeout when deleting
 secondary request
To: miklos@szeredi.hu
From: Maxim Patlasov <MPatlasov@parallels.com>
Cc: fuse-devel@lists.sourceforge.net, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date: Wed, 02 Oct 2013 21:38:43 +0400
Message-ID: <20131002173837.31188.34247.stgit@dhcp-10-30-17-2.sw.ru>
In-Reply-To: <20131002173701.31188.33547.stgit@dhcp-10-30-17-2.sw.ru>
References: <20131002173701.31188.33547.stgit@dhcp-10-30-17-2.sw.ru>
User-Agent: StGit/0.16
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

BDI_WRITTEN counter is used to estimate bdi bandwidth. It must be incremented
every time as bdi ends page writeback. No matter whether it was fulfilled by
actual write or by discarding the request (e.g. due to shrunk i_size).

Note that even before writepages patches, the case "Got truncated off
completely" was handled in fuse_send_writepage() by calling
fuse_writepage_finish() which updated BDI_WRITTEN unconditionally.

Signed-off-by: Maxim Patlasov <MPatlasov@parallels.com>
---
 fs/fuse/file.c |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/fs/fuse/file.c b/fs/fuse/file.c
index a3c7123..5d323bd 100644
--- a/fs/fuse/file.c
+++ b/fs/fuse/file.c
@@ -1536,6 +1536,7 @@ static void fuse_writepage_end(struct fuse_conn *fc, struct fuse_req *req)
 			drop->inode->i_mapping->backing_dev_info;
 		dec_bdi_stat(bdi, BDI_WRITEBACK);
 		dec_zone_page_state(drop->pages[0], NR_WRITEBACK_TEMP);
+		bdi_writeout_inc(bdi);
 		fuse_writepage_free(fc, drop);
 		fuse_put_request(fc, drop);
 		drop = next;
@@ -1706,11 +1707,14 @@ static bool fuse_writepage_in_flight(struct fuse_req *new_req,
 
 	if (old_req->num_pages == 1 && (old_req->state == FUSE_REQ_INIT ||
 					old_req->state == FUSE_REQ_PENDING)) {
+		struct backing_dev_info *bdi = page->mapping->backing_dev_info;
+
 		copy_highpage(old_req->pages[0], page);
 		spin_unlock(&fc->lock);
 
-		dec_bdi_stat(page->mapping->backing_dev_info, BDI_WRITEBACK);
+		dec_bdi_stat(bdi, BDI_WRITEBACK);
 		dec_zone_page_state(page, NR_WRITEBACK_TEMP);
+		bdi_writeout_inc(bdi);
 		fuse_writepage_free(fc, new_req);
 		fuse_request_free(new_req);
 		goto out;

