Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755031Ab3KKR44 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Nov 2013 12:56:56 -0500
Received: from mail-pb0-f42.google.com ([209.85.160.42]:56920 "EHLO
	mail-pb0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754167Ab3KKR4s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Nov 2013 12:56:48 -0500
From: Amit Pundir <amit.pundir@linaro.org>
To: =?UTF-8?q?Arve=20Hj=C3=B8nnev=C3=A5g?= <arve@android.com>,
        "Rafael J. Wysocki" <rjw@sisk.pl>,
        Alexander Viro <viro@zeniv.linux.org.uk>
Cc: John Stultz <john.stultz@linaro.org>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Android Kernel Team <kernel-team@android.com>
Subject: [RFC][PATCH] epoll: allow EPOLLWAKEUP flag if PM_SLEEP is enabled
Date: Mon, 11 Nov 2013 23:26:31 +0530
Message-Id: <1384192591-20916-1-git-send-email-amit.pundir@linaro.org>
X-Mailer: git-send-email 1.7.10.4
Author: Amit Pundir <amit.pundir@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I stumbled upon ENOMEM error from epoll_ctl() while bringing up Android-4.4 
on a device that does not yet support PM_SLEEP.

While looking into the problem, I found that ep_create_wakeup_source()
reports ENOMEM if wakeup_source_register() returns NULL.
ep_create_wakeup_source() assumes that NULL is only returned if we run
into ENOMEM but NULL is also returned when CONFIG_PM_SLEEP is disabled.

If CONFIG_PM_SLEEP is disabled, stripping the EPOLLWAKEUP flag seems to
be a reasonable solution here, allowing the call to succeed, while
dropping the wakeup logic.  While returning EINVAL might also be a good
solution, stripping the flag seems to follow the established behavior,
as is done when the process doesn't have sufficient capabilities to
block suspend.

I'd appreciate any thoughts or feedback!

Signed-off-by: Amit Pundir <amit.pundir@linaro.org>
---
 fs/eventpoll.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/fs/eventpoll.c b/fs/eventpoll.c
index 473e09d..7a83079 100644
--- a/fs/eventpoll.c
+++ b/fs/eventpoll.c
@@ -1820,7 +1820,8 @@ SYSCALL_DEFINE4(epoll_ctl, int, epfd, int, op, int, fd,
 		goto error_tgt_fput;
 
 	/* Check if EPOLLWAKEUP is allowed */
-	if ((epds.events & EPOLLWAKEUP) && !capable(CAP_BLOCK_SUSPEND))
+	if ((epds.events & EPOLLWAKEUP) &&
+		(!capable(CAP_BLOCK_SUSPEND) || !IS_ENABLED(CONFIG_PM_SLEEP)))
 		epds.events &= ~EPOLLWAKEUP;
 
 	/*
-- 
1.7.10.4

