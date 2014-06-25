Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753665AbaFYBfg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jun 2014 21:35:36 -0400
Received: from fgwmail.fujitsu.co.jp ([164.71.1.133]:34597 "EHLO
	fgwmail.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751826AbaFYBff (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jun 2014 21:35:35 -0400
X-SecurityPolicyCheck: OK by SHieldMailChecker v2.2.3
X-SHieldMailCheckerPolicyVersion: FJ-ISEC-20140219
Date: Wed, 25 Jun 2014 10:35:03 +0900 (JST)
Message-Id: <20140625.103503.409316067.d.hatayama@jp.fujitsu.com>
To: peterz@infradead.org, acme@kernel.org, mingo@redhat.com, paulus@samba.org,
        hpa@zytor.com, tglx@linutronix.de, matt@console-pimps.org,
        dzickus@redhat.com
Cc: x86@kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v3] perf/x86/intel: ignore CondChgd bit to avoid false NMI
 handling
From: HATAYAMA Daisuke <d.hatayama@jp.fujitsu.com>
X-Mailer: Mew version 6.5 on Emacs 24.3 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=iso-8859-7
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id s5P1ZmGb002984

This is a resend patch from the previous v2 patch since there's no
response except for Don.

ChangeLog

  v2 => v3
  - Add Acked-by by Don Zickus
  - Rebase the patch based on v3.16-rc2
  - Rewrite patch description a little

  v1 => v2)
  - Add reason and the fact I know on CondChgd in patch description

>From 63d6fa2a3dfa9ff7d1710c85d8d020cdc37f3b49 Mon Sep 17 00:00:00 2001
From: HATAYAMA Daisuke <d.hatayama@jp.fujitsu.com>
Date: Wed, 25 Jun 2014 10:09:07 +0900
Subject: [PATCH] perf/x86/intel: ignore CondChgd bit to avoid false NMI
 handling
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

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
---
 arch/x86/kernel/cpu/perf_event_intel.c | 9 +++++++++
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
-- 
1.9.3
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
