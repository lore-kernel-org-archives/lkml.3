Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965034Ab3DJXRF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Apr 2013 19:17:05 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:56070 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S937098Ab3DJWrN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Apr 2013 18:47:13 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Artem Bityutskiy <artem.bityutskiy@linux.intel.com>,
        Mark Jackson <mpfj-list@mimc.co.uk>
Subject: [ 11/64] UBIFS: make space fixup work in the remount case
Date: Wed, 10 Apr 2013 15:46:08 -0700
Message-Id: <20130410224335.706105772@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.rc1.5.g7e0651a
In-Reply-To: <20130410224333.114387235@linuxfoundation.org>
References: <20130410224333.114387235@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/ubifs/super.c |   12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

--- a/fs/ubifs/super.c
+++ b/fs/ubifs/super.c
@@ -1568,6 +1568,12 @@ static int ubifs_remount_rw(struct ubifs
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
@@ -1684,12 +1690,6 @@ static int ubifs_remount_rw(struct ubifs
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
 


