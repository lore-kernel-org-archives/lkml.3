Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752654AbaLOOxL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Dec 2014 09:53:11 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:38642 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752788AbaLOO2T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Dec 2014 09:28:19 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Trond Myklebust <trond.myklebust@primarydata.com>,
        "J. Bruce Fields" <bfields@redhat.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.16.y-ckt 089/168] nfsd: Fix slot wake up race in the nfsv4.1 callback code
Date: Mon, 15 Dec 2014 14:25:43 +0000
Message-Id: <1418653622-21105-90-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <1418653622-21105-1-git-send-email-luis.henriques@canonical.com>
References: <1418653622-21105-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.16
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.16.7-ckt3 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Trond Myklebust <trond.myklebust@primarydata.com>

commit c6c15e1ed303ffc47e696ea1c9a9df1761c1f603 upstream.

The currect code for nfsd41_cb_get_slot() and nfsd4_cb_done() has no
locking in order to guarantee atomicity, and so allows for races of
the form.

Task 1                                  Task 2
======                                  ======
if (test_and_set_bit(0) != 0) {
                                        clear_bit(0)
                                        rpc_wake_up_next(queue)
        rpc_sleep_on(queue)
        return false;
}

This patch breaks the race condition by adding a retest of the bit
after the call to rpc_sleep_on().

Signed-off-by: Trond Myklebust <trond.myklebust@primarydata.com>
Signed-off-by: J. Bruce Fields <bfields@redhat.com>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 fs/nfsd/nfs4callback.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/fs/nfsd/nfs4callback.c b/fs/nfsd/nfs4callback.c
index 0f23ad005826..510a99115bb7 100644
--- a/fs/nfsd/nfs4callback.c
+++ b/fs/nfsd/nfs4callback.c
@@ -801,8 +801,12 @@ static bool nfsd41_cb_get_slot(struct nfs4_client *clp, struct rpc_task *task)
 {
 	if (test_and_set_bit(0, &clp->cl_cb_slot_busy) != 0) {
 		rpc_sleep_on(&clp->cl_cb_waitq, task, NULL);
-		dprintk("%s slot is busy\n", __func__);
-		return false;
+		/* Race breaker */
+		if (test_and_set_bit(0, &clp->cl_cb_slot_busy) != 0) {
+			dprintk("%s slot is busy\n", __func__);
+			return false;
+		}
+		rpc_wake_up_queued_task(&clp->cl_cb_waitq, task);
 	}
 	return true;
 }
-- 
2.1.3

