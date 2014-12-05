Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754040AbaLEXH7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Dec 2014 18:07:59 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:54668 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754035AbaLEXGo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Dec 2014 18:06:44 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Trond Myklebust <trond.myklebust@primarydata.com>,
        "J. Bruce Fields" <bfields@redhat.com>
Subject: [PATCH 3.10 41/45] nfsd: Fix slot wake up race in the nfsv4.1 callback code
Date: Fri,  5 Dec 2014 14:45:24 -0800
Message-Id: <20141205223323.285097065@linuxfoundation.org>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <20141205223316.738290875@linuxfoundation.org>
References: <20141205223316.738290875@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/nfsd/nfs4callback.c |    8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

--- a/fs/nfsd/nfs4callback.c
+++ b/fs/nfsd/nfs4callback.c
@@ -784,8 +784,12 @@ static bool nfsd41_cb_get_slot(struct nf
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


