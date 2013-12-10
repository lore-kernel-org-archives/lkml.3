Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753772Ab3LJICJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Dec 2013 03:02:09 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:58920 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753595Ab3LJICB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Dec 2013 03:02:01 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Trond Myklebust <Trond.Myklebust@netapp.com>
Subject: [PATCH 3.12 37/62] NFSv4: Update list of irrecoverable errors on DELEGRETURN
Date: Tue, 10 Dec 2013 00:01:08 -0800
Message-Id: <20131210080100.047952024@linuxfoundation.org>
X-Mailer: git-send-email 1.8.5.rc3
In-Reply-To: <20131210080057.415644748@linuxfoundation.org>
References: <20131210080057.415644748@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Trond Myklebust <Trond.Myklebust@netapp.com>

commit c97cf606e43b85a6cf158b810375dd77312024db upstream.

If the DELEGRETURN errors out with something like NFS4ERR_BAD_STATEID
then there is no recovery possible. Just quit without returning an error.

Also, note that the client must not assume that the NFSv4 lease has been
renewed when it sees an error on DELEGRETURN.

Signed-off-by: Trond Myklebust <Trond.Myklebust@netapp.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/nfs/nfs4proc.c |   10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

--- a/fs/nfs/nfs4proc.c
+++ b/fs/nfs/nfs4proc.c
@@ -4938,11 +4938,17 @@ static void nfs4_delegreturn_done(struct
 
 	trace_nfs4_delegreturn_exit(&data->args, &data->res, task->tk_status);
 	switch (task->tk_status) {
-	case -NFS4ERR_STALE_STATEID:
-	case -NFS4ERR_EXPIRED:
 	case 0:
 		renew_lease(data->res.server, data->timestamp);
 		break;
+	case -NFS4ERR_ADMIN_REVOKED:
+	case -NFS4ERR_DELEG_REVOKED:
+	case -NFS4ERR_BAD_STATEID:
+	case -NFS4ERR_OLD_STATEID:
+	case -NFS4ERR_STALE_STATEID:
+	case -NFS4ERR_EXPIRED:
+		task->tk_status = 0;
+		break;
 	default:
 		if (nfs4_async_handle_error(task, data->res.server, NULL) ==
 				-EAGAIN) {


