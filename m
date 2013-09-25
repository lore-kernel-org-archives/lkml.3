Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932446Ab3IYA2R (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Sep 2013 20:28:17 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:39756 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756750Ab3IYAU5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Sep 2013 20:20:57 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Mikhail Kulemin <Mikhail.Kulemin@ru.ibm.com>,
        Hemant Kumar Shaw <hkshaw@linux.vnet.ibm.com>,
        Oleg Nesterov <oleg@redhat.com>, Anton Arapov <anton@redhat.com>,
        Ingo Molnar <mingo@kernel.org>, masami.hiramatsu.pt@hitachi.com,
        srikar@linux.vnet.ibm.com, systemtap@sourceware.org
Subject: [ 091/117] uprobes: Fix utask->depth accounting in handle_trampoline()
Date: Tue, 24 Sep 2013 17:19:17 -0700
Message-Id: <20130925001750.865517088@linuxfoundation.org>
X-Mailer: git-send-email 1.8.4.3.gca3854a
In-Reply-To: <20130925001740.833541979@linuxfoundation.org>
References: <20130925001740.833541979@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Oleg Nesterov <oleg@redhat.com>

commit 878b5a6efd38030c7a90895dc8346e8fb1e09b4c upstream.

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
Link: http://lkml.kernel.org/r/20130911154726.GA8093@redhat.com
Signed-off-by: Ingo Molnar <mingo@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 kernel/events/uprobes.c |    4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

--- a/kernel/events/uprobes.c
+++ b/kernel/events/uprobes.c
@@ -1682,12 +1682,10 @@ static bool handle_trampoline(struct pt_
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
 


