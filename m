Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933059Ab3B1Ou7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Feb 2013 09:50:59 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:42504 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932999Ab3B1Ous (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Feb 2013 09:50:48 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Jan Kara <jack@suse.cz>, Mark Fasheh <mfasheh@suse.com>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Andrew Morton <akpm@linux-foundation.org>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 118/139] ocfs2: fix possible use-after-free with AIO
Date: Thu, 28 Feb 2013 14:44:28 +0000
Message-Id: <1362062689-2567-119-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1362062689-2567-1-git-send-email-luis.henriques@canonical.com>
References: <1362062689-2567-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.7 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jan Kara <jack@suse.cz>

commit 9b171e0c74ca0549d0610990a862dd895870f04a upstream.

Running AIO is pinning inode in memory using file reference. Once AIO
is completed using aio_complete(), file reference is put and inode can
be freed from memory. So we have to be sure that calling aio_complete()
is the last thing we do with the inode.

Signed-off-by: Jan Kara <jack@suse.cz>
Acked-by: Jeff Moyer <jmoyer@redhat.com>
Acked-by: Joel Becker <jlbec@evilplan.org>
Cc: Mark Fasheh <mfasheh@suse.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 fs/ocfs2/aops.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/ocfs2/aops.c b/fs/ocfs2/aops.c
index 6577432..340bd02 100644
--- a/fs/ocfs2/aops.c
+++ b/fs/ocfs2/aops.c
@@ -593,9 +593,9 @@ static void ocfs2_dio_end_io(struct kiocb *iocb,
 	level = ocfs2_iocb_rw_locked_level(iocb);
 	ocfs2_rw_unlock(inode, level);
 
+	inode_dio_done(inode);
 	if (is_async)
 		aio_complete(iocb, ret, 0);
-	inode_dio_done(inode);
 }
 
 /*
-- 
1.8.1.2

