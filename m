Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752019AbaJYSn0 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 Oct 2014 14:43:26 -0400
Received: from terminus.zytor.com ([198.137.202.10]:56374 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751565AbaJYSnZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 Oct 2014 14:43:25 -0400
Date: Sat, 25 Oct 2014 01:45:50 -0700
From: tip-bot for Mathias Krause <tipbot@zytor.com>
Message-ID: <tip-6891c4509c792209c44ced55a60f13954cb50ef4@git.kernel.org>
Cc: hpa@zytor.com, tglx@linutronix.de, mingo@kernel.org, oleg@redhat.com,
        minipli@googlemail.com, pageexec@freemail.hu, spender@grsecurity.net,
        linux-kernel@vger.kernel.org
Reply-To: tglx@linutronix.de, hpa@zytor.com, minipli@googlemail.com,
        mingo@kernel.org, oleg@redhat.com, pageexec@freemail.hu,
        linux-kernel@vger.kernel.org, spender@grsecurity.net
In-Reply-To: <1412456799-32339-1-git-send-email-minipli@googlemail.com>
References: <1412456799-32339-1-git-send-email-minipli@googlemail.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:timers/urgent] posix-timers:
  Fix stack info leak in timer_create()
Git-Commit-ID: 6891c4509c792209c44ced55a60f13954cb50ef4
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  6891c4509c792209c44ced55a60f13954cb50ef4
Gitweb:     http://git.kernel.org/tip/6891c4509c792209c44ced55a60f13954cb50ef4
Author:     Mathias Krause <minipli@googlemail.com>
AuthorDate: Sat, 4 Oct 2014 23:06:39 +0200
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Sat, 25 Oct 2014 10:43:15 +0200

posix-timers: Fix stack info leak in timer_create()

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
Cc: <stable@vger.kernel.org>	# v2.6.28+
Link: http://lkml.kernel.org/r/1412456799-32339-1-git-send-email-minipli@googlemail.com
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 kernel/time/posix-timers.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/kernel/time/posix-timers.c b/kernel/time/posix-timers.c
index 42b463a..31ea01f 100644
--- a/kernel/time/posix-timers.c
+++ b/kernel/time/posix-timers.c
@@ -636,6 +636,7 @@ SYSCALL_DEFINE3(timer_create, const clockid_t, which_clock,
 			goto out;
 		}
 	} else {
+		memset(&event.sigev_value, 0, sizeof(event.sigev_value));
 		event.sigev_notify = SIGEV_SIGNAL;
 		event.sigev_signo = SIGALRM;
 		event.sigev_value.sival_int = new_timer->it_id;
