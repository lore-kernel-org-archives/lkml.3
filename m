Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754587AbaFCNwn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jun 2014 09:52:43 -0400
Received: from mail-wi0-f181.google.com ([209.85.212.181]:36058 "EHLO
	mail-wi0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753862AbaFCNwm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jun 2014 09:52:42 -0400
Date: Tue, 3 Jun 2014 15:52:35 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [GIT PULL] x86/ras changes for v3.16
Message-ID: <20140603135235.GA32502@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the latest x86-ras-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git x86-ras-for-linus

   # HEAD: 716079f66eacd31d040db9cd0627ca0d625d6126 mce: Panic when a core has reached a timeout

Improve mcheck device initialization and bootstrap robustness.

 Thanks,

	Ingo

------------------>
Borislav Petkov (1):
      mce: Panic when a core has reached a timeout

Mathieu Souchaud (1):
      x86/mce: Improve mcheck_init_device() error handling


 arch/x86/kernel/cpu/mcheck/mce.c | 50 ++++++++++++++++++++++++++++++++--------
 1 file changed, 41 insertions(+), 9 deletions(-)

diff --git a/arch/x86/kernel/cpu/mcheck/mce.c b/arch/x86/kernel/cpu/mcheck/mce.c
index 68317c8..6cc8003 100644
--- a/arch/x86/kernel/cpu/mcheck/mce.c
+++ b/arch/x86/kernel/cpu/mcheck/mce.c
@@ -704,8 +704,7 @@ static int mce_timed_out(u64 *t)
 	if (!mca_cfg.monarch_timeout)
 		goto out;
 	if ((s64)*t < SPINUNIT) {
-		/* CHECKME: Make panic default for 1 too? */
-		if (mca_cfg.tolerant < 1)
+		if (mca_cfg.tolerant <= 1)
 			mce_panic("Timeout synchronizing machine check over CPUs",
 				  NULL, NULL);
 		cpu_missing = 1;
@@ -2437,32 +2436,65 @@ static __init int mcheck_init_device(void)
 	int err;
 	int i = 0;
 
-	if (!mce_available(&boot_cpu_data))
-		return -EIO;
+	if (!mce_available(&boot_cpu_data)) {
+		err = -EIO;
+		goto err_out;
+	}
 
-	zalloc_cpumask_var(&mce_device_initialized, GFP_KERNEL);
+	if (!zalloc_cpumask_var(&mce_device_initialized, GFP_KERNEL)) {
+		err = -ENOMEM;
+		goto err_out;
+	}
 
 	mce_init_banks();
 
 	err = subsys_system_register(&mce_subsys, NULL);
 	if (err)
-		return err;
+		goto err_out_mem;
 
 	cpu_notifier_register_begin();
 	for_each_online_cpu(i) {
 		err = mce_device_create(i);
 		if (err) {
 			cpu_notifier_register_done();
-			return err;
+			goto err_device_create;
 		}
 	}
 
-	register_syscore_ops(&mce_syscore_ops);
 	__register_hotcpu_notifier(&mce_cpu_notifier);
 	cpu_notifier_register_done();
 
+	register_syscore_ops(&mce_syscore_ops);
+
 	/* register character device /dev/mcelog */
-	misc_register(&mce_chrdev_device);
+	err = misc_register(&mce_chrdev_device);
+	if (err)
+		goto err_register;
+
+	return 0;
+
+err_register:
+	unregister_syscore_ops(&mce_syscore_ops);
+
+	cpu_notifier_register_begin();
+	__unregister_hotcpu_notifier(&mce_cpu_notifier);
+	cpu_notifier_register_done();
+
+err_device_create:
+	/*
+	 * We didn't keep track of which devices were created above, but
+	 * even if we had, the set of online cpus might have changed.
+	 * Play safe and remove for every possible cpu, since
+	 * mce_device_remove() will do the right thing.
+	 */
+	for_each_possible_cpu(i)
+		mce_device_remove(i);
+
+err_out_mem:
+	free_cpumask_var(mce_device_initialized);
+
+err_out:
+	pr_err("Unable to init device /dev/mcelog (rc: %d)\n", err);
 
 	return err;
 }
