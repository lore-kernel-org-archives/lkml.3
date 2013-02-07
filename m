Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758895Ab3BGQO0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Feb 2013 11:14:26 -0500
Received: from mail-da0-f48.google.com ([209.85.210.48]:56900 "EHLO
	mail-da0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756212Ab3BGQOL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Feb 2013 11:14:11 -0500
Date: Thu, 7 Feb 2013 08:14:04 -0800
From: Tejun Heo <tj@kernel.org>
To: Sedat Dilek <sedat.dilek@gmail.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, Al Viro <viro@zeniv.linux.org.uk>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH v2] ipc: convert to idr_alloc()
Message-ID: <20130207161404.GK2875@htj.dyndns.org>
References: <CA+icZUXzh1S2+ZQ8vvPFSN8jXS62kijbAP+83F0hG9emLQzpQw@mail.gmail.com>
 <CA+icZUWQuLe1banpd9qzuvUtSep0GiyQWpu=yjhSao_9qAgaUA@mail.gmail.com>
 <CA+icZUWNXpta6PhVCMvEjZVTgi0H0AC4Ou+ysG+b5PMEF6kxXQ@mail.gmail.com>
 <87ip644bqh.fsf@xmission.com>
 <CA+icZUX=2w-hj8SHy8AG-3gQbmN2XCwx_XCSuJ8Gmp=z0gri9w@mail.gmail.com>
 <CA+icZUV1rrR_8Wx6BFj5=gAATdt=j5wDFt6EPMRi=m7rWH94CQ@mail.gmail.com>
 <CA+icZUU23tENcnh=jH9FXk82X=8MUAJAYeZpfDOhnt3MWoLzhQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+icZUU23tENcnh=jH9FXk82X=8MUAJAYeZpfDOhnt3MWoLzhQ@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Convert to the much saner new idr interface.

The new interface doesn't directly translate to the way idr_pre_get()
was used around ipc_addid() as preloading disables preemption.  From
my cursory reading, it seems like we should be able to do all
allocation from ipc_addid(), so I moved it there.  Can you please
check whether this would be okay?  If this is wrong and ipc_addid()
should be allowed to be called from non-sleepable context, I'd suggest
allocating id itself in the outer functions and later install the
pointer using idr_replace().

Only compile tested.

v2: The v1 conversion of ipcget_public() was incorrect.  As
    idr_pre_get() returns 0 for -ENOMEM failure, @err should have been
    initialized to 1 not 0.  As the function doesn't do preloading
    itself anymore, there's no point in the error handling path.
    Simply remove the -ENOMEM path.

Signed-off-by: Tejun Heo <tj@kernel.org>
Reported-by: Sedat Dilek <sedat.dilek@gmail.com>
Cc: Stanislav Kinsbursky <skinsbursky@parallels.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: James Morris <jmorris@namei.org>
---
Yeah, I messed up the ipcget_public() conversion.  Can you please test
this one?

Thanks.

 ipc/util.c |   30 +++++++++---------------------
 1 file changed, 9 insertions(+), 21 deletions(-)

--- a/ipc/util.c
+++ b/ipc/util.c
@@ -252,7 +252,7 @@ int ipc_addid(struct ipc_ids* ids, struc
 {
 	kuid_t euid;
 	kgid_t egid;
-	int id, err;
+	int id;
 	int next_id = ids->next_id;
 
 	if (size > IPCMNI)
@@ -261,17 +261,21 @@ int ipc_addid(struct ipc_ids* ids, struc
 	if (ids->in_use >= size)
 		return -ENOSPC;
 
+	idr_preload(GFP_KERNEL);
+
 	spin_lock_init(&new->lock);
 	new->deleted = 0;
 	rcu_read_lock();
 	spin_lock(&new->lock);
 
-	err = idr_get_new_above(&ids->ipcs_idr, new,
-				(next_id < 0) ? 0 : ipcid_to_idx(next_id), &id);
-	if (err) {
+	id = idr_alloc(&ids->ipcs_idr, new,
+		       (next_id < 0) ? 0 : ipcid_to_idx(next_id), 0,
+		       GFP_NOWAIT);
+	idr_preload_end();
+	if (id < 0) {
 		spin_unlock(&new->lock);
 		rcu_read_unlock();
-		return err;
+		return id;
 	}
 
 	ids->in_use++;
@@ -307,19 +311,10 @@ static int ipcget_new(struct ipc_namespa
 		struct ipc_ops *ops, struct ipc_params *params)
 {
 	int err;
-retry:
-	err = idr_pre_get(&ids->ipcs_idr, GFP_KERNEL);
-
-	if (!err)
-		return -ENOMEM;
 
 	down_write(&ids->rw_mutex);
 	err = ops->getnew(ns, params);
 	up_write(&ids->rw_mutex);
-
-	if (err == -EAGAIN)
-		goto retry;
-
 	return err;
 }
 
@@ -376,8 +371,6 @@ static int ipcget_public(struct ipc_name
 	struct kern_ipc_perm *ipcp;
 	int flg = params->flg;
 	int err;
-retry:
-	err = idr_pre_get(&ids->ipcs_idr, GFP_KERNEL);
 
 	/*
 	 * Take the lock as a writer since we are potentially going to add
@@ -389,8 +382,6 @@ retry:
 		/* key not used */
 		if (!(flg & IPC_CREAT))
 			err = -ENOENT;
-		else if (!err)
-			err = -ENOMEM;
 		else
 			err = ops->getnew(ns, params);
 	} else {
@@ -413,9 +404,6 @@ retry:
 	}
 	up_write(&ids->rw_mutex);
 
-	if (err == -EAGAIN)
-		goto retry;
-
 	return err;
 }
 
