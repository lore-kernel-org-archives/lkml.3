Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751316Ab3AYUCA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jan 2013 15:02:00 -0500
Received: from mail.windriver.com ([147.11.1.11]:42780 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751074Ab3AYUB6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jan 2013 15:01:58 -0500
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: linux-kernel@vger.kernel.org
Cc: Jim Somerville <Jim.Somerville@windriver.com>,
        Jerome Marchand <jmarchan@redhat.com>,
        John McCutchan <john@johnmccutchan.com>, Robert Love <rlove@rlove.org>,
        Eric Paris <eparis@parisplace.org>, stable <stable@vger.kernel.org>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: [PATCH] inotify: Remove broken mask checks causing unmount to be EINVAL
Date: Fri, 25 Jan 2013 15:01:28 -0500
Message-Id: <1359144088-23869-1-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.8.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jim Somerville <Jim.Somerville@windriver.com>

Running the command:

	inotifywait -e unmount /mnt/disk

immediately aborts with a -EINVAL return code.  This is however
a valid parameter.  This abort occurs only if unmount is the
sole event parameter.  If other event parameters are supplied,
then the unmount event wait will work.

The problem was introduced by commit 44b350fc23e36e95c8e042b7ded
("inotify: Fix mask checks").  In that commit, it states:

	The mask checks in inotify_update_existing_watch() and
	inotify_new_watch() are useless because inotify_arg_to_mask()
	sets FS_IN_IGNORED and FS_EVENT_ON_CHILD bits anyway.

But instead of removing the useless checks, it did this:

	        mask = inotify_arg_to_mask(arg);
	-       if (unlikely(!mask))
	+       if (unlikely(!(mask & IN_ALL_EVENTS)))
	                return -EINVAL;

The problem is that IN_ALL_EVENTS doesn't include IN_UNMOUNT, and
other parts of the code keep IN_UNMOUNT separate from IN_ALL_EVENTS.
So the check should be:

	if (unlikely(!(mask & (IN_ALL_EVENTS | IN_UNMOUNT))))

But inotify_arg_to_mask(arg) always sets the IN_UNMOUNT bit in the mask
anyway, so the check is always going to pass and thus should simply
be removed.  Also note that inotify_arg_to_mask completely controls
what mask bits get set from arg, there's no way for invalid bits to
get enabled there.

Lets fix it by simply removing the useless broken checks.

Cc: Jerome Marchand <jmarchan@redhat.com>
Cc: John McCutchan <john@johnmccutchan.com>
Cc: Robert Love <rlove@rlove.org>
Cc: Eric Paris <eparis@parisplace.org>
Cc: stable <stable@vger.kernel.org>  # 2.6.37+
Signed-off-by: Jim Somerville <Jim.Somerville@windriver.com>
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 fs/notify/inotify/inotify_user.c | 4 ----
 1 file changed, 4 deletions(-)

diff --git a/fs/notify/inotify/inotify_user.c b/fs/notify/inotify/inotify_user.c
index 228a2c2..07f7a92 100644
--- a/fs/notify/inotify/inotify_user.c
+++ b/fs/notify/inotify/inotify_user.c
@@ -576,8 +576,6 @@ static int inotify_update_existing_watch(struct fsnotify_group *group,
 
 	/* don't allow invalid bits: we don't want flags set */
 	mask = inotify_arg_to_mask(arg);
-	if (unlikely(!(mask & IN_ALL_EVENTS)))
-		return -EINVAL;
 
 	fsn_mark = fsnotify_find_inode_mark(group, inode);
 	if (!fsn_mark)
@@ -629,8 +627,6 @@ static int inotify_new_watch(struct fsnotify_group *group,
 
 	/* don't allow invalid bits: we don't want flags set */
 	mask = inotify_arg_to_mask(arg);
-	if (unlikely(!(mask & IN_ALL_EVENTS)))
-		return -EINVAL;
 
 	tmp_i_mark = kmem_cache_alloc(inotify_inode_mark_cachep, GFP_KERNEL);
 	if (unlikely(!tmp_i_mark))
-- 
1.8.1

