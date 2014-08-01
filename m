Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755296AbaHAQbq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Aug 2014 12:31:46 -0400
Received: from mail-pd0-f169.google.com ([209.85.192.169]:37725 "EHLO
	mail-pd0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753139AbaHAQbp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Aug 2014 12:31:45 -0400
From: Amit Pundir <amit.pundir@linaro.org>
To: linux-kernel@vger.kernel.org
Cc: Todd Poynor <toddpoynor@google.com>, Pavel Machek <pavel@ucw.cz>,
        Thomas Gleixner <tglx@linutronix.de>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Len Brown <len.brown@intel.com>, linux-pm@vger.kernel.org,
        Android Kernel Team <kernel-team@android.com>,
        John Stultz <john.stultz@linaro.org>,
        Sumit Semwal <sumit.semwal@linaro.org>,
        Amit Pundir <amit.pundir@linaro.org>
Subject: [RFC][PATCH 1/2] PM: Print pending wakeup IRQ preventing suspend to dmesg
Date: Fri,  1 Aug 2014 22:00:48 +0530
Message-Id: <1406910649-4028-2-git-send-email-amit.pundir@linaro.org>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1406910649-4028-1-git-send-email-amit.pundir@linaro.org>
References: <1406910649-4028-1-git-send-email-amit.pundir@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Todd Poynor <toddpoynor@google.com>

Currently when a pending wakeup irq stops suspend, it can be difficult
to determine why suspend was prevented and which IRQ was actually
responsible.

In order to help debug these situations, this patch prints the IRQ
number and action name of that pending wakeup irq which prevents suspend.
This patch comes from the Android patch set, where its been used to debug
suspend problems.

Cc: Pavel Machek <pavel@ucw.cz>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Rafael J. Wysocki <rjw@rjwysocki.net>
Cc: Len Brown <len.brown@intel.com>
Cc: linux-pm@vger.kernel.org
Cc: Android Kernel Team <kernel-team@android.com>
Cc: John Stultz <john.stultz@linaro.org>
Cc: Sumit Semwal <sumit.semwal@linaro.org>
Signed-off-by: Todd Poynor <toddpoynor@google.com>
[Amit Pundir: Reworded the commit message]
Signed-off-by: Amit Pundir <amit.pundir@linaro.org>
---
 kernel/irq/pm.c |    7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/kernel/irq/pm.c b/kernel/irq/pm.c
index abcd6ca..c2bc8d9 100644
--- a/kernel/irq/pm.c
+++ b/kernel/irq/pm.c
@@ -109,8 +109,13 @@ int check_wakeup_irqs(void)
 		 * can abort suspend.
 		 */
 		if (irqd_is_wakeup_set(&desc->irq_data)) {
-			if (desc->depth == 1 && desc->istate & IRQS_PENDING)
+			if (desc->depth == 1 && desc->istate & IRQS_PENDING) {
+				pr_info("Wakeup IRQ %d %s pending, suspend aborted\n",
+					irq,
+					desc->action && desc->action->name ?
+					desc->action->name : "");
 				return -EBUSY;
+			}
 			continue;
 		}
 		/*
-- 
1.7.10.4

