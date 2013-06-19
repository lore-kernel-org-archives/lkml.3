Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756510Ab3FSHD4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Jun 2013 03:03:56 -0400
Received: from terminus.zytor.com ([198.137.202.10]:35732 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751141Ab3FSHDy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Jun 2013 03:03:54 -0400
Date: Wed, 19 Jun 2013 00:03:32 -0700
From: tip-bot for James Bottomley <tipbot@zytor.com>
Message-ID: <tip-29ce3785b22da47c49f4ef6e14b9014fa5dee261@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        srivatsa.bhat@linux.vnet.ibm.com, tglx@linutronix.de,
        JBottomley@Parallels.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        tglx@linutronix.de, srivatsa.bhat@linux.vnet.ibm.com,
        JBottomley@Parallels.com
In-Reply-To: <1371236142.2726.43.camel@dabdike>
References: <1371236142.2726.43.camel@dabdike>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:core/urgent] idle:
  Enable interrupts in the weak arch_cpu_idle() implementation
Git-Commit-ID: 29ce3785b22da47c49f4ef6e14b9014fa5dee261
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Wed, 19 Jun 2013 00:03:39 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  29ce3785b22da47c49f4ef6e14b9014fa5dee261
Gitweb:     http://git.kernel.org/tip/29ce3785b22da47c49f4ef6e14b9014fa5dee261
Author:     James Bottomley <JBottomley@Parallels.com>
AuthorDate: Wed, 8 May 2013 14:05:34 -0700
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Fri, 14 Jun 2013 23:01:05 +0200

idle: Enable interrupts in the weak arch_cpu_idle() implementation

PARISC bootup triggers the warning at kernel/cpu/idle.c:96. That's
caused by the weak arch_cpu_idle() implementation, which is provided
to avoid that architectures implement idle_poll over and over.

The switchover to polling mode happens in the first call of the weak
arch_cpu_idle() implementation, but that code fails to reenable
interrupts and therefor triggers the warning.

Fix this by enabling interrupts in the weak arch_cpu_idle() code.

[ tglx: Made the changelog match the patch ]

Signed-off-by: James Bottomley <JBottomley@Parallels.com>
Reviewed-by: Srivatsa S. Bhat <srivatsa.bhat@linux.vnet.ibm.com>
Link: http://lkml.kernel.org/r/1371236142.2726.43.camel@dabdike
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 kernel/cpu/idle.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/kernel/cpu/idle.c b/kernel/cpu/idle.c
index bf2ee1a..e695c0a 100644
--- a/kernel/cpu/idle.c
+++ b/kernel/cpu/idle.c
@@ -59,6 +59,7 @@ void __weak arch_cpu_idle_dead(void) { }
 void __weak arch_cpu_idle(void)
 {
 	cpu_idle_force_poll = 1;
+	local_irq_enable();
 }
 
 /*
