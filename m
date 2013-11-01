Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755875Ab3KAJwp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Nov 2013 05:52:45 -0400
Received: from terminus.zytor.com ([198.137.202.10]:60514 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754807Ab3KAJwm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Nov 2013 05:52:42 -0400
Date: Fri, 1 Nov 2013 02:52:21 -0700
From: tip-bot for Heiko Carstens <tipbot@zytor.com>
Message-ID: <tip-7d716456a0ee4e9bd63be9234f886d20382ac950@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        a.p.zijlstra@chello.nl, heiko.carstens@de.ibm.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        a.p.zijlstra@chello.nl, heiko.carstens@de.ibm.com, tglx@linutronix.de
In-Reply-To: <20131031114814.GB5551@osiris>
References: <20131031114814.GB5551@osiris>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/core] sched/wait:
  Fix __wait_event_interruptible_lock_irq_timeout()
Git-Commit-ID: 7d716456a0ee4e9bd63be9234f886d20382ac950
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.1 (terminus.zytor.com [127.0.0.1]); Fri, 01 Nov 2013 02:52:28 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  7d716456a0ee4e9bd63be9234f886d20382ac950
Gitweb:     http://git.kernel.org/tip/7d716456a0ee4e9bd63be9234f886d20382ac950
Author:     Heiko Carstens <heiko.carstens@de.ibm.com>
AuthorDate: Thu, 31 Oct 2013 12:48:14 +0100
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Fri, 1 Nov 2013 08:42:44 +0100

sched/wait: Fix __wait_event_interruptible_lock_irq_timeout()

__wait_event_interruptible_lock_irq_timeout() needs the timeout
parameter passed instead of "ret".

This magically compiled since the only user has a local ret
variable. Luckily we got a build warning:

  CC      drivers/s390/scsi/zfcp_qdio.o
  drivers/s390/scsi/zfcp_qdio.c: In function 'zfcp_qdio_sbal_get':
  include/linux/wait.h:780:15: warning: 'ret' may be used uninitialized

Signed-off-by: Heiko Carstens <heiko.carstens@de.ibm.com>
Acked-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/r/20131031114814.GB5551@osiris
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 include/linux/wait.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/linux/wait.h b/include/linux/wait.h
index 3b23afa..61939ba 100644
--- a/include/linux/wait.h
+++ b/include/linux/wait.h
@@ -739,7 +739,7 @@ do {									\
 #define __wait_event_interruptible_lock_irq_timeout(wq, condition,	\
 						    lock, timeout)	\
 	___wait_event(wq, ___wait_cond_timeout(condition),		\
-		      TASK_INTERRUPTIBLE, 0, ret,			\
+		      TASK_INTERRUPTIBLE, 0, timeout,			\
 		      spin_unlock_irq(&lock);				\
 		      __ret = schedule_timeout(__ret);			\
 		      spin_lock_irq(&lock));
