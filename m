Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755467Ab3IKPyT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Sep 2013 11:54:19 -0400
Received: from mx1.redhat.com ([209.132.183.28]:15761 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754376Ab3IKPyS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Sep 2013 11:54:18 -0400
Date: Wed, 11 Sep 2013 17:47:26 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: anton@redhat.com, Hemant Kumar Shaw <hkshaw@linux.vnet.ibm.com>,
        masami.hiramatsu.pt@hitachi.com,
        Mikhail Kulemin <Mikhail.Kulemin@ru.ibm.com>,
        srikar@linux.vnet.ibm.com, systemtap@sourceware.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] uprobes: Fix utask->depth accounting in handle_trampoline()
Message-ID: <20130911154726.GA8093@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently utask->depth is simply the number of allocated/pending
return_instance's in uprobe_task->return_instances list.

handle_trampoline() should decrement this counter every time we
handle/free an instance, but due to typo it does this only if
->chained == T. This means that in the likely case this counter
is never decremented and the probed task can't report more than
MAX_URETPROBE_DEPTH events.

Cc: stable@vger.kernel.org
Signed-off-by: Oleg Nesterov <oleg@redhat.com>
Reported-by: Mikhail Kulemin <Mikhail.Kulemin@ru.ibm.com>
Reported-by: Hemant Kumar Shaw <hkshaw@linux.vnet.ibm.com>
---
 kernel/events/uprobes.c |    4 +---
 1 files changed, 1 insertions(+), 3 deletions(-)

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
 
-- 
1.5.5.1


