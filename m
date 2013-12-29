Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755671Ab3L2Ca3 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Dec 2013 21:30:29 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:55483 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752990Ab3L2CKu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Dec 2013 21:10:50 -0500
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org, "Trond Myklebust" <Trond.Myklebust@netapp.com>
Date: Sun, 29 Dec 2013 03:08:43 +0100
Message-ID: <lsq.1388282923.932615930@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [PATCH 3.2 078/185] NFSv4: Update list of irrecoverable errors on
 DELEGRETURN
In-Reply-To: <lsq.1388282923.751256928@decadent.org.uk>
X-SA-Exim-Connect-IP: 31.18.200.85
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.54-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Trond Myklebust <Trond.Myklebust@netapp.com>

commit c97cf606e43b85a6cf158b810375dd77312024db upstream.

If the DELEGRETURN errors out with something like NFS4ERR_BAD_STATEID
then there is no recovery possible. Just quit without returning an error.

Also, note that the client must not assume that the NFSv4 lease has been
renewed when it sees an error on DELEGRETURN.

Signed-off-by: Trond Myklebust <Trond.Myklebust@netapp.com>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 fs/nfs/nfs4proc.c | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

--- a/fs/nfs/nfs4proc.c
+++ b/fs/nfs/nfs4proc.c
@@ -3886,11 +3886,17 @@ static void nfs4_delegreturn_done(struct
 		return;
 
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

