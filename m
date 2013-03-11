Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753359Ab3CKTPW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Mar 2013 15:15:22 -0400
Received: from userp1040.oracle.com ([156.151.31.81]:48560 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751247Ab3CKTPV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Mar 2013 15:15:21 -0400
Date: Mon, 11 Mar 2013 15:15:07 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: jun.nakajima@intel.com, eranian@google.com, a.p.zijlstra@chello.nl,
        mingo@kernel.org, linux-kernel@vger.kernel.org
Subject: SNB-PEBS errate in perf code - omits stepping 2?
Message-ID: <20130311191507.GA31827@phenom.dumpdata.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hey,

I think quirk:

+static int intel_snb_pebs_broken(int cpu)
+{
+       u32 rev = UINT_MAX; /* default to broken for unknown models */
+
+       switch (cpu_data(cpu).x86_model) {
+       case 42: /* SNB */
+               rev = 0x28;
+               break;
+
+       case 45: /* SNB-EP */
+               switch (cpu_data(cpu).x86_mask) {
+               case 6: rev = 0x618; break;
+               case 7: rev = 0x70c; break;
+               }
+       }
+
+       return (cpu_data(cpu).microcode < rev);
+}
+


needs a bit of update? I've this CPU:

vendor_id       : GenuineIntel
cpu family      : 6
model           : 45
model name      : Genuine Intel(R) CPU  @ 2.30GHz
stepping        : 2
cpu MHz         : 2294.534
cache size      : 20480 KB
..
microcode       : 0x8000020c

and since the stepping is '2' and there are no 'default' case
in the switch statement, it ends up failing b/c it is asking
for revision UINT_MAX.

Is there a specific microcode errate version for this type
of CPU? Or am I a lucky recipient of an early development CPU?


Perhaps that check should also have this:

diff --git a/arch/x86/kernel/cpu/perf_event_intel.c b/arch/x86/kernel/cpu/perf_event_intel.c
index 529c893..287d43a 100644
--- a/arch/x86/kernel/cpu/perf_event_intel.c
+++ b/arch/x86/kernel/cpu/perf_event_intel.c
@@ -1845,6 +1845,9 @@ static int intel_snb_pebs_broken(int cpu)
 		case 7: rev = 0x70c; break;
 		}
 	}
+	if (rev == UINT_MAX)
+		pr_warn("Please contact Intel to update quirk as you have"
+			"an unknown CPU stepping: %d\n", cpu_data(cpu).x86_mask);
 
 	return (cpu_data(cpu).microcode < rev);
 }
