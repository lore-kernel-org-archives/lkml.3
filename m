Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754041Ab3JBLBM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Oct 2013 07:01:12 -0400
Received: from relay.parallels.com ([195.214.232.42]:34475 "EHLO
	relay.parallels.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753693Ab3JBLBI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Oct 2013 07:01:08 -0400
Subject: [PATCH 1/5] fuse: writepages: roll back changes if request not found
To: miklos@szeredi.hu
From: Maxim Patlasov <MPatlasov@parallels.com>
Cc: fuse-devel@lists.sourceforge.net, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date: Wed, 02 Oct 2013 15:01:07 +0400
Message-ID: <20131002110037.26932.60001.stgit@dhcp-10-30-17-2.sw.ru>
In-Reply-To: <20131002105815.26932.46041.stgit@dhcp-10-30-17-2.sw.ru>
References: <20131002105815.26932.46041.stgit@dhcp-10-30-17-2.sw.ru>
User-Agent: StGit/0.16
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

fuse_writepage_in_flight() returns false if it fails to find request with
given index in fi->writepages. Then the caller proceeds with populating
data->orig_pages[] and incrementing req->num_pages. Hence,
fuse_writepage_in_flight() must revert changes it made in request before
returning false.

Signed-off-by: Maxim Patlasov <MPatlasov@parallels.com>
---
 fs/fuse/file.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/fs/fuse/file.c b/fs/fuse/file.c
index 135360e..575e44f 100644
--- a/fs/fuse/file.c
+++ b/fs/fuse/file.c
@@ -1659,8 +1659,11 @@ static bool fuse_writepage_in_flight(struct fuse_req *new_req,
 			break;
 		}
 	}
-	if (!found)
+	if (!found) {
+		new_req->num_pages = 0;
+		list_add(&new_req->writepages_entry, &fi->writepages);
 		goto out_unlock;
+	}
 
 	for (tmp = old_req; tmp != NULL; tmp = tmp->misc.write.next) {
 		BUG_ON(tmp->inode != new_req->inode);

