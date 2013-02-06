Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755876Ab3BFA1I (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Feb 2013 19:27:08 -0500
Received: from mga01.intel.com ([192.55.52.88]:28260 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753302Ab3BFA1F (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Feb 2013 19:27:05 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,610,1355126400"; 
   d="scan'208";a="287093879"
Date: Tue, 5 Feb 2013 16:27:04 -0800
From: Andi Kleen <ak@linux.intel.com>
To: Stephane Eranian <eranian@google.com>
Cc: Andi Kleen <andi@firstfloor.org>, Ingo Molnar <mingo@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 4/5] perf, x86: Support full width counting
Message-ID: <20130206002704.GA11047@tassilo.jf.intel.com>
References: <1360028954-16946-1-git-send-email-andi@firstfloor.org>
 <1360028954-16946-5-git-send-email-andi@firstfloor.org>
 <CABPqkBTyBJwaz+ON20nCM0jyQASoHXRDejtyNLJ1AoBSWS_tPA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CABPqkBTyBJwaz+ON20nCM0jyQASoHXRDejtyNLJ1AoBSWS_tPA@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Here's an updated patch. I'm not reposting the full series. 
Also cut down on cc to spare the innocents.

---

 perf, x86: Support full width counting v2

Recent Intel CPUs like Haswell and IvyBridge have a new alternative MSR
range for perfctrs that allows writing the full counter width. Enable this
range if the hardware reports it using a new capability bit.

This lowers the overhead of perf stat slightly because it has to do less
interrupts to accumulate the counter value. On Haswell it also avoids some
problems with TSX aborting when the end of the counter range is reached.

v2: Print the feature at boot
Signed-off-by: Andi Kleen <ak@linux.intel.com>

diff --git a/arch/x86/include/uapi/asm/msr-index.h b/arch/x86/include/uapi/asm/msr-index.h
index 433a59f..af41a77 100644
--- a/arch/x86/include/uapi/asm/msr-index.h
+++ b/arch/x86/include/uapi/asm/msr-index.h
@@ -163,6 +163,9 @@
 #define MSR_KNC_EVNTSEL0               0x00000028
 #define MSR_KNC_EVNTSEL1               0x00000029
 
+/* Alternative perfctr range with full access. */
+#define MSR_IA32_PMC0			0x000004c1
+
 /* AMD64 MSRs. Not complete. See the architecture manual for a more
    complete list. */
 
diff --git a/arch/x86/kernel/cpu/perf_event.h b/arch/x86/kernel/cpu/perf_event.h
index 1567b0d..ce2a863 100644
--- a/arch/x86/kernel/cpu/perf_event.h
+++ b/arch/x86/kernel/cpu/perf_event.h
@@ -278,6 +278,7 @@ union perf_capabilities {
 		u64	pebs_arch_reg:1;
 		u64	pebs_format:4;
 		u64	smm_freeze:1;
+		u64	fw_write:1;
 	};
 	u64	capabilities;
 };
diff --git a/arch/x86/kernel/cpu/perf_event_intel.c b/arch/x86/kernel/cpu/perf_event_intel.c
index aa48048..06dcc0c 100644
--- a/arch/x86/kernel/cpu/perf_event_intel.c
+++ b/arch/x86/kernel/cpu/perf_event_intel.c
@@ -2228,5 +2228,12 @@ __init int intel_pmu_init(void)
 		}
 	}
 
+	/* Support full width counters using alternative MSR range */
+	if (x86_pmu.intel_cap.fw_write) {
+		x86_pmu.max_period = x86_pmu.cntval_mask;
+		x86_pmu.perfctr = MSR_IA32_PMC0;
+		pr_cont("full-width counters, ");
+	}
+
 	return 0;
 }

-- 
ak@linux.intel.com -- Speaking for myself only
