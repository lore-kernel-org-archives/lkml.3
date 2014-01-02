Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751061AbaABKwa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Jan 2014 05:52:30 -0500
Received: from www262.sakura.ne.jp ([202.181.97.72]:54621 "EHLO
	www262.sakura.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750738AbaABKw3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Jan 2014 05:52:29 -0500
X-Nat-Received: from [202.181.97.72]:60939 [ident-empty]
	by smtp-proxy.isp with TPROXY id 1388659943.17814
To: swhiteho@redhat.com
Cc: rpeterso@redhat.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] GFS2: Fix unsafe dereference in dump_holder()
From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
References: <201312242051.ECA46103.MFFVFOtHSJOLQO@I-love.SAKURA.ne.jp>
	<1388657311.2746.10.camel@menhir>
In-Reply-To: <1388657311.2746.10.camel@menhir>
Message-Id: <201401021952.HGF52137.FFOHMQFVOJLStO@I-love.SAKURA.ne.jp>
X-Mailer: Winbiff [Version 2.51 PL2]
X-Accept-Language: ja,en,zh
Date: Thu, 2 Jan 2014 19:52:20 +0900
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-Anti-Virus: Kaspersky Anti-Virus for Linux Mail Server 5.6.45.2/RELEASE, bases: 02012014 #7224517, status: clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Steven Whitehouse wrote:
> > Subject: [PATCH] GFS2: Fix unsafe dereference in dump_holder()
> > 
> > Since we are not in RCU nor tasklist_lock held, we need to grab a reference on
> > the returned task_struct. Use get_pid_task()/get_task_comm() to safely read the
> > target task's comm name.
> > 
> > Signed-off-by: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
> > ---
> 
> Well this is not entirely true... for 99.9% of calls to this function we
> do have the rcu read lock held (when called from the seq file code). So
> the only issue is when called from the GLOCK_BUG_ON() macro.
> 
> Since it appears that rcu_read_lock() will nest, then we could
> presumably just add that around dump_holder or even around
> gfs2_dump_glock ?
> 
> I think that is a neater solution than taking extra ref counts and
> copying the string around,

OK. I didn't check what lock protects this dereference. I just noticed this
dereference when I was checking direct ->comm access which might fail to return
consistent comm name. I might propose changing ->comm access to RCU in the
future ( https://lkml.org/lkml/2013/12/25/21 ).

For now add only rcu_read_lock()/rcu_read_unlock(). Patch follows.
----------
>From 63f41a384636be1acd1575ee9f9e0de317cbc131 Mon Sep 17 00:00:00 2001
From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Date: Thu, 2 Jan 2014 19:41:23 +0900
Subject: [PATCH v2] GFS2: Fix unsafe dereference in dump_holder()

GLOCK_BUG_ON() might call this function without RCU read lock. Make sure that
RCU read lock is held when using task_struct returned from pid_task().

Signed-off-by: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
---
 fs/gfs2/glock.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/fs/gfs2/glock.c b/fs/gfs2/glock.c
index c8420f7..6f7a47c 100644
--- a/fs/gfs2/glock.c
+++ b/fs/gfs2/glock.c
@@ -1655,6 +1655,7 @@ static int dump_holder(struct seq_file *seq, const struct gfs2_holder *gh)
 	struct task_struct *gh_owner = NULL;
 	char flags_buf[32];
 
+	rcu_read_lock();
 	if (gh->gh_owner_pid)
 		gh_owner = pid_task(gh->gh_owner_pid, PIDTYPE_PID);
 	gfs2_print_dbg(seq, " H: s:%s f:%s e:%d p:%ld [%s] %pS\n",
@@ -1664,6 +1665,7 @@ static int dump_holder(struct seq_file *seq, const struct gfs2_holder *gh)
 		       gh->gh_owner_pid ? (long)pid_nr(gh->gh_owner_pid) : -1,
 		       gh_owner ? gh_owner->comm : "(ended)",
 		       (void *)gh->gh_ip);
+	rcu_read_unlock();
 	return 0;
 }
 
-- 
1.7.1
