Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759388Ab3KMOfT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Nov 2013 09:35:19 -0500
Received: from mx1.redhat.com ([209.132.183.28]:22844 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755562Ab3KMOfN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Nov 2013 09:35:13 -0500
Date: Wed, 13 Nov 2013 15:36:12 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>,
        Peter Zijlstra <peterz@infradead.org>
Cc: David Laight <David.Laight@ACULAB.COM>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Ingo Molnar <mingo@kernel.org>, Tejun Heo <tj@kernel.org>,
        linux-kernel@vger.kernel.org
Subject: [PATCH 2/3] fork: no need to initialize child->exit_state
Message-ID: <20131113143612.GA10540@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131113143552.GA10517@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

A zombie task obviously can't fork(), remove the unnecessary
initialization of child->exit_state. It is zero anyway after
dup_task_struct().

Note: copy_process() is huge and it has a lot of chaotic
initializations, probably it makes sense to move them into the
new helper called by dup_task_struct().

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
---
 kernel/fork.c |    4 +---
 1 files changed, 1 insertions(+), 3 deletions(-)

diff --git a/kernel/fork.c b/kernel/fork.c
index 8531609..2cb6024 100644
--- a/kernel/fork.c
+++ b/kernel/fork.c
@@ -1405,13 +1405,11 @@ static struct task_struct *copy_process(unsigned long clone_flags,
 		p->tgid = p->pid;
 	}
 
-	p->pdeath_signal = 0;
-	p->exit_state = 0;
-
 	p->nr_dirtied = 0;
 	p->nr_dirtied_pause = 128 >> (PAGE_SHIFT - 10);
 	p->dirty_paused_when = 0;
 
+	p->pdeath_signal = 0;
 	INIT_LIST_HEAD(&p->thread_group);
 	p->task_works = NULL;
 
-- 
1.5.5.1

