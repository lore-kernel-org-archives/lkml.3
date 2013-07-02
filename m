Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752830Ab3GBFpU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Jul 2013 01:45:20 -0400
Received: from mail-pa0-f48.google.com ([209.85.220.48]:41733 "EHLO
	mail-pa0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752238Ab3GBFpP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Jul 2013 01:45:15 -0400
Date: Tue, 2 Jul 2013 13:45:08 +0800
From: majianpeng <majianpeng@gmail.com>
To: sage <sage@inktank.com>
Cc: ceph-devel <ceph-devel@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Reply-To: majianpeng <majianpeng@gmail.com>
Subject: [PATCH 2/3] ceph: update atime after read-operation.
X-Priority: 3
X-GUID: BC88863F-2F25-4DA6-B26E-9D51D559E9AA
X-Has-Attach: no
X-Mailer: Foxmail 7.0.1.90[en]
Mime-Version: 1.0
Message-ID: <201307021345043628495@gmail.com>
Content-Type: text/plain;
	charset="gb2312"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id r625jdLU005632

Now ceph don't support updating atime after read-operation if the open
mode is CEPH_CAP_FILE_RD.There are two reasons:
1:in client of fs,it don't set dirty cap of CEPH_CAP_FILE_RD.
2:in mds,it only update the atime if the condition
"dirty & (CEPH_CAP_FILE_EXCL|CEPH_CAP_FILE_WR) is true.
But if we can read, we can update atime. This patch only modify client to
support.

Signed-off-by: Jianpeng Ma <majianpeng@gmail.com>
---
 fs/ceph/file.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/fs/ceph/file.c b/fs/ceph/file.c
index 87df15a..9daea70 100644
--- a/fs/ceph/file.c
+++ b/fs/ceph/file.c
@@ -672,6 +672,15 @@ again:
 out:
 	dout("aio_read %p %llx.%llx dropping cap refs on %s = %d\n",
 	     inode, ceph_vinop(inode), ceph_cap_string(got), (int)ret);
+
+	if (ret >= 0) {
+		int dirty;
+		spin_lock(&ci->i_ceph_lock);
+		dirty = __ceph_mark_dirty_caps(ci, CEPH_CAP_FILE_RD);
+		spin_unlock(&ci->i_ceph_lock);
+		if (dirty)
+			__mark_inode_dirty(inode, dirty);
+	}
 	ceph_put_cap_refs(ci, got);
 
 	if (checkeof && ret >= 0) {
-- 
1.8.1.2
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
