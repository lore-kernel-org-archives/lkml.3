Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932435Ab3KMToD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Nov 2013 14:44:03 -0500
Received: from terminus.zytor.com ([198.137.202.10]:54613 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932325Ab3KMTn1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Nov 2013 14:43:27 -0500
Date: Wed, 13 Nov 2013 11:43:15 -0800
From: tip-bot for Thomas Gleixner <tipbot@zytor.com>
Message-ID: <tip-9385d949d5bd0eb642ed05ea263c3638c9f4e372@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        tglx@linutronix.de, davem@davemloft.net
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        tglx@linutronix.de, davem@davemloft.net
In-Reply-To: <20130917183628.966769884@linutronix.de>
References: <20130917183628.966769884@linutronix.de>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:irq/urgent] sparc: Use preempt_schedule_irq
Git-Commit-ID: 9385d949d5bd0eb642ed05ea263c3638c9f4e372
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.1 (terminus.zytor.com [127.0.0.1]); Wed, 13 Nov 2013 11:43:21 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  9385d949d5bd0eb642ed05ea263c3638c9f4e372
Gitweb:     http://git.kernel.org/tip/9385d949d5bd0eb642ed05ea263c3638c9f4e372
Author:     Thomas Gleixner <tglx@linutronix.de>
AuthorDate: Tue, 17 Sep 2013 18:53:08 +0000
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Wed, 13 Nov 2013 20:21:47 +0100

sparc: Use preempt_schedule_irq

The low level preemption code fiddles with the PREEMPT_ACTIVE bit for
no reason and calls schedule() with interrupts disabled, which is
wrong to begin with. Remove the PREEMPT_ACTIVE fiddling and call the
proper schedule_preempt_irq() function.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Acked-by: David S. Miller <davem@davemloft.net>
Cc: sparclinux@vger.kernel.org
Link: http://lkml.kernel.org/r/20130917183628.966769884@linutronix.de

---
 arch/sparc/kernel/rtrap_64.S | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/arch/sparc/kernel/rtrap_64.S b/arch/sparc/kernel/rtrap_64.S
index afa2a9e..76213db 100644
--- a/arch/sparc/kernel/rtrap_64.S
+++ b/arch/sparc/kernel/rtrap_64.S
@@ -306,12 +306,10 @@ to_kernel:
 		 nop
 		cmp			%l4, 0
 		bne,pn			%xcc, kern_fpucheck
-		 sethi			%hi(PREEMPT_ACTIVE), %l6
-		stw			%l6, [%g6 + TI_PRE_COUNT]
-		call			schedule
+		 nop
+		call			preempt_schedule_irq
 		 nop
 		ba,pt			%xcc, rtrap
-		 stw			%g0, [%g6 + TI_PRE_COUNT]
 #endif
 kern_fpucheck:	ldub			[%g6 + TI_FPDEPTH], %l5
 		brz,pt			%l5, rt_continue
