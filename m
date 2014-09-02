Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753054AbaIBIBe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Sep 2014 04:01:34 -0400
Received: from mailhub.sw.ru ([195.214.232.25]:35768 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751109AbaIBIBc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Sep 2014 04:01:32 -0400
From: Andrey Vagin <avagin@openvz.org>
To: linux-kernel@vger.kernel.org
Cc: Andrey Vagin <avagin@openvz.org>, Cyrill Gorcunov <gorcunov@openvz.org>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 2/2] fs/notify: don't show f_handle if exportfs_encode_inode_fh failed
Date: Tue,  2 Sep 2014 12:00:15 +0400
Message-Id: <1409644815-19367-2-git-send-email-avagin@openvz.org>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1409644815-19367-1-git-send-email-avagin@openvz.org>
References: <1409644815-19367-1-git-send-email-avagin@openvz.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently we handle only ENOSPC. In case of other errors the file_handle
variable isn't filled properly and we will show a part of stack.

Cc: Cyrill Gorcunov <gorcunov@openvz.org>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Andrey Vagin <avagin@openvz.org>
---
 fs/notify/fdinfo.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/notify/fdinfo.c b/fs/notify/fdinfo.c
index 660d33b..9d7e2b9 100644
--- a/fs/notify/fdinfo.c
+++ b/fs/notify/fdinfo.c
@@ -50,7 +50,7 @@ static int show_mark_fhandle(struct seq_file *m, struct inode *inode)
 	size = f.handle.handle_bytes >> 2;
 
 	ret = exportfs_encode_inode_fh(inode, (struct fid *)f.handle.f_handle, &size, 0);
-	if ((ret == FILEID_INVALID) || (ret == -ENOSPC)) {
+	if ((ret == FILEID_INVALID) || (ret < 0)) {
 		WARN_ONCE(1, "Can't encode file handler for inotify: %d\n", ret);
 		return 0;
 	}
-- 
1.9.3

