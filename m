Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756129AbaE3U2v (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 May 2014 16:28:51 -0400
Received: from mail.skyhub.de ([78.46.96.112]:38261 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751338AbaE3U2u (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 May 2014 16:28:50 -0400
Date: Fri, 30 May 2014 22:28:40 +0200
From: Borislav Petkov <bp@alien8.de>
To: x86-ml <x86@kernel.org>
Cc: Tony Luck <tony.luck@intel.com>, lkml <linux-kernel@vger.kernel.org>
Subject: [GIT PULL] RAS fixlets for 3.16
Message-ID: <20140530202840.GI28131@pd.tnic>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi guys,

now that there will be -rc8, we don't need to delay those for 3.17, so
please pull.

Thanks.

The following changes since commit c7208164e66f63e3ec1759b98087849286410741:

  Linux 3.15-rc7 (2014-05-25 16:06:00 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/ras/ras.git tags/ras_for_3.16

for you to fetch changes up to 716079f66eacd31d040db9cd0627ca0d625d6126:

  mce: Panic when a core has reached a timeout (2014-05-30 22:05:31 +0200)

----------------------------------------------------------------
Two fixes which needn't be delayed for 3.17.

* Add proper error paths to mcheck_init_device(), from Mathieu Souchaud

* Make machine panic with the default tolerance settings if at least one
core reaches the timeout in the #MC handler.

----------------------------------------------------------------
Borislav Petkov (1):
      mce: Panic when a core has reached a timeout

Mathieu Souchaud (1):
      x86/mce: Improve mcheck_init_device() error handling

 arch/x86/kernel/cpu/mcheck/mce.c | 50 ++++++++++++++++++++++++++++++++--------
 1 file changed, 41 insertions(+), 9 deletions(-)

diff --git a/arch/x86/kernel/cpu/mcheck/mce.c b/arch/x86/kernel/cpu/mcheck/mce.c
index 68317c80de7f..6cc800381d14 100644
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

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
