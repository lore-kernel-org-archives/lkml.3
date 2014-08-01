Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755320AbaHAQGl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Aug 2014 12:06:41 -0400
Received: from mail-ig0-f169.google.com ([209.85.213.169]:38419 "EHLO
	mail-ig0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755250AbaHAQGj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Aug 2014 12:06:39 -0400
From: Jeff Harris <jefftharris@gmail.com>
X-Google-Original-From: Jeff Harris <jharris@westell.com>
To: David Woodhouse <dwmw2@infradead.org>, linux-mtd@lists.infradead.org,
        linux-kernel@vger.kernel.org
Cc: Jeff Harris <jharris@westell.com>
Subject: [PATCH] jffs2: Re-enable write-buffering after filesystem sync
Date: Fri,  1 Aug 2014 12:06:12 -0400
Message-Id: <1406909172-7219-1-git-send-email-jharris@westell.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

A JFFS2 filesystem sync cancels the write buffering dirty work and performs
the flush manually.  However, the flag which indicates that the work is active
is not reset.  Thus, if a sync happens while the work is pending, the flag
will never be reset resulting in future work never being started.  The flag is
now reset under the appropriate lock along with the timer cancellation.

Tested on 3.13.6.

Signed-off-by: Jeff Harris <jharris@westell.com>
---
 fs/jffs2/super.c |    3 +++
 1 file changed, 3 insertions(+)

diff --git a/fs/jffs2/super.c b/fs/jffs2/super.c
index 0918f0e..263136b 100644
--- a/fs/jffs2/super.c
+++ b/fs/jffs2/super.c
@@ -101,7 +101,10 @@ static int jffs2_sync_fs(struct super_block *sb, int wait)
 	struct jffs2_sb_info *c = JFFS2_SB_INFO(sb);
 
 #ifdef CONFIG_JFFS2_FS_WRITEBUFFER
+	spin_lock(&c->wbuf_dwork_lock);
 	cancel_delayed_work_sync(&c->wbuf_dwork);
+	c->wbuf_queued = 0;
+	spin_lock(&c->wbuf_dwork_lock);
 #endif
 
 	mutex_lock(&c->alloc_sem);
-- 
1.7.9.5

