Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755470Ab3JBRi5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Oct 2013 13:38:57 -0400
Received: from relay.parallels.com ([195.214.232.42]:39836 "EHLO
	relay.parallels.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755034Ab3JBRiz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Oct 2013 13:38:55 -0400
Subject: [PATCH 4/4] fuse: writepages: protect secondary requests from fuse
 file release
To: miklos@szeredi.hu
From: Maxim Patlasov <MPatlasov@parallels.com>
Cc: fuse-devel@lists.sourceforge.net, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date: Wed, 02 Oct 2013 21:38:54 +0400
Message-ID: <20131002173848.31188.77211.stgit@dhcp-10-30-17-2.sw.ru>
In-Reply-To: <20131002173701.31188.33547.stgit@dhcp-10-30-17-2.sw.ru>
References: <20131002173701.31188.33547.stgit@dhcp-10-30-17-2.sw.ru>
User-Agent: StGit/0.16
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

All async fuse requests must be supplied with extra reference to a fuse file.
This is necessary to ensure that the fuse file is not released until all
in-flight requests are completed. Fuse secondary writeback requests must
obey this rule as well.

Signed-off-by: Maxim Patlasov <MPatlasov@parallels.com>
---
 fs/fuse/file.c |    1 +
 1 file changed, 1 insertion(+)

diff --git a/fs/fuse/file.c b/fs/fuse/file.c
index 5d323bd..266a792 100644
--- a/fs/fuse/file.c
+++ b/fs/fuse/file.c
@@ -1521,6 +1521,7 @@ static void fuse_writepage_end(struct fuse_conn *fc, struct fuse_req *req)
 			continue;
 		}
 
+		next->ff = fuse_file_get(req->ff);
 		list_add(&next->writepages_entry, &fi->writepages);
 		list_add_tail(&next->list, &fi->queued_writes);
 		fuse_flush_writepages(inode);

