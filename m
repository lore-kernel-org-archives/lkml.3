Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752923Ab3A3BXs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jan 2013 20:23:48 -0500
Received: from terminus.zytor.com ([198.137.202.10]:43627 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751626Ab3A3BXr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jan 2013 20:23:47 -0500
Date: Tue, 29 Jan 2013 17:23:35 -0800
From: tip-bot for Yinghai Lu <yinghai@kernel.org>
Message-ID: <tip-231b3642a3c73fb9f1221dcb96fe8c0fbb658dfd@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        yinghai@kernel.org, tglx@linutronix.de, hpa@linux.intel.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        yinghai@kernel.org, tglx@linutronix.de, hpa@linux.intel.com
In-Reply-To: <1359058816-7615-7-git-send-email-yinghai@kernel.org>
References: <1359058816-7615-7-git-send-email-yinghai@kernel.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/mm2] x86, realmode: Set real_mode permissions early
Git-Commit-ID: 231b3642a3c73fb9f1221dcb96fe8c0fbb658dfd
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Tue, 29 Jan 2013 17:23:41 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  231b3642a3c73fb9f1221dcb96fe8c0fbb658dfd
Gitweb:     http://git.kernel.org/tip/231b3642a3c73fb9f1221dcb96fe8c0fbb658dfd
Author:     Yinghai Lu <yinghai@kernel.org>
AuthorDate: Thu, 24 Jan 2013 12:19:47 -0800
Committer:  H. Peter Anvin <hpa@linux.intel.com>
CommitDate: Tue, 29 Jan 2013 15:12:25 -0800

x86, realmode: Set real_mode permissions early

Trampoline code is executed by APs with kernel low mapping on 64bit.
We need to set trampoline code to EXEC early before we boot APs.

Found the problem after switching to #PF handler set page table,
and we do not set initial kernel low mapping with EXEC anymore in
arch/x86/kernel/head_64.S.

Change to use early_initcall instead that will make sure trampoline
will have EXEC set.

-v2: Merge two comments according to Borislav Petkov <bp@alien8.de>

Signed-off-by: Yinghai Lu <yinghai@kernel.org>
Link: http://lkml.kernel.org/r/1359058816-7615-7-git-send-email-yinghai@kernel.org
Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
---
 arch/x86/realmode/init.c | 11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

diff --git a/arch/x86/realmode/init.c b/arch/x86/realmode/init.c
index cbca565..c44ea7c 100644
--- a/arch/x86/realmode/init.c
+++ b/arch/x86/realmode/init.c
@@ -84,10 +84,12 @@ void __init setup_real_mode(void)
 }
 
 /*
- * set_real_mode_permissions() gets called very early, to guarantee the
- * availability of low memory.  This is before the proper kernel page
+ * setup_real_mode() gets called very early, to guarantee the
+ * availability of low memory. This is before the proper kernel page
  * tables are set up, so we cannot set page permissions in that
- * function.  Thus, we use an arch_initcall instead.
+ * function. Also trampoline code will be executed by APs so we
+ * need to mark it executable at do_pre_smp_initcalls() at least,
+ * thus run it as a early_initcall().
  */
 static int __init set_real_mode_permissions(void)
 {
@@ -111,5 +113,4 @@ static int __init set_real_mode_permissions(void)
 
 	return 0;
 }
-
-arch_initcall(set_real_mode_permissions);
+early_initcall(set_real_mode_permissions);
