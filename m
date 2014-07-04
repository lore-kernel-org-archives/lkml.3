Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760902AbaGDW4x (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jul 2014 18:56:53 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:57170 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030414AbaGDWRR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jul 2014 18:17:17 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Trond Myklebust <trond.myklebust@primarydata.com>
Subject: [PATCH 3.15 38/66] NFS: Use raw_write_seqcount_begin/end int nfs4_reclaim_open_state
Date: Fri,  4 Jul 2014 15:14:37 -0700
Message-Id: <20140704221424.551732478@linuxfoundation.org>
X-Mailer: git-send-email 2.0.1
In-Reply-To: <20140704221422.813435485@linuxfoundation.org>
References: <20140704221422.813435485@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Trond Myklebust <trond.myklebust@primarydata.com>

commit abbec2da13f0e4c5d9b78b7e2c025a3e617228ba upstream.

The addition of lockdep code to write_seqcount_begin/end has lead to
a bunch of false positive claims of ABBA deadlocks with the so_lock
spinlock. Audits show that this simply cannot happen because the
read side code does not spin while holding so_lock.

Signed-off-by: Trond Myklebust <trond.myklebust@primarydata.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/nfs/nfs4state.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/fs/nfs/nfs4state.c
+++ b/fs/nfs/nfs4state.c
@@ -1456,7 +1456,7 @@ static int nfs4_reclaim_open_state(struc
 	 * server that doesn't support a grace period.
 	 */
 	spin_lock(&sp->so_lock);
-	write_seqcount_begin(&sp->so_reclaim_seqcount);
+	raw_write_seqcount_begin(&sp->so_reclaim_seqcount);
 restart:
 	list_for_each_entry(state, &sp->so_states, open_states) {
 		if (!test_and_clear_bit(ops->state_flag_bit, &state->flags))
@@ -1519,13 +1519,13 @@ restart:
 		spin_lock(&sp->so_lock);
 		goto restart;
 	}
-	write_seqcount_end(&sp->so_reclaim_seqcount);
+	raw_write_seqcount_end(&sp->so_reclaim_seqcount);
 	spin_unlock(&sp->so_lock);
 	return 0;
 out_err:
 	nfs4_put_open_state(state);
 	spin_lock(&sp->so_lock);
-	write_seqcount_end(&sp->so_reclaim_seqcount);
+	raw_write_seqcount_end(&sp->so_reclaim_seqcount);
 	spin_unlock(&sp->so_lock);
 	return status;
 }


