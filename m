Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933419Ab3CUOEQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Mar 2013 10:04:16 -0400
Received: from relay.parallels.com ([195.214.232.42]:38978 "EHLO
	relay.parallels.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933352Ab3CUOEO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Mar 2013 10:04:14 -0400
Subject: [PATCH 3/4] fuse: skip blocking on allocations of synchronous requests
To: miklos@szeredi.hu
From: "Maxim V. Patlasov" <MPatlasov@parallels.com>
Cc: fuse-devel@lists.sourceforge.net, xemul@parallels.com,
        linux-kernel@vger.kernel.org, devel@openvz.org, dev@parallels.com
Date: Thu, 21 Mar 2013 18:02:28 +0400
Message-ID: <20130321140220.4051.16728.stgit@maximpc.sw.ru>
In-Reply-To: <20130321140047.4051.6701.stgit@maximpc.sw.ru>
References: <20130321140047.4051.6701.stgit@maximpc.sw.ru>
User-Agent: StGit/0.15
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Miklos wrote:

> A task may have at most one synchronous request allocated. So these
> requests need not be otherwise limited.

The patch re-works fuse_get_req() to follow this idea.

Signed-off-by: Maxim Patlasov <mpatlasov@parallels.com>
---
 fs/fuse/dev.c |   26 ++++++++++++++++++--------
 1 files changed, 18 insertions(+), 8 deletions(-)

diff --git a/fs/fuse/dev.c b/fs/fuse/dev.c
index 6137650..1f7ce89 100644
--- a/fs/fuse/dev.c
+++ b/fs/fuse/dev.c
@@ -137,17 +137,27 @@ struct fuse_req *fuse_get_req_internal(struct fuse_conn *fc, unsigned npages,
 				       bool for_background)
 {
 	struct fuse_req *req;
-	sigset_t oldset;
-	int intr;
 	int err;
+	int *flag_p = NULL;
 
 	atomic_inc(&fc->num_waiting);
-	block_sigs(&oldset);
-	intr = wait_event_interruptible(fc->blocked_waitq, !fc->blocked);
-	restore_sigs(&oldset);
-	err = -EINTR;
-	if (intr)
-		goto out;
+
+	if (for_background)
+		flag_p = &fc->blocked;
+	else if (fc->uninitialized)
+		flag_p = &fc->uninitialized;
+
+	if (flag_p) {
+		sigset_t oldset;
+		int intr;
+
+		block_sigs(&oldset);
+		intr = wait_event_interruptible(fc->blocked_waitq, !*flag_p);
+		restore_sigs(&oldset);
+		err = -EINTR;
+		if (intr)
+			goto out;
+	}
 
 	err = -ENOTCONN;
 	if (!fc->connected)

