Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934829Ab3DGXbM (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Apr 2013 19:31:12 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:46764 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S934583Ab3DGXbI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Apr 2013 19:31:08 -0400
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org,
        "Artem Bityutskiy" <artem.bityutskiy@linux.intel.com>,
        "Mark Jackson" <mpfj-list@mimc.co.uk>
Date: Sun, 07 Apr 2013 23:45:42 +0100
Message-ID: <lsq.1365374742.164890553@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [03/74] UBIFS: make space fixup work in the remount case
In-Reply-To: <lsq.1365374742.214522651@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:b4b3:7e2a:e2d0:3478
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.43-rc1 review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 fs/ubifs/super.c |   12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

--- a/fs/ubifs/super.c
+++ b/fs/ubifs/super.c
@@ -1583,6 +1583,12 @@ static int ubifs_remount_rw(struct ubifs
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
@@ -1699,12 +1705,6 @@ static int ubifs_remount_rw(struct ubifs
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
 

