Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752132AbaKBOVR (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Nov 2014 09:21:17 -0500
Received: from mout.web.de ([212.227.15.4]:54683 "EHLO mout.web.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751074AbaKBOVN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Nov 2014 09:21:13 -0500
Message-ID: <54563DCB.2010103@users.sourceforge.net>
Date: Sun, 02 Nov 2014 15:20:59 +0100
From: SF Markus Elfring <elfring@users.sourceforge.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Sage Weil <sage@inktank.com>, ceph-devel@vger.kernel.org
CC: linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org,
        trivial@kernel.org, Coccinelle <cocci@systeme.lip6.fr>
Subject: [PATCH 1/1] ceph: Deletion of unnecessary checks before two function
 calls
References: <5307CAA2.8060406@users.sourceforge.net> <alpine.DEB.2.02.1402212321410.2043@localhost6.localdomain6> <530A086E.8010901@users.sourceforge.net> <alpine.DEB.2.02.1402231635510.1985@localhost6.localdomain6> <530A72AA.3000601@users.sourceforge.net> <alpine.DEB.2.02.1402240658210.2090@localhost6.localdomain6> <530B5FB6.6010207@users.sourceforge.net> <alpine.DEB.2.10.1402241710370.2074@hadrien> <530C5E18.1020800@users.sourceforge.net> <alpine.DEB.2.10.1402251014170.2080@hadrien> <530CD2C4.4050903@users.sourceforge.net> <alpine.DEB.2.10.1402251840450.7035@hadrien> <530CF8FF.8080600@users.sourceforge.net> <alpine.DEB.2.02.1402252117150.2047@localhost6.localdomain6> <530DD06F.4090703@users.sourceforge.net> <alpine.DEB.2.02.1402262129250.2221@localhost6.localdomain6> <5317A59D.4@users.sourceforge.net>
In-Reply-To: <5317A59D.4@users.sourceforge.net>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
X-Provags-ID: V03:K0:Sjd526UdRUF/sqS/UO5TCJsgT3NvkdjYUGxNXkA1KjIoYbv5AVM
 0BTLcacGEaWX9GU4DQL/THdsRSQjlPQr0sbmm1YUhfumTEK/GYmqqsaFy1XKONY0aF6giYT
 lySlFK/TEQ14OevYedR7oAOXhN56m2kWnvaJtPatFFEtISm8e5Cg6Rs/Ze5J4AsBRVDrcyu
 4cyH4K7WcOONf0PCUne2Q==
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The functions ceph_put_snap_context() and iput() test whether their argument
is NULL and then return immediately. Thus the test around the call
is not needed.

This issue was detected by using the Coccinelle software.

Signed-off-by: Markus Elfring <elfring@users.sourceforge.net>
---
 fs/ceph/caps.c       | 3 +--
 fs/ceph/mds_client.c | 6 ++----
 fs/ceph/snap.c       | 9 +++------
 3 files changed, 6 insertions(+), 12 deletions(-)

diff --git a/fs/ceph/caps.c b/fs/ceph/caps.c
index 6d1cd45..7d99fc8 100644
--- a/fs/ceph/caps.c
+++ b/fs/ceph/caps.c
@@ -3136,8 +3136,7 @@ flush_cap_releases:
 done:
 	mutex_unlock(&session->s_mutex);
 done_unlocked:
-	if (inode)
-		iput(inode);
+	iput(inode);
 	return;

 bad:
diff --git a/fs/ceph/mds_client.c b/fs/ceph/mds_client.c
index bad07c0..3b0ab05 100644
--- a/fs/ceph/mds_client.c
+++ b/fs/ceph/mds_client.c
@@ -523,8 +523,7 @@ void ceph_mdsc_release_request(struct kref *kref)
 	}
 	if (req->r_locked_dir)
 		ceph_put_cap_refs(ceph_inode(req->r_locked_dir), CEPH_CAP_PIN);
-	if (req->r_target_inode)
-		iput(req->r_target_inode);
+	iput(req->r_target_inode);
 	if (req->r_dentry)
 		dput(req->r_dentry);
 	if (req->r_old_dentry)
@@ -995,8 +994,7 @@ out:
 	session->s_cap_iterator = NULL;
 	spin_unlock(&session->s_cap_lock);

-	if (last_inode)
-		iput(last_inode);
+	iput(last_inode);
 	if (old_cap)
 		ceph_put_cap(session->s_mdsc, old_cap);

diff --git a/fs/ceph/snap.c b/fs/ceph/snap.c
index f01645a..c1cc993 100644
--- a/fs/ceph/snap.c
+++ b/fs/ceph/snap.c
@@ -365,8 +365,7 @@ static int build_snap_context(struct ceph_snap_realm *realm)
 	     realm->ino, realm, snapc, snapc->seq,
 	     (unsigned int) snapc->num_snaps);

-	if (realm->cached_context)
-		ceph_put_snap_context(realm->cached_context);
+	ceph_put_snap_context(realm->cached_context);
 	realm->cached_context = snapc;
 	return 0;

@@ -590,15 +589,13 @@ static void queue_realm_cap_snaps(struct ceph_snap_realm
*realm)
 		if (!inode)
 			continue;
 		spin_unlock(&realm->inodes_with_caps_lock);
-		if (lastinode)
-			iput(lastinode);
+		iput(lastinode);
 		lastinode = inode;
 		ceph_queue_cap_snap(ci);
 		spin_lock(&realm->inodes_with_caps_lock);
 	}
 	spin_unlock(&realm->inodes_with_caps_lock);
-	if (lastinode)
-		iput(lastinode);
+	iput(lastinode);

 	list_for_each_entry(child, &realm->children, child_item) {
 		dout("queue_realm_cap_snaps %p %llx queue child %p %llx\n",
-- 
2.1.3


