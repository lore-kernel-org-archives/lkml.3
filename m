Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757828AbaJIVLF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Oct 2014 17:11:05 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:59559 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757797AbaJIVK6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Oct 2014 17:10:58 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Nicolas Iooss <nicolas.iooss_linux@m4x.org>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        =?UTF-8?q?Arve=20Hj=C3=B8nnev=C3=A5g?= <arve@android.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.13 050/163] eventpoll: fix uninitialized variable in epoll_ctl
Date: Thu,  9 Oct 2014 14:01:15 -0700
Message-Id: <1412888588-26755-51-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1412888588-26755-1-git-send-email-kamal@canonical.com>
References: <1412888588-26755-1-git-send-email-kamal@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Extended-Stable: 3.13
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13.11.9 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Nicolas Iooss <nicolas.iooss_linux@m4x.org>

commit c680e41b3a2e944185c74bf60531e3d316d3ecc4 upstream.

When calling epoll_ctl with operation EPOLL_CTL_DEL, structure epds is
not initialized but ep_take_care_of_epollwakeup reads its event field.
When this unintialized field has EPOLLWAKEUP bit set, a capability check
is done for CAP_BLOCK_SUSPEND in ep_take_care_of_epollwakeup.  This
produces unexpected messages in the audit log, such as (on a system
running SELinux):

    type=AVC msg=audit(1408212798.866:410): avc:  denied
    { block_suspend } for  pid=7754 comm="dbus-daemon" capability=36
    scontext=unconfined_u:unconfined_r:unconfined_t
    tcontext=unconfined_u:unconfined_r:unconfined_t
    tclass=capability2 permissive=1

    type=SYSCALL msg=audit(1408212798.866:410): arch=c000003e syscall=233
    success=yes exit=0 a0=3 a1=2 a2=9 a3=7fffd4d66ec0 items=0 ppid=1
    pid=7754 auid=1000 uid=0 gid=0 euid=0 suid=0 fsuid=0 egid=0 sgid=0
    fsgid=0 tty=(none) ses=3 comm="dbus-daemon"
    exe="/usr/bin/dbus-daemon"
    subj=unconfined_u:unconfined_r:unconfined_t key=(null)

("arch=c000003e syscall=233 a1=2" means "epoll_ctl(op=EPOLL_CTL_DEL)")

Remove use of epds in epoll_ctl when op == EPOLL_CTL_DEL.

Fixes: 4d7e30d98939 ("epoll: Add a flag, EPOLLWAKEUP, to prevent suspend while epoll events are ready")
Signed-off-by: Nicolas Iooss <nicolas.iooss_linux@m4x.org>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: Arve Hjønnevåg <arve@android.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 fs/eventpoll.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/fs/eventpoll.c b/fs/eventpoll.c
index ead0046..f50d79e 100644
--- a/fs/eventpoll.c
+++ b/fs/eventpoll.c
@@ -1852,7 +1852,8 @@ SYSCALL_DEFINE4(epoll_ctl, int, epfd, int, op, int, fd,
 		goto error_tgt_fput;
 
 	/* Check if EPOLLWAKEUP is allowed */
-	ep_take_care_of_epollwakeup(&epds);
+	if (ep_op_has_event(op))
+		ep_take_care_of_epollwakeup(&epds);
 
 	/*
 	 * We have to check that the file structure underneath the file descriptor
-- 
1.9.1

