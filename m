Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754737Ab3ILLMQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Sep 2013 07:12:16 -0400
Received: from terminus.zytor.com ([198.137.202.10]:34456 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754497Ab3ILLLz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Sep 2013 07:11:55 -0400
Date: Thu, 12 Sep 2013 04:11:37 -0700
From: tip-bot for Oleg Nesterov <tipbot@zytor.com>
Message-ID: <tip-878b5a6efd38030c7a90895dc8346e8fb1e09b4c@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        hkshaw@linux.vnet.ibm.com, anton@redhat.com, tglx@linutronix.de,
        oleg@redhat.com, Mikhail.Kulemin@ru.ibm.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        hkshaw@linux.vnet.ibm.com, anton@redhat.com, tglx@linutronix.de,
        oleg@redhat.com, Mikhail.Kulemin@ru.ibm.com
In-Reply-To: <20130911154726.GA8093@redhat.com>
References: <20130911154726.GA8093@redhat.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/urgent] uprobes: Fix utask->
 depth accounting in handle_trampoline()
Git-Commit-ID: 878b5a6efd38030c7a90895dc8346e8fb1e09b4c
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Thu, 12 Sep 2013 04:11:44 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  878b5a6efd38030c7a90895dc8346e8fb1e09b4c
Gitweb:     http://git.kernel.org/tip/878b5a6efd38030c7a90895dc8346e8fb1e09b4c
Author:     Oleg Nesterov <oleg@redhat.com>
AuthorDate: Wed, 11 Sep 2013 17:47:26 +0200
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Thu, 12 Sep 2013 08:00:55 +0200

uprobes: Fix utask->depth accounting in handle_trampoline()

Currently utask->depth is simply the number of allocated/pending
return_instance's in uprobe_task->return_instances list.

handle_trampoline() should decrement this counter every time we
handle/free an instance, but due to typo it does this only if
->chained == T. This means that in the likely case this counter
is never decremented and the probed task can't report more than
MAX_URETPROBE_DEPTH events.

Reported-by: Mikhail Kulemin <Mikhail.Kulemin@ru.ibm.com>
Reported-by: Hemant Kumar Shaw <hkshaw@linux.vnet.ibm.com>
Signed-off-by: Oleg Nesterov <oleg@redhat.com>
Acked-by: Anton Arapov <anton@redhat.com>
Cc: masami.hiramatsu.pt@hitachi.com
Cc: srikar@linux.vnet.ibm.com
Cc: systemtap@sourceware.org
Cc: stable@vger.kernel.org
Link: http://lkml.kernel.org/r/20130911154726.GA8093@redhat.com
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 kernel/events/uprobes.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/kernel/events/uprobes.c b/kernel/events/uprobes.c
index f356974..ad8e1bd 100644
--- a/kernel/events/uprobes.c
+++ b/kernel/events/uprobes.c
@@ -1682,12 +1682,10 @@ static bool handle_trampoline(struct pt_regs *regs)
 		tmp = ri;
 		ri = ri->next;
 		kfree(tmp);
+		utask->depth--;
 
 		if (!chained)
 			break;
-
-		utask->depth--;
-
 		BUG_ON(!ri);
 	}
 
