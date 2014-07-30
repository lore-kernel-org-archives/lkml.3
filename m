Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755503AbaG3MrS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jul 2014 08:47:18 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:36042 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752960AbaG3MrO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jul 2014 08:47:14 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: HATAYAMA Daisuke <d.hatayama@jp.fujitsu.com>
Cc: Don Zickus <dzickus@redhat.com>, Peter Zijlstra <peterz@infradead.org>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org, Ingo Molnar <mingo@kernel.org>,
        Luis Henriques <luis.henriques@canonical.com>,
        kernel-team@lists.ubuntu.com
Subject: [3.11.y.z extended stable] Patch "perf/x86/intel: ignore CondChgd bit to avoid false NMI handling" has been added to staging queue
Date: Wed, 30 Jul 2014 13:47:00 +0100
Message-Id: <1406724420-16251-1-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.9.1
X-Extended-Stable: 3.11
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a note to let you know that I have just added a patch titled

    perf/x86/intel: ignore CondChgd bit to avoid false NMI handling

to the linux-3.11.y-queue branch of the 3.11.y.z extended stable tree 
which can be found at:

 http://kernel.ubuntu.com/git?p=ubuntu/linux.git;a=shortlog;h=refs/heads/linux-3.11.y-queue

If you, or anyone else, feels it should not be added to this tree, please 
reply to this email.

For more information about the 3.11.y.z tree, see
https://wiki.ubuntu.com/Kernel/Dev/ExtendedStable

Thanks.
-Luis

------

>From af961b2e8088e933535dd5cd1dbe8819d49159a6 Mon Sep 17 00:00:00 2001
From: HATAYAMA Daisuke <d.hatayama@jp.fujitsu.com>
Date: Wed, 25 Jun 2014 10:09:07 +0900
Subject: perf/x86/intel: ignore CondChgd bit to avoid false NMI handling
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

commit b292d7a10487aee6e74b1c18b8d95b92f40d4a4f upstream.

Currently, any NMI is falsely handled by a NMI handler of NMI watchdog
if CondChgd bit in MSR_CORE_PERF_GLOBAL_STATUS MSR is set.

For example, we use external NMI to make system panic to get crash
dump, but in this case, the external NMI is falsely handled do to the
issue.

This commit deals with the issue simply by ignoring CondChgd bit.

Here is explanation in detail.

On x86 NMI watchdog uses performance monitoring feature to
periodically signal NMI each time performance counter gets overflowed.

intel_pmu_handle_irq() is called as a NMI_LOCAL handler from a NMI
handler of NMI watchdog, perf_event_nmi_handler(). It identifies an
owner of a given NMI by looking at overflow status bits in
MSR_CORE_PERF_GLOBAL_STATUS MSR. If some of the bits are set, then it
handles the given NMI as its own NMI.

The problem is that the intel_pmu_handle_irq() doesn't distinguish
CondChgd bit from other bits. Unlike the other status bits, CondChgd
bit doesn't represent overflow status for performance counters. Thus,
CondChgd bit cannot be thought of as a mark indicating a given NMI is
NMI watchdog's.

As a result, if CondChgd bit is set, any NMI is falsely handled by the
NMI handler of NMI watchdog. Also, if type of the falsely handled NMI
is either NMI_UNKNOWN, NMI_SERR or NMI_IO_CHECK, the corresponding
action is never performed until CondChgd bit is cleared.

I noticed this behavior on systems with Ivy Bridge processors: Intel
Xeon CPU E5-2630 v2 and Intel Xeon CPU E7-8890 v2. On both systems,
CondChgd bit in MSR_CORE_PERF_GLOBAL_STATUS MSR has already been set
in the beginning at boot. Then the CondChgd bit is immediately cleared
by next wrmsr to MSR_CORE_PERF_GLOBAL_CTRL MSR and appears to remain
0.

On the other hand, on older processors such as Nehalem, Xeon E7540,
CondChgd bit is not set in the beginning at boot.

I'm not sure about exact behavior of CondChgd bit, in particular when
this bit is set. Although I read Intel System Programmer's Manual to
figure out that, the descriptions I found are:

  In 18.9.1:

  "The MSR_PERF_GLOBAL_STATUS MSR also provides a ¡sticky bit¢ to
   indicate changes to the state of performancmonitoring hardware"

  In Table 35-2 IA-32 Architectural MSRs

  63 CondChg: status bits of this register has changed.

These are different from the bahviour I see on the actual system as I
explained above.

At least, I think ignoring CondChgd bit should be enough for NMI
watchdog perspective.

Signed-off-by: HATAYAMA Daisuke <d.hatayama@jp.fujitsu.com>
Acked-by: Don Zickus <dzickus@redhat.com>
Signed-off-by: Peter Zijlstra <peterz@infradead.org>
Cc: Arnaldo Carvalho de Melo <acme@kernel.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Link: http://lkml.kernel.org/r/20140625.103503.409316067.d.hatayama@jp.fujitsu.com
Signed-off-by: Ingo Molnar <mingo@kernel.org>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 arch/x86/kernel/cpu/perf_event_intel.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/arch/x86/kernel/cpu/perf_event_intel.c b/arch/x86/kernel/cpu/perf_event_intel.c
index a45d8d4ace10..6eb3e3e7fc4c 100644
--- a/arch/x86/kernel/cpu/perf_event_intel.c
+++ b/arch/x86/kernel/cpu/perf_event_intel.c
@@ -1217,6 +1217,15 @@ again:
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
--
1.9.1

