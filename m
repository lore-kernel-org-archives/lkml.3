Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752545Ab3EJJYq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 May 2013 05:24:46 -0400
Received: from mx1.redhat.com ([209.132.183.28]:25945 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752032Ab3EJJYp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 May 2013 05:24:45 -0400
From: Cong Wang <amwang@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>, Jan Kara <jack@suse.cz>,
        Cong Wang <amwang@redhat.com>
Subject: [Patch] quota: do not leak info to user-space
Date: Fri, 10 May 2013 17:24:33 +0800
Message-Id: <1368177873-4819-1-git-send-email-amwang@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Cong Wang <amwang@redhat.com>

There is a hole in struct fs_quota_stat, so we have to
zero the struct on stack before copying it to user-space.

Cc: Jan Kara <jack@suse.cz>
Signed-off-by: Cong Wang <amwang@redhat.com>

---
diff --git a/fs/quota/quota.c b/fs/quota/quota.c
index c7314f1..2b0c182 100644
--- a/fs/quota/quota.c
+++ b/fs/quota/quota.c
@@ -211,6 +211,7 @@ static int quota_getxstate(struct super_block *sb, void __user *addr)
 
 	if (!sb->s_qcop->get_xstate)
 		return -ENOSYS;
+	memset(&fqs, 0, sizeof(fqs));
 	ret = sb->s_qcop->get_xstate(sb, &fqs);
 	if (!ret && copy_to_user(addr, &fqs, sizeof(fqs)))
 		return -EFAULT;
