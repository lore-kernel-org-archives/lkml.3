Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754105AbaG2PKs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jul 2014 11:10:48 -0400
Received: from ip4-83-240-18-248.cust.nbox.cz ([83.240.18.248]:59696 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754071AbaG2PJj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jul 2014 11:09:39 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: HATAYAMA Daisuke <d.hatayama@jp.fujitsu.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org, Ingo Molnar <mingo@kernel.org>,
        Jiri Slaby <jslaby@suse.cz>
Subject: [patch added to the 3.12 stable tree] perf/x86/intel: ignore CondChgd bit to avoid false NMI handling
Date: Tue, 29 Jul 2014 17:09:19 +0200
Message-Id: <1406646576-1299-39-git-send-email-jslaby@suse.cz>
X-Mailer: git-send-email 2.0.1
In-Reply-To: <1406646576-1299-1-git-send-email-jslaby@suse.cz>
References: <1406646576-1299-1-git-send-email-jslaby@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: HATAYAMA Daisuke <d.hatayama@jp.fujitsu.com>

This patch has been added to the 3.12 stable tree. If you have any
objections, please let us know.

===============

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
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 arch/x86/kernel/cpu/perf_event_intel.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/arch/x86/kernel/cpu/perf_event_intel.c b/arch/x86/kernel/cpu/perf_event_intel.c
index f31a1655d1ff..aa4b5c132c66 100644
--- a/arch/x86/kernel/cpu/perf_event_intel.c
+++ b/arch/x86/kernel/cpu/perf_event_intel.c
@@ -1365,6 +1365,15 @@ again:
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
2.0.1

