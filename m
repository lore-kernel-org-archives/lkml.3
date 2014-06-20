Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758046AbaFTVL1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jun 2014 17:11:27 -0400
Received: from mail.skyhub.de ([78.46.96.112]:37817 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753502AbaFTVL0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jun 2014 17:11:26 -0400
Date: Fri, 20 Jun 2014 23:11:15 +0200
From: Borislav Petkov <bp@alien8.de>
To: Boris Ostrovsky <boris.ostrovsky@oracle.com>
Cc: tony.luck@intel.com, linux-kernel@vger.kernel.org,
        linux-edac@vger.kernel.org, mattieu.souchaud@free.fr
Subject: Re: [PATCH] x86/mce: Don't unregister CPU hotplug notifier in error
 path
Message-ID: <20140620211115.GO11391@pd.tnic>
References: <20140620152312.GB11391@pd.tnic>
 <53A45627.6090306@oracle.com>
 <20140620155845.GC11391@pd.tnic>
 <53A45E67.7070000@oracle.com>
 <20140620175240.GE11391@pd.tnic>
 <53A48DF6.9020503@oracle.com>
 <20140620200358.GK11391@pd.tnic>
 <53A496B2.2090701@oracle.com>
 <20140620202900.GL11391@pd.tnic>
 <53A49CF9.3050400@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <53A49CF9.3050400@oracle.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 20, 2014 at 04:43:37PM -0400, Boris Ostrovsky wrote:
> We are getting CPU_ONLINE notifier for ASPs during boot:

Bah, that's craptastic. Hmm, ok, let's try this instead:

--
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
