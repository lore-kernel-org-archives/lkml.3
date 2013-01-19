Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754978Ab3ASCUE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jan 2013 21:20:04 -0500
Received: from mail-pa0-f44.google.com ([209.85.220.44]:43766 "EHLO
	mail-pa0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751070Ab3ASCUD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jan 2013 21:20:03 -0500
From: Namjae Jeon <linkinjeon@gmail.com>
To: hirofumi@mail.parknet.co.jp, akpm@linux-foundation.org
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        Namjae Jeon <linkinjeon@gmail.com>,
        Namjae Jeon <namjae.jeon@samsung.com>,
        Ravishankar N <ravi.n1@samsung.com>
Subject: [PATCH] fat: eliminate iterations in fat_search_long in case of EOD
Date: Sat, 19 Jan 2013 11:19:50 +0900
Message-Id: <1358561990-8216-1-git-send-email-linkinjeon@gmail.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Namjae Jeon <namjae.jeon@samsung.com>

When searching a directory for names, we can stop checking for further
entries if we detect End of Directory, i.e. if (de->name[0] == 0x00).The
current code traverses the cluster chain of a directory until a hit is
found or till the last cluster for that directory, ignoring the EOD mark.
Fix this.

Signed-off-by: Namjae Jeon <namjae.jeon@samsung.com>
Signed-off-by: Ravishankar N <ravi.n1@samsung.com>
---
 fs/fat/dir.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/fat/dir.c b/fs/fat/dir.c
index 58bf744..cde0e69 100644
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
-- 
1.7.9.5

