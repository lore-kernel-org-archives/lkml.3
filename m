Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932488Ab3K0A72 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Nov 2013 19:59:28 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:39424 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758680Ab3K0A7A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Nov 2013 19:59:00 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Jesper Nilsson <jesper.nilsson@axis.com>,
        Davidlohr Bueso <davidlohr@hp.com>, Rik van Riel <riel@redhat.com>,
        Michel Lespinasse <walken@google.com>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 3.12 012/116] ipc,shm: correct error return value in shmctl (SHM_UNLOCK)
Date: Tue, 26 Nov 2013 16:56:25 -0800
Message-Id: <20131127005737.770459456@linuxfoundation.org>
X-Mailer: git-send-email 1.8.5.rc3
In-Reply-To: <20131127005736.915454872@linuxfoundation.org>
References: <20131127005736.915454872@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jesper Nilsson <jesper.nilsson@axis.com>

commit 3a72660b07d86d60457ca32080b1ce8c2b628ee2 upstream.

Commit 2caacaa82a51 ("ipc,shm: shorten critical region for shmctl")
restructured the ipc shm to shorten critical region, but introduced a
path where the return value could be -EPERM, even if the operation
actually was performed.

Before the commit, the err return value was reset by the return value
from security_shm_shmctl() after the if (!ns_capable(...)) statement.

Now, we still exit the if statement with err set to -EPERM, and in the
case of SHM_UNLOCK, it is not reset at all, and used as the return value
from shmctl.

To fix this, we only set err when errors occur, leaving the fallthrough
case alone.

Signed-off-by: Jesper Nilsson <jesper.nilsson@axis.com>
Cc: Davidlohr Bueso <davidlohr@hp.com>
Cc: Rik van Riel <riel@redhat.com>
Cc: Michel Lespinasse <walken@google.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 ipc/shm.c |    9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

--- a/ipc/shm.c
+++ b/ipc/shm.c
@@ -974,12 +974,15 @@ SYSCALL_DEFINE3(shmctl, int, shmid, int,
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


