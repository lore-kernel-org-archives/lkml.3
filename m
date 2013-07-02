Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932549Ab3GBJ3V (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Jul 2013 05:29:21 -0400
Received: from mail-pb0-f43.google.com ([209.85.160.43]:49459 "EHLO
	mail-pb0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753623Ab3GBJ3S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Jul 2013 05:29:18 -0400
Date: Tue, 2 Jul 2013 17:29:15 +0800
From: majianpeng <majianpeng@gmail.com>
To: sage <sage@inktank.com>
Cc: ceph-devel <ceph-devel@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Reply-To: majianpeng <majianpeng@gmail.com>
Subject: [RFC PATCH] ceph: send the ctime of file/snap when send a cap msg.
X-Priority: 3
X-GUID: DDB9110B-B11B-476B-A07E-35E299E4755F
X-Has-Attach: no
X-Mailer: Foxmail 7.0.1.90[en]
Mime-Version: 1.0
Message-ID: <201307021700280328740@gmail.com>
Content-Type: text/plain;
	charset="gb2312"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id r629TZ9F006797

Now,when sent a cap msg to inode/snap, it don't include the ctime of
inode/snap.So make the mtime ahead of ctime.

BTY,for snap, i'm not exactly send the ctime of snap or null.

Signed-off-by: Jianpeng Ma <majianpeng@gmail.com>
---
 fs/ceph/caps.c | 11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)

diff --git a/fs/ceph/caps.c b/fs/ceph/caps.c
index da0f9b8..8735108 100644
--- a/fs/ceph/caps.c
+++ b/fs/ceph/caps.c
@@ -943,7 +943,7 @@ static int send_cap_msg(struct ceph_mds_session *session,
 			u32 seq, u64 flush_tid, u32 issue_seq, u32 mseq,
 			u64 size, u64 max_size,
 			struct timespec *mtime, struct timespec *atime,
-			u64 time_warp_seq,
+			struct timespec *ctime, u64 time_warp_seq,
 			kuid_t uid, kgid_t gid, umode_t mode,
 			u64 xattr_version,
 			struct ceph_buffer *xattrs_buf,
@@ -986,6 +986,8 @@ static int send_cap_msg(struct ceph_mds_session *session,
 		ceph_encode_timespec(&fc->mtime, mtime);
 	if (atime)
 		ceph_encode_timespec(&fc->atime, atime);
+	if (ctime)
+		ceph_encode_timespec(&fc->ctime, ctime);
 	fc->time_warp_seq = cpu_to_le32(time_warp_seq);
 
 	fc->uid = cpu_to_le32(from_kuid(&init_user_ns, uid));
@@ -1092,7 +1094,7 @@ static int __send_cap(struct ceph_mds_client *mdsc, struct ceph_cap *cap,
 	int held, revoking, dropping, keep;
 	u64 seq, issue_seq, mseq, time_warp_seq, follows;
 	u64 size, max_size;
-	struct timespec mtime, atime;
+	struct timespec mtime, atime, ctime;
 	int wake = 0;
 	umode_t mode;
 	kuid_t uid;
@@ -1176,6 +1178,7 @@ static int __send_cap(struct ceph_mds_client *mdsc, struct ceph_cap *cap,
 	ci->i_requested_max_size = max_size;
 	mtime = inode->i_mtime;
 	atime = inode->i_atime;
+	ctime = inode->i_ctime;
 	time_warp_seq = ci->i_time_warp_seq;
 	uid = inode->i_uid;
 	gid = inode->i_gid;
@@ -1191,7 +1194,7 @@ static int __send_cap(struct ceph_mds_client *mdsc, struct ceph_cap *cap,
 
 	ret = send_cap_msg(session, ceph_vino(inode).ino, cap_id,
 		op, keep, want, flushing, seq, flush_tid, issue_seq, mseq,
-		size, max_size, &mtime, &atime, time_warp_seq,
+		size, max_size, &mtime, &atime, &ctime, time_warp_seq,
 		uid, gid, mode, xattr_version, xattr_blob,
 		follows);
 	if (ret < 0) {
@@ -1310,7 +1313,7 @@ retry:
 			     CEPH_CAP_OP_FLUSHSNAP, capsnap->issued, 0,
 			     capsnap->dirty, 0, capsnap->flush_tid, 0, mseq,
 			     capsnap->size, 0,
-			     &capsnap->mtime, &capsnap->atime,
+			     &capsnap->mtime, &capsnap->atime, &capsnap->ctime,
 			     capsnap->time_warp_seq,
 			     capsnap->uid, capsnap->gid, capsnap->mode,
 			     capsnap->xattr_version, capsnap->xattr_blob,
-- 
1.8.1.2
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
