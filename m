Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759363Ab3BXRdj (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Feb 2013 12:33:39 -0500
Received: from mx1.redhat.com ([209.132.183.28]:12411 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758730Ab3BXRdf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Feb 2013 12:33:35 -0500
Date: Sun, 24 Feb 2013 18:32:06 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Mandeep Singh Baines <msb@chromium.org>, Neil Horman <nhorman@redhat.com>,
        "Rafael J. Wysocki" <rjw@sisk.pl>, Tejun Heo <tj@kernel.org>,
        linux-kernel@vger.kernel.org
Subject: [PATCH 2/3] freezer: do not send a fake signal to a PF_DUMPCORE
	thread
Message-ID: <20130224173206.GA32206@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130224173144.GA32179@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

A coredumping thread can't be frozen anyway but the fake signal sent
by freeze_task() can confuse dump_write/wait_for_dump_helpers/etc
and interrupt the coredump.

We are going to make the do_coredump() paths freezable but the fake
TIF_SIGPENDING doesn't help, it only makes sense when we assume that
the target can return to user-mode and call get_signal_to_deliver().

Change freeze_task() to check PF_DUMPCORE along with PF_KTHREAD.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
---
 kernel/freezer.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/kernel/freezer.c b/kernel/freezer.c
index c38893b..88d2644 100644
--- a/kernel/freezer.c
+++ b/kernel/freezer.c
@@ -116,7 +116,7 @@ bool freeze_task(struct task_struct *p)
 		return false;
 	}
 
-	if (!(p->flags & PF_KTHREAD))
+	if (!(p->flags & (PF_KTHREAD | PF_DUMPCORE)))
 		fake_signal_wake_up(p);
 	else
 		wake_up_state(p, TASK_INTERRUPTIBLE);
-- 
1.5.5.1

