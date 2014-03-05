Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759388AbaCEPbw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Mar 2014 10:31:52 -0500
Received: from mga09.intel.com ([134.134.136.24]:43536 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756461AbaCEPbu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Mar 2014 10:31:50 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,593,1389772800"; 
   d="scan'208";a="494521639"
Date: Wed, 5 Mar 2014 07:31:49 -0800
From: Andi Kleen <ak@linux.intel.com>
To: Jiri Olsa <jolsa@redhat.com>
Cc: Andi Kleen <andi@firstfloor.org>, acme@redhat.com, mingo@kernel.org,
        linux-kernel@vger.kernel.org, eranian@google.com, namhyung@kernel.org
Subject: Re: [PATCH 2/8] perf, tools: Support handling complete branch stacks
 as histograms v4
Message-ID: <20140305153149.GQ12219@tassilo.jf.intel.com>
References: <1393561352-23448-1-git-send-email-andi@firstfloor.org>
 <1393561352-23448-3-git-send-email-andi@firstfloor.org>
 <20140305102948.GB1835@krava.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140305102948.GB1835@krava.brq.redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> segfaults here..
> 
> [jolsa@krava perf]$ ./perf record -g sleep 1
> [ perf record: Woken up 1 times to write data ]
> [ perf record: Captured and wrote 0.013 MB perf.data (~567 samples) ]
> [jolsa@krava perf]$ ./perf report
> perf: Segmentation fault
> [jolsa@krava perf]$ 

Thanks. Fixed with this patch:

commit 124014960a8fb09043914fb79ea86e0444408ab0
Author: Andi Kleen <ak@linux.intel.com>
Date:   Wed Mar 5 07:28:56 2014 -0800

    perf, tools, report: Fix perf report without -b
    
    Fix report crash when -b is not used. Reported by Jiri Olsa.
    
    Signed-off-by: Andi Kleen <ak@linux.intel.com>

diff --git a/tools/perf/util/machine.c b/tools/perf/util/machine.c
index ef198c3..04ec451 100644
--- a/tools/perf/util/machine.c
+++ b/tools/perf/util/machine.c
@@ -1381,15 +1381,15 @@ static int machine__resolve_callchain_sample(struct machine *machine,
 	 * - No annotations (should annotate somehow)
 	 */
 
-	if (branch->nr > PERF_MAX_BRANCH_DEPTH) {
-		pr_warning("corrupted branch chain. skipping...\n");
-		return 0;
-	}
-
-	if (callchain_param.branch_callstack) {
+	if (branch && callchain_param.branch_callstack) {
 		int nr = min(max_stack, (int)branch->nr);
 		struct branch_entry be[nr];
 
+		if (branch->nr > PERF_MAX_BRANCH_DEPTH) {
+			pr_warning("corrupted branch chain. skipping...\n");
+			return 0;
+		}
+
 		for (i = 0; i < nr; i++) {
 			if (callchain_param.order == ORDER_CALLEE) {
 				be[i] = branch->entries[i];


-- 
ak@linux.intel.com -- Speaking for myself only
