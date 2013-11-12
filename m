Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756746Ab3KLUwt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Nov 2013 15:52:49 -0500
Received: from mail-pb0-f41.google.com ([209.85.160.41]:52149 "EHLO
	mail-pb0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753864Ab3KLUwj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Nov 2013 15:52:39 -0500
From: Amit Pundir <amit.pundir@linaro.org>
To: =?UTF-8?q?Arve=20Hj=C3=B8nnev=C3=A5g?= <arve@android.com>,
        "Rafael J. Wysocki" <rjw@sisk.pl>,
        Alexander Viro <viro@zeniv.linux.org.uk>
Cc: John Stultz <john.stultz@linaro.org>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Android Kernel Team <kernel-team@android.com>
Subject: [RFC][PATCH v2] epoll: allow EPOLLWAKEUP flag if PM_SLEEP is enabled
Date: Wed, 13 Nov 2013 02:22:28 +0530
Message-Id: <1384289548-26015-1-git-send-email-amit.pundir@linaro.org>
X-Mailer: git-send-email 1.7.10.4
Author: Amit Pundir <amit.pundir@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

ep_create_wakeup_source() reports ENOMEM if wakeup_source_register()
returns NULL. ep_create_wakeup_source() assumes that NULL is only
returned if we run into ENOMEM but NULL is also returned when
CONFIG_PM_SLEEP is disabled.

Signed-off-by: Amit Pundir <amit.pundir@linaro.org>
---
Changed in v2:
Using static inline functions instead of #ifdefs
---
 fs/eventpoll.c                 |    3 +--
 include/uapi/linux/eventpoll.h |   12 ++++++++++++
 2 files changed, 13 insertions(+), 2 deletions(-)

diff --git a/fs/eventpoll.c b/fs/eventpoll.c
index 473e09d..10f9c43 100644
--- a/fs/eventpoll.c
+++ b/fs/eventpoll.c
@@ -1820,8 +1820,7 @@ SYSCALL_DEFINE4(epoll_ctl, int, epfd, int, op, int, fd,
 		goto error_tgt_fput;
 
 	/* Check if EPOLLWAKEUP is allowed */
-	if ((epds.events & EPOLLWAKEUP) && !capable(CAP_BLOCK_SUSPEND))
-		epds.events &= ~EPOLLWAKEUP;
+	ep_epollwakeup_check(&epds.events);
 
 	/*
 	 * We have to check that the file structure underneath the file descriptor
diff --git a/include/uapi/linux/eventpoll.h b/include/uapi/linux/eventpoll.h
index 2c267bc..1d139c2 100644
--- a/include/uapi/linux/eventpoll.h
+++ b/include/uapi/linux/eventpoll.h
@@ -62,4 +62,16 @@ struct epoll_event {
 } EPOLL_PACKED;
 
 
+#ifdef CONFIG_PM_SLEEP
+static inline void ep_epollwakeup_check(__u32 *epev)
+{
+	if ((*epev & EPOLLWAKEUP) && !capable(CAP_BLOCK_SUSPEND))
+		*epev &= ~EPOLLWAKEUP;
+}
+#else
+static inline void ep_epollwakeup_check(__u32 *epev)
+{
+	*epev &= ~EPOLLWAKEUP;
+}
+#endif
 #endif /* _UAPI_LINUX_EVENTPOLL_H */
-- 
1.7.10.4

