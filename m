Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965453AbbA1Eqw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jan 2015 23:46:52 -0500
Received: from mail.kernel.org ([198.145.29.136]:40211 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934426AbbA1EXK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jan 2015 23:23:10 -0500
From: lizf@kernel.org
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Mathias Krause <minipli@googlemail.com>,
        Oleg Nesterov <oleg@redhat.com>,
        Brad Spengler <spender@grsecurity.net>,
        PaX Team <pageexec@freemail.hu>, Thomas Gleixner <tglx@linutronix.de>,
        Zefan Li <lizefan@huawei.com>
Subject: [PATCH 3.4 105/177] posix-timers: Fix stack info leak in timer_create()
Date: Wed, 28 Jan 2015 12:09:23 +0800
Message-Id: <1422418236-12852-196-git-send-email-lizf@kernel.org>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1422418050-12581-1-git-send-email-lizf@kernel.org>
References: <1422418050-12581-1-git-send-email-lizf@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Mathias Krause <minipli@googlemail.com>

3.4.106-rc1 review patch.  If anyone has any objections, please let me know.

------------------


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
[lizf: Backported to 3.4: adjust filename]
Signed-off-by: Zefan Li <lizefan@huawei.com>
---
 kernel/posix-timers.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/kernel/posix-timers.c b/kernel/posix-timers.c
index e885be1..02824a5 100644
--- a/kernel/posix-timers.c
+++ b/kernel/posix-timers.c
@@ -589,6 +589,7 @@ SYSCALL_DEFINE3(timer_create, const clockid_t, which_clock,
 			goto out;
 		}
 	} else {
+		memset(&event.sigev_value, 0, sizeof(event.sigev_value));
 		event.sigev_notify = SIGEV_SIGNAL;
 		event.sigev_signo = SIGALRM;
 		event.sigev_value.sival_int = new_timer->it_id;
-- 
1.9.1

