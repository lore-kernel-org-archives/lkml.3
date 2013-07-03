Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965265Ab3GCTNr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Jul 2013 15:13:47 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:20493 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933552Ab3GCTAV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Jul 2013 15:00:21 -0400
X-Authority-Analysis: v=2.0 cv=Odoa/2vY c=1 sm=0 a=Sro2XwOs0tJUSHxCKfOySw==:17 a=Drc5e87SC40A:10 a=Ciwy3NGCPMMA:10 a=dejC_lkiIXUA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=KGjhK52YXX0A:10 a=UvYVTWkxpywA:10 a=NEAV23lmAAAA:8 a=VwQbUJbxAAAA:8 a=DswfTcTIAAAA:8 a=wLQR5jzhkwdXqm0_owAA:9 a=JfjM6313LcIA:10 a=jeBq3FmKZ4MA:10 a=zeHy8UFopJslfPXe:21 a=ZR1oBvUpdrsVOVv7:21 a=Sro2XwOs0tJUSHxCKfOySw==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 67.255.60.225
Message-Id: <20130703184105.498046950@goodmis.org>
User-Agent: quilt/0.60-1
Date: Wed, 03 Jul 2013 14:40:50 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Jim Schutt <jaschut@sandia.gov>, Alex Elder <elder@inktank.com>
Subject: [113/141] ceph: add cpu_to_le32() calls when encoding a reconnect capability
References: <20130703183857.307196999@goodmis.org>
Content-Disposition: inline; filename=0113-ceph-add-cpu_to_le32-calls-when-encoding-a-reconnect.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.6.11.6 stable review patch.
If anyone has any objections, please let me know.

------------------

From: Jim Schutt <jaschut@sandia.gov>

[ Upstream commit c420276a532a10ef59849adc2681f45306166b89 ]

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

Cc: stable@vger.kernel.org # 3.4+
Signed-off-by: Jim Schutt <jaschut@sandia.gov>
Reviewed-by: Alex Elder <elder@inktank.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 fs/ceph/locks.c      |    7 +++++--
 fs/ceph/mds_client.c |    2 +-
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
index 1bcf712..f51a927 100644
--- a/fs/ceph/mds_client.c
+++ b/fs/ceph/mds_client.c
@@ -2447,7 +2447,7 @@ static int encode_caps_cb(struct inode *inode, struct ceph_cap *cap,
 			lock_flocks();
 			ceph_count_locks(inode, &num_fcntl_locks,
 					 &num_flock_locks);
-			rec.v2.flock_len = (2*sizeof(u32) +
+			rec.v2.flock_len = cpu_to_le32(2*sizeof(u32) +
 					    (num_fcntl_locks+num_flock_locks) *
 					    sizeof(struct ceph_filelock));
 			unlock_flocks();
-- 
1.7.10.4


