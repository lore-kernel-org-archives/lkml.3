Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932285AbaGIRKJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jul 2014 13:10:09 -0400
Received: from mail-qc0-f201.google.com ([209.85.216.201]:34977 "EHLO
	mail-qc0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756624AbaGIRJp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jul 2014 13:09:45 -0400
From: Havard Skinnemoen <hskinnemoen@google.com>
To: Tony Luck <tony.luck@intel.com>, Borislav Petkov <bp@alien8.de>
Cc: linux-kernel@vger.kernel.org, Ewout van Bekkum <ewout@google.com>,
        Havard Skinnemoen <hskinnemoen@google.com>
Subject: [PATCH 5/6] x86-mce: check if no_way_out applies before deciding not to clear MCE banks.
Date: Wed,  9 Jul 2014 10:09:25 -0700
Message-Id: <1404925766-32253-6-git-send-email-hskinnemoen@google.com>
X-Mailer: git-send-email 2.0.0.526.g5318336
In-Reply-To: <1404925766-32253-1-git-send-email-hskinnemoen@google.com>
References: <1404925766-32253-1-git-send-email-hskinnemoen@google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ewout van Bekkum <ewout@google.com>

The machine check handler, do_machine_check(), has a sanity check before
clearing the MCE banks in case the system has no_way_out and has to
crash.  However, this sanity check does not take into account the
configured MCE tolerant level as the system may still keep running. The
sanity check was updated to check if the system has no_way_out and that
no_way_out is relevant (tolerant level is less than 3).

Signed-off-by: Ewout van Bekkum <ewout@google.com>
Signed-off-by: Havard Skinnemoen <hskinnemoen@google.com>
---
 arch/x86/kernel/cpu/mcheck/mce.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/kernel/cpu/mcheck/mce.c b/arch/x86/kernel/cpu/mcheck/mce.c
index 64270d7..1587b18 100644
--- a/arch/x86/kernel/cpu/mcheck/mce.c
+++ b/arch/x86/kernel/cpu/mcheck/mce.c
@@ -1153,7 +1153,7 @@ void do_machine_check(struct pt_regs *regs, long error_code)
 	/* mce_clear_state will clear *final, save locally for use later */
 	m = *final;
 
-	if (!no_way_out)
+	if (!(no_way_out && cfg->tolerant < 3))
 		mce_clear_state(toclear);
 
 	/*
-- 
2.0.0.526.g5318336

