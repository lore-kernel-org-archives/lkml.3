Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759497Ab3EBBgo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 May 2013 21:36:44 -0400
Received: from mail-ye0-f202.google.com ([209.85.213.202]:50427 "EHLO
	mail-ye0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758865Ab3EBBfT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 May 2013 21:35:19 -0400
From: Colin Cross <ccross@android.com>
To: linux-pm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, "Rafael J. Wysocki" <rjw@sisk.pl>,
        arve@android.com, Tejun Heo <tj@kernel.org>,
        Oleg Nesterov <oleg@redhat.com>, Colin Cross <ccross@android.com>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        linux-fsdevel@vger.kernel.org
Subject: [PATCH v2 05/10] epoll: use freezable blocking call
Date: Wed,  1 May 2013 18:35:03 -0700
Message-Id: <1367458508-9133-6-git-send-email-ccross@android.com>
X-Mailer: git-send-email 1.8.2.1
In-Reply-To: <1367458508-9133-1-git-send-email-ccross@android.com>
References: <1367458508-9133-1-git-send-email-ccross@android.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Avoid waking up every thread sleeping in an epoll_wait call during
suspend and resume by calling a freezable blocking call.  Previous
patches modified the freezer to avoid sending wakeups to threads
that are blocked in freezable blocking calls.

This call was selected to be converted to a freezable call because
it doesn't hold any locks or release any resources when interrupted
that might be needed by another freezing task or a kernel driver
during suspend, and is a common site where idle userspace tasks are
blocked.

Signed-off-by: Colin Cross <ccross@android.com>
---
 fs/eventpoll.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/fs/eventpoll.c b/fs/eventpoll.c
index 9fec183..65245e7 100644
--- a/fs/eventpoll.c
+++ b/fs/eventpoll.c
@@ -34,6 +34,7 @@
 #include <linux/mutex.h>
 #include <linux/anon_inodes.h>
 #include <linux/device.h>
+#include <linux/freezer.h>
 #include <asm/uaccess.h>
 #include <asm/io.h>
 #include <asm/mman.h>
@@ -1543,7 +1544,8 @@ fetch_events:
 			}
 
 			spin_unlock_irqrestore(&ep->lock, flags);
-			if (!schedule_hrtimeout_range(to, slack, HRTIMER_MODE_ABS))
+			if (!freezable_schedule_hrtimeout_range(to, slack,
+								HRTIMER_MODE_ABS))
 				timed_out = 1;
 
 			spin_lock_irqsave(&ep->lock, flags);
-- 
1.8.2.1

