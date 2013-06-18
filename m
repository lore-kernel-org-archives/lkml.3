Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932513Ab3FRLyE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Jun 2013 07:54:04 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:56174 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932413Ab3FRLpA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Jun 2013 07:45:00 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Jim Schutt <jaschut@sandia.gov>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 63/93] ceph: add cpu_to_le32() calls when encoding a reconnect capability
Date: Tue, 18 Jun 2013 12:43:11 +0100
Message-Id: <1371555821-12820-64-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1371555821-12820-1-git-send-email-luis.henriques@canonical.com>
References: <1371555821-12820-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.15 -stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 fs/ceph/locks.c      | 7 +++++--
 fs/ceph/mds_client.c | 2 +-
 2 files changed, 6 insertions(+), 3 deletions(-)

diff --git a/fs/ceph/locks.c b/fs/ceph/locks.c
index 80576d05..e9960c8 100644
--- a/fs/ceph/locks.c
+++ b/fs/ceph/locks.c
@@ -206,10 +206,12 @@ int ceph_encode_locks(struct inode *inode, struct ceph_pagelist *pagelist,
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
@@ -229,7 +231,8 @@ int ceph_encode_locks(struct inode *inode, struct ceph_pagelist *pagelist,
 			goto fail;
 	}
 
-	err = ceph_pagelist_append(pagelist, &num_flock_locks, sizeof(u32));
+	nlocks = cpu_to_le32(num_flock_locks);
+	err = ceph_pagelist_append(pagelist, &nlocks, sizeof(nlocks));
 	if (err)
 		goto fail;
 	for (lock = inode->i_flock; lock != NULL; lock = lock->fl_next) {
diff --git a/fs/ceph/mds_client.c b/fs/ceph/mds_client.c
index 7111bc9..d375524 100644
--- a/fs/ceph/mds_client.c
+++ b/fs/ceph/mds_client.c
@@ -2457,7 +2457,7 @@ static int encode_caps_cb(struct inode *inode, struct ceph_cap *cap,
 			lock_flocks();
 			ceph_count_locks(inode, &num_fcntl_locks,
 					 &num_flock_locks);
-			rec.v2.flock_len = (2*sizeof(u32) +
+			rec.v2.flock_len = cpu_to_le32(2*sizeof(u32) +
 					    (num_fcntl_locks+num_flock_locks) *
 					    sizeof(struct ceph_filelock));
 			unlock_flocks();
-- 
1.8.1.2

