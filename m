Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751013Ab3FSEEb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Jun 2013 00:04:31 -0400
Received: from intranet.asianux.com ([58.214.24.6]:58728 "EHLO
	intranet.asianux.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750759Ab3FSEEa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Jun 2013 00:04:30 -0400
X-Spam-Score: -100.8
Message-ID: <51C12D9A.8030801@asianux.com>
Date: Wed, 19 Jun 2013 12:03:38 +0800
From: Chen Gang <gang.chen@asianux.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130110 Thunderbird/17.0.2
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
        Oleg Nesterov <oleg@redhat.com>, laijs@cn.fujitsu.com
CC: Andrew Morton <akpm@linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [PATCH] kernel/kthread.c: need spin_lock_irq() for 'worker' before
 main looping,  since it can "WARN_ON(worker->task)".
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Since "WARN_ON(worker->task)", we can not assume that 'worker->task'
will be NULL before set 'current' to it.

So need let 'worker' lock protected too, just like it already lock
protected all time in main looping.


Signed-off-by: Chen Gang <gang.chen@asianux.com>
---
 kernel/kthread.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/kernel/kthread.c b/kernel/kthread.c
index 760e86d..8d572b8 100644
--- a/kernel/kthread.c
+++ b/kernel/kthread.c
@@ -511,8 +511,10 @@ int kthread_worker_fn(void *worker_ptr)
 	struct kthread_worker *worker = worker_ptr;
 	struct kthread_work *work;
 
+	spin_lock_irq(&worker->lock);
 	WARN_ON(worker->task);
 	worker->task = current;
+	spin_unlock_irq(&worker->lock);
 repeat:
 	set_current_state(TASK_INTERRUPTIBLE);	/* mb paired w/ kthread_stop */
 
-- 
1.7.7.6
