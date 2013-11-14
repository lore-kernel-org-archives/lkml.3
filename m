Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753452Ab3KNLy5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Nov 2013 06:54:57 -0500
Received: from mx1.redhat.com ([209.132.183.28]:59259 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752932Ab3KNLyz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Nov 2013 06:54:55 -0500
Date: Thu, 14 Nov 2013 12:56:18 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Tejun Heo <tj@kernel.org>
Cc: zhang.yi20@zte.com.cn, linux-kernel@vger.kernel.org,
        Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Subject: [PATCH 1/1] workqueue: swap set_cpus_allowed_ptr() and
	PF_NO_SETAFFINITY
Message-ID: <20131114115618.GB30824@redhat.com>
References: <OFC3933D9B.5510E97E-ON48257C23.0007B7CD-48257C23.000A4246@zte.com.cn> <20131114052326.GA29031@mtj.dyndns.org> <20131114114039.GA29277@redhat.com> <20131114115551.GA30824@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131114115551.GA30824@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Move the setting of PF_NO_SETAFFINITY up before set_cpus_allowed()
in create_worker(). Otherwise userland can change ->cpus_allowed
in between.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
---
 kernel/workqueue.c |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/kernel/workqueue.c b/kernel/workqueue.c
index 987293d..775af74 100644
--- a/kernel/workqueue.c
+++ b/kernel/workqueue.c
@@ -1736,16 +1736,16 @@ static struct worker *create_worker(struct worker_pool *pool)
 	if (IS_ERR(worker->task))
 		goto fail;
 
+	set_user_nice(worker->task, pool->attrs->nice);
+
+	/* prevent userland from meddling with cpumask of workqueue workers */
+	worker->task->flags |= PF_NO_SETAFFINITY;
 	/*
 	 * set_cpus_allowed_ptr() will fail if the cpumask doesn't have any
 	 * online CPUs.  It'll be re-applied when any of the CPUs come up.
 	 */
-	set_user_nice(worker->task, pool->attrs->nice);
 	set_cpus_allowed_ptr(worker->task, pool->attrs->cpumask);
 
-	/* prevent userland from meddling with cpumask of workqueue workers */
-	worker->task->flags |= PF_NO_SETAFFINITY;
-
 	/*
 	 * The caller is responsible for ensuring %POOL_DISASSOCIATED
 	 * remains stable across this function.  See the comments above the
-- 
1.5.5.1


