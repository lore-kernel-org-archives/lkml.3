Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757864Ab3KOH11 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Nov 2013 02:27:27 -0500
Received: from mail-pa0-f54.google.com ([209.85.220.54]:43661 "EHLO
	mail-pa0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757004Ab3KOH0m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Nov 2013 02:26:42 -0500
From: Amit Pundir <amit.pundir@linaro.org>
To: "Rafael J. Wysocki" <rjw@sisk.pl>,
        =?UTF-8?q?Arve=20Hj=C3=B8nnev=C3=A5g?= <arve@android.com>,
        Alexander Viro <viro@zeniv.linux.org.uk>
Cc: John Stultz <john.stultz@linaro.org>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Android Kernel Team <kernel-team@android.com>
Subject: [PATCH v3] epoll: drop EPOLLWAKEUP if PM_SLEEP is disabled
Date: Fri, 15 Nov 2013 12:56:31 +0530
Message-Id: <1384500391-20513-1-git-send-email-amit.pundir@linaro.org>
X-Mailer: git-send-email 1.7.10.4
Author: Amit Pundir <amit.pundir@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Drop EPOLLWAKEUP from epoll events mask if CONFIG_PM_SLEEP is disabled.

Signed-off-by: Amit Pundir <amit.pundir@linaro.org>
---
Changes in v3:
 Renamed ep_epollwakeup_check() to ep_take_care_of_epollwakeup().
 Didn't update ep_create_wakeup_source() to return -ENOSYS if PM_SLEEP is unset.
---
 fs/eventpoll.c                 |    3 +--
 include/uapi/linux/eventpoll.h |   13 ++++++++++++-
 2 files changed, 13 insertions(+), 3 deletions(-)

diff --git a/fs/eventpoll.c b/fs/eventpoll.c
index 473e09d..dbf382b 100644
--- a/fs/eventpoll.c
+++ b/fs/eventpoll.c
@@ -1820,8 +1820,7 @@ SYSCALL_DEFINE4(epoll_ctl, int, epfd, int, op, int, fd,
 		goto error_tgt_fput;
 
 	/* Check if EPOLLWAKEUP is allowed */
-	if ((epds.events & EPOLLWAKEUP) && !capable(CAP_BLOCK_SUSPEND))
-		epds.events &= ~EPOLLWAKEUP;
+	ep_take_care_of_epollwakeup(&epds);
 
 	/*
 	 * We have to check that the file structure underneath the file descriptor
diff --git a/include/uapi/linux/eventpoll.h b/include/uapi/linux/eventpoll.h
index 2c267bc..bc81fb2 100644
--- a/include/uapi/linux/eventpoll.h
+++ b/include/uapi/linux/eventpoll.h
@@ -61,5 +61,16 @@ struct epoll_event {
 	__u64 data;
 } EPOLL_PACKED;
 
-
+#ifdef CONFIG_PM_SLEEP
+static inline void ep_take_care_of_epollwakeup(struct epoll_event *epev)
+{
+	if ((epev->events & EPOLLWAKEUP) && !capable(CAP_BLOCK_SUSPEND))
+		epev->events &= ~EPOLLWAKEUP;
+}
+#else
+static inline void ep_take_care_of_epollwakeup(struct epoll_event *epev)
+{
+	epev->events &= ~EPOLLWAKEUP;
+}
+#endif
 #endif /* _UAPI_LINUX_EVENTPOLL_H */
-- 
1.7.10.4

