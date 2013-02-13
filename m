Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964865Ab3BMRwm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Feb 2013 12:52:42 -0500
Received: from out03.mta.xmission.com ([166.70.13.233]:53435 "EHLO
	out03.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934544Ab3BMRwk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Feb 2013 12:52:40 -0500
From: "Eric W. Biederman" <ebiederm@xmission.com>
To: <linux-fsdevel@vger.kernel.org>
Cc: Linux Containers <containers@lists.linux-foundation.org>,
        <linux-kernel@vger.kernel.org>, "Serge E. Hallyn" <serge@hallyn.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Sage Weil <sage@inktank.com>
Date: Wed, 13 Feb 2013 09:50:51 -0800
Message-Id: <1360777934-5663-2-git-send-email-ebiederm@xmission.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1360777934-5663-1-git-send-email-ebiederm@xmission.com>
References: <87621w14vs.fsf@xmission.com>
 <1360777934-5663-1-git-send-email-ebiederm@xmission.com>
X-XM-AID: U2FsdGVkX1/Wptrip5GyGx0dsPTjTZR/c4v44hcWNl8=
X-SA-Exim-Connect-IP: 98.207.153.68
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.1 XMSubLong Long Subject
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -0.0 BAYES_40 BODY: Bayes spam probability is 20 to 40%
	*      [score: 0.2089]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa03 1397; Body=1 Fuz1=1 Fuz2=1]
X-Spam-DCC: XMission; sa03 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;<linux-fsdevel@vger.kernel.org>
X-Spam-Relay-Country: 
Subject: [PATCH review 02/85] ceph: Translate between uid and gids in cap messages and kuids and kgids
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Wed, 14 Nov 2012 14:26:46 -0700)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Eric W. Biederman" <ebiederm@xmission.com>

- Make the uid and gid arguments of send_cap_msg() used to compose
  ceph_mds_caps messages of type kuid_t and kgid_t.

- Pass inode->i_uid and inode->i_gid in __send_cap to send_cap_msg()
  through variables of type kuid_t and kgid_t.

- Modify struct ceph_cap_snap to store uids and gids in types kuid_t
  and kgid_t.  This allows capturing inode->i_uid and inode->i_gid in
  ceph_queue_cap_snap() without loss and pssing them to
  __ceph_flush_snaps() where they are removed from struct
  ceph_cap_snap and passed to send_cap_msg().

- In handle_cap_grant translate uid and gids in the initial user
  namespace stored in struct ceph_mds_cap into kuids and kgids
  before setting inode->i_uid and inode->i_gid.

Cc: Sage Weil <sage@inktank.com>
Signed-off-by: "Eric W. Biederman" <ebiederm@xmission.com>
---
 fs/ceph/caps.c  |   14 +++++++-------
 fs/ceph/super.h |    4 ++--
 2 files changed, 9 insertions(+), 9 deletions(-)

diff --git a/fs/ceph/caps.c b/fs/ceph/caps.c
index a1d9bb3..39eb466 100644
--- a/fs/ceph/caps.c
+++ b/fs/ceph/caps.c
@@ -930,7 +930,7 @@ static int send_cap_msg(struct ceph_mds_session *session,
 			u64 size, u64 max_size,
 			struct timespec *mtime, struct timespec *atime,
 			u64 time_warp_seq,
-			uid_t uid, gid_t gid, umode_t mode,
+			kuid_t uid, kgid_t gid, umode_t mode,
 			u64 xattr_version,
 			struct ceph_buffer *xattrs_buf,
 			u64 follows)
@@ -974,8 +974,8 @@ static int send_cap_msg(struct ceph_mds_session *session,
 		ceph_encode_timespec(&fc->atime, atime);
 	fc->time_warp_seq = cpu_to_le32(time_warp_seq);
 
-	fc->uid = cpu_to_le32(uid);
-	fc->gid = cpu_to_le32(gid);
+	fc->uid = cpu_to_le32(from_kuid(&init_user_ns, uid));
+	fc->gid = cpu_to_le32(from_kgid(&init_user_ns, gid));
 	fc->mode = cpu_to_le32(mode);
 
 	fc->xattr_version = cpu_to_le64(xattr_version);
@@ -1081,8 +1081,8 @@ static int __send_cap(struct ceph_mds_client *mdsc, struct ceph_cap *cap,
 	struct timespec mtime, atime;
 	int wake = 0;
 	umode_t mode;
-	uid_t uid;
-	gid_t gid;
+	kuid_t uid;
+	kgid_t gid;
 	struct ceph_mds_session *session;
 	u64 xattr_version = 0;
 	struct ceph_buffer *xattr_blob = NULL;
@@ -2359,8 +2359,8 @@ static void handle_cap_grant(struct inode *inode, struct ceph_mds_caps *grant,
 
 	if ((issued & CEPH_CAP_AUTH_EXCL) == 0) {
 		inode->i_mode = le32_to_cpu(grant->mode);
-		inode->i_uid = le32_to_cpu(grant->uid);
-		inode->i_gid = le32_to_cpu(grant->gid);
+		inode->i_uid = make_kuid(&init_user_ns, le32_to_cpu(grant->uid));
+		inode->i_gid = make_kgid(&init_user_ns, le32_to_cpu(grant->gid));
 		dout("%p mode 0%o uid.gid %d.%d\n", inode, inode->i_mode,
 		     inode->i_uid, inode->i_gid);
 	}
diff --git a/fs/ceph/super.h b/fs/ceph/super.h
index 66ebe72..f053bbd 100644
--- a/fs/ceph/super.h
+++ b/fs/ceph/super.h
@@ -138,8 +138,8 @@ struct ceph_cap_snap {
 	struct ceph_snap_context *context;
 
 	umode_t mode;
-	uid_t uid;
-	gid_t gid;
+	kuid_t uid;
+	kgid_t gid;
 
 	struct ceph_buffer *xattr_blob;
 	u64 xattr_version;
-- 
1.7.5.4

