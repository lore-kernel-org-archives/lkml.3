Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932405Ab3CGE25 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Mar 2013 23:28:57 -0500
Received: from terminus.zytor.com ([198.137.202.10]:50067 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754146Ab3CGE24 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Mar 2013 23:28:56 -0500
Date: Wed, 6 Mar 2013 20:26:56 -0800
From: tip-bot for Krzysztof Mazur <tipbot@zytor.com>
Message-ID: <tip-015221fefbc93689dd47508a66326556adf2abcd@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        krzysiek@podlesie.net, tglx@linutronix.de, bp@suse.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        tglx@linutronix.de, krzysiek@podlesie.net, bp@suse.de
In-Reply-To: <1362266082-2227-1-git-send-email-krzysiek@podlesie.net>
References: <1362266082-2227-1-git-send-email-krzysiek@podlesie.net>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/urgent] x86: Fix 32-bit *_cpu_data initializers
Git-Commit-ID: 015221fefbc93689dd47508a66326556adf2abcd
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Wed, 06 Mar 2013 20:27:02 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  015221fefbc93689dd47508a66326556adf2abcd
Gitweb:     http://git.kernel.org/tip/015221fefbc93689dd47508a66326556adf2abcd
Author:     Krzysztof Mazur <krzysiek@podlesie.net>
AuthorDate: Sun, 3 Mar 2013 00:14:42 +0100
Committer:  H. Peter Anvin <hpa@zytor.com>
CommitDate: Wed, 6 Mar 2013 20:15:50 -0800

x86: Fix 32-bit *_cpu_data initializers

The commit 27be457000211a6903968dfce06d5f73f051a217
('x86 idle: remove 32-bit-only "no-hlt" parameter, hlt_works_ok
flag') removed the hlt_works_ok flag from struct cpuinfo_x86, but
boot_cpu_data and new_cpu_data initializers were not changed
causing setting f00f_bug flag, instead of fdiv_bug.

If CONFIG_X86_F00F_BUG is not set the f00f_bug flag is never
cleared.

To avoid such problems in future C99-style initialization is now
used.

Signed-off-by: Krzysztof Mazur <krzysiek@podlesie.net>
Acked-by: Borislav Petkov <bp@suse.de>
Cc: len.brown@intel.com
Link: http://lkml.kernel.org/r/1362266082-2227-1-git-send-email-krzysiek@podlesie.net
Signed-off-by: Ingo Molnar <mingo@kernel.org>
Signed-off-by: H. Peter Anvin <hpa@zytor.com>
---
 arch/x86/kernel/setup.c | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kernel/setup.c b/arch/x86/kernel/setup.c
index 84d3285..90d8cc9 100644
--- a/arch/x86/kernel/setup.c
+++ b/arch/x86/kernel/setup.c
@@ -171,9 +171,15 @@ static struct resource bss_resource = {
 
 #ifdef CONFIG_X86_32
 /* cpu data as detected by the assembly code in head.S */
-struct cpuinfo_x86 new_cpu_data __cpuinitdata = {0, 0, 0, 0, -1, 1, 0, 0, -1};
+struct cpuinfo_x86 new_cpu_data __cpuinitdata = {
+	.wp_works_ok = -1,
+	.fdiv_bug = -1,
+};
 /* common cpu data for all cpus */
-struct cpuinfo_x86 boot_cpu_data __read_mostly = {0, 0, 0, 0, -1, 1, 0, 0, -1};
+struct cpuinfo_x86 boot_cpu_data __read_mostly = {
+	.wp_works_ok = -1,
+	.fdiv_bug = -1,
+};
 EXPORT_SYMBOL(boot_cpu_data);
 
 unsigned int def_to_bigsmp;
