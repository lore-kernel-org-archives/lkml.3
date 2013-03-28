Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756172Ab3C1Goi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Mar 2013 02:44:38 -0400
Received: from mail-qa0-f52.google.com ([209.85.216.52]:63211 "EHLO
	mail-qa0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756076Ab3C1Gof (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Mar 2013 02:44:35 -0400
From: Tejun Heo <tj@kernel.org>
To: laijs@cn.fujitsu.com
Cc: axboe@kernel.dk, jack@suse.cz, fengguang.wu@intel.com, jmoyer@redhat.com,
        zab@redhat.com, linux-kernel@vger.kernel.org,
        herbert@gondor.hengli.com.au, davem@davemloft.net,
        linux-crypto@vger.kernel.org, Tejun Heo <tj@kernel.org>
Subject: [PATCH 07/14] workqueue: move hot fields of workqueue_struct to the end
Date: Wed, 27 Mar 2013 23:43:33 -0700
Message-Id: <1364453020-2829-8-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1364453020-2829-1-git-send-email-tj@kernel.org>
References: <1364453020-2829-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Move wq->flags and ->cpu_pwqs to the end of workqueue_struct and align
them to the cacheline.  These two fields are used in the work item
issue path and thus hot.  The scheduled NUMA affinity support will add
dispatch table at the end of workqueue_struct and relocating these two
fields will allow us hitting only single cacheline on hot paths.

Note that wq->pwqs isn't moved although it currently is being used in
the work item issue path for unbound workqueues.  The dispatch table
mentioned above will replace its use in the issue path, so it will
become cold once NUMA support is implemented.

Signed-off-by: Tejun Heo <tj@kernel.org>
---
 kernel/workqueue.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/kernel/workqueue.c b/kernel/workqueue.c
index 23c9099..9297ea3 100644
--- a/kernel/workqueue.c
+++ b/kernel/workqueue.c
@@ -227,8 +227,6 @@ struct wq_device;
  * the appropriate worker_pool through its pool_workqueues.
  */
 struct workqueue_struct {
-	unsigned int		flags;		/* WQ: WQ_* flags */
-	struct pool_workqueue __percpu *cpu_pwqs; /* I: per-cpu pwq's */
 	struct list_head	pwqs;		/* WR: all pwqs of this wq */
 	struct list_head	list;		/* PL: list of all workqueues */
 
@@ -255,6 +253,10 @@ struct workqueue_struct {
 	struct lockdep_map	lockdep_map;
 #endif
 	char			name[WQ_NAME_LEN]; /* I: workqueue name */
+
+	/* hot fields used during command issue, aligned to cacheline */
+	unsigned int		flags ____cacheline_aligned; /* WQ: WQ_* flags */
+	struct pool_workqueue __percpu *cpu_pwqs; /* I: per-cpu pwqs */
 };
 
 static struct kmem_cache *pwq_cache;
-- 
1.8.1.4

