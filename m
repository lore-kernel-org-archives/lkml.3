Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933222AbaGURBL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jul 2014 13:01:11 -0400
Received: from mail.skyhub.de ([78.46.96.112]:49820 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933206AbaGURBG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jul 2014 13:01:06 -0400
Date: Mon, 21 Jul 2014 19:01:00 +0200
From: Borislav Petkov <bp@alien8.de>
To: x86-ml <x86@kernel.org>
Cc: Tony Luck <tony.luck@intel.com>, lkml <linux-kernel@vger.kernel.org>
Subject: [GIT PULL] RAS urgent fix for 3.16
Message-ID: <20140721170100.GA11555@pd.tnic>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi guys,

please pull for the tip/urgent queue.

The following changes since commit 9a3c4145af32125c5ee39c0272662b47307a8323:

  Linux 3.16-rc6 (2014-07-20 21:04:16 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/ras/ras.git tags/ras_urgent

for you to fetch changes up to 51cbe7e7c400def749950ab6b2c120624dbe21a7:

  x86, MCE: Robustify mcheck_init_device (2014-07-21 18:14:32 +0200)

----------------------------------------------------------------
Promote one fix for 3.16

This fix was necessary after

9c15a24b038f ("x86/mce: Improve mcheck_init_device() error handling")

went in. What this patch did was, among others, check the return value
of misc_register and exit early if it encountered an error. Original
code sloppily didn't do that.

However,

        cef12ee52b05 ("xen/mce: Add mcelog support for Xen platform")

made it so that xen's init routine xen_late_init_mcelog runs first. This
was needed for the xen mcelog device which is supposed to be independent
from the baremetal one.

Initially it was reported that misc_register() fails often on xen and
that's why it needed fixing. However, it is *supposed* to fail by
design, when running in dom0 so that the xen mcelog device file gets
registered first.

And *then* you need the notifier *not* unregistered on the error path so
that the timer does get deleted properly in the CPU hotplug notifier.

Btw, this fix is needed also on baremetal in the unlikely event that
misc_register(&mce_chrdev_device) fails there too.

I was unsure whether to rush it in now and decided to delay it to 3.17.
However, xen people wanted it promoted as it breaks xen when doing cpu
hotplug there. So, after a bit of simmering in tip/master for initial
smoke testing, let's move it to 3.16. It fixes a semi-regression which
got introduced in 3.16 so no need for stable tagging.

tip/x86/ras contains that exact same commit but we can't remove it
there as it is not the last one. It won't cause any merge issues, as I
confirmed locally but I should state here the special situation of this
one fix explicitly anyway.

Thanks.

----------------------------------------------------------------
Borislav Petkov (1):
      x86, MCE: Robustify mcheck_init_device

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
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
