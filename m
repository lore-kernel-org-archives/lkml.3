Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752649Ab3KTKoQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Nov 2013 05:44:16 -0500
Received: from ra.se.axis.com ([195.60.68.13]:58587 "EHLO ra.se.axis.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752328Ab3KTKoO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Nov 2013 05:44:14 -0500
Date: Wed, 20 Nov 2013 11:44:12 +0100
From: Jesper Nilsson <jesper.nilsson@axis.com>
To: Andrew Morton <akpm@linux-foundation.org>,
        Davidlohr Bueso <davidlohr@hp.com>, Rik van Riel <riel@redhat.com>,
        Michel Lespinasse <walken@google.com>,
        Al Viro <viro@zeniv.linux.org.uk>, linux-kernel@vger.kernel.org
Subject: [PATCH] ipc,shm: Correct error return value in shmctl (SHM_UNLOCK)
Message-ID: <20131120104411.GA15831@axis.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit 2caacaa82a51b78fc0c800e206473874094287ed restructured
the ipc shm to shorten critical region, but introduced a path
where the return value could be -EPERM, even if the operation
actually was performed.

Before the commit, the err return value was reset by the return value
from security_shm_shmctl() after the if (!ns_capable(...)) statement.

Now, we still exit the if statement with err set to -EPERM,
and in the case of SHM_UNLOCK, it is not reset at all,
and used as the return value from shmctl.

To fix this, we only set err when errors occur, leaving the
fallthrough case alone.

Signed-off-by: Jesper Nilsson <jesper.nilsson@axis.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Davidlohr Bueso <davidlohr@hp.com>
Cc: Rik van Riel <riel@redhat.com>
Cc: Michel Lespinasse <walken@google.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: stable@vger.kernel.org
---
 ipc/shm.c | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/ipc/shm.c b/ipc/shm.c
index d697396..4076f9e 100644
--- a/ipc/shm.c
+++ b/ipc/shm.c
@@ -974,12 +974,15 @@ SYSCALL_DEFINE3(shmctl, int, shmid, int, cmd, struct shmid_ds __user *, buf)
 		ipc_lock_object(&shp->shm_perm);
 		if (!ns_capable(ns->user_ns, CAP_IPC_LOCK)) {
 			kuid_t euid = current_euid();
-			err = -EPERM;
 			if (!uid_eq(euid, shp->shm_perm.uid) &&
-			    !uid_eq(euid, shp->shm_perm.cuid))
+			    !uid_eq(euid, shp->shm_perm.cuid)) {
+				err = -EPERM;
 				goto out_unlock0;
-			if (cmd == SHM_LOCK && !rlimit(RLIMIT_MEMLOCK))
+			}
+			if (cmd == SHM_LOCK && !rlimit(RLIMIT_MEMLOCK)) {
+				err = -EPERM;
 				goto out_unlock0;
+			}
 		}
 
 		shm_file = shp->shm_file;
-- 
1.8.4


/^JN - Jesper Nilsson
-- 
               Jesper Nilsson -- jesper.nilsson@axis.com
