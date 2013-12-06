Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1162438Ab3LFNQc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Dec 2013 08:16:32 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:44648 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161992Ab3LFNEk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Dec 2013 08:04:40 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Trond Myklebust <Trond.Myklebust@netapp.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 229/272] NFSv4: Fix state reference counting in _nfs4_opendata_reclaim_to_nfs4_state
Date: Fri,  6 Dec 2013 12:58:38 +0000
Message-Id: <1386334761-25517-230-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1386334761-25517-1-git-send-email-luis.henriques@canonical.com>
References: <1386334761-25517-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11.10.1 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Trond Myklebust <Trond.Myklebust@netapp.com>

commit d49f042aeec99c5f87160bb52dd52088b1051311 upstream.

Currently, if the call to nfs_refresh_inode fails, then we end up leaking
a reference count, due to the call to nfs4_get_open_state.
While we're at it, replace nfs4_get_open_state with a simple call to
atomic_inc(); there is no need to do a full lookup of the struct nfs_state
since it is passed as an argument in the struct nfs4_opendata, and
is already assigned to the variable 'state'.

Signed-off-by: Trond Myklebust <Trond.Myklebust@netapp.com>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 fs/nfs/nfs4proc.c | 6 +-----
 1 file changed, 1 insertion(+), 5 deletions(-)

diff --git a/fs/nfs/nfs4proc.c b/fs/nfs/nfs4proc.c
index 84c6225..9960a5b 100644
--- a/fs/nfs/nfs4proc.c
+++ b/fs/nfs/nfs4proc.c
@@ -1236,11 +1236,6 @@ _nfs4_opendata_reclaim_to_nfs4_state(struct nfs4_opendata *data)
 		goto err;
 	}
 
-	ret = -ENOMEM;
-	state = nfs4_get_open_state(inode, data->owner);
-	if (state == NULL)
-		goto err;
-
 	ret = nfs_refresh_inode(inode, &data->f_attr);
 	if (ret)
 		goto err;
@@ -1251,6 +1246,7 @@ _nfs4_opendata_reclaim_to_nfs4_state(struct nfs4_opendata *data)
 		nfs4_opendata_check_deleg(data, state);
 	update_open_stateid(state, &data->o_res.stateid, NULL,
 			    data->o_arg.fmode);
+	atomic_inc(&state->count);
 
 	return state;
 err:
-- 
1.8.3.2

