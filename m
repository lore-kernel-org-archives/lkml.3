Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753070AbaLFPXa (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Dec 2014 10:23:30 -0500
Received: from ip4-83-240-67-251.cust.nbox.cz ([83.240.67.251]:47706 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752069AbaLFPIE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Dec 2014 10:08:04 -0500
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
        Trond Myklebust <trond.myklebust@primarydata.com>,
        "J. Bruce Fields" <bfields@redhat.com>, Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 59/66] nfsd: Fix slot wake up race in the nfsv4.1 callback code
Date: Sat,  6 Dec 2014 16:07:51 +0100
Message-Id: <55c8dd290be7ca4e64432b837d774314add709c0.1417878427.git.jslaby@suse.cz>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <d278ba6471641f99eda3b3c76f8414339c9dbed0.1417878427.git.jslaby@suse.cz>
References: <d278ba6471641f99eda3b3c76f8414339c9dbed0.1417878427.git.jslaby@suse.cz>
In-Reply-To: <cover.1417878427.git.jslaby@suse.cz>
References: <cover.1417878427.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Trond Myklebust <trond.myklebust@primarydata.com>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

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
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 fs/nfsd/nfs4callback.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/fs/nfsd/nfs4callback.c b/fs/nfsd/nfs4callback.c
index cc8c5b32043c..f42bbe5fbc0a 100644
--- a/fs/nfsd/nfs4callback.c
+++ b/fs/nfsd/nfs4callback.c
@@ -784,8 +784,12 @@ static bool nfsd41_cb_get_slot(struct nfs4_client *clp, struct rpc_task *task)
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

