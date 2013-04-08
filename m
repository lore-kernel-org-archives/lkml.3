Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935182Ab3DHJyS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Apr 2013 05:54:18 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:43086 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935988Ab3DHJw7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Apr 2013 05:52:59 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Artem Bityutskiy <artem.bityutskiy@linux.intel.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 100/102] UBIFS: make space fixup work in the remount case
Date: Mon,  8 Apr 2013 10:50:55 +0100
Message-Id: <1365414657-29191-101-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1365414657-29191-1-git-send-email-luis.henriques@canonical.com>
References: <1365414657-29191-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.10 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Artem Bityutskiy <artem.bityutskiy@linux.intel.com>

commit 67e753ca41782913d805ff4a8a2b0f60b26b7915 upstream.

The UBIFS space fixup is a useful feature which allows to fixup the "broken"
flash space at the time of the first mount. The "broken" space is usually the
result of using a "dumb" industrial flasher which is not able to skip empty
NAND pages and just writes all 0xFFs to the empty space, which has grave
side-effects for UBIFS when UBIFS trise to write useful data to those empty
pages.

The fix-up feature works roughly like this:
1. mkfs.ubifs sets the fixup flag in UBIFS superblock when creating the image
   (see -F option)
2. when the file-system is mounted for the first time, UBIFS notices the fixup
   flag and re-writes the entire media atomically, which may take really a lot
   of time.
3. UBIFS clears the fixup flag in the superblock.

This works fine when the file system is mounted R/W for the very first time.
But it did not really work in the case when we first mount the file-system R/O,
and then re-mount R/W. The reason was that we started the fixup procedure too
late, which we cannot really do because we have to fixup the space before it
starts being used.

Signed-off-by: Artem Bityutskiy <artem.bityutskiy@linux.intel.com>
Reported-by: Mark Jackson <mpfj-list@mimc.co.uk>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 fs/ubifs/super.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/fs/ubifs/super.c b/fs/ubifs/super.c
index 5862dd9..202c0e4 100644
--- a/fs/ubifs/super.c
+++ b/fs/ubifs/super.c
@@ -1579,6 +1579,12 @@ static int ubifs_remount_rw(struct ubifs_info *c)
 	c->remounting_rw = 1;
 	c->ro_mount = 0;
 
+	if (c->space_fixup) {
+		err = ubifs_fixup_free_space(c);
+		if (err)
+			return err;
+	}
+
 	err = check_free_space(c);
 	if (err)
 		goto out;
@@ -1695,12 +1701,6 @@ static int ubifs_remount_rw(struct ubifs_info *c)
 		err = dbg_check_space_info(c);
 	}
 
-	if (c->space_fixup) {
-		err = ubifs_fixup_free_space(c);
-		if (err)
-			goto out;
-	}
-
 	mutex_unlock(&c->umount_mutex);
 	return err;
 
-- 
1.8.1.2

