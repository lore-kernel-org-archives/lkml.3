Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752629AbaEAV3V (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 May 2014 17:29:21 -0400
Received: from mail-qg0-f41.google.com ([209.85.192.41]:46999 "EHLO
	mail-qg0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752231AbaEAV3T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 May 2014 17:29:19 -0400
X-Google-Original-From: Vince Weaver <vince@vincent-weaver-1.umelst.maine.edu>
Date: Thu, 1 May 2014 17:32:55 -0400 (EDT)
From: Vince Weaver <vincent.weaver@maine.edu>
To: Vince Weaver <vincent.weaver@maine.edu>
cc: Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@kernel.org>,
        linux-kernel@vger.kernel.org, Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [perf] more perf_fuzzer memory corruption
In-Reply-To: <alpine.DEB.2.10.1405011443410.19874@vincent-weaver-1.umelst.maine.edu>
Message-ID: <alpine.DEB.2.10.1405011729450.19874@vincent-weaver-1.umelst.maine.edu>
References: <alpine.DEB.2.10.1404242243220.12717@vincent-weaver-1.umelst.maine.edu> <alpine.DEB.2.10.1404281447570.18996@vincent-weaver-1.umelst.maine.edu> <20140429094632.GP27561@twins.programming.kicks-ass.net> <alpine.DEB.2.10.1404291411220.22490@vincent-weaver-1.umelst.maine.edu>
 <20140429190108.GB30445@twins.programming.kicks-ass.net> <alpine.DEB.2.10.1404291534520.22490@vincent-weaver-1.umelst.maine.edu> <20140430184437.GH17778@laptop.programming.kicks-ass.net> <alpine.DEB.2.10.1405011003360.18142@vincent-weaver-1.umelst.maine.edu>
 <alpine.DEB.2.10.1405011023400.18142@vincent-weaver-1.umelst.maine.edu> <20140501150948.GR11096@twins.programming.kicks-ass.net> <alpine.DEB.2.10.1405011147340.18142@vincent-weaver-1.umelst.maine.edu> <alpine.DEB.2.02.1405011829190.6261@ionos.tec.linutronix.de>
 <alpine.DEB.2.10.1405011315250.19082@vincent-weaver-1.umelst.maine.edu> <alpine.DEB.2.10.1405011443410.19874@vincent-weaver-1.umelst.maine.edu>
User-Agent: Alpine 2.10 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


OK, with the following patch I've been running the problem test case for 
an hour without triggering the bug.

I'm sure this is the wrong fix (maybe patching over the problem istead of 
fixing the root cause), but it works for me.

It looks like this whole mess got introduced with 76e1d9047 in Linux 
2.6.35 when the swevent code was converted to use a hashed list.

Signed-off-by: Vince Weaver <vincent.weaver@maine.edu>

diff --git a/kernel/events/core.c b/kernel/events/core.c
index f83a71a..970d711 100644
--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -5775,6 +5800,11 @@ static void sw_perf_event_destroy(struct perf_event *event)
 
 	WARN_ON(event->parent);
 
+	perf_pmu_disable(event->pmu);
+	if ((event->hlist_entry.pprev) && (event->hlist_entry.pprev!=LIST_POISON2))
+		 event->pmu->del(event, 0);
+	perf_pmu_enable(event->pmu);
+
 	static_key_slow_dec(&perf_swevent_enabled[event_id]);
 	swevent_hlist_put(event);
 }
