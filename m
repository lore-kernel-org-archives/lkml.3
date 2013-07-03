Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753290Ab3GCFfE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Jul 2013 01:35:04 -0400
Received: from mail-pa0-f43.google.com ([209.85.220.43]:50785 "EHLO
	mail-pa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751512Ab3GCFfA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Jul 2013 01:35:00 -0400
Date: Wed, 3 Jul 2013 13:34:56 +0800
From: majianpeng <majianpeng@gmail.com>
To: sage <sage@inktank.com>
Cc: ceph-devel <ceph-devel@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Reply-To: majianpeng <majianpeng@gmail.com>
Subject: [PATCH 1/2] ceph: update atime after read.
X-Priority: 3
X-GUID: A90B0E5F-BF2C-4B66-A376-F36717614D61
X-Has-Attach: no
X-Mailer: Foxmail 7.0.1.90[en]
Mime-Version: 1.0
Message-ID: <201307031334515420104@gmail.com>
Content-Type: text/plain;
	charset="gb2312"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id r635ZBEr012360

Now ceph don't update atime after read.So add this function.

Signed-off-by: Jianpeng Ma <majianpeng@gmail.com>
---
 fs/ceph/file.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/fs/ceph/file.c b/fs/ceph/file.c
index 656e169..fa74e6f 100644
--- a/fs/ceph/file.c
+++ b/fs/ceph/file.c
@@ -669,6 +669,15 @@ again:
 out:
 	dout("aio_read %p %llx.%llx dropping cap refs on %s = %d\n",
 	     inode, ceph_vinop(inode), ceph_cap_string(got), (int)ret);
+
+	if (ret > 0) {
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
