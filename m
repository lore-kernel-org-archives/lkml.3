Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755862AbaEOT1F (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 May 2014 15:27:05 -0400
Received: from mx1.redhat.com ([209.132.183.28]:1946 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755679AbaEOT0t (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 May 2014 15:26:49 -0400
From: Don Zickus <dzickus@redhat.com>
To: x86@kernel.org
Cc: Peter Zijlstra <peterz@infradead.org>, Andi Kleen <andi@firstfloor.org>,
        gong.chen@linux.intel.com, LKML <linux-kernel@vger.kernel.org>,
        Elliott@hp.com, Don Zickus <dzickus@redhat.com>
Subject: [PATCH 4/6] x86, nmi: Remove 'reason' value from unknown nmi output
Date: Thu, 15 May 2014 15:25:47 -0400
Message-Id: <1400181949-157170-5-git-send-email-dzickus@redhat.com>
In-Reply-To: <1400181949-157170-1-git-send-email-dzickus@redhat.com>
References: <1400181949-157170-1-git-send-email-dzickus@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The 'reason' value is from the io port for the external NMI.

We already have handlers that deal with non-zero 'reason'.  Providing
this in the output of unknown NMI, doesn't add much.

In addition, it should lower the number of questions I get when
customers keep attaching new unknown NMI panic updates because the
reason value changes (which is expected because part of it is a
timer bit that toggles all the time).

However, the main reason for this, is for the next patch which
will move the external NMI check to another function.  Hence the
reason value will not be available.

Signed-off-by: Don Zickus <dzickus@redhat.com>
---
 arch/x86/kernel/nmi.c |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/arch/x86/kernel/nmi.c b/arch/x86/kernel/nmi.c
index 0467f42..a5835ad 100644
--- a/arch/x86/kernel/nmi.c
+++ b/arch/x86/kernel/nmi.c
@@ -388,7 +388,7 @@ io_check_error(unsigned char reason, struct pt_regs *regs)
 }
 
 static __kprobes void
-unknown_nmi_error(unsigned char reason, struct pt_regs *regs)
+unknown_nmi_error(struct pt_regs *regs)
 {
 	int handled;
 
@@ -406,8 +406,8 @@ unknown_nmi_error(unsigned char reason, struct pt_regs *regs)
 
 	__this_cpu_add(nmi_stats.unknown, 1);
 
-	pr_emerg("Uhhuh. NMI received for unknown reason %02x on CPU %d.\n",
-		 reason, smp_processor_id());
+	pr_emerg("Uhhuh. NMI received for unknown reason on CPU %d.\n",
+		 smp_processor_id());
 
 	pr_emerg("Do you have a strange power saving mode enabled?\n");
 	if (unknown_nmi_panic || panic_on_unrecovered_nmi)
@@ -533,7 +533,7 @@ static __kprobes void default_do_nmi(struct pt_regs *regs)
 	if (b2b && __this_cpu_read(swallow_nmi))
 		__this_cpu_add(nmi_stats.swallow, 1);
 	else
-		unknown_nmi_error(reason, regs);
+		unknown_nmi_error(regs);
 }
 
 /*
-- 
1.7.1

