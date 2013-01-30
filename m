Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754578Ab3A3NrP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jan 2013 08:47:15 -0500
Received: from mail-pa0-f42.google.com ([209.85.220.42]:61068 "EHLO
	mail-pa0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754183Ab3A3NrL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jan 2013 08:47:11 -0500
From: Namjae Jeon <linkinjeon@gmail.com>
To: jaegeuk.kim@samsung.com
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-f2fs-devel@lists.sourceforge.net,
        Namjae Jeon <linkinjeon@gmail.com>,
        Namjae Jeon <namjae.jeon@samsung.com>,
        Amit Sahrawat <a.sahrawat@samsung.com>
Subject: [PATCH 1/3] f2fs: avoid redundant call to has_not_enough_free_secs in f2fs_gc
Date: Wed, 30 Jan 2013 22:47:02 +0900
Message-Id: <1359553622-7449-1-git-send-email-linkinjeon@gmail.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Namjae Jeon <namjae.jeon@samsung.com>

After doing a write_checkpoint from garbage collection path if there is still
need to do more garbage collection, gc_more label is used to jump and start
the process again. And in that process, first step before getting victim is to
check if there are not enough free sections, which is already done before
doing a jump to gc_more. We can avoid the redundant call to check free
sections, by checking the gc_type flag which will remain FG_GC(value 1) under
this condition.

Signed-off-by: Namjae Jeon <namjae.jeon@samsung.com>
Signed-off-by: Amit Sahrawat <a.sahrawat@samsung.com>
---
 fs/f2fs/gc.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/f2fs/gc.c b/fs/f2fs/gc.c
index 9b5d0aa..0dfdaa5 100644
--- a/fs/f2fs/gc.c
+++ b/fs/f2fs/gc.c
@@ -672,7 +672,7 @@ gc_more:
 	if (!(sbi->sb->s_flags & MS_ACTIVE))
 		goto stop;
 
-	if (has_not_enough_free_secs(sbi))
+	if (!gc_type && has_not_enough_free_secs(sbi))
 		gc_type = FG_GC;
 
 	if (!__get_victim(sbi, &segno, gc_type, NO_CHECK_TYPE))
-- 
1.7.9.5

