Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755880AbaGHTTY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jul 2014 15:19:24 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:54242 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755743AbaGHTIm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jul 2014 15:08:42 -0400
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org, "J. Bruce Fields" <bfields@redhat.com>,
        "Benny Halevy" <bhalevy@primarydata.com>,
        "Jeff Layton" <jlayton@primarydata.com>
Date: Tue, 08 Jul 2014 20:01:50 +0100
Message-ID: <lsq.1404846110.152556058@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [PATCH 3.2 058/125] nfsd4: use recall_lock for delegation hashing
In-Reply-To: <lsq.1404846109.699842714@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.249
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.61-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Benny Halevy <bhalevy@primarydata.com>

commit 931ee56c67573eb4e51c8a4e78598d965b8b059e upstream.

This fixes a bug in the handling of the fi_delegations list.

nfs4_setlease does not hold the recall_lock when adding to it. The
client_mutex is held, which prevents against concurrent list changes,
but nfsd_break_deleg_cb does not hold while walking it. New delegations
could theoretically creep onto the list while we're walking it there.

Signed-off-by: Benny Halevy <bhalevy@primarydata.com>
Signed-off-by: Jeff Layton <jlayton@primarydata.com>
Signed-off-by: J. Bruce Fields <bfields@redhat.com>
[bwh: Backported to 3.2:
 - Adjust context
 - Also remove a list_del_init() in nfs4_setlease() which would now be
   before the corresponding list_add()
 - Drop change to nfsd_find_all_delegations(), which doesn't exist]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 fs/nfsd/nfs4state.c | 20 +++++++++++++++-----
 1 file changed, 15 insertions(+), 5 deletions(-)

--- a/fs/nfsd/nfs4state.c
+++ b/fs/nfsd/nfs4state.c
@@ -337,13 +337,22 @@ static void unhash_stid(struct nfs4_stid
 	idr_remove(stateids, s->sc_stateid.si_opaque.so_id);
 }
 
+static void
+hash_delegation_locked(struct nfs4_delegation *dp, struct nfs4_file *fp)
+{
+	lockdep_assert_held(&recall_lock);
+
+	list_add(&dp->dl_perfile, &fp->fi_delegations);
+	list_add(&dp->dl_perclnt, &dp->dl_stid.sc_client->cl_delegations);
+}
+
 /* Called under the state lock. */
 static void
 unhash_delegation(struct nfs4_delegation *dp)
 {
 	unhash_stid(&dp->dl_stid);
-	list_del_init(&dp->dl_perclnt);
 	spin_lock(&recall_lock);
+	list_del_init(&dp->dl_perclnt);
 	list_del_init(&dp->dl_perfile);
 	list_del_init(&dp->dl_recall_lru);
 	spin_unlock(&recall_lock);
@@ -2810,10 +2819,8 @@ static int nfs4_setlease(struct nfs4_del
 	if (!fl)
 		return -ENOMEM;
 	fl->fl_file = find_readable_file(fp);
-	list_add(&dp->dl_perclnt, &dp->dl_stid.sc_client->cl_delegations);
 	status = vfs_setlease(fl->fl_file, fl->fl_type, &fl);
 	if (status) {
-		list_del_init(&dp->dl_perclnt);
 		locks_free_lock(fl);
 		return -ENOMEM;
 	}
@@ -2821,7 +2828,9 @@ static int nfs4_setlease(struct nfs4_del
 	fp->fi_deleg_file = fl->fl_file;
 	get_file(fp->fi_deleg_file);
 	atomic_set(&fp->fi_delegees, 1);
-	list_add(&dp->dl_perfile, &fp->fi_delegations);
+	spin_lock(&recall_lock);
+	hash_delegation_locked(dp, fp);
+	spin_unlock(&recall_lock);
 	return 0;
 }
 
@@ -2837,9 +2846,8 @@ static int nfs4_set_delegation(struct nf
 		return -EAGAIN;
 	}
 	atomic_inc(&fp->fi_delegees);
-	list_add(&dp->dl_perfile, &fp->fi_delegations);
+	hash_delegation_locked(dp, fp);
 	spin_unlock(&recall_lock);
-	list_add(&dp->dl_perclnt, &dp->dl_stid.sc_client->cl_delegations);
 	return 0;
 }
 

