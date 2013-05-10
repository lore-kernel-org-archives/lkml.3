Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757185Ab3EJOgh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 May 2013 10:36:37 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:57142 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755165Ab3EJOVK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 May 2013 10:21:10 -0400
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org,
        "Linus Torvalds" <torvalds@linux-foundation.org>,
        "Jim Somerville" <Jim.Somerville@windriver.com>,
        "Zhao Hongjiang" <zhaohongjiang@huawei.com>,
        "Eric Paris" <eparis@parisplace.org>,
        "Jerome Marchand" <jmarchan@redhat.com>,
        "Paul Gortmaker" <paul.gortmaker@windriver.com>
Date: Fri, 10 May 2013 14:39:41 +0100
Message-ID: <lsq.1368193181.704230679@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [068/118] inotify: invalid mask should return a error number but
 not set it
In-Reply-To: <lsq.1368193179.973009354@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:d51a:8785:aa0a:cebe
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.45-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Zhao Hongjiang <zhaohongjiang@huawei.com>

commit 04df32fa10ab9a6f0643db2949d42efc966bc844 upstream.

When we run the crackerjack testsuite, the inotify_add_watch test is
stalled.

This is caused by the invalid mask 0 - the task is waiting for the event
but it never comes.  inotify_add_watch() should return -EINVAL as it did
before commit 676a0675cf92 ("inotify: remove broken mask checks causing
unmount to be EINVAL").  That commit removes the invalid mask check, but
that check is needed.

Check the mask's ALL_INOTIFY_BITS before the inotify_arg_to_mask() call.
If none are set, just return -EINVAL.

Because IN_UNMOUNT is in ALL_INOTIFY_BITS, this change will not trigger
the problem that above commit fixed.

[akpm@linux-foundation.org: fix build]
Signed-off-by: Zhao Hongjiang <zhaohongjiang@huawei.com>
Acked-by: Jim Somerville <Jim.Somerville@windriver.com>
Cc: Paul Gortmaker <paul.gortmaker@windriver.com>
Cc: Jerome Marchand <jmarchan@redhat.com>
Cc: Eric Paris <eparis@parisplace.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
[bwh: Backported to 3.2: adjust context]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 fs/notify/inotify/inotify_user.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

--- a/fs/notify/inotify/inotify_user.c
+++ b/fs/notify/inotify/inotify_user.c
@@ -577,7 +577,6 @@ static int inotify_update_existing_watch
 	int add = (arg & IN_MASK_ADD);
 	int ret;
 
-	/* don't allow invalid bits: we don't want flags set */
 	mask = inotify_arg_to_mask(arg);
 
 	fsn_mark = fsnotify_find_inode_mark(group, inode);
@@ -628,7 +627,6 @@ static int inotify_new_watch(struct fsno
 	struct idr *idr = &group->inotify_data.idr;
 	spinlock_t *idr_lock = &group->inotify_data.idr_lock;
 
-	/* don't allow invalid bits: we don't want flags set */
 	mask = inotify_arg_to_mask(arg);
 
 	tmp_i_mark = kmem_cache_alloc(inotify_inode_mark_cachep, GFP_KERNEL);
@@ -757,6 +755,10 @@ SYSCALL_DEFINE3(inotify_add_watch, int,
 	int ret, fput_needed;
 	unsigned flags = 0;
 
+	/* don't allow invalid bits: we don't want flags set */
+	if (unlikely(!(mask & ALL_INOTIFY_BITS)))
+		return -EINVAL;
+
 	filp = fget_light(fd, &fput_needed);
 	if (unlikely(!filp))
 		return -EBADF;

