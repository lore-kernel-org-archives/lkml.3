Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761017AbbA1EQ6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jan 2015 23:16:58 -0500
Received: from mail.kernel.org ([198.145.29.136]:37900 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760988AbbA1EQz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jan 2015 23:16:55 -0500
From: lizf@kernel.org
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Andy Adamson <andros@netapp.com>,
        Trond Myklebust <trond.myklebust@primarydata.com>,
        Zefan Li <lizefan@huawei.com>
Subject: [PATCH 3.4 038/177] NFSv4.1: Fix an NFSv4.1 state renewal regression
Date: Wed, 28 Jan 2015 12:07:22 +0800
Message-Id: <1422418236-12852-75-git-send-email-lizf@kernel.org>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1422418050-12581-1-git-send-email-lizf@kernel.org>
References: <1422418050-12581-1-git-send-email-lizf@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andy Adamson <andros@netapp.com>

3.4.106-rc1 review patch.  If anyone has any objections, please let me know.

------------------


commit d1f456b0b9545f1606a54cd17c20775f159bd2ce upstream.

Commit 2f60ea6b8ced ("NFSv4: The NFSv4.0 client must send RENEW calls if it holds a delegation") set the NFS4_RENEW_TIMEOUT flag in nfs4_renew_state, and does
not put an nfs41_proc_async_sequence call, the NFSv4.1 lease renewal heartbeat
call, on the wire to renew the NFSv4.1 state if the flag was not set.

The NFS4_RENEW_TIMEOUT flag is set when "now" is after the last renewal
(cl_last_renewal) plus the lease time divided by 3. This is arbitrary and
sometimes does the following:

In normal operation, the only way a future state renewal call is put on the
wire is via a call to nfs4_schedule_state_renewal, which schedules a
nfs4_renew_state workqueue task. nfs4_renew_state determines if the
NFS4_RENEW_TIMEOUT should be set, and the calls nfs41_proc_async_sequence,
which only gets sent if the NFS4_RENEW_TIMEOUT flag is set.
Then the nfs41_proc_async_sequence rpc_release function schedules
another state remewal via nfs4_schedule_state_renewal.

Without this change we can get into a state where an application stops
accessing the NFSv4.1 share, state renewal calls stop due to the
NFS4_RENEW_TIMEOUT flag _not_ being set. The only way to recover
from this situation is with a clientid re-establishment, once the application
resumes and the server has timed out the lease and so returns
NFS4ERR_BAD_SESSION on the subsequent SEQUENCE operation.

An example application:
open, lock, write a file.

sleep for 6 * lease (could be less)

ulock, close.

In the above example with NFSv4.1 delegations enabled, without this change,
there are no OP_SEQUENCE state renewal calls during the sleep, and the
clientid is recovered due to lease expiration on the close.

This issue does not occur with NFSv4.1 delegations disabled, nor with
NFSv4.0, with or without delegations enabled.

Signed-off-by: Andy Adamson <andros@netapp.com>
Link: http://lkml.kernel.org/r/1411486536-23401-1-git-send-email-andros@netapp.com
Fixes: 2f60ea6b8ced (NFSv4: The NFSv4.0 client must send RENEW calls...)
Signed-off-by: Trond Myklebust <trond.myklebust@primarydata.com>
[lizf: Backported to 3.4: adjust context]
Signed-off-by: Zefan Li <lizefan@huawei.com>
---
 fs/nfs/nfs4proc.c   |  2 +-
 fs/nfs/nfs4renewd.c | 12 ++++++++++--
 2 files changed, 11 insertions(+), 3 deletions(-)

diff --git a/fs/nfs/nfs4proc.c b/fs/nfs/nfs4proc.c
index 527a4fc..37ab4e1 100644
--- a/fs/nfs/nfs4proc.c
+++ b/fs/nfs/nfs4proc.c
@@ -5796,7 +5796,7 @@ static int nfs41_proc_async_sequence(struct nfs_client *clp, struct rpc_cred *cr
 	int ret = 0;
 
 	if ((renew_flags & NFS4_RENEW_TIMEOUT) == 0)
-		return 0;
+		return -EAGAIN;
 	task = _nfs41_proc_sequence(clp, cred, &nfs41_sequence_ops);
 	if (IS_ERR(task))
 		ret = PTR_ERR(task);
diff --git a/fs/nfs/nfs4renewd.c b/fs/nfs/nfs4renewd.c
index dc484c0..78071cf9 100644
--- a/fs/nfs/nfs4renewd.c
+++ b/fs/nfs/nfs4renewd.c
@@ -88,10 +88,18 @@ nfs4_renew_state(struct work_struct *work)
 			}
 			nfs_expire_all_delegations(clp);
 		} else {
+			int ret;
+
 			/* Queue an asynchronous RENEW. */
-			ops->sched_state_renewal(clp, cred, renew_flags);
+			ret = ops->sched_state_renewal(clp, cred, renew_flags);
 			put_rpccred(cred);
-			goto out_exp;
+			switch (ret) {
+			default:
+				goto out_exp;
+			case -EAGAIN:
+			case -ENOMEM:
+				break;
+			}
 		}
 	} else {
 		dprintk("%s: failed to call renewd. Reason: lease not expired \n",
-- 
1.9.1

