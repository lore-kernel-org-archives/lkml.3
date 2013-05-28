Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757772Ab3E1VWy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 May 2013 17:22:54 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:59536 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757034Ab3E1VVW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 May 2013 17:21:22 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Trond Myklebust <Trond.Myklebust@netapp.com>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 03/78] NFSv4: Handle NFS4ERR_DELAY and NFS4ERR_GRACE in nfs4_lock_delegation_recall
Date: Tue, 28 May 2013 14:19:12 -0700
Message-Id: <1369776027-17859-4-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1369776027-17859-1-git-send-email-kamal@canonical.com>
References: <1369776027-17859-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.1 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Trond Myklebust <Trond.Myklebust@netapp.com>

commit dbb21c25a35a71baf413f5176f028ee11b88cfbc upstream.

A server shouldn't normally return NFS4ERR_GRACE if the client holds a
delegation, since no conflicting lock reclaims can be granted, however
the spec does not require the server to grant the lock in this
instance.

Signed-off-by: Trond Myklebust <Trond.Myklebust@netapp.com>
[ kamal: backport to 3.8 ]
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 fs/nfs/nfs4proc.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/fs/nfs/nfs4proc.c b/fs/nfs/nfs4proc.c
index e3c6121..a404dae 100644
--- a/fs/nfs/nfs4proc.c
+++ b/fs/nfs/nfs4proc.c
@@ -4984,13 +4984,17 @@ int nfs4_lock_delegation_recall(struct nfs4_state *state, struct file_lock *fl)
 				nfs4_schedule_stateid_recovery(server, state);
 				err = 0;
 				goto out;
+			case -NFS4ERR_DELAY:
+			case -NFS4ERR_GRACE:
+				set_bit(NFS_DELEGATED_STATE, &state->flags);
+				ssleep(1);
+				err = -EAGAIN;
+				goto out;
 			case -ENOMEM:
 			case -NFS4ERR_DENIED:
 				/* kill_proc(fl->fl_pid, SIGLOST, 1); */
 				err = 0;
 				goto out;
-			case -NFS4ERR_DELAY:
-				break;
 		}
 		err = nfs4_handle_exception(server, err, &exception);
 	} while (exception.retry);
-- 
1.8.1.2

