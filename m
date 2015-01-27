Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932979AbbA0Mq3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jan 2015 07:46:29 -0500
Received: from szxga01-in.huawei.com ([119.145.14.64]:46710 "EHLO
	szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932483AbbA0MqZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jan 2015 07:46:25 -0500
Message-ID: <54C78879.3010603@huawei.com>
Date: Tue, 27 Jan 2015 20:45:45 +0800
From: Zhang Zhen <zhenzhang.zhang@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:16.0) Gecko/20121010 Thunderbird/16.0.1
MIME-Version: 1.0
To: <linux-fsdevel@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC: Wang Nan <wangnan0@huawei.com>, <eparis@parisplace.org>, <rlove@rlove.org>,
        <john@johnmccutchan.com>
Subject: [RESEND PATCH] inotify: update documentation to reflect code changes
References: <1418785193-31576-1-git-send-email-zhenzhang.zhang@huawei.com>
In-Reply-To: <1418785193-31576-1-git-send-email-zhenzhang.zhang@huawei.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.111.68.57]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The inotify kernel interface was removed by Eric Paris
in this commit: 2dfc1ca inotify: remove inotify in
kernel interface.

Signed-off-by: Zhang Zhen <zhenzhang.zhang@huawei.com>
---
 Documentation/filesystems/inotify.txt | 120 +---------------------------------
 1 file changed, 2 insertions(+), 118 deletions(-)

diff --git a/Documentation/filesystems/inotify.txt b/Documentation/filesystems/inotify.txt
index cfd0271..9b74b45 100644
--- a/Documentation/filesystems/inotify.txt
+++ b/Documentation/filesystems/inotify.txt
@@ -69,123 +69,7 @@ Prototypes:
 	int inotify_rm_watch (int fd, __u32 mask);


-(iii) Kernel Interface
-
-Inotify's kernel API consists a set of functions for managing watches and an
-event callback.
-
-To use the kernel API, you must first initialize an inotify instance with a set
-of inotify_operations.  You are given an opaque inotify_handle, which you use
-for any further calls to inotify.
-
-    struct inotify_handle *ih = inotify_init(my_event_handler);
-
-You must provide a function for processing events and a function for destroying
-the inotify watch.
-
-    void handle_event(struct inotify_watch *watch, u32 wd, u32 mask,
-    	              u32 cookie, const char *name, struct inode *inode)
-
-	watch - the pointer to the inotify_watch that triggered this call
-	wd - the watch descriptor
-	mask - describes the event that occurred
-	cookie - an identifier for synchronizing events
-	name - the dentry name for affected files in a directory-based event
-	inode - the affected inode in a directory-based event
-
-    void destroy_watch(struct inotify_watch *watch)
-
-You may add watches by providing a pre-allocated and initialized inotify_watch
-structure and specifying the inode to watch along with an inotify event mask.
-You must pin the inode during the call.  You will likely wish to embed the
-inotify_watch structure in a structure of your own which contains other
-information about the watch.  Once you add an inotify watch, it is immediately
-subject to removal depending on filesystem events.  You must grab a reference if
-you depend on the watch hanging around after the call.
-
-    inotify_init_watch(&my_watch->iwatch);
-    inotify_get_watch(&my_watch->iwatch);	// optional
-    s32 wd = inotify_add_watch(ih, &my_watch->iwatch, inode, mask);
-    inotify_put_watch(&my_watch->iwatch);	// optional
-
-You may use the watch descriptor (wd) or the address of the inotify_watch for
-other inotify operations.  You must not directly read or manipulate data in the
-inotify_watch.  Additionally, you must not call inotify_add_watch() more than
-once for a given inotify_watch structure, unless you have first called either
-inotify_rm_watch() or inotify_rm_wd().
-
-To determine if you have already registered a watch for a given inode, you may
-call inotify_find_watch(), which gives you both the wd and the watch pointer for
-the inotify_watch, or an error if the watch does not exist.
-
-    wd = inotify_find_watch(ih, inode, &watchp);
-
-You may use container_of() on the watch pointer to access your own data
-associated with a given watch.  When an existing watch is found,
-inotify_find_watch() bumps the refcount before releasing its locks.  You must
-put that reference with:
-
-    put_inotify_watch(watchp);
-
-Call inotify_find_update_watch() to update the event mask for an existing watch.
-inotify_find_update_watch() returns the wd of the updated watch, or an error if
-the watch does not exist.
-
-    wd = inotify_find_update_watch(ih, inode, mask);
-
-An existing watch may be removed by calling either inotify_rm_watch() or
-inotify_rm_wd().
-
-    int ret = inotify_rm_watch(ih, &my_watch->iwatch);
-    int ret = inotify_rm_wd(ih, wd);
-
-A watch may be removed while executing your event handler with the following:
-
-    inotify_remove_watch_locked(ih, iwatch);
-
-Call inotify_destroy() to remove all watches from your inotify instance and
-release it.  If there are no outstanding references, inotify_destroy() will call
-your destroy_watch op for each watch.
-
-    inotify_destroy(ih);
-
-When inotify removes a watch, it sends an IN_IGNORED event to your callback.
-You may use this event as an indication to free the watch memory.  Note that
-inotify may remove a watch due to filesystem events, as well as by your request.
-If you use IN_ONESHOT, inotify will remove the watch after the first event, at
-which point you may call the final inotify_put_watch.
-
-(iv) Kernel Interface Prototypes
-
-	struct inotify_handle *inotify_init(struct inotify_operations *ops);
-
-	inotify_init_watch(struct inotify_watch *watch);
-
-	s32 inotify_add_watch(struct inotify_handle *ih,
-		              struct inotify_watch *watch,
-			      struct inode *inode, u32 mask);
-
-	s32 inotify_find_watch(struct inotify_handle *ih, struct inode *inode,
-			       struct inotify_watch **watchp);
-
-	s32 inotify_find_update_watch(struct inotify_handle *ih,
-				      struct inode *inode, u32 mask);
-
-	int inotify_rm_wd(struct inotify_handle *ih, u32 wd);
-
-	int inotify_rm_watch(struct inotify_handle *ih,
-			     struct inotify_watch *watch);
-
-	void inotify_remove_watch_locked(struct inotify_handle *ih,
-					 struct inotify_watch *watch);
-
-	void inotify_destroy(struct inotify_handle *ih);
-
-	void get_inotify_watch(struct inotify_watch *watch);
-	void put_inotify_watch(struct inotify_watch *watch);
-
-
-(v) Internal Kernel Implementation
+(iii) Internal Kernel Implementation

 Each inotify instance is represented by an inotify_handle structure.
 Inotify's userspace consumers also have an inotify_device which is
@@ -198,7 +82,7 @@ See fs/notify/inotify/inotify_fsnotify.c and fs/notify/inotify/inotify_user.c
 for the locking and lifetime rules.


-(vi) Rationale
+(iv) Rationale

 Q: What is the design decision behind not tying the watch to the open fd of
    the watched object?
-- 
1.8.1.4


.




