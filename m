Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753370Ab3I0LCq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Sep 2013 07:02:46 -0400
Received: from terminus.zytor.com ([198.137.202.10]:35254 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751156Ab3I0LCo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Sep 2013 07:02:44 -0400
Date: Fri, 27 Sep 2013 04:02:04 -0700
From: tip-bot for Suravee Suthikulpanit <tipbot@zytor.com>
Message-ID: <tip-accd1e823ed1d5980106dd522a4c535084400830@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        bp@alien8.de, suravee.suthikulpanit@amd.com, jacob.w.shin@gmail.com,
        herrmann.der.user@googlemail.com, tglx@linutronix.de, bp@suse.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        bp@alien8.de, suravee.suthikulpanit@amd.com, jacob.w.shin@gmail.com,
        herrmann.der.user@googlemail.com, tglx@linutronix.de, bp@suse.de
In-Reply-To: <1285806432-1995-1-git-send-email-suravee.suthikulpanit@amd.com>
References: <1285806432-1995-1-git-send-email-suravee.suthikulpanit@amd.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/urgent] x86/microcode/AMD:
  Fix patch level reporting for family 15h
Git-Commit-ID: accd1e823ed1d5980106dd522a4c535084400830
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Fri, 27 Sep 2013 04:02:11 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  accd1e823ed1d5980106dd522a4c535084400830
Gitweb:     http://git.kernel.org/tip/accd1e823ed1d5980106dd522a4c535084400830
Author:     Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
AuthorDate: Wed, 29 Sep 2010 19:27:12 -0500
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Fri, 27 Sep 2013 09:29:27 +0200

x86/microcode/AMD: Fix patch level reporting for family 15h

On AMD family 14h, applying microcode patch on the a core (core0)
would also affect the other core (core1) in the same compute
unit. The driver would skip applying the patch on core1, but it
still need to update kernel structures to reflect the proper
patch level.

The current logic is not updating the struct
ucode_cpu_info.cpu_sig.rev of the skipped core. This causes the
/sys/devices/system/cpu/cpu1/microcode/version to report
incorrect patch level as shown below:

  $ grep . cpu?/microcode/version
  cpu0/microcode/version:0x600063d
  cpu1/microcode/version:0x6000626
  cpu2/microcode/version:0x600063d
  cpu3/microcode/version:0x6000626
  cpu4/microcode/version:0x600063d

Signed-off-by: Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
Acked-by: Borislav Petkov <bp@suse.de>
Cc: <bp@alien8.de>
Cc: <jacob.w.shin@gmail.com>
Cc: <herrmann.der.user@googlemail.com>
Link: http://lkml.kernel.org/r/1285806432-1995-1-git-send-email-suravee.suthikulpanit@amd.com
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 arch/x86/kernel/microcode_amd.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/x86/kernel/microcode_amd.c b/arch/x86/kernel/microcode_amd.c
index 7123b5d..af99f71 100644
--- a/arch/x86/kernel/microcode_amd.c
+++ b/arch/x86/kernel/microcode_amd.c
@@ -216,6 +216,7 @@ int apply_microcode_amd(int cpu)
 	/* need to apply patch? */
 	if (rev >= mc_amd->hdr.patch_id) {
 		c->microcode = rev;
+		uci->cpu_sig.rev = rev;
 		return 0;
 	}
 
