Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751742AbaHQP20 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Aug 2014 11:28:26 -0400
Received: from mx1.redhat.com ([209.132.183.28]:20939 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751392AbaHQP2Z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Aug 2014 11:28:25 -0400
Date: Sun, 17 Aug 2014 17:25:49 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Rik van Riel <riel@redhat.com>, Mike Galbraith <umgwanakikbuti@gmail.com>,
        Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>,
        Frank Mayhar <fmayhar@google.com>,
        Frederic Weisbecker <fweisbec@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Sanjay Rao <srao@redhat.com>, Larry Woodman <lwoodman@redhat.com>,
        linux-kernel@vger.kernel.org, Kirill Tkhai <tkhai@yandex.ru>
Subject: [PATCH 0/2] sched: tasklist_lock cleanups (Was: don't use
	while_each_thread())
Message-ID: <20140817152549.GA17984@redhat.com>
References: <20140813191938.GA19301@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140813191938.GA19301@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/13, Oleg Nesterov wrote:
>
> Peter, could you take these simple patches ?
>
> Better later than never... per-file, but please feel free to join
> them in a single patch.
>
> read_lock_irq*(tasklist_lock) in kernel/sched/ files looks strange.
> Why? I'll recheck, but this looks unneeded.

Yes, please consider these minor cleanups on top of for_each_thread
conversions.

read_lock_irq(tasklist) in normalize_rt_tasks() doesn't really hurt,
but it looks confusing. If we really have a reason to disable irqs
this (subtle) reason should be documented.

And I can't understand tg_has_rt_tasks(). Don't we need something
like the patch below? If not, please do not ask me why I think so,
I don't understand this black magic ;) But the usage of the global
"runqueues" array looks suspicious.

Oleg.

--- x/kernel/sched/core.c
+++ x/kernel/sched/core.c
@@ -7354,7 +7354,7 @@ static inline int tg_has_rt_tasks(struct
 	struct task_struct *g, *p;
 
 	for_each_process_thread(g, p) {
-		if (rt_task(p) && task_rq(p)->rt.tg == tg)
+		if (rt_task(p) && task_group(p) == tg)
 			return 1;
 	}
 

