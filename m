Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756987Ab3IOA62 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Sep 2013 20:58:28 -0400
Received: from mail-bk0-f45.google.com ([209.85.214.45]:40436 "EHLO
	mail-bk0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756853Ab3IOA6X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Sep 2013 20:58:23 -0400
From: "Lee, Chun-Yi" <joeyli.kernel@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: linux-security-module@vger.kernel.org, linux-efi@vger.kernel.org,
        linux-pm@vger.kernel.org, linux-crypto@vger.kernel.org,
        opensuse-kernel@opensuse.org, David Howells <dhowells@redhat.com>,
        "Rafael J. Wysocki" <rjw@sisk.pl>,
        Matthew Garrett <mjg59@srcf.ucam.org>, Len Brown <len.brown@intel.com>,
        Pavel Machek <pavel@ucw.cz>, Josh Boyer <jwboyer@redhat.com>,
        Vojtech Pavlik <vojtech@suse.cz>,
        Matt Fleming <matt.fleming@intel.com>,
        James Bottomley <james.bottomley@hansenpartnership.com>,
        Greg KH <gregkh@linuxfoundation.org>, JKosina@suse.com,
        Rusty Russell <rusty@rustcorp.com.au>,
        Herbert Xu <herbert@gondor.hengli.com.au>,
        "David S. Miller" <davem@davemloft.net>,
        "H. Peter Anvin" <hpa@zytor.com>, Michal Marek <mmarek@suse.cz>,
        Gary Lin <GLin@suse.com>, Vivek Goyal <vgoyal@redhat.com>,
        "Lee, Chun-Yi" <jlee@suse.com>
Subject: [PATCH V4 11/15] Hibernate: taint kernel when signature check fail
Date: Sun, 15 Sep 2013 08:56:57 +0800
Message-Id: <1379206621-18639-12-git-send-email-jlee@suse.com>
X-Mailer: git-send-email 1.6.0.2
In-Reply-To: <1379206621-18639-1-git-send-email-jlee@suse.com>
References: <1379206621-18639-1-git-send-email-jlee@suse.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We will not direct fail the hibernate snapshot restore when the
signature check fail, instead kernel will complain by warning
message and taint kernel.

This patch also introduced a sig_enforce flag to indicate if we want
direct fail the snapshot restore when signature check fail. User can
enable it through snapshot_sig_enforce parameter or
EFI_SECURE_BOOT_SNAPSHOT_SIG_ENFORCE.

Signed-off-by: Lee, Chun-Yi <jlee@suse.com>
---
 Documentation/kernel-parameters.txt |    7 +++++++
 arch/x86/Kconfig                    |   11 +++++++++++
 include/linux/kernel.h              |    1 +
 include/linux/suspend.h             |    7 +++++++
 kernel/panic.c                      |    2 ++
 kernel/power/hibernate_keys.c       |   35 +++++++++++++++++++++++++++++++++++
 kernel/power/power.h                |    1 +
 kernel/power/snapshot.c             |    6 +++++-
 8 files changed, 69 insertions(+), 1 deletions(-)

diff --git a/Documentation/kernel-parameters.txt b/Documentation/kernel-parameters.txt
index 7f9d4f5..4c686c0 100644
--- a/Documentation/kernel-parameters.txt
+++ b/Documentation/kernel-parameters.txt
@@ -2730,6 +2730,13 @@ bytes respectively. Such letter suffixes can also be entirely omitted.
 			Useful for devices that are detected asynchronously
 			(e.g. USB and MMC devices).
 
+	snapshot_sig_enforce
+			[HIBERNATE] When CONFIG_SNAPSHOT_VERIFICATION is set,
+			this means the snapshot image without (valid) signatures
+			will fail to recover. This parameter provides user to
+			force launch the snapshot signature check even the UEFI
+			secure boot didn't enable.
+
 	hibernate=	[HIBERNATION]
 		noresume	Don't check if there's a hibernation image
 				present during boot.
diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index ea73d2f..b43217a 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -1591,6 +1591,17 @@ config EFI_SECURE_BOOT_SIG_ENFORCE
 	  Say Y here to automatically enable module signature enforcement
 	  when a system boots with UEFI Secure Boot enabled.
 
+config EFI_SECURE_BOOT_SNAPSHOT_SIG_ENFORCE
+	def_bool n
+	prompt "Force snapshot signing when UEFI Secure Boot is enabled"
+	---help---
+	  UEFI Secure Boot provides a mechanism for ensuring that the
+	  firmware will only load signed bootloaders and kernels. Certain
+	  use cases may also require that the snapshot image of hibernate
+	  also be signed.
+	  Say Y here to automatically enable snapshot iage signature
+	  enforcement when a system boots with UEFI Secure Boot enabled.
+
 config SECCOMP
 	def_bool y
 	prompt "Enable seccomp to safely compute untrusted bytecode"
diff --git a/include/linux/kernel.h b/include/linux/kernel.h
index 482ad2d..95df772 100644
--- a/include/linux/kernel.h
+++ b/include/linux/kernel.h
@@ -427,6 +427,7 @@ extern enum system_states {
 #define TAINT_CRAP			10
 #define TAINT_FIRMWARE_WORKAROUND	11
 #define TAINT_OOT_MODULE		12
+#define TAINT_UNSAFE_HIBERNATE		13
 
 extern const char hex_asc[];
 #define hex_asc_lo(x)	hex_asc[((x) & 0x0f)]
diff --git a/include/linux/suspend.h b/include/linux/suspend.h
index f73cabf..6b46726 100644
--- a/include/linux/suspend.h
+++ b/include/linux/suspend.h
@@ -320,6 +320,13 @@ extern unsigned long get_safe_page(gfp_t gfp_mask);
 extern void hibernation_set_ops(const struct platform_hibernation_ops *ops);
 extern int hibernate(void);
 extern bool system_entering_hibernation(void);
+
+#ifdef CONFIG_SNAPSHOT_VERIFICATION
+extern void enforce_signed_snapshot(void);
+#else
+static inline void enforce_signed_snapshot(void) {};
+#endif
+
 #else /* CONFIG_HIBERNATION */
 static inline void register_nosave_region(unsigned long b, unsigned long e) {}
 static inline void register_nosave_region_late(unsigned long b, unsigned long e) {}
diff --git a/kernel/panic.c b/kernel/panic.c
index 8018646..c59b1f6 100644
--- a/kernel/panic.c
+++ b/kernel/panic.c
@@ -206,6 +206,7 @@ static const struct tnt tnts[] = {
 	{ TAINT_CRAP,			'C', ' ' },
 	{ TAINT_FIRMWARE_WORKAROUND,	'I', ' ' },
 	{ TAINT_OOT_MODULE,		'O', ' ' },
+	{ TAINT_UNSAFE_HIBERNATE,	'H', ' ' },
 };
 
 /**
@@ -224,6 +225,7 @@ static const struct tnt tnts[] = {
  *  'C' - modules from drivers/staging are loaded.
  *  'I' - Working around severe firmware bug.
  *  'O' - Out-of-tree module has been loaded.
+ *  'H' - System restored from unsafe hibernate snapshot image.
  *
  *	The string is overwritten by the next call to print_tainted().
  */
diff --git a/kernel/power/hibernate_keys.c b/kernel/power/hibernate_keys.c
index 0bce9ab..daf08e0 100644
--- a/kernel/power/hibernate_keys.c
+++ b/kernel/power/hibernate_keys.c
@@ -17,6 +17,7 @@ struct forward_info {
 static void *skey_data;
 static void *forward_info_buf;
 static unsigned long skey_dsize;
+static bool sig_enforce = false;
 
 bool swsusp_page_is_sign_key(struct page *page)
 {
@@ -52,6 +53,7 @@ void fill_sig_forward_info(void *page, int sig_check_ret_in)
 	memset(page, 0, PAGE_SIZE);
 	info = (struct forward_info *)page;
 
+	info->head.sig_enforce = sig_enforce;
 	info->head.sig_check_ret = sig_check_ret_in;
 	if (skey_data && !IS_ERR(skey_data) &&
 		skey_dsize <= SKEY_DBUF_MAX_SIZE) {
@@ -74,6 +76,11 @@ void restore_sig_forward_info(void)
 	}
 	info = (struct forward_info *)forward_info_buf;
 
+	/* eanble sig_enforce either boot kernel or resume target kernel set it */
+	sig_enforce = sig_enforce || info->head.sig_enforce;
+	if (sig_enforce)
+		pr_info("PM: Enforce S4 snapshot signature check\n");
+
 	sig_check_ret = info->head.sig_check_ret;
 	if (sig_check_ret)
 		pr_info("PM: Signature check fail: %d\n", sig_check_ret);
@@ -89,6 +96,14 @@ void restore_sig_forward_info(void)
 
 	/* reset skey page buffer */
 	memset(forward_info_buf, 0, PAGE_SIZE);
+
+	/* taint kernel */
+	if (!sig_enforce && sig_check_ret) {
+		pr_warning("PM: Hibernate signature check fail, system "
+			   "restored from unsafe snapshot: tainting kernel\n");
+		add_taint(TAINT_UNSAFE_HIBERNATE, LOCKDEP_STILL_OK);
+		pr_info("%s\n", print_tainted());
+	}
 }
 
 bool skey_data_available(void)
@@ -275,6 +290,17 @@ size_t get_key_length(const struct key *key)
 	return len;
 }
 
+void enforce_signed_snapshot(void)
+{
+	sig_enforce = true;
+	pr_info("PM: Enforce signature verification of hibernate snapshot\n");
+}
+
+bool sig_enforced(void)
+{
+	return sig_enforce;
+}
+
 static int __init init_sign_key_data(void)
 {
 	skey_data = (void *)get_zeroed_page(GFP_KERNEL);
@@ -290,3 +316,12 @@ static int __init init_sign_key_data(void)
 }
 
 late_initcall(init_sign_key_data);
+
+static int __init sig_enforce_setup(char *str)
+{
+	sig_enforce = true;
+	pr_info("PM: Enforce signature verification of hibernate snapshot\n");
+	return 1;
+}
+
+__setup("snapshot_sig_enforce", sig_enforce_setup);
diff --git a/kernel/power/power.h b/kernel/power/power.h
index d2da75b..4f411ac 100644
--- a/kernel/power/power.h
+++ b/kernel/power/power.h
@@ -187,6 +187,7 @@ extern void restore_sig_forward_info(void);
 extern bool swsusp_page_is_sign_key(struct page *page);
 extern unsigned long get_sig_forward_info_pfn(void);
 extern void fill_sig_forward_info(void *page_addr, int sig_check_ret);
+extern bool sig_enforced(void);
 #else
 static inline bool skey_data_available(void)
 {
diff --git a/kernel/power/snapshot.c b/kernel/power/snapshot.c
index d3e14aa..8a166e1 100644
--- a/kernel/power/snapshot.c
+++ b/kernel/power/snapshot.c
@@ -2581,7 +2581,11 @@ int snapshot_image_verify(void)
 		pr_info("PM: snapshot signature check SUCCESS!\n");
 
 forward_ret:
-	snapshot_fill_sig_forward_info(ret);
+	/* forward check result when pass or not enforce verify success */
+	if (!ret || !sig_enforced()) {
+		snapshot_fill_sig_forward_info(ret);
+		ret = 0;
+	}
 error_shash:
 	kfree(handle_buffers);
 	kfree(digest);
-- 
1.6.0.2

