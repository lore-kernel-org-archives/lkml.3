Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933043Ab3FRQj1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Jun 2013 12:39:27 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:49238 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932734Ab3FRQOd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Jun 2013 12:14:33 -0400
From: Greg Kroah-Hartman <greg@kroah.com>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Jim Schutt <jaschut@sandia.gov>, Alex Elder <elder@inktank.com>
Subject: [ 03/26] ceph: add cpu_to_le32() calls when encoding a reconnect capability
Date: Tue, 18 Jun 2013 09:14:43 -0700
Message-Id: <20130618161231.894526956@linuxfoundation.org>
X-Mailer: git-send-email 1.8.3.254.g5578ad7
In-Reply-To: <20130618161231.154881788@linuxfoundation.org>
References: <20130618161231.154881788@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

3.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jim Schutt <jaschut@sandia.gov>

commit c420276a532a10ef59849adc2681f45306166b89 upstream.

In his review, Alex Elder mentioned that he hadn't checked that
num_fcntl_locks and num_flock_locks were properly decoded on the
server side, from a le32 over-the-wire type to a cpu type.
I checked, and AFAICS it is done; those interested can consult
    Locker::_do_cap_update()
in src/mds/Locker.cc and src/include/encoding.h in the Ceph server
code (git://github.com/ceph/ceph).

I also checked the server side for flock_len decoding, and I believe
that also happens correctly, by virtue of having been declared
__le32 in struct ceph_mds_cap_reconnect, in src/include/ceph_fs.h.

Signed-off-by: Jim Schutt <jaschut@sandia.gov>
Reviewed-by: Alex Elder <elder@inktank.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/ceph/locks.c      |    7 +++++--
 fs/ceph/mds_client.c |    2 +-
 2 files changed, 6 insertions(+), 3 deletions(-)

--- a/fs/ceph/locks.c
+++ b/fs/ceph/locks.c
@@ -206,10 +206,12 @@ int ceph_encode_locks(struct inode *inod
 	int err = 0;
 	int seen_fcntl = 0;
 	int seen_flock = 0;
+	__le32 nlocks;
 
 	dout("encoding %d flock and %d fcntl locks", num_flock_locks,
 	     num_fcntl_locks);
-	err = ceph_pagelist_append(pagelist, &num_fcntl_locks, sizeof(u32));
+	nlocks = cpu_to_le32(num_fcntl_locks);
+	err = ceph_pagelist_append(pagelist, &nlocks, sizeof(nlocks));
 	if (err)
 		goto fail;
 	for (lock = inode->i_flock; lock != NULL; lock = lock->fl_next) {
@@ -229,7 +231,8 @@ int ceph_encode_locks(struct inode *inod
 			goto fail;
 	}
 
-	err = ceph_pagelist_append(pagelist, &num_flock_locks, sizeof(u32));
+	nlocks = cpu_to_le32(num_flock_locks);
+	err = ceph_pagelist_append(pagelist, &nlocks, sizeof(nlocks));
 	if (err)
 		goto fail;
 	for (lock = inode->i_flock; lock != NULL; lock = lock->fl_next) {
--- a/fs/ceph/mds_client.c
+++ b/fs/ceph/mds_client.c
@@ -2462,7 +2462,7 @@ static int encode_caps_cb(struct inode *
 			lock_flocks();
 			ceph_count_locks(inode, &num_fcntl_locks,
 					 &num_flock_locks);
-			rec.v2.flock_len = (2*sizeof(u32) +
+			rec.v2.flock_len = cpu_to_le32(2*sizeof(u32) +
 					    (num_fcntl_locks+num_flock_locks) *
 					    sizeof(struct ceph_filelock));
 			unlock_flocks();


