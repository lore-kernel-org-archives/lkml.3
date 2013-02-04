Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755793Ab3BDOoD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Feb 2013 09:44:03 -0500
Received: from mail-pa0-f52.google.com ([209.85.220.52]:58470 "EHLO
	mail-pa0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753637Ab3BDOoA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Feb 2013 09:44:00 -0500
From: Namjae Jeon <linkinjeon@gmail.com>
To: hirofumi@mail.parknet.co.jp, akpm@linux-foundation.org
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        Namjae Jeon <linkinjeon@gmail.com>,
        Namjae Jeon <namjae.jeon@samsung.com>,
        Ravishankar N <ravi.n1@samsung.com>
Subject: [PATCH v2] fat: eliminate iterations in fat_search_long and __fat_readdir in case of EOD
Date: Mon,  4 Feb 2013 23:43:47 +0900
Message-Id: <1359989028-7457-1-git-send-email-linkinjeon@gmail.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Namjae Jeon <namjae.jeon@samsung.com>

When doing lookups via fat_search_long(), we can stop checking for
further entries if we detect End of Directory, i.e. if (de->name[0] ==
0x00).The current code traverses the cluster chain of a directory until a hit
is found or till the last cluster for that directory, ignoring the EOD
mark. Fix this.

Likewise,when readdir(3) is called, we can stop checking for further
entries in __fat_readdir() when we hit EOD.

Signed-off-by: Namjae Jeon <namjae.jeon@samsung.com>
Signed-off-by: Ravishankar N <ravi.n1@samsung.com>
---
 fs/fat/dir.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/fs/fat/dir.c b/fs/fat/dir.c
index 58bf744..78dabf00 100644
--- a/fs/fat/dir.c
+++ b/fs/fat/dir.c
@@ -484,10 +484,10 @@ parse_record:
 		nr_slots = 0;
 		if (de->name[0] == DELETED_FLAG)
 			continue;
+		if (!de->name[0])
+			goto end_of_dir;
 		if (de->attr != ATTR_EXT && (de->attr & ATTR_VOLUME))
 			continue;
-		if (de->attr != ATTR_EXT && IS_FREE(de->name))
-			continue;
 		if (de->attr == ATTR_EXT) {
 			int status = fat_parse_long(inode, &cpos, &bh, &de,
 						    &unicode, &nr_slots);
@@ -608,8 +608,8 @@ parse_record:
 			goto record_end;
 		if (de->attr != ATTR_EXT && (de->attr & ATTR_VOLUME))
 			goto record_end;
-		if (de->attr != ATTR_EXT && IS_FREE(de->name))
-			goto record_end;
+		if (!de->name[0])
+			goto end_of_dir;
 	} else {
 		if ((de->attr & ATTR_VOLUME) || IS_FREE(de->name))
 			goto record_end;
-- 
1.7.9.5

