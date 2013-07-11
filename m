Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932233Ab3GKWCF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Jul 2013 18:02:05 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:43096 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756622Ab3GKWBu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Jul 2013 18:01:50 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Andy Adamson <andros@netapp.com>,
        Trond Myklebust <Trond.Myklebust@netapp.com>
Subject: [ 14/19] NFSv4.1 end back channel session draining
Date: Thu, 11 Jul 2013 15:01:31 -0700
Message-Id: <20130711214832.250774896@linuxfoundation.org>
X-Mailer: git-send-email 1.8.3.rc0.20.gb99dd2e
In-Reply-To: <20130711214830.611455274@linuxfoundation.org>
References: <20130711214830.611455274@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Andy Adamson <andros@netapp.com>

commit 62f288a02f97bd9f6b2361a6fff709729fe9e110 upstream.

We need to ensure that we clear NFS4_SLOT_TBL_DRAINING on the back
channel when we're done recovering the session.

Regression introduced by commit 774d5f14e (NFSv4.1 Fix a pNFS session
draining deadlock)

Signed-off-by: Andy Adamson <andros@netapp.com>
[Trond: Changed order to start back-channel first. Minor code cleanup]
Signed-off-by: Trond Myklebust <Trond.Myklebust@netapp.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/nfs/nfs4state.c |   23 +++++++++++------------
 1 file changed, 11 insertions(+), 12 deletions(-)

--- a/fs/nfs/nfs4state.c
+++ b/fs/nfs/nfs4state.c
@@ -228,19 +228,8 @@ static int nfs41_setup_state_renewal(str
 	return status;
 }
 
-/*
- * Back channel returns NFS4ERR_DELAY for new requests when
- * NFS4_SESSION_DRAINING is set so there is no work to be done when draining
- * is ended.
- */
-static void nfs4_end_drain_session(struct nfs_client *clp)
+static void nfs4_end_drain_slot_table(struct nfs4_slot_table *tbl)
 {
-	struct nfs4_session *ses = clp->cl_session;
-	struct nfs4_slot_table *tbl;
-
-	if (ses == NULL)
-		return;
-	tbl = &ses->fc_slot_table;
 	if (test_and_clear_bit(NFS4_SLOT_TBL_DRAINING, &tbl->slot_tbl_state)) {
 		spin_lock(&tbl->slot_tbl_lock);
 		nfs41_wake_slot_table(tbl);
@@ -248,6 +237,16 @@ static void nfs4_end_drain_session(struc
 	}
 }
 
+static void nfs4_end_drain_session(struct nfs_client *clp)
+{
+	struct nfs4_session *ses = clp->cl_session;
+
+	if (ses != NULL) {
+		nfs4_end_drain_slot_table(&ses->bc_slot_table);
+		nfs4_end_drain_slot_table(&ses->fc_slot_table);
+	}
+}
+
 /*
  * Signal state manager thread if session fore channel is drained
  */


