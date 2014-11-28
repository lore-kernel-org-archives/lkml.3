Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752114AbaK1S2J (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Nov 2014 13:28:09 -0500
Received: from mail-wi0-f180.google.com ([209.85.212.180]:62860 "EHLO
	mail-wi0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751703AbaK1SYm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Nov 2014 13:24:42 -0500
From: Frederic Weisbecker <fweisbec@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>, Tony Luck <tony.luck@intel.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Thomas Gleixner <tglx@linutronix.de>, Oleg Nesterov <oleg@redhat.com>,
        Paul Mackerras <paulus@samba.org>,
        Wu Fengguang <fengguang.wu@intel.com>, Ingo Molnar <mingo@kernel.org>,
        Rik van Riel <riel@redhat.com>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>
Subject: [RFC PATCH 17/30] acct: Convert obsolete cputime type to nsecs
Date: Fri, 28 Nov 2014 19:23:47 +0100
Message-Id: <1417199040-21044-18-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <1417199040-21044-1-git-send-email-fweisbec@gmail.com>
References: <1417199040-21044-1-git-send-email-fweisbec@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Heiko Carstens <heiko.carstens@de.ibm.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Rik van Riel <riel@redhat.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Tony Luck <tony.luck@intel.com>
Cc: Wu Fengguang <fengguang.wu@intel.com>
Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
---
 include/linux/sched.h | 2 +-
 kernel/acct.c         | 9 +++++----
 2 files changed, 6 insertions(+), 5 deletions(-)

diff --git a/include/linux/sched.h b/include/linux/sched.h
index 3be3b0b..6c8c077 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -469,7 +469,7 @@ struct pacct_struct {
 	int			ac_flag;
 	long			ac_exitcode;
 	unsigned long		ac_mem;
-	cputime_t		ac_utime, ac_stime;
+	u64			ac_utime, ac_stime;
 	unsigned long		ac_minflt, ac_majflt;
 };
 
diff --git a/kernel/acct.c b/kernel/acct.c
index acfa901..50a0c4a 100644
--- a/kernel/acct.c
+++ b/kernel/acct.c
@@ -455,8 +455,8 @@ static void fill_ac(acct_t *ac)
 	spin_lock_irq(&current->sighand->siglock);
 	tty = current->signal->tty;	/* Safe as we hold the siglock */
 	ac->ac_tty = tty ? old_encode_dev(tty_devnum(tty)) : 0;
-	ac->ac_utime = encode_comp_t(jiffies_to_AHZ(cputime_to_jiffies(pacct->ac_utime)));
-	ac->ac_stime = encode_comp_t(jiffies_to_AHZ(cputime_to_jiffies(pacct->ac_stime)));
+	ac->ac_utime = encode_comp_t(nsec_to_AHZ(pacct->ac_utime));
+	ac->ac_stime = encode_comp_t(nsec_to_AHZ(pacct->ac_stime));
 	ac->ac_flag = pacct->ac_flag;
 	ac->ac_mem = encode_comp_t(pacct->ac_mem);
 	ac->ac_minflt = encode_comp_t(pacct->ac_minflt);
@@ -532,7 +532,7 @@ out:
 void acct_collect(long exitcode, int group_dead)
 {
 	struct pacct_struct *pacct = &current->signal->pacct;
-	cputime_t utime, stime;
+	u64 utime, stime;
 	unsigned long vsize = 0;
 
 	if (group_dead && current->mm) {
@@ -561,7 +561,8 @@ void acct_collect(long exitcode, int group_dead)
 		pacct->ac_flag |= ACORE;
 	if (current->flags & PF_SIGNALED)
 		pacct->ac_flag |= AXSIG;
-	task_cputime_t(current, &utime, &stime);
+
+	task_cputime(current, &utime, &stime);
 	pacct->ac_utime += utime;
 	pacct->ac_stime += stime;
 	pacct->ac_minflt += current->min_flt;
-- 
2.1.3

