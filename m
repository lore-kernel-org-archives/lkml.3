Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752805AbaBCCXx (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Feb 2014 21:23:53 -0500
Received: from mail-pd0-f181.google.com ([209.85.192.181]:47229 "EHLO
	mail-pd0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752675AbaBCCXU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Feb 2014 21:23:20 -0500
From: Nathaniel Yazdani <n1ght.4nd.d4y@gmail.com>
To: viro@zeniv.linux.org.uk
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        Nathaniel Yazdani <n1ght.4nd.d4y@gmail.com>
Subject: [RFC PATCH 2/3] epoll: add struct epoll & ioctl() commands
Date: Sun,  2 Feb 2014 18:17:11 -0800
Message-Id: <1391393832-8754-3-git-send-email-n1ght.4nd.d4y@gmail.com>
X-Mailer: git-send-email 1.8.4.5
In-Reply-To: <1391393832-8754-1-git-send-email-n1ght.4nd.d4y@gmail.com>
References: <1391393832-8754-1-git-send-email-n1ght.4nd.d4y@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add a new 'struct epoll' to the userspace eventpoll interface. Buffers
supplied to read() & write() calls on eventpolls are interpreted as
arrays of this structure. The new structure's only functional difference
from epoll_event is it also holds the associated file descriptor (needed
for write() to properly create events but useful information in general).
Also define the ioctl() command macros to set & get the timeout of an
eventpoll.

Signed-off-by: Nathaniel Yazdani <n1ght.4nd.d4y@gmail.com>
---
diff --git a/include/uapi/linux/eventpoll.h b/include/uapi/linux/eventpoll.h
index bc81fb2..73f817c 100644
--- a/include/uapi/linux/eventpoll.h
+++ b/include/uapi/linux/eventpoll.h
@@ -56,11 +56,21 @@
 #define EPOLL_PACKED
 #endif
 
+/* ioctl() requests */
+#define EPIOC_GETTIMEOUT	_IOR('$', 0x10, int)
+#define EPIOC_SETTIMEOUT	_IOW('$', 0x11, int)
+
 struct epoll_event {
 	__u32 events;
 	__u64 data;
 } EPOLL_PACKED;
 
+struct epoll {
+	int ep_fildes; /* file descriptor */
+	int ep_events; /* triggering events */
+	long long ep_ident; /* entry ID (cf. epoll_event->data) */
+} EPOLL_PACKED; /* A.K.A. "epe" for "eventpoll entry" */
+
 #ifdef CONFIG_PM_SLEEP
 static inline void ep_take_care_of_epollwakeup(struct epoll_event *epev)
 {
