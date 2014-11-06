Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752432AbaKFWlL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Nov 2014 17:41:11 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:58685 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752151AbaKFWlG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Nov 2014 17:41:06 -0500
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Mathias Krause <minipli@googlemail.com>, Oleg Nesterov <oleg@redhat.com>,
        Brad Spengler <spender@grsecurity.net>,
        PaX Team <pageexec@freemail.hu>, Thomas Gleixner <tglx@linutronix.de>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.13 138/162] posix-timers: Fix stack info leak in timer_create()
Date: Thu,  6 Nov 2014 14:36:42 -0800
Message-Id: <1415313426-9622-139-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1415313426-9622-1-git-send-email-kamal@canonical.com>
References: <1415313426-9622-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.13
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13.11.11 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mathias Krause <minipli@googlemail.com>

commit 6891c4509c792209c44ced55a60f13954cb50ef4 upstream.

If userland creates a timer without specifying a sigevent info, we'll
create one ourself, using a stack local variable. Particularly will we
use the timer ID as sival_int. But as sigev_value is a union containing
a pointer and an int, that assignment will only partially initialize
sigev_value on systems where the size of a pointer is bigger than the
size of an int. On such systems we'll copy the uninitialized stack bytes
from the timer_create() call to userland when the timer actually fires
and we're going to deliver the signal.

Initialize sigev_value with 0 to plug the stack info leak.

Found in the PaX patch, written by the PaX Team.

Fixes: 5a9fa7307285 ("posix-timers: kill ->it_sigev_signo and...")
Signed-off-by: Mathias Krause <minipli@googlemail.com>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: Brad Spengler <spender@grsecurity.net>
Cc: PaX Team <pageexec@freemail.hu>
Link: http://lkml.kernel.org/r/1412456799-32339-1-git-send-email-minipli@googlemail.com
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 kernel/posix-timers.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/kernel/posix-timers.c b/kernel/posix-timers.c
index 424c2d4..77e6b83 100644
--- a/kernel/posix-timers.c
+++ b/kernel/posix-timers.c
@@ -634,6 +634,7 @@ SYSCALL_DEFINE3(timer_create, const clockid_t, which_clock,
 			goto out;
 		}
 	} else {
+		memset(&event.sigev_value, 0, sizeof(event.sigev_value));
 		event.sigev_notify = SIGEV_SIGNAL;
 		event.sigev_signo = SIGALRM;
 		event.sigev_value.sival_int = new_timer->it_id;
-- 
1.9.1

