Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754056AbbAVUii (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jan 2015 15:38:38 -0500
Received: from mail-qc0-f180.google.com ([209.85.216.180]:51321 "EHLO
	mail-qc0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752715AbbAVUig (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jan 2015 15:38:36 -0500
Date: Thu, 22 Jan 2015 21:38:34 +0100
From: Stephane Eranian <eranian@google.com>
To: linux-kernel@vger.kernel.org
Cc: peterz@infradead.org, mingo@elte.hu, vincent.weaver@maine.edu,
        cl@linux.com, paulus@samba.org, acme@redhat.com
Subject: [PATCH] perf/rapl: fix crash in rapl_scale()
Message-ID: <20150122203834.GA10228@thinkpad>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


This patch fixes a systematic crash in rapl_scale()
due to an invalid pointer.

The bug was introduced by commit:
commit 89cbc76768c2fa4ed95545bf961f3a14ddfeed21
Author: Christoph Lameter <cl@linux.com>
Date:   Sun Aug 17 12:30:40 2014 -0500

    x86: Replace __get_cpu_var uses


The fix is simple. Just put the parenthesis where it needs
to be, i.e., around rapl_pmu. To my surprise, the compiler
was not complaining about passing an integer instead of a
pointer.

Reported-by: Vince Weaver <vincent.weaver@maine.edu>
Signed-off-by: Stephane Eranian <eranian@google.com>
Tested-by: Vince Weaver <vincent.weaver@maine.edu>
--

diff --git a/arch/x86/kernel/cpu/perf_event_intel_rapl.c b/arch/x86/kernel/cpu/perf_event_intel_rapl.c
index 6e434f8..c4bb8b8 100644
--- a/arch/x86/kernel/cpu/perf_event_intel_rapl.c
+++ b/arch/x86/kernel/cpu/perf_event_intel_rapl.c
@@ -142,7 +142,7 @@ static inline u64 rapl_scale(u64 v)
 	 * or use ldexp(count, -32).
 	 * Watts = Joules/Time delta
 	 */
-	return v << (32 - __this_cpu_read(rapl_pmu->hw_unit));
+	return v << (32 - __this_cpu_read(rapl_pmu)->hw_unit);
 }
 
 static u64 rapl_event_update(struct perf_event *event)
