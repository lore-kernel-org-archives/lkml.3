Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753067Ab3GBFqW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Jul 2013 01:46:22 -0400
Received: from mail-pb0-f48.google.com ([209.85.160.48]:39734 "EHLO
	mail-pb0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752243Ab3GBFpQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Jul 2013 01:45:16 -0400
Date: Tue, 2 Jul 2013 13:45:12 +0800
From: majianpeng <majianpeng@gmail.com>
To: sage <sage@inktank.com>
Cc: ceph-devel <ceph-devel@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Reply-To: majianpeng <majianpeng@gmail.com>
Subject: [PATCH 1/3] mds: update atime if client can read.
X-Priority: 3
X-GUID: A6A95C9D-0292-4992-AD61-5B1C1B40D9BF
X-Has-Attach: no
X-Mailer: Foxmail 7.0.1.90[en]
Mime-Version: 1.0
Message-ID: <201307021345090019137@gmail.com>
Content-Type: text/plain;
	charset="gb2312"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id r625kXSg005648

Now, update atime only for CEPH_CAP_FILE_EXCL.Change this if
CEPH_CAP_FILE_RD.

Signed-off-by: Jianpeng Ma <majianpeng@gmail.com>
---
 src/mds/Locker.cc | 15 +++++++++------
 1 file changed, 9 insertions(+), 6 deletions(-)

diff --git a/src/mds/Locker.cc b/src/mds/Locker.cc
index 30e014a..58f953f 100644
--- a/src/mds/Locker.cc
+++ b/src/mds/Locker.cc
@@ -2676,8 +2676,9 @@ void Locker::_do_snap_update(CInode *in, snapid_t snap, int dirty, snapid_t foll
 void Locker::_update_cap_fields(CInode *in, int dirty, MClientCaps *m, inode_t *pi)
 {
   // file
+  utime_t atime = m->get_atime();
+
   if (dirty & (CEPH_CAP_FILE_EXCL|CEPH_CAP_FILE_WR)) {
-    utime_t atime = m->get_atime();
     utime_t mtime = m->get_mtime();
     utime_t ctime = m->get_ctime();
     uint64_t size = m->get_size();
@@ -2700,11 +2701,7 @@ void Locker::_update_cap_fields(CInode *in, int dirty, MClientCaps *m, inode_t *
       pi->size = size;
       pi->rstat.rbytes = size;
     }
-    if ((dirty & CEPH_CAP_FILE_EXCL) && atime != pi->atime) {
-      dout(7) << "  atime " << pi->atime << " -> " << atime
-	      << " for " << *in << dendl;
-      pi->atime = atime;
-    }
+    
     if ((dirty & CEPH_CAP_FILE_EXCL) &&
 	ceph_seq_cmp(pi->time_warp_seq, m->get_time_warp_seq()) < 0) {
       dout(7) << "  time_warp_seq " << pi->time_warp_seq << " -> " << m->get_time_warp_seq()
@@ -2712,6 +2709,12 @@ void Locker::_update_cap_fields(CInode *in, int dirty, MClientCaps *m, inode_t *
       pi->time_warp_seq = m->get_time_warp_seq();
     }
   }
+  
+  if ((dirty & CEPH_CAP_FILE_RD) && atime > pi->atime) {
+      dout(7) << "  atime " << pi->atime << " -> " << atime
+	      << " for " << *in << dendl;
+      pi->atime = atime;
+  }
   // auth
   if (dirty & CEPH_CAP_AUTH_EXCL) {
     if (m->head.uid != pi->uid) {
-- 
1.8.3.rc1.44.gb387c77
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
