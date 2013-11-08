Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757568Ab3KHP4N (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Nov 2013 10:56:13 -0500
Received: from mx1.redhat.com ([209.132.183.28]:64401 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756024Ab3KHP4L (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Nov 2013 10:56:11 -0500
Date: Fri, 8 Nov 2013 16:57:35 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Anton Arapov <aarapov@redhat.com>, David Smith <dsmith@redhat.com>,
        "Frank Ch. Eigler" <fche@redhat.com>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH 1/1] uprobes: Fix the wrong usage of current->utask in
	uprobe_copy_process()
Message-ID: <20131108155735.GB26611@redhat.com>
References: <20131108155714.GA26611@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131108155714.GA26611@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit aa59c53fd459 "uprobes: Change uprobe_copy_process() to dup
xol_area" has a stupid typo, we need to setup t->utask->vaddr but
the code wrongly uses current->utask.

Even with this bug dup_xol_work() works "in practice", but only
because get_unmapped_area(NULL, TASK_SIZE - PAGE_SIZE) likely
returns the same address every time.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
---
 kernel/events/uprobes.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/kernel/events/uprobes.c b/kernel/events/uprobes.c
index 26fdd65..847201f 100644
--- a/kernel/events/uprobes.c
+++ b/kernel/events/uprobes.c
@@ -1446,7 +1446,7 @@ void uprobe_copy_process(struct task_struct *t, unsigned long flags)
 	if (!work)
 		return uprobe_warn(t, "dup xol area");
 
-	utask->vaddr = area->vaddr;
+	t->utask->vaddr = area->vaddr;
 	init_task_work(work, dup_xol_work);
 	task_work_add(t, work, true);
 }
-- 
1.5.5.1


