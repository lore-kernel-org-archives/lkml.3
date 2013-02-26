Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760166Ab3BZX5f (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Feb 2013 18:57:35 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:41880 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760130Ab3BZX5a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Feb 2013 18:57:30 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Jim Somerville <Jim.Somerville@windriver.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Jerome Marchand <jmarchan@redhat.com>,
        John McCutchan <john@johnmccutchan.com>, Robert Love <rlove@rlove.org>,
        Eric Paris <eparis@parisplace.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [ 036/150] inotify: remove broken mask checks causing unmount to be EINVAL
Date: Tue, 26 Feb 2013 15:54:53 -0800
Message-Id: <20130226235527.951790876@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.rc1.5.g7e0651a
In-Reply-To: <20130226235523.930663721@linuxfoundation.org>
References: <20130226235523.930663721@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jim Somerville <Jim.Somerville@windriver.com>

commit 676a0675cf9200ac047fb50825f80867b3bb733b upstream.

Running the command:

	inotifywait -e unmount /mnt/disk

immediately aborts with a -EINVAL return code.  This is however a valid
parameter.  This abort occurs only if unmount is the sole event
parameter.  If other event parameters are supplied, then the unmount
event wait will work.

The problem was introduced by commit 44b350fc23e ("inotify: Fix mask
checks").  In that commit, it states:

	The mask checks in inotify_update_existing_watch() and
	inotify_new_watch() are useless because inotify_arg_to_mask()
	sets FS_IN_IGNORED and FS_EVENT_ON_CHILD bits anyway.

But instead of removing the useless checks, it did this:

	        mask = inotify_arg_to_mask(arg);
	-       if (unlikely(!mask))
	+       if (unlikely(!(mask & IN_ALL_EVENTS)))
	                return -EINVAL;

The problem is that IN_ALL_EVENTS doesn't include IN_UNMOUNT, and other
parts of the code keep IN_UNMOUNT separate from IN_ALL_EVENTS.  So the
check should be:

	if (unlikely(!(mask & (IN_ALL_EVENTS | IN_UNMOUNT))))

But inotify_arg_to_mask(arg) always sets the IN_UNMOUNT bit in the mask
anyway, so the check is always going to pass and thus should simply be
removed.  Also note that inotify_arg_to_mask completely controls what
mask bits get set from arg, there's no way for invalid bits to get
enabled there.

Lets fix it by simply removing the useless broken checks.

Signed-off-by: Jim Somerville <Jim.Somerville@windriver.com>
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
Cc: Jerome Marchand <jmarchan@redhat.com>
Cc: John McCutchan <john@johnmccutchan.com>
Cc: Robert Love <rlove@rlove.org>
Cc: Eric Paris <eparis@parisplace.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/notify/inotify/inotify_user.c |    4 ----
 1 file changed, 4 deletions(-)

--- a/fs/notify/inotify/inotify_user.c
+++ b/fs/notify/inotify/inotify_user.c
@@ -576,8 +576,6 @@ static int inotify_update_existing_watch
 
 	/* don't allow invalid bits: we don't want flags set */
 	mask = inotify_arg_to_mask(arg);
-	if (unlikely(!(mask & IN_ALL_EVENTS)))
-		return -EINVAL;
 
 	fsn_mark = fsnotify_find_inode_mark(group, inode);
 	if (!fsn_mark)
@@ -629,8 +627,6 @@ static int inotify_new_watch(struct fsno
 
 	/* don't allow invalid bits: we don't want flags set */
 	mask = inotify_arg_to_mask(arg);
-	if (unlikely(!(mask & IN_ALL_EVENTS)))
-		return -EINVAL;
 
 	tmp_i_mark = kmem_cache_alloc(inotify_inode_mark_cachep, GFP_KERNEL);
 	if (unlikely(!tmp_i_mark))


