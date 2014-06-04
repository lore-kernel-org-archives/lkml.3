Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756176AbaFEAM7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jun 2014 20:12:59 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:40276 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753323AbaFDXWo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jun 2014 19:22:44 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        "J. Bruce Fields" <bfields@redhat.com>
Subject: [PATCH 3.14 152/228] nfsd4: remove lockowner when removing lock stateid
Date: Wed,  4 Jun 2014 16:23:01 -0700
Message-Id: <20140604232352.906195229@linuxfoundation.org>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <20140604232347.966798903@linuxfoundation.org>
References: <20140604232347.966798903@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.14-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/nfsd/nfs4state.c |   11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

--- a/fs/nfsd/nfs4state.c
+++ b/fs/nfsd/nfs4state.c
@@ -3714,9 +3714,16 @@ out:
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
 


