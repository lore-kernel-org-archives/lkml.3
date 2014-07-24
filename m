Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934883AbaGXXhZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jul 2014 19:37:25 -0400
Received: from terminus.zytor.com ([198.137.202.10]:34868 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932131AbaGXXhX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jul 2014 19:37:23 -0400
Date: Thu, 24 Jul 2014 16:36:33 -0700
From: tip-bot for Borislav Petkov <tipbot@zytor.com>
Message-ID: <tip-51cbe7e7c400def749950ab6b2c120624dbe21a7@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        boris.ostrovsky@oracle.com, tglx@linutronix.de, bp@suse.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        boris.ostrovsky@oracle.com, tglx@linutronix.de, bp@suse.de
In-Reply-To: <1403274493-1371-1-git-send-email-boris.ostrovsky@oracle.com>
References: <1403274493-1371-1-git-send-email-boris.ostrovsky@oracle.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/urgent] x86, MCE: Robustify mcheck_init_device
Git-Commit-ID: 51cbe7e7c400def749950ab6b2c120624dbe21a7
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  51cbe7e7c400def749950ab6b2c120624dbe21a7
Gitweb:     http://git.kernel.org/tip/51cbe7e7c400def749950ab6b2c120624dbe21a7
Author:     Borislav Petkov <bp@suse.de>
AuthorDate: Fri, 20 Jun 2014 23:16:45 +0200
Committer:  Borislav Petkov <bp@suse.de>
CommitDate: Mon, 21 Jul 2014 18:14:32 +0200

x86, MCE: Robustify mcheck_init_device

BorisO reports that misc_register() fails often on xen. The current code
unregisters the CPU hotplug notifier in that case. If then a CPU is
offlined and onlined back again, we end up with a second timer running
on that CPU, leading to soft lockups and system hangs.

So let's leave the hotcpu notifier always registered - even if
mce_device_create failed for some cores and never unreg it so that we
can deal with the timer handling accordingly.

Reported-and-Tested-by: Boris Ostrovsky <boris.ostrovsky@oracle.com>
Link: http://lkml.kernel.org/r/1403274493-1371-1-git-send-email-boris.ostrovsky@oracle.com
Signed-off-by: Borislav Petkov <bp@suse.de>
---
 arch/x86/kernel/cpu/mcheck/mce.c | 10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff --git a/arch/x86/kernel/cpu/mcheck/mce.c b/arch/x86/kernel/cpu/mcheck/mce.c
index bb92f38..9a79c8d 100644
--- a/arch/x86/kernel/cpu/mcheck/mce.c
+++ b/arch/x86/kernel/cpu/mcheck/mce.c
@@ -2451,6 +2451,12 @@ static __init int mcheck_init_device(void)
 	for_each_online_cpu(i) {
 		err = mce_device_create(i);
 		if (err) {
+			/*
+			 * Register notifier anyway (and do not unreg it) so
+			 * that we don't leave undeleted timers, see notifier
+			 * callback above.
+			 */
+			__register_hotcpu_notifier(&mce_cpu_notifier);
 			cpu_notifier_register_done();
 			goto err_device_create;
 		}
@@ -2471,10 +2477,6 @@ static __init int mcheck_init_device(void)
 err_register:
 	unregister_syscore_ops(&mce_syscore_ops);
 
-	cpu_notifier_register_begin();
-	__unregister_hotcpu_notifier(&mce_cpu_notifier);
-	cpu_notifier_register_done();
-
 err_device_create:
 	/*
 	 * We didn't keep track of which devices were created above, but
