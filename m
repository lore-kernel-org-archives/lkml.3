Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753801Ab3IPHYo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Sep 2013 03:24:44 -0400
Received: from merlin.infradead.org ([205.233.59.134]:42852 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751923Ab3IPHYn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Sep 2013 03:24:43 -0400
Date: Mon, 16 Sep 2013 09:24:31 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Andi Kleen <andi@firstfloor.org>
Cc: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        tglx@linutronix.de, linux-tip-commits@vger.kernel.org
Subject: Re: [tip:perf/core] perf/x86/intel: Clean-up/reduce PEBS code
Message-ID: <20130916072431.GV26785@twins.programming.kicks-ass.net>
References: <tip-8q6y4davda9aawwv5yxe7klp@git.kernel.org>
 <87mwng53ki.fsf@tassilo.jf.intel.com>
 <20130916060736.GN21832@twins.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130916060736.GN21832@twins.programming.kicks-ass.net>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 16, 2013 at 08:07:36AM +0200, Peter Zijlstra wrote:
> There already was an implicit division there, and
> sizeof(pebs_record_hsw) = 176, can it really optimize that constant
> division?
> 
> I suppose we could go and introduce CONFIG_PERF_DEBUG and stuff sanity
> checks under that.. :/

Or we could write it like so:

---
--- a/arch/x86/kernel/cpu/perf_event_intel_ds.c
+++ b/arch/x86/kernel/cpu/perf_event_intel_ds.c
@@ -954,16 +954,16 @@ static void intel_pmu_drain_pebs_nhm(str
 
 	ds->pebs_index = ds->pebs_buffer_base;
 
-	n = (top - at) / x86_pmu.pebs_record_size;
-	if (n <= 0)
+	if (unlikely(at > top))
 		return;
 
 	/*
 	 * Should not happen, we program the threshold at 1 and do not
 	 * set a reset value.
 	 */
-	WARN_ONCE(n > x86_pmu.max_pebs_events,
-		  "Unexpected number of pebs records %d\n", n);
+	WARN_ONCE(top - at > x86_pmu.max_pebs_events * x86_pmu.pebs_record_size,
+		  "Unexpected number of pebs records %d\n", 
+		  (top - at) / x86_pmu.pebs_record_size);
 
 	for (; at < top; at += x86_pmu.pebs_record_size) {
 		struct pebs_record_nhm *p = at;
