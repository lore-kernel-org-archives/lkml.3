Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758946Ab3EGEM4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 May 2013 00:12:56 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:29703 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932924Ab3EGD6q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 May 2013 23:58:46 -0400
X-Authority-Analysis: v=2.0 cv=cOZiQyiN c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=Ciwy3NGCPMMA:10 a=raB0Mn4BeHgA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=IppKSFhynL0A:10 a=QyXUC8HyAAAA:8 a=HmjiGiwDAAAA:8 a=VwQbUJbxAAAA:8 a=UOpjjlpZozkG-P3uORQA:9 a=italRXllwh8A:10 a=jeBq3FmKZ4MA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-Id: <20130507035842.071907452@goodmis.org>
User-Agent: quilt/0.60-1
Date: Mon, 06 May 2013 23:57:19 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Artem Bityutskiy <artem.bityutskiy@linux.intel.com>,
        Mark Jackson <mpfj-list@mimc.co.uk>
Subject: [007/126] UBIFS: make space fixup work in the remount case
References: <20130507035712.909872333@goodmis.org>
Content-Disposition: inline; filename=0007-UBIFS-make-space-fixup-work-in-the-remount-case.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.6.11.3 stable review patch.
If anyone has any objections, please let me know.

------------------

From: Artem Bityutskiy <artem.bityutskiy@linux.intel.com>

[ Upstream commit 67e753ca41782913d805ff4a8a2b0f60b26b7915 ]

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
Cc: stable@vger.kernel.org # 3.0+
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 fs/ubifs/super.c |   12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/fs/ubifs/super.c b/fs/ubifs/super.c
index 71a197f..c39f275 100644
--- a/fs/ubifs/super.c
+++ b/fs/ubifs/super.c
@@ -1576,6 +1576,12 @@ static int ubifs_remount_rw(struct ubifs_info *c)
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
@@ -1692,12 +1698,6 @@ static int ubifs_remount_rw(struct ubifs_info *c)
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
1.7.10.4


