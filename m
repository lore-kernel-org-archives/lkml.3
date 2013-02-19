Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933547Ab3BSTbh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Feb 2013 14:31:37 -0500
Received: from terminus.zytor.com ([198.137.202.10]:45570 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933416Ab3BSTbg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Feb 2013 14:31:36 -0500
Date: Tue, 19 Feb 2013 11:29:19 -0800
From: tip-bot for Borislav Petkov <tipbot@zytor.com>
Message-ID: <tip-52d3d06e706bdde3d6c5c386deb065c3b4c51618@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        boris.ostrovsky@oracle.com, gleb@redhat.com, tglx@linutronix.de,
        bp@suse.de, hpa@linux.intel.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        boris.ostrovsky@oracle.com, gleb@redhat.com, tglx@linutronix.de,
        bp@suse.de, hpa@linux.intel.com
In-Reply-To: <1361298793-31834-1-git-send-email-bp@alien8.de>
References: <1361298793-31834-1-git-send-email-bp@alien8.de>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/cpu] x86, cpu, amd:
  Fix WC+ workaround for older virtual hosts
Git-Commit-ID: 52d3d06e706bdde3d6c5c386deb065c3b4c51618
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Tue, 19 Feb 2013 11:29:25 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  52d3d06e706bdde3d6c5c386deb065c3b4c51618
Gitweb:     http://git.kernel.org/tip/52d3d06e706bdde3d6c5c386deb065c3b4c51618
Author:     Borislav Petkov <bp@suse.de>
AuthorDate: Tue, 19 Feb 2013 19:33:12 +0100
Committer:  H. Peter Anvin <hpa@linux.intel.com>
CommitDate: Tue, 19 Feb 2013 10:44:00 -0800

x86, cpu, amd: Fix WC+ workaround for older virtual hosts

The WC+ workaround for F10h introduces a new MSR and kvm host #GPs
on accesses to unknown MSRs if paravirt is not compiled in. Use the
exception-handling MSR accessors so as not to break 3.8 and later guests
booting on older hosts.

Remove a redundant family check while at it.

Cc: Gleb Natapov <gleb@redhat.com>
Cc: Boris Ostrovsky <boris.ostrovsky@oracle.com>
Signed-off-by: Borislav Petkov <bp@suse.de>
Link: http://lkml.kernel.org/r/1361298793-31834-1-git-send-email-bp@alien8.de
Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
---
 arch/x86/kernel/cpu/amd.c | 12 +++++++-----
 1 file changed, 7 insertions(+), 5 deletions(-)

diff --git a/arch/x86/kernel/cpu/amd.c b/arch/x86/kernel/cpu/amd.c
index 721ef32..163af4a 100644
--- a/arch/x86/kernel/cpu/amd.c
+++ b/arch/x86/kernel/cpu/amd.c
@@ -723,12 +723,14 @@ static void __cpuinit init_amd(struct cpuinfo_x86 *c)
 		 * performance degradation for certain nested-paging guests.
 		 * Prevent this conversion by clearing bit 24 in
 		 * MSR_AMD64_BU_CFG2.
+		 *
+		 * NOTE: we want to use the _safe accessors so as not to #GP kvm
+		 * guests on older kvm hosts.
 		 */
-		if (c->x86 == 0x10) {
-			rdmsrl(MSR_AMD64_BU_CFG2, value);
-			value &= ~(1ULL << 24);
-			wrmsrl(MSR_AMD64_BU_CFG2, value);
-		}
+
+		rdmsrl_safe(MSR_AMD64_BU_CFG2, &value);
+		value &= ~(1ULL << 24);
+		wrmsrl_safe(MSR_AMD64_BU_CFG2, value);
 	}
 
 	rdmsr_safe(MSR_AMD64_PATCH_LEVEL, &c->microcode, &dummy);
