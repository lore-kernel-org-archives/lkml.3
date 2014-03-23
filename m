Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752119AbaCWTjN (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Mar 2014 15:39:13 -0400
Received: from mx1.redhat.com ([209.132.183.28]:29763 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751305AbaCWTjI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Mar 2014 15:39:08 -0400
Date: Sun, 23 Mar 2014 20:38:07 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Al Viro <viro@ZenIV.linux.org.uk>, David Woodhouse <dwmw2@infradead.org>,
        Richard Weinberger <richard@nod.at>, Tejun Heo <tj@kernel.org>,
        linux-kernel@vger.kernel.org
Subject: [PATCH 09/11] signals: disallow_signal() should flush the
	potentially pending signal
Message-ID: <20140323193807.GA10520@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140323193730.GA10464@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

disallow_signal() simply sets SIG_IGN, this is not enough and
recalc_sigpending() is simply pointless because in can never
change the state of TIF_SIGPENDING.

If we ignore a signal, we also need to do flush_sigqueue_mask() for
the case when this signal is pending, this way recalc_sigpending()
can actually clear TIF_SIGPENDING and we do not "leak" the allocated
siginfo's.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
---
 kernel/signal.c |    7 +++++++
 1 files changed, 7 insertions(+), 0 deletions(-)

diff --git a/kernel/signal.c b/kernel/signal.c
index 30bfe53..a615110 100644
--- a/kernel/signal.c
+++ b/kernel/signal.c
@@ -3082,8 +3082,15 @@ EXPORT_SYMBOL(allow_signal);
 
 void disallow_signal(int sig)
 {
+	sigset_t mask;
+
+	sigemptyset(&mask);
+	sigaddset(&mask, sig);
+
 	spin_lock_irq(&current->sighand->siglock);
 	current->sighand->action[(sig)-1].sa.sa_handler = SIG_IGN;
+	flush_sigqueue_mask(&mask, &current->signal->shared_pending);
+	flush_sigqueue_mask(&mask, &current->pending);
 	recalc_sigpending();
 	spin_unlock_irq(&current->sighand->siglock);
 }
-- 
1.5.5.1

