Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758949Ab3FMX2J (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Jun 2013 19:28:09 -0400
Received: from mx1.corp.phx1.mozilla.com ([63.245.216.69]:41096 "EHLO
	smtp.mozilla.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752483Ab3FMX2H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Jun 2013 19:28:07 -0400
X-Greylist: delayed 414 seconds by postgrey-1.27 at vger.kernel.org; Thu, 13 Jun 2013 19:28:07 EDT
Date: Thu, 13 Jun 2013 16:21:11 -0700
From: Jed Davis <jld@mozilla.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Will Deacon <will.deacon@arm.com>,
        Russell King <linux@arm.linux.org.uk>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [PATCH] perf: ARM: Record the user-mode PC in the call chain.
Message-ID: <20130613232111.GA12536@mozilla.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-User-Agent-Host: Linux nimbostratus 3.2.0-4-amd64 x86_64
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

With this change, we no longer lose the innermost entry in the user-mode
part of the call chain.  See also the x86 port, which includes the ip.

It's possible to partially work around this problem by post-processing
the data to use the PERF_SAMPLE_IP value, but this works only if the CPU
wasn't in the kernel when the sample was taken.

Signed-off-by: Jed Davis <jld@mozilla.com>
---
 arch/arm/kernel/perf_event.c |    1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/arm/kernel/perf_event.c b/arch/arm/kernel/perf_event.c
index 8c3094d..d9f5cd4 100644
--- a/arch/arm/kernel/perf_event.c
+++ b/arch/arm/kernel/perf_event.c
@@ -569,6 +569,7 @@ perf_callchain_user(struct perf_callchain_entry *entry, struct pt_regs *regs)
 		return;
 	}
 
+	perf_callchain_store(entry, regs->ARM_pc);
 	tail = (struct frame_tail __user *)regs->ARM_fp - 1;
 
 	while ((entry->nr < PERF_MAX_STACK_DEPTH) &&
-- 
1.7.10.4

