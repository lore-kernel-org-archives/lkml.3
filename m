Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932518Ab3GCIwN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Jul 2013 04:52:13 -0400
Received: from e06smtp13.uk.ibm.com ([195.75.94.109]:44522 "EHLO
	e06smtp13.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755129Ab3GCIvc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Jul 2013 04:51:32 -0400
From: Martin Schwidefsky <schwidefsky@de.ibm.com>
To: Jonathan Lim <jlim@sgi.com>, "Eric W. Biederman" <ebiederm@xmission.com>,
        Frederic Weisbecker <fweisbec@gmail.com>
Cc: linux-kernel@vger.kernel.org, Martin Schwidefsky <schwidefsky@de.ibm.com>
Subject: [PATCH] tsacct: optimize acct_update_integrals
Date: Wed,  3 Jul 2013 10:51:21 +0200
Message-Id: <1372841481-23899-1-git-send-email-schwidefsky@de.ibm.com>
X-Mailer: git-send-email 1.7.9.5
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13070308-2966-0000-0000-00000809ADBA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The conversion of a cputime to micro seconds can be done without the
detour via jiffies. This avoids unnecessary and costly calculations,
e.g. on s390 a 64-bit division and a multiplication can be replaced
with a simple shift.

Signed-off-by: Martin Schwidefsky <schwidefsky@de.ibm.com>
---
 kernel/tsacct.c |    5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff --git a/kernel/tsacct.c b/kernel/tsacct.c
index a1dd9a1..bf09be1 100644
--- a/kernel/tsacct.c
+++ b/kernel/tsacct.c
@@ -126,16 +126,13 @@ static void __acct_update_integrals(struct task_struct *tsk,
 {
 	if (likely(tsk->mm)) {
 		cputime_t time, dtime;
-		struct timeval value;
 		unsigned long flags;
 		u64 delta;
 
 		local_irq_save(flags);
 		time = stime + utime;
 		dtime = time - tsk->acct_timexpd;
-		jiffies_to_timeval(cputime_to_jiffies(dtime), &value);
-		delta = value.tv_sec;
-		delta = delta * USEC_PER_SEC + value.tv_usec;
+		delta = cputime_to_usecs(dtime);
 
 		if (delta == 0)
 			goto out;
-- 
1.7.9.5

