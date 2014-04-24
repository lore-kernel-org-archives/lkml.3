Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758379AbaDXRPe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Apr 2014 13:15:34 -0400
Received: from mx1.redhat.com ([209.132.183.28]:54997 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755854AbaDXRP1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Apr 2014 13:15:27 -0400
From: Will Woods <wwoods@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Jan Kara <jack@suse.cz>, Eric Paris <eparis@redhat.com>
Subject: [PATCH 1/1] fanotify: fix -EOVERFLOW with large files on 64-bit
Date: Thu, 24 Apr 2014 13:15:24 -0400
Message-Id: <1398359724-10057-1-git-send-email-wwoods@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 64-bit systems, O_LARGEFILE is automatically added to flags inside
the open() syscall (also openat(), blkdev_open(), etc).
Userspace therefore defines O_LARGEFILE to be 0 - you can use it,
but it's a no-op. Everything should be O_LARGEFILE by default.

But: when fanotify does create_fd() it uses dentry_open(), which skips
all that. And userspace can't set O_LARGEFILE in fanotify_init() because
it's defined to 0. So if fanotify gets an event regarding a large file,
the read() will just fail with -EOVERFLOW.

This patch adds O_LARGEFILE to fanotify_init()'s event_f_flags on 64-bit
systems, using the same test as open()/openat()/etc.

Resolves: https://bugzilla.redhat.com/show_bug.cgi?id=696821

Acked-by: Eric Paris <eparis@redhat.com>
Signed-off-by: Will Woods <wwoods@redhat.com>
---
 fs/notify/fanotify/fanotify_user.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/fs/notify/fanotify/fanotify_user.c b/fs/notify/fanotify/fanotify_user.c
index 4e565c8..732648b 100644
--- a/fs/notify/fanotify/fanotify_user.c
+++ b/fs/notify/fanotify/fanotify_user.c
@@ -698,6 +698,8 @@ SYSCALL_DEFINE2(fanotify_init, unsigned int, flags, unsigned int, event_f_flags)
 	}
 	group->overflow_event = &oevent->fse;
 
+	if (force_o_largefile())
+		event_f_flags |= O_LARGEFILE;
 	group->fanotify_data.f_flags = event_f_flags;
 #ifdef CONFIG_FANOTIFY_ACCESS_PERMISSIONS
 	spin_lock_init(&group->fanotify_data.access_lock);
-- 
1.9.0

