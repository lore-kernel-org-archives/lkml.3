Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933063AbaEGPgy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 May 2014 11:36:54 -0400
Received: from mx1.redhat.com ([209.132.183.28]:16442 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756207AbaEGPfR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 May 2014 11:35:17 -0400
From: Don Zickus <dzickus@redhat.com>
To: x86@kernel.org
Cc: Peter Zijlstra <peterz@infradead.org>, ak@linux.intel.com,
        gong.chen@linux.intel.com, LKML <linux-kernel@vger.kernel.org>,
        Don Zickus <dzickus@redhat.com>
Subject: [PATCH 3/5] x86, nmi: Remove 'reason' value from unknown nmi output
Date: Wed,  7 May 2014 11:34:41 -0400
Message-Id: <1399476883-98970-4-git-send-email-dzickus@redhat.com>
In-Reply-To: <1399476883-98970-1-git-send-email-dzickus@redhat.com>
References: <1399476883-98970-1-git-send-email-dzickus@redhat.com>
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
index f3f4c43..be2d622 100644
--- a/arch/x86/kernel/nmi.c
+++ b/arch/x86/kernel/nmi.c
@@ -277,7 +277,7 @@ io_check_error(unsigned char reason, struct pt_regs *regs)
 }
 
 static __kprobes void
-unknown_nmi_error(unsigned char reason, struct pt_regs *regs)
+unknown_nmi_error(struct pt_regs *regs)
 {
 	int handled;
 
@@ -295,8 +295,8 @@ unknown_nmi_error(unsigned char reason, struct pt_regs *regs)
 
 	__this_cpu_add(nmi_stats.unknown, 1);
 
-	pr_emerg("Uhhuh. NMI received for unknown reason %02x on CPU %d.\n",
-		 reason, smp_processor_id());
+	pr_emerg("Uhhuh. NMI received for unknown reason on CPU %d.\n",
+		 smp_processor_id());
 
 	pr_emerg("Do you have a strange power saving mode enabled?\n");
 	if (unknown_nmi_panic || panic_on_unrecovered_nmi)
@@ -413,7 +413,7 @@ static __kprobes void default_do_nmi(struct pt_regs *regs)
 	if (b2b && __this_cpu_read(swallow_nmi))
 		__this_cpu_add(nmi_stats.swallow, 1);
 	else
-		unknown_nmi_error(reason, regs);
+		unknown_nmi_error(regs);
 }
 
 /*
-- 
1.7.1

