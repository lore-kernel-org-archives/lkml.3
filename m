Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966594AbaLLG5A (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Dec 2014 01:57:00 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:51764 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758719AbaLLGQy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Dec 2014 01:16:54 -0500
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org,
        "Trond Myklebust" <trond.myklebust@primarydata.com>,
        "J. Bruce Fields" <bfields@redhat.com>
Date: Fri, 12 Dec 2014 06:14:25 +0000
Message-ID: <lsq.1418364865.454774474@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [PATCH 3.2 143/164] nfsd: Fix slot wake up race in the nfsv4.1
 callback code
In-Reply-To: <lsq.1418364865.554543691@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:c97:8151:cc89:c28d
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.65-rc1 review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 fs/nfsd/nfs4callback.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

--- a/fs/nfsd/nfs4callback.c
+++ b/fs/nfsd/nfs4callback.c
@@ -785,8 +785,12 @@ static bool nfsd41_cb_get_slot(struct nf
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

