Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933385AbaKLBeP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2014 20:34:15 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:59591 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754778AbaKLBeI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2014 20:34:08 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Mathias Krause <minipli@googlemail.com>,
        Oleg Nesterov <oleg@redhat.com>,
        Brad Spengler <spender@grsecurity.net>,
        PaX Team <pageexec@freemail.hu>, Thomas Gleixner <tglx@linutronix.de>
Subject: [PATCH 3.17 274/319] posix-timers: Fix stack info leak in timer_create()
Date: Wed, 12 Nov 2014 10:16:52 +0900
Message-Id: <20141112011038.140012187@linuxfoundation.org>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <20141112010952.553519040@linuxfoundation.org>
References: <20141112010952.553519040@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.17-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 kernel/time/posix-timers.c |    1 +
 1 file changed, 1 insertion(+)

--- a/kernel/time/posix-timers.c
+++ b/kernel/time/posix-timers.c
@@ -636,6 +636,7 @@ SYSCALL_DEFINE3(timer_create, const cloc
 			goto out;
 		}
 	} else {
+		memset(&event.sigev_value, 0, sizeof(event.sigev_value));
 		event.sigev_notify = SIGEV_SIGNAL;
 		event.sigev_signo = SIGALRM;
 		event.sigev_value.sival_int = new_timer->it_id;


