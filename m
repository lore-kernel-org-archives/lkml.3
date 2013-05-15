Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932930Ab3EOQjR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 May 2013 12:39:17 -0400
Received: from sentry-two.sandia.gov ([132.175.109.14]:43760 "EHLO
	sentry-two.sandia.gov" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932543Ab3EOQjN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 May 2013 12:39:13 -0400
X-WSS-ID: 0MMUM99-0B-0Q3-02
X-M-MSG: 
X-Server-Uuid: AF72F651-81B1-4134-BA8C-A8E1A4E620FF
From: "Jim Schutt" <jaschut@sandia.gov>
To: elder@inktank.com
cc: ceph-devel@vger.kernel.org, linux-kernel@vger.kernel.org,
        "Jim Schutt" <jaschut@sandia.gov>
Subject: [PATCH v2 2/3] ceph: add missing cpu_to_le32() calls when
 encoding a reconnect capability
Date: Wed, 15 May 2013 10:38:13 -0600
Message-ID: <1368635894-114707-3-git-send-email-jaschut@sandia.gov>
X-Mailer: git-send-email 1.7.8.2
In-Reply-To: <1368635894-114707-1-git-send-email-jaschut@sandia.gov>
References: <1368635894-114707-1-git-send-email-jaschut@sandia.gov>
X-PMX-Version: 5.6.1.2065439, Antispam-Engine: 2.7.2.376379,
 Antispam-Data: 2013.5.15.163017
X-PMX-Spam: Gauge=IIIIIIII, Probability=8%, Report=' MULTIPLE_RCPTS 0.1,
 HTML_00_01 0.05, HTML_00_10 0.05, BODYTEXTP_SIZE_3000_LESS 0,
 BODY_SIZE_2000_2999 0, BODY_SIZE_5000_LESS 0, BODY_SIZE_7000_LESS 0,
 DATE_TZ_NA 0, __ANY_URI 0, __HAS_FROM 0, __HAS_MSGID 0, __HAS_X_MAILER
 0, __IN_REP_TO 0, __MIME_TEXT_ONLY 0, __MULTIPLE_RCPTS_CC_X2 0,
 __SANE_MSGID 0, __SUBJ_ALPHA_END 0, __TO_MALFORMED_2 0, __TO_NO_NAME 0,
 __URI_NO_PATH 0, __URI_NO_WWW 0, __URI_NS '
X-TMWD-Spam-Summary: TS=20130515163843; ID=1; SEV=2.3.1;
 DFV=B2013022509; IFV=NA; AIF=B2013022509; RPD=5.03.0010; ENG=NA;
 RPDID=7374723D303030312E30413031303230352E35313933424131332E303037413A534346535441543838363133332C73733D312C6667733D30;
 CAT=NONE; CON=NONE; SIG=AAAAAAAAAAAAAAAAAAAAAAAAfQ==
X-MMS-Spam-Filter-ID: B2013022509_5.03.0010
MIME-Version: 1.0
X-WSS-ID: 7D8D659903W2202092-01-01
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
X-RSA-Inspected: yes
X-RSA-Classifications: public
X-RSA-Action: allow
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In his review, Alex Elder mentioned that he hadn't checked that num_fcntl_locks
and num_flock_locks were properly decoded on the server side, from a le32
over-the-wire type to a cpu type.  I checked, and AFAICS it is done; those
interested can consult Locker::_do_cap_update() in src/mds/Locker.cc and
src/include/encoding.h in the Ceph server code (git://github.com/ceph/ceph).

I also checked the server side for flock_len decoding, and I believe that
also happens correctly, by virtue of having been declared __le32 in
struct ceph_mds_cap_reconnect, in src/include/ceph_fs.h.

Signed-off-by: Jim Schutt <jaschut@sandia.gov>
---
 fs/ceph/locks.c      |    7 +++++--
 fs/ceph/mds_client.c |    2 +-
 2 files changed, 6 insertions(+), 3 deletions(-)

diff --git a/fs/ceph/locks.c b/fs/ceph/locks.c
index ffc86cb..4518313 100644
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
index 4f22671..d9ca152 100644
--- a/fs/ceph/mds_client.c
+++ b/fs/ceph/mds_client.c
@@ -2485,7 +2485,7 @@ static int encode_caps_cb(struct inode *inode, struct ceph_cap *cap,
 			lock_flocks();
 			ceph_count_locks(inode, &num_fcntl_locks,
 					 &num_flock_locks);
-			rec.v2.flock_len = (2*sizeof(u32) +
+			rec.v2.flock_len = cpu_to_le32(2*sizeof(u32) +
 					    (num_fcntl_locks+num_flock_locks) *
 					    sizeof(struct ceph_filelock));
 			unlock_flocks();
-- 
1.7.8.2


