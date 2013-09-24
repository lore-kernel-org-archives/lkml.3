Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752722Ab3IXGSj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Sep 2013 02:18:39 -0400
Received: from mail-pb0-f44.google.com ([209.85.160.44]:62685 "EHLO
	mail-pb0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752221Ab3IXGSh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Sep 2013 02:18:37 -0400
From: Kent Overstreet <kmo@daterainc.com>
To: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
        linux-bcache@vger.kernel.org
Cc: axboe@kernel.dk, Gabriel de Perthuis <g2p.code@gmail.com>,
        Kent Overstreet <kmo@daterainc.com>, stable@vger.kernel.org
Subject: [PATCH 03/11] bcache: Strip endline when writing the label through sysfs
Date: Mon, 23 Sep 2013 23:17:28 -0700
Message-Id: <1380003456-19938-4-git-send-email-kmo@daterainc.com>
X-Mailer: git-send-email 1.8.4.rc3
In-Reply-To: <1380003456-19938-1-git-send-email-kmo@daterainc.com>
References: <1380003456-19938-1-git-send-email-kmo@daterainc.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Gabriel de Perthuis <g2p.code@gmail.com>

sysfs attributes with unusual characters have crappy failure modes
in Squeeze (udev 164); later versions of udev are unaffected.

This should make these characters more unusual.

Signed-off-by: Gabriel de Perthuis <g2p.code@gmail.com>
Signed-off-by: Kent Overstreet <kmo@daterainc.com>
Cc: linux-stable <stable@vger.kernel.org> # >= v3.10
---
 drivers/md/bcache/sysfs.c | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/drivers/md/bcache/sysfs.c b/drivers/md/bcache/sysfs.c
index 4fe6ab2..924dcfd 100644
--- a/drivers/md/bcache/sysfs.c
+++ b/drivers/md/bcache/sysfs.c
@@ -223,8 +223,13 @@ STORE(__cached_dev)
 	}
 
 	if (attr == &sysfs_label) {
-		/* note: endlines are preserved */
-		memcpy(dc->sb.label, buf, SB_LABEL_SIZE);
+		if (size > SB_LABEL_SIZE)
+			return -EINVAL;
+		memcpy(dc->sb.label, buf, size);
+		if (size < SB_LABEL_SIZE)
+			dc->sb.label[size] = '\0';
+		if (size && dc->sb.label[size - 1] == '\n')
+			dc->sb.label[size - 1] = '\0';
 		bch_write_bdev_super(dc, NULL);
 		if (dc->disk.c) {
 			memcpy(dc->disk.c->uuids[dc->disk.id].label,
-- 
1.8.4.rc3

