Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755458AbaFKHjS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jun 2014 03:39:18 -0400
Received: from fgwmail3.fujitsu.co.jp ([164.71.1.134]:52354 "EHLO
	fgwmail4.fujitsu.co.jp" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751311AbaFKHjR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jun 2014 03:39:17 -0400
X-Greylist: delayed 525 seconds by postgrey-1.27 at vger.kernel.org; Wed, 11 Jun 2014 03:39:16 EDT
Subject: [PATCH] perf/x86/intel: ignore CondChgd bit to avoid false NMI
 handling
From: HATAYAMA Daisuke <d.hatayama@jp.fujitsu.com>
To: a.p.zijlstra@chello.nl, acme@kernel.org, mingo@redhat.com,
        paulus@samba.org, hpa@zytor.com, tglx@linutronix.de
Cc: x86@kernel.org, linux-kernel@vger.kernel.org
Date: Wed, 11 Jun 2014 16:30:28 +0900
Message-ID: <20140611073028.9847.65622.stgit@localhost6.localdomain6>
User-Agent: StGit/0.17-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: No
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently, a NMI handler for NMI watchdog may falsely handle any NMI
signaled for different purpose if CondChgd bit in
MSR_CORE_PERF_GLOBAL_STATUS MSR is set.

This commit deals with the issue simply by ignoring CondChgd bit.

Here is explanation in detail.

On x86 NMI watchdog uses performance monitoring feature to
periodically signal NMI each time performance counter gets overflowed.

intel_pmu_handle_irq() is called as a NMI_LOCAL handler from a NMI
handler of NMI watchdog, perf_event_nmi_handler(). It identifies owner
of a given NMI by looking at overflow status bits in
MSR_CORE_PERF_GLOBAL_STATUS MSR. If some of the bits are set, then it
handles the given NMI as its own NMI.

The problem is that intel_pmu_handle_irq() doesn't distinguish
CondChgd bit from other bits. Unlike the other status bits, CondChgd
bit doesn't represent overflow status for performance counters. Thus,
CondChgd bit cannot be thought of as a mark indicating a given NMI is
NMI watchdog's.

I noticed this behavior on systems with Ivy Bridge processors: Intel
Xeon CPU E5-2630 v2 and Intel Xeon CPU E7-8890 v2. On both systems,
CondChgd bit in MSR_CORE_PERF_GLOBAL_STATUS MSR has already been set
in the beginning at boot. (then the CondChgd bit is cleared by next
wrmsr to MSR_CORE_PERF_GLOBAL_CTRL MSR and appears to remain 0.)

On the other hand, on older processors such as Nehalem, CondChgd bit
is not set in the beginning at boot.

I'm not sure about exact behavior of CondChgd bit, in particular when
this bit is set. Although I read Intel System Programmer's Manual to
figure out but I have yet completed that. At least, I think ignoring
CondChgd bit should be enough for NMI watchdog perspective.

Signed-off-by: HATAYAMA Daisuke <d.hatayama@jp.fujitsu.com>
---
 arch/x86/kernel/cpu/perf_event_intel.c |    9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/arch/x86/kernel/cpu/perf_event_intel.c b/arch/x86/kernel/cpu/perf_event_intel.c
index adb02aa..07846d7 100644
--- a/arch/x86/kernel/cpu/perf_event_intel.c
+++ b/arch/x86/kernel/cpu/perf_event_intel.c
@@ -1382,6 +1382,15 @@ again:
 	intel_pmu_lbr_read();
 
 	/*
+	 * CondChgd bit 63 doesn't mean any overflow status. Ignore
+	 * and clear the bit.
+	 */
+	if (__test_and_clear_bit(63, (unsigned long *)&status)) {
+		if (!status)
+			goto done;
+	}
+
+	/*
 	 * PEBS overflow sets bit 62 in the global status register
 	 */
 	if (__test_and_clear_bit(62, (unsigned long *)&status)) {

