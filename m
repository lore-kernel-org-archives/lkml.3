Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933090Ab3GKO1J (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Jul 2013 10:27:09 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:43227 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933052Ab3GKO07 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Jul 2013 10:26:59 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Stanislav Kinsbursky <skinsbursky@parallels.com>,
        Trond Myklebust <Trond.Myklebust@netapp.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 80/98] SUNRPC: PipeFS MOUNT notification optimization for dying clients
Date: Thu, 11 Jul 2013 15:24:50 +0100
Message-Id: <1373552708-15235-81-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1373552708-15235-1-git-send-email-luis.henriques@canonical.com>
References: <1373552708-15235-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.17 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Stanislav Kinsbursky <skinsbursky@parallels.com>

commit 4f6bb246f69443549fbbd0f2abaf863243cb35e9 upstream.

Not need to create pipes for dying client. So just skip them.

Note: we can safely dereference the client structure, because notification
caller is holding sn->pipefs_sb_lock.

Signed-off-by: Stanislav Kinsbursky <skinsbursky@parallels.com>
Signed-off-by: Trond Myklebust <Trond.Myklebust@netapp.com>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 net/sunrpc/clnt.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/net/sunrpc/clnt.c b/net/sunrpc/clnt.c
index 631a75d..e0fd6a7 100644
--- a/net/sunrpc/clnt.c
+++ b/net/sunrpc/clnt.c
@@ -179,6 +179,8 @@ static inline int rpc_clnt_skip_event(struct rpc_clnt *clnt, unsigned long event
 	if (((event == RPC_PIPEFS_MOUNT) && clnt->cl_dentry) ||
 	    ((event == RPC_PIPEFS_UMOUNT) && !clnt->cl_dentry))
 		return 1;
+	if ((event == RPC_PIPEFS_MOUNT) && atomic_read(&clnt->cl_count) == 0)
+		return 1;
 	return 0;
 }
 
-- 
1.8.1.2

