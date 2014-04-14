Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755336AbaDNRo7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Apr 2014 13:44:59 -0400
Received: from userp1040.oracle.com ([156.151.31.81]:39965 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755405AbaDNRos (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Apr 2014 13:44:48 -0400
From: Sasha Levin <sasha.levin@oracle.com>
To: vegard.nossum@oracle.com, penberg@kernel.org
Cc: jamie.iles@oracle.com, hpa@zytor.com, mingo@redhat.com, tglx@linutronix.de,
        x86@kernel.org, masami.hiramatsu.pt@hitachi.com,
        linux-kernel@vger.kernel.org, linux-mm@vger.kernel.org,
        Sasha Levin <sasha.levin@oracle.com>
Subject: [PATCH 1/4] kmemcheck: add additional selfchecks
Date: Mon, 14 Apr 2014 13:44:07 -0400
Message-Id: <1397497450-6440-1-git-send-email-sasha.levin@oracle.com>
X-Mailer: git-send-email 1.8.3.2
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

kmemcheck has it's own tiny opcode decoder, and is not using the
kernel's decoder for historic reasons.

While the decoder works for more cases, it fails on quite a few
opcodes and returns incorrect values, which leads to either a
failure to detect an issue, or a false positive.

This patch adds a few of those opcodes: setne, btsl and callq,
thus causing selfcheck to fail during boot.

Signed-off-by: Sasha Levin <sasha.levin@oracle.com>
---
 arch/x86/mm/kmemcheck/selftest.c |    9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/arch/x86/mm/kmemcheck/selftest.c b/arch/x86/mm/kmemcheck/selftest.c
index aef7140..c898d33 100644
--- a/arch/x86/mm/kmemcheck/selftest.c
+++ b/arch/x86/mm/kmemcheck/selftest.c
@@ -23,6 +23,12 @@ static const struct selftest_opcode selftest_opcodes[] = {
 	{1, "\x66\x0f\xbe\x51\xf8",	"movswq <mem8>, <reg16>"},
 	{1, "\x0f\xbe\x51\xf8",		"movswq <mem8>, <reg32>"},
 
+	/* SETNE */
+	{1, "\x0f\x95\xc0",		"setne <reg8>"},
+
+	/* BTSL */
+	{4, "\x0f\xba\x6b\x10\x00",	"btsl <imm8>, <mem32>"},
+
 #ifdef CONFIG_X86_64
 	/* MOVZX / MOVZXD */
 	{1, "\x49\x0f\xb6\x51\xf8",	"movzbq <mem8>, <reg64>"},
@@ -32,6 +38,9 @@ static const struct selftest_opcode selftest_opcodes[] = {
 	{1, "\x49\x0f\xbe\x51\xf8",	"movsbq <mem8>, <reg64>"},
 	{2, "\x49\x0f\xbf\x51\xf8",	"movsbq <mem16>, <reg64>"},
 	{4, "\x49\x63\x51\xf8",		"movslq <mem32>, <reg64>"},
+
+	/* CALLQ */
+	{8, "\xe8\x00\x00\x00",		"call <mem64>"},
 #endif
 };
 
-- 
1.7.10.4

