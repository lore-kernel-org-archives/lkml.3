Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753993Ab3CSJb4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Mar 2013 05:31:56 -0400
Received: from relay.parallels.com ([195.214.232.42]:55562 "EHLO
	relay.parallels.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750839Ab3CSJby (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Mar 2013 05:31:54 -0400
From: Vladimir Davydov <vdavydov@parallels.com>
To: Al Viro <viro@zeniv.linux.org.uk>
CC: <linux-kernel@vger.kernel.org>, <devel@openvz.org>,
        Doug Ledford <dledford@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>
Subject: [PATCH] mqueue: sys_mq_open: do not call mnt_drop_write() if read-only
Date: Tue, 19 Mar 2013 13:31:18 +0400
Message-ID: <1363685478-9997-1-git-send-email-vdavydov@parallels.com>
X-Mailer: git-send-email 1.7.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.30.22.158]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

mnt_drop_write() must be called only if mnt_want_write() succeeded,
otherwise the mnt_writers counter will diverge.

Signed-off-by: Vladimir Davydov <vdavydov@parallels.com>
Cc: Doug Ledford <dledford@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>
---
 ipc/mqueue.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/ipc/mqueue.c b/ipc/mqueue.c
index e5c4f60..3953fda 100644
--- a/ipc/mqueue.c
+++ b/ipc/mqueue.c
@@ -840,7 +840,8 @@ out_putfd:
 		fd = error;
 	}
 	mutex_unlock(&root->d_inode->i_mutex);
-	mnt_drop_write(mnt);
+	if (!ro)
+		mnt_drop_write(mnt);
 out_putname:
 	putname(name);
 	return fd;
-- 
1.7.1

