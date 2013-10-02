Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754562Ab3JBOgt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Oct 2013 10:36:49 -0400
Received: from cantor2.suse.de ([195.135.220.15]:48984 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752949Ab3JBO25 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Oct 2013 10:28:57 -0400
From: Jan Kara <jack@suse.cz>
To: LKML <linux-kernel@vger.kernel.org>
Cc: linux-mm@kvack.org, Jan Kara <jack@suse.cz>, linux-scsi@vger.kernel.org,
        Kai Makisara <Kai.Makisara@kolumbus.fi>
Subject: [PATCH 07/26] st: Convert sgl_map_user_pages() to use get_user_pages_fast()
Date: Wed,  2 Oct 2013 16:27:48 +0200
Message-Id: <1380724087-13927-8-git-send-email-jack@suse.cz>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1380724087-13927-1-git-send-email-jack@suse.cz>
References: <1380724087-13927-1-git-send-email-jack@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

CC: linux-scsi@vger.kernel.org
CC: Kai Makisara <Kai.Makisara@kolumbus.fi>
Signed-off-by: Jan Kara <jack@suse.cz>
---
 drivers/scsi/st.c | 18 +++++-------------
 1 file changed, 5 insertions(+), 13 deletions(-)

diff --git a/drivers/scsi/st.c b/drivers/scsi/st.c
index ff44b3c2cff2..ba11299c3740 100644
--- a/drivers/scsi/st.c
+++ b/drivers/scsi/st.c
@@ -4514,19 +4514,11 @@ static int sgl_map_user_pages(struct st_buffer *STbp,
 	if ((pages = kmalloc(max_pages * sizeof(*pages), GFP_KERNEL)) == NULL)
 		return -ENOMEM;
 
-        /* Try to fault in all of the necessary pages */
-	down_read(&current->mm->mmap_sem);
-        /* rw==READ means read from drive, write into memory area */
-	res = get_user_pages(
-		current,
-		current->mm,
-		uaddr,
-		nr_pages,
-		rw == READ,
-		0, /* don't force */
-		pages,
-		NULL);
-	up_read(&current->mm->mmap_sem);
+        /*
+	 * Try to fault in all of the necessary pages. rw==READ means read
+	 * from drive, write into memory area.
+	 */
+	res = get_user_pages_fast(uaddr, nr_pages, rw == READ, pages);
 
 	/* Errors and no page mapped should return here */
 	if (res < nr_pages)
-- 
1.8.1.4

