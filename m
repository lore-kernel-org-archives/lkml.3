Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755885Ab3J1I4U (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Oct 2013 04:56:20 -0400
Received: from terminus.zytor.com ([198.137.202.10]:55553 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755842Ab3J1I4Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Oct 2013 04:56:16 -0400
Date: Mon, 28 Oct 2013 01:54:59 -0700
From: tip-bot for Thomas Pfaff <tipbot@zytor.com>
Message-ID: <tip-bbfe65c219c638e19f1da5adab1005b2d68ca810@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        bigeasy@linutronix.de, tglx@linutronix.de, meltedpianoman@gmail.com,
        tpfaff@pcs.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        tglx@linutronix.de, bigeasy@linutronix.de, tpfaff@pcs.com,
        meltedpianoman@gmail.com
In-Reply-To: <1381489240-29626-1-git-send-email-bigeasy@linutronix.de>
References: <1381489240-29626-1-git-send-email-bigeasy@linutronix.de>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:irq/urgent] genirq:
  Set the irq thread policy without checking CAP_SYS_NICE
Git-Commit-ID: bbfe65c219c638e19f1da5adab1005b2d68ca810
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.1 (terminus.zytor.com [127.0.0.1]); Mon, 28 Oct 2013 01:55:06 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  bbfe65c219c638e19f1da5adab1005b2d68ca810
Gitweb:     http://git.kernel.org/tip/bbfe65c219c638e19f1da5adab1005b2d68ca810
Author:     Thomas Pfaff <tpfaff@pcs.com>
AuthorDate: Fri, 11 Oct 2013 13:00:40 +0200
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Mon, 28 Oct 2013 09:50:42 +0100

genirq: Set the irq thread policy without checking CAP_SYS_NICE

In commit ee23871389 ("genirq: Set irq thread to RT priority on
creation") we moved the assigment of the thread's priority from the
thread's function into __setup_irq(). That function may run in user
context for instance if the user opens an UART node and then driver
calls requests in the ->open() callback. That user may not have
CAP_SYS_NICE and so the irq thread won't run with the SCHED_OTHER
policy.

This patch uses sched_setscheduler_nocheck() so we omit the CAP_SYS_NICE
check which is otherwise required for the SCHED_OTHER policy.

[bigeasy: Rewrite the changelog]

Signed-off-by: Thomas Pfaff <tpfaff@pcs.com>
Cc: Ivo Sieben <meltedpianoman@gmail.com>
Cc: stable@vger.kernel.org
Link: http://lkml.kernel.org/r/1381489240-29626-1-git-send-email-bigeasy@linutronix.de
Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 kernel/irq/manage.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/irq/manage.c b/kernel/irq/manage.c
index 514bcfd..3e59f95 100644
--- a/kernel/irq/manage.c
+++ b/kernel/irq/manage.c
@@ -956,7 +956,7 @@ __setup_irq(unsigned int irq, struct irq_desc *desc, struct irqaction *new)
 			goto out_mput;
 		}
 
-		sched_setscheduler(t, SCHED_FIFO, &param);
+		sched_setscheduler_nocheck(t, SCHED_FIFO, &param);
 
 		/*
 		 * We keep the reference to the task struct even if
