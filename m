Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759262Ab3BHN1f (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Feb 2013 08:27:35 -0500
Received: from mail-vc0-f182.google.com ([209.85.220.182]:50391 "EHLO
	mail-vc0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755526Ab3BHN1e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Feb 2013 08:27:34 -0500
MIME-Version: 1.0
In-Reply-To: <CALLzPKYCjihDy32=ZQbwVN0jEitVCWKadFCxjN=vw2GnBUFmyA@mail.gmail.com>
References: <cover.1360067333.git.dmitry.kasatkin@intel.com>
	<cc87f1242960fad1a9fb44bcec331915e14c832b.1360067333.git.dmitry.kasatkin@intel.com>
	<20130207170542.GF6462@redhat.com>
	<CALLzPKYCjihDy32=ZQbwVN0jEitVCWKadFCxjN=vw2GnBUFmyA@mail.gmail.com>
Date: Fri, 8 Feb 2013 15:27:30 +0200
Message-ID: <CALLzPKZpzDY0b_GvYgiKWeu1KFeLqyfKaKzBbiw8ze6ssE2N6Q@mail.gmail.com>
Subject: Re: [RFC 2/2] initramfs with digital signature protection
From: "Kasatkin, Dmitry" <dmitry.kasatkin@intel.com>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>
>> Dmitry,
>>
>> How do we make sure that this is the first call to user mode helpers. I
>> see that we first unpacked unsigned initramfs. Then after a while we
>> unpacked signed initramfs on /root and did a chroot. But now there is
>> a window before chroot, where kernel might call into /sbin/hotplug or
>> /sbin/modprobe from unsigned initramfs?
>>
>> Specifically, I put some printk and I am seeing calls to /sbin/hotplug
>> before we even unpacked signed initramfs.
>

I did some experiments and made this  patch which prevents launching
of user mode helpers before pre-init from signed image is executed.

I do not know if this is the right way to do it, but at least it works for me.
The whole idea of these patches is to allow simple usage of signed image,
without the need to modify kernel parameters (0 block) and boot loaders....

--------------------------------------------------------------------------------------------------
commit a99eaa06ab142906da67800423425b7c5def0a3e
Author: Dmitry Kasatkin <dmitry.kasatkin@intel.com>
Date:   Fri Feb 8 15:05:22 2013 +0200

    initramfs_sig: prevent usermode helpers before signed image is executed

    This patch prevents execution of user mode helper before /pre-init
    is executed.

    Signed-off-by: Dmitry Kasatkin <dmitry.kasatkin@intel.com>

diff --git a/include/linux/kmod.h b/include/linux/kmod.h
index 5398d58..8b6d2d5 100644
--- a/include/linux/kmod.h
+++ b/include/linux/kmod.h
@@ -53,6 +53,8 @@ struct file;
 #define UMH_WAIT_PROC	2	/* wait for the process to complete */
 #define UMH_KILLABLE	4	/* wait for EXEC/PROC killable */

+#define UMH_FLAGS_SIG	0x01
+
 struct subprocess_info {
 	struct work_struct work;
 	struct completion *complete;
@@ -64,6 +66,7 @@ struct subprocess_info {
 	int (*init)(struct subprocess_info *info, struct cred *new);
 	void (*cleanup)(struct subprocess_info *info);
 	void *data;
+	unsigned flags;
 };

 extern int
@@ -71,6 +74,12 @@ call_usermodehelper_fns(char *path, char **argv,
char **envp, int wait,
 			int (*init)(struct subprocess_info *info, struct cred *new),
 			void (*cleanup)(struct subprocess_info *), void *data);

+extern int
+__call_usermodehelper_fns(char *path, char **argv, char **envp, int wait,
+			  int (*init)(struct subprocess_info *info, struct cred *new),
+			  void (*cleanup)(struct subprocess_info *),
+			  void *data, unsigned flags);
+
 static inline int
 call_usermodehelper(char *path, char **argv, char **envp, int wait)
 {
diff --git a/init/initramfs_sig.c b/init/initramfs_sig.c
index 3385414..7ab0604 100644
--- a/init/initramfs_sig.c
+++ b/init/initramfs_sig.c
@@ -146,9 +146,9 @@ static int __init load_initramfs(void)
 	 */
 	current->flags |= PF_FREEZER_SKIP;

-	err = call_usermodehelper_fns("/pre-init", argv, envp_init,
-				      UMH_WAIT_PROC, init_init, init_cleanup,
-				      NULL);
+	err = __call_usermodehelper_fns("/pre-init", argv, envp_init,
+				        UMH_WAIT_PROC, init_init, init_cleanup,
+				        NULL, UMH_FLAGS_SIG);

 	current->flags &= ~PF_FREEZER_SKIP;

@@ -167,5 +167,7 @@ int __init initramfs_sig_load(void)

 	pr_info("initramfs_sig finished\n");

+	usermodehelper_enable();
+
 	return 0;
 }
diff --git a/init/main.c b/init/main.c
index 43ef145..bbfa130 100644
--- a/init/main.c
+++ b/init/main.c
@@ -784,7 +784,9 @@ static void __init do_basic_setup(void)
 	driver_init();
 	init_irq_proc();
 	do_ctors();
+#ifndef CONFIG_INITRAMFS_SIG
 	usermodehelper_enable();
+#endif
 	do_initcalls();
 }

diff --git a/kernel/kmod.c b/kernel/kmod.c
index 0023a87..e4b9117 100644
--- a/kernel/kmod.c
+++ b/kernel/kmod.c
@@ -564,10 +564,12 @@ int call_usermodehelper_exec(struct
subprocess_info *sub_info, int wait)
 	if (sub_info->path[0] == '\0')
 		goto out;

-	if (!khelper_wq || usermodehelper_disabled) {
+	if (!khelper_wq || (usermodehelper_disabled &&
+		    !(sub_info->flags & UMH_FLAGS_SIG))) {
 		retval = -EBUSY;
 		goto out;
 	}
+	pr_info("initr: %s: %s\n", __func__, sub_info->path);
 	/*
 	 * Worker thread must not wait for khelper thread at below
 	 * wait_for_completion() if the thread was created with CLONE_VFORK
@@ -613,10 +615,10 @@ unlock:
  * check the call_usermodehelper_fns() return value: if it is -ENOMEM, perform
  * the necessaary cleanup within the caller.
  */
-int call_usermodehelper_fns(
+int __call_usermodehelper_fns(
 	char *path, char **argv, char **envp, int wait,
 	int (*init)(struct subprocess_info *info, struct cred *new),
-	void (*cleanup)(struct subprocess_info *), void *data)
+	void (*cleanup)(struct subprocess_info *), void *data, unsigned flags)
 {
 	struct subprocess_info *info;
 	gfp_t gfp_mask = (wait == UMH_NO_WAIT) ? GFP_ATOMIC : GFP_KERNEL;
@@ -628,8 +630,18 @@ int call_usermodehelper_fns(

 	call_usermodehelper_setfns(info, init, cleanup, data);

+	info->flags = flags;
+
 	return call_usermodehelper_exec(info, wait);
 }
+
+int call_usermodehelper_fns(
+	char *path, char **argv, char **envp, int wait,
+	int (*init)(struct subprocess_info *info, struct cred *new),
+	void (*cleanup)(struct subprocess_info *), void *data)
+{
+	return __call_usermodehelper_fns(path, argv, envp, wait, init,
cleanup, data, 0);
+}
 EXPORT_SYMBOL(call_usermodehelper_fns);

 static int proc_cap_handler(struct ctl_table *table, int write,
