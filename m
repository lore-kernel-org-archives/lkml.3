Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752291AbaIJO3E (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Sep 2014 10:29:04 -0400
Received: from mail-qg0-f52.google.com ([209.85.192.52]:51605 "EHLO
	mail-qg0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752137AbaIJO3B (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Sep 2014 10:29:01 -0400
From: Jeff Layton <jlayton@primarydata.com>
To: linux-fsdevel@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Al Viro <viro@ZenIV.linux.org.uk>,
        Christoph Hellwig <hch@infradead.org>, bfields@fieldses.org
Subject: [RFC PATCH 02/12] locks: add new struct list_head to struct file_lock
Date: Wed, 10 Sep 2014 10:28:40 -0400
Message-Id: <1410359330-27564-3-git-send-email-jlayton@primarydata.com>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1410359330-27564-1-git-send-email-jlayton@primarydata.com>
References: <1410359330-27564-1-git-send-email-jlayton@primarydata.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

...that we can use to queue file_locks to per-ctx list_heads

Signed-off-by: Jeff Layton <jlayton@primarydata.com>
---
 fs/locks.c         | 6 +++---
 include/linux/fs.h | 1 +
 2 files changed, 4 insertions(+), 3 deletions(-)

diff --git a/fs/locks.c b/fs/locks.c
index 6aa36bf21cc9..af55bd35be5f 100644
--- a/fs/locks.c
+++ b/fs/locks.c
@@ -292,8 +292,8 @@ locks_dispose_list(struct list_head *dispose)
 	struct file_lock *fl;
 
 	while (!list_empty(dispose)) {
-		fl = list_first_entry(dispose, struct file_lock, fl_block);
-		list_del_init(&fl->fl_block);
+		fl = list_first_entry(dispose, struct file_lock, fl_list);
+		list_del_init(&fl->fl_list);
 		locks_free_lock(fl);
 	}
 }
@@ -726,7 +726,7 @@ static void locks_delete_lock(struct file_lock **thisfl_p,
 
 	locks_unlink_lock(thisfl_p);
 	if (dispose)
-		list_add(&fl->fl_block, dispose);
+		list_add(&fl->fl_list, dispose);
 	else
 		locks_free_lock(fl);
 }
diff --git a/include/linux/fs.h b/include/linux/fs.h
index 090212e26d12..303dfcd3b663 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -904,6 +904,7 @@ int locks_in_grace(struct net *);
  */
 struct file_lock {
 	struct file_lock *fl_next;	/* singly linked list for this inode  */
+	struct list_head fl_list;	/* link into file_lock_context */
 	struct hlist_node fl_link;	/* node in global lists */
 	struct list_head fl_block;	/* circular list of blocked processes */
 	fl_owner_t fl_owner;
-- 
1.9.3

