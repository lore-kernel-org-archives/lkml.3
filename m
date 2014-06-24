Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753505AbaFXKee (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jun 2014 06:34:34 -0400
Received: from mail.skyhub.de ([78.46.96.112]:58835 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751407AbaFXKec (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jun 2014 06:34:32 -0400
Date: Tue, 24 Jun 2014 12:34:30 +0200
From: Borislav Petkov <bp@alien8.de>
To: Boris Ostrovsky <boris.ostrovsky@oracle.com>
Cc: tony.luck@intel.com, mattieu.souchaud@free.fr, linux-edac@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] x86, MCE: Robustify mcheck_init_device
Message-ID: <20140624103430.GF4439@pd.tnic>
References: <1acfd8b6-48f1-4324-9723-224a7f4f7367@default>
 <20140624102531.GE4439@pd.tnic>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20140624102531.GE4439@pd.tnic>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Borislav Petkov <bp@suse.de>
Subject: [PATCH] x86, MCE: Robustify mcheck_init_device

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
index bb92f38153b2..9a79c8dbd8e8 100644
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
-- 
2.0.0

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
