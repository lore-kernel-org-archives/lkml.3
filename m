Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964953Ab3HIP0E (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Aug 2013 11:26:04 -0400
Received: from mx1.redhat.com ([209.132.183.28]:57596 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934350Ab3HIP0C (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Aug 2013 11:26:02 -0400
Date: Fri, 9 Aug 2013 17:19:13 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Linus Torvalds <torvalds@linux-foundation.org>,
        Christine Caulfield <ccaulfie@redhat.com>,
        David Teigland <teigland@redhat.com>
Cc: Long Gao <gaolong@kylinos.com.cn>, Al Viro <viro@zeniv.linux.org.uk>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [PATCH 1/1] dlm: kill the unnecessary and wrong
	device_close()->recalc_sigpending()
Message-ID: <20130809151913.GB4619@redhat.com>
References: <tencent_26310211398C21034BD3B2F9@qq.com> <CA+55aFwAnWZGkXbyLmL3RxQGW-dX_jjDBPfA5PjxeVWn==a6tA@mail.gmail.com> <20130808191749.GA12062@redhat.com> <20130809151852.GA4619@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130809151852.GA4619@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

device_close()->recalc_sigpending() is not needed, sigprocmask()
takes care of TIF_SIGPENDING correctly.

And without ->siglock it is racy and wrong, it can wrongly clear
TIF_SIGPENDING and miss a signal.

But even with this patch device_close() is still buggy:

	1. sigprocmask() should not be used, we have set_task_blocked(),
	   but this is minor.

	2. We should never block SIGKILL or SIGSTOP, and this is what
	   the code tries to do.

	3. This can't protect against SIGKILL or SIGSTOP anyway. Another
	   thread can do signal_wake_up(), say, do_signal_stop() or
	   complete_signal() or debugger.

	4. sigprocmask(SIG_BLOCK, allsigs) doesn't necessarily clears
	   TIF_SIGPENDING, say, freezing() or ->jobctl.

	5. device_write() looks equally wrong by the same reason.

Looks like, this tries to protect some wait_event_interruptible() logic
from signals, it should be turned into uninterruptible wait. Or we need
to implement something like signals_stop/start for such a use-case.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
---
 fs/dlm/user.c |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/fs/dlm/user.c b/fs/dlm/user.c
index 911649a..8121491 100644
--- a/fs/dlm/user.c
+++ b/fs/dlm/user.c
@@ -686,7 +686,6 @@ static int device_close(struct inode *inode, struct file *file)
 	   device_remove_lockspace() */
 
 	sigprocmask(SIG_SETMASK, &tmpsig, NULL);
-	recalc_sigpending();
 
 	return 0;
 }
-- 
1.5.5.1


