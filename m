Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754051AbaFWNDt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jun 2014 09:03:49 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:36741 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753982AbaFWNDo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jun 2014 09:03:44 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: "J. Bruce Fields" <bfields@redhat.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 17/93] nfsd4: remove lockowner when removing lock stateid
Date: Mon, 23 Jun 2014 14:01:56 +0100
Message-Id: <1403528592-2163-18-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1403528592-2163-1-git-send-email-luis.henriques@canonical.com>
References: <1403528592-2163-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11.10.12 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: "J. Bruce Fields" <bfields@redhat.com>

commit a1b8ff4c97b4375d21b6d6c45d75877303f61b3b upstream.

The nfsv4 state code has always assumed a one-to-one correspondance
between lock stateid's and lockowners even if it appears not to in some
places.

We may actually change that, but for now when FREE_STATEID releases a
lock stateid it also needs to release the parent lockowner.

Symptoms were a subsequent LOCK crashing in find_lockowner_str when it
calls same_lockowner_ino on a lockowner that unexpectedly has an empty
so_stateids list.

Signed-off-by: J. Bruce Fields <bfields@redhat.com>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 fs/nfsd/nfs4state.c | 11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

diff --git a/fs/nfsd/nfs4state.c b/fs/nfsd/nfs4state.c
index 2a997eb693f7..4858accc4c33 100644
--- a/fs/nfsd/nfs4state.c
+++ b/fs/nfsd/nfs4state.c
@@ -3696,9 +3696,16 @@ out:
 static __be32
 nfsd4_free_lock_stateid(struct nfs4_ol_stateid *stp)
 {
-	if (check_for_locks(stp->st_file, lockowner(stp->st_stateowner)))
+	struct nfs4_lockowner *lo = lockowner(stp->st_stateowner);
+
+	if (check_for_locks(stp->st_file, lo))
 		return nfserr_locks_held;
-	release_lock_stateid(stp);
+	/*
+	 * Currently there's a 1-1 lock stateid<->lockowner
+	 * correspondance, and we have to delete the lockowner when we
+	 * delete the lock stateid:
+	 */
+	unhash_lockowner(lo);
 	return nfs_ok;
 }
 
-- 
1.9.1

