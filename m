Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965751AbaGPTWu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jul 2014 15:22:50 -0400
Received: from terminus.zytor.com ([198.137.202.10]:44431 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932065AbaGPTWo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jul 2014 15:22:44 -0400
Date: Wed, 16 Jul 2014 12:21:57 -0700
From: tip-bot for David Rientjes <tipbot@zytor.com>
Message-ID: <tip-4485154138f6ffa5b252cb490aba3e8eb30124e4@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        torvalds@linux-foundation.org, peterz@infradead.org, acme@kernel.org,
        tglx@linutronix.de, rientjes@google.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, peterz@infradead.org, acme@kernel.org,
        tglx@linutronix.de, rientjes@google.com
In-Reply-To: <alpine.DEB.2.02.1406301600460.26302@chino.kir.corp.google.com>
References: <alpine.DEB.2.02.1406301600460.26302@chino.kir.corp.google.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/urgent] perf/x86/intel:
  Avoid spamming kernel log for BTS buffer failure
Git-Commit-ID: 4485154138f6ffa5b252cb490aba3e8eb30124e4
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

Commit-ID:  4485154138f6ffa5b252cb490aba3e8eb30124e4
Gitweb:     http://git.kernel.org/tip/4485154138f6ffa5b252cb490aba3e8eb30124e4
Author:     David Rientjes <rientjes@google.com>
AuthorDate: Mon, 30 Jun 2014 16:04:08 -0700
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Wed, 16 Jul 2014 13:31:30 +0200

perf/x86/intel: Avoid spamming kernel log for BTS buffer failure

It's unnecessary to excessively spam the kernel log anytime the BTS buffer
cannot be allocated, so make this allocation __GFP_NOWARN.

The user probably will want to at least find some artifact that the
allocation has failed in the past, probably due to fragmentation because
of its large size, when it's not allocated at bootstrap.  Thus, add a
WARN_ONCE() so something is left behind for them to understand why perf
commnads that require PEBS is not working properly.

Signed-off-by: David Rientjes <rientjes@google.com>
Signed-off-by: Peter Zijlstra <peterz@infradead.org>
Cc: Arnaldo Carvalho de Melo <acme@kernel.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Link: http://lkml.kernel.org/r/alpine.DEB.2.02.1406301600460.26302@chino.kir.corp.google.com
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 arch/x86/kernel/cpu/perf_event_intel_ds.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kernel/cpu/perf_event_intel_ds.c b/arch/x86/kernel/cpu/perf_event_intel_ds.c
index 980970c..696ade3 100644
--- a/arch/x86/kernel/cpu/perf_event_intel_ds.c
+++ b/arch/x86/kernel/cpu/perf_event_intel_ds.c
@@ -311,9 +311,11 @@ static int alloc_bts_buffer(int cpu)
 	if (!x86_pmu.bts)
 		return 0;
 
-	buffer = kzalloc_node(BTS_BUFFER_SIZE, GFP_KERNEL, node);
-	if (unlikely(!buffer))
+	buffer = kzalloc_node(BTS_BUFFER_SIZE, GFP_KERNEL | __GFP_NOWARN, node);
+	if (unlikely(!buffer)) {
+		WARN_ONCE(1, "%s: BTS buffer allocation failure\n", __func__);
 		return -ENOMEM;
+	}
 
 	max = BTS_BUFFER_SIZE / BTS_RECORD_SIZE;
 	thresh = max / 16;
