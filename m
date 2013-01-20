Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752495Ab3ATT0s (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Jan 2013 14:26:48 -0500
Received: from mx1.redhat.com ([209.132.183.28]:37473 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752317Ab3ATT0r (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Jan 2013 14:26:47 -0500
Date: Sun, 20 Jan 2013 20:26:04 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Dan Carpenter <dan.carpenter@oracle.com>,
        Kernel Security <security@kernel.org>,
        Michael Davidson <md@google.com>,
        Suleiman Souhlal <suleiman@google.com>, Julien Tinnes <jln@google.com>,
        Aaron Durbin <adurbin@google.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org, Tejun Heo <tj@kernel.org>,
        Roland McGrath <roland@hack.frob.com>, Tony Luck <tony.luck@intel.com>,
        Fenghua Yu <fenghua.yu@intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [PATCH 4/4] wake_up_process() should be never used to wakeup a
	TASK_STOPPED/TRACED task
Message-ID: <20130120192604.GE6771@redhat.com>
References: <20130116181830.GA6469@redhat.com> <CA+55aFzkWqSEzw9oa5JodrM2NWE0H_AF7xyzRhd+DQ=PB=ZT2A@mail.gmail.com> <20130118153700.GA27915@redhat.com> <CA+55aFxEow_-PoX0xFa07yOi6az=6uVx8zeOsfToErmzh7dB8A@mail.gmail.com> <20130118172854.GA29753@redhat.com> <20130118175224.GA520@redhat.com> <CA+55aFyEsU-pkX557A-m+xoGkA_v+fXEyA8z8HbJ5J8K1jObeg@mail.gmail.com> <20130118185559.GA3773@redhat.com> <CA+55aFy=newnMbx53HipyWbRs2mUUPSqXXCpSfDLW78gkro37g@mail.gmail.com> <20130120192448.GA6771@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130120192448.GA6771@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

wake_up_process() should never wakeup a TASK_STOPPED/TRACED task.
Change it to use TASK_NORMAL and add the WARN_ON().

TASK_ALL has no other users, probably can be killed.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
---
 kernel/sched/core.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index 257002c..26058d0 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -1523,7 +1523,8 @@ out:
  */
 int wake_up_process(struct task_struct *p)
 {
-	return try_to_wake_up(p, TASK_ALL, 0);
+	WARN_ON(task_is_stopped_or_traced(p));
+	return try_to_wake_up(p, TASK_NORMAL, 0);
 }
 EXPORT_SYMBOL(wake_up_process);
 
-- 
1.5.5.1


