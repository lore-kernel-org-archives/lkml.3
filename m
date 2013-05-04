Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758286Ab3EDIWB (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 May 2013 04:22:01 -0400
Received: from terminus.zytor.com ([198.137.202.10]:52724 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750705Ab3EDIV7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 May 2013 04:21:59 -0400
Date: Sat, 4 May 2013 01:21:45 -0700
From: tip-bot for Peter Zijlstra <tipbot@zytor.com>
Message-ID: <tip-mk8i82ffzax01cnqo829iy1q@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        a.p.zijlstra@chello.nl, stable@kernel.org, ak@linux.intel.com,
        tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        a.p.zijlstra@chello.nl, stable@kernel.org, ak@linux.intel.com,
        tglx@linutronix.de
In-Reply-To: <20130503121256.158211806@chello.nl>
References: <20130503121256.158211806@chello.nl>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/urgent] perf/x86/intel/lbr: Fix LBR filter
Git-Commit-ID: 6e15eb3ba6c0249c9e8c783517d131b47db995ca
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  6e15eb3ba6c0249c9e8c783517d131b47db995ca
Gitweb:     http://git.kernel.org/tip/6e15eb3ba6c0249c9e8c783517d131b47db995ca
Author:     Peter Zijlstra <a.p.zijlstra@chello.nl>
AuthorDate: Fri, 3 May 2013 14:11:24 +0200
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Sat, 4 May 2013 08:37:47 +0200

perf/x86/intel/lbr: Fix LBR filter

The LBR 'from' adddress is under full userspace control; ensure
we validate it before reading from it.

Note: is_module_text_address() can potentially be quite
expensive; for those running into that with high overhead
in modules optimize it using an RCU backed rb-tree.

Reported-by: Andi Kleen <ak@linux.intel.com>
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: <stable@kernel.org>
Cc: eranian@google.com
Link: http://lkml.kernel.org/r/20130503121256.158211806@chello.nl
Signed-off-by: Ingo Molnar <mingo@kernel.org>
Link: http://lkml.kernel.org/n/tip-mk8i82ffzax01cnqo829iy1q@git.kernel.org
---
 arch/x86/kernel/cpu/perf_event_intel_lbr.c | 14 ++++++++++++--
 1 file changed, 12 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kernel/cpu/perf_event_intel_lbr.c b/arch/x86/kernel/cpu/perf_event_intel_lbr.c
index da02e9c..de341d4 100644
--- a/arch/x86/kernel/cpu/perf_event_intel_lbr.c
+++ b/arch/x86/kernel/cpu/perf_event_intel_lbr.c
@@ -442,8 +442,18 @@ static int branch_type(unsigned long from, unsigned long to)
 			return X86_BR_NONE;
 
 		addr = buf;
-	} else
-		addr = (void *)from;
+	} else {
+		/*
+		 * The LBR logs any address in the IP, even if the IP just
+		 * faulted. This means userspace can control the from address.
+		 * Ensure we don't blindy read any address by validating it is
+		 * a known text address.
+		 */
+		if (kernel_text_address(from))
+			addr = (void *)from;
+		else
+			return X86_BR_NONE;
+	}
 
 	/*
 	 * decoder needs to know the ABI especially
