Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753367AbaHLOt6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Aug 2014 10:49:58 -0400
Received: from mail-qa0-f48.google.com ([209.85.216.48]:58579 "EHLO
	mail-qa0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753075AbaHLOsV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Aug 2014 10:48:21 -0400
From: Jeff Layton <jlayton@primarydata.com>
To: linux-fsdevel@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, linux-nfs@vger.kernel.org
Subject: [PATCH 1/5] locks: don't call locks_release_private from locks_copy_lock
Date: Tue, 12 Aug 2014 10:48:09 -0400
Message-Id: <1407854893-2698-2-git-send-email-jlayton@primarydata.com>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1407854893-2698-1-git-send-email-jlayton@primarydata.com>
References: <1407854893-2698-1-git-send-email-jlayton@primarydata.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

All callers of locks_copy_lock pass in a brand new file_lock struct, so
there's no need to calls locks_release_private on it. Replace that with
a warning that fires in the event that we receive a target lock that
doesn't look like it's properly initialized.

Signed-off-by: Jeff Layton <jlayton@primarydata.com>
---
 fs/locks.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/fs/locks.c b/fs/locks.c
index 356667a434c1..2c2d4f5022a7 100644
--- a/fs/locks.c
+++ b/fs/locks.c
@@ -285,7 +285,8 @@ EXPORT_SYMBOL(__locks_copy_lock);
 
 void locks_copy_lock(struct file_lock *new, struct file_lock *fl)
 {
-	locks_release_private(new);
+	/* "new" must be a freshly-initialized lock */
+	WARN_ON_ONCE(new->fl_ops);
 
 	__locks_copy_lock(new, fl);
 	new->fl_file = fl->fl_file;
-- 
1.9.3

