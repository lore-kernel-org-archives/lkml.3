Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753080Ab3FYSgy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Jun 2013 14:36:54 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:41321 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753173Ab3FYSgI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Jun 2013 14:36:08 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Zhao Hongjiang <zhaohongjiang@huawei.com>,
        Jim Somerville <Jim.Somerville@windriver.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Jerome Marchand <jmarchan@redhat.com>,
        Eric Paris <eparis@parisplace.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [ 27/27] inotify: invalid mask should return a error number but not set it
Date: Tue, 25 Jun 2013 11:35:46 -0700
Message-Id: <20130625183520.815554051@linuxfoundation.org>
X-Mailer: git-send-email 1.8.3.rc0.20.gb99dd2e
In-Reply-To: <20130625183517.651770593@linuxfoundation.org>
References: <20130625183517.651770593@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>


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


