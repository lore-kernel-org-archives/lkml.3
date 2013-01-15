Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756072Ab3AOGYF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jan 2013 01:24:05 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:55565 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751095Ab3AOGXu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jan 2013 01:23:50 -0500
MIME-Version: 1.0
In-Reply-To: <CACVXFVNB3bOxF8aZ3Cg3vtOQZR=jNsDj=RbUQcKAhuc0c--Tyg@mail.gmail.com>
References: <CALxABCaE3=XpGmgNJs1pre11aJ8T0pntVzf_mA6_OYNzis9nvQ@mail.gmail.com>
	<Pine.LNX.4.44L0.1301131153520.17578-100000@netrider.rowland.org>
	<CALxABCYtKJD4YrPxy6p+Frim8erccp3ine7SVEV9ReoaRh1BWQ@mail.gmail.com>
	<CACVXFVPMH-CHGw2EVwgYK5ozn1NAygT0f9=Df4vhSJmYYOZBMw@mail.gmail.com>
	<CACVXFVNvBeHG2TgfNY-wRQYtqsd6v-3AAiQVPAECuRnJ--ON-g@mail.gmail.com>
	<CA+55aFxV40V2WvNtJY3EC0F-B9wPk8CV2o1TTTyoF4CoWH7rhQ@mail.gmail.com>
	<CACVXFVNB3bOxF8aZ3Cg3vtOQZR=jNsDj=RbUQcKAhuc0c--Tyg@mail.gmail.com>
Date: Tue, 15 Jan 2013 14:23:47 +0800
Message-ID: <CACVXFVMFyhM+EsBytw0MKVW4Vp4aOtc_5sfX0v-643m7fwnc3Q@mail.gmail.com>
Subject: Re: USB device cannot be reconnected and khubd "blocked for more than
 120 seconds"
From: Ming Lei <ming.lei@canonical.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Alex Riesen <raa.lkml@gmail.com>, Alan Stern <stern@rowland.harvard.edu>,
        Jens Axboe <axboe@kernel.dk>, USB list <linux-usb@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 15, 2013 at 9:53 AM, Ming Lei <ming.lei@canonical.com> wrote:
>
> I will try to figure out one patch to address the scsi block async probe
> issue first, and see if it can fix the problem by moving add_disk()
> into sd_probe()
> and calling async_synchronize_full_domain(&scsi_sd_probe_domain)
> in the entry of sd_open().

Looks it isn't doable because the block partition device can only be created
inside the async things.

But I have another idea to address the problem, and let module code call
async_synchronize_full() only if the module requires that explicitly, so how
about the below draft patch?

diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index 7992635..c5106a0 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -3143,6 +3143,8 @@ static int __init init_sd(void)
 	if (err)
 		goto err_out_driver;

+	mod_init_async_wait(THIS_MODULE);
+
 	return 0;

 err_out_driver:
diff --git a/include/linux/module.h b/include/linux/module.h
index 7760c6d..09bd4c5 100644
--- a/include/linux/module.h
+++ b/include/linux/module.h
@@ -300,6 +300,12 @@ struct module

 	unsigned int taints;	/* same bits as kernel:tainted */

+	/*
+	 * set if the module wants to call async_synchronize_full
+	 * after its init() is complted.
+	 */
+	unsigned int init_async_wait:1;
+
 #ifdef CONFIG_GENERIC_BUG
 	/* Support for BUG */
 	unsigned num_bugs;
@@ -656,4 +662,16 @@ static inline void module_bug_finalize(const Elf_Ehdr *hdr,
 static inline void module_bug_cleanup(struct module *mod) {}
 #endif	/* CONFIG_GENERIC_BUG */

+/*
+ * If one module wants to complete its all async code after
+ * its init() executed, the module can call this function in
+ * the entry of its init(), but the module's async function
+ * can't call request_module, otherwise deadlock will be caused.
+ */
+static inline void mod_init_async_wait(struct module *mod)
+{
+	if (mod)
+		mod->init_async_wait = 1;
+}
+
 #endif /* _LINUX_MODULE_H */
diff --git a/kernel/module.c b/kernel/module.c
index 250092c..dc5d011 100644
--- a/kernel/module.c
+++ b/kernel/module.c
@@ -3058,8 +3058,9 @@ static int do_init_module(struct module *mod)
 	blocking_notifier_call_chain(&module_notify_list,
 				     MODULE_STATE_LIVE, mod);

-	/* We need to finish all async code before the module init sequence is done */
-	async_synchronize_full();
+	/* Only complete all async code if the module requires that */
+	if (mod->init_async_wait)
+		async_synchronize_full();

 	mutex_lock(&module_mutex);
 	/* Drop initial reference. */


Thanks,
--
Ming Lei
