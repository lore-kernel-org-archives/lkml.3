Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754998Ab3CKVSI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Mar 2013 17:18:08 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:37337 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754470Ab3CKVSD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Mar 2013 17:18:03 -0400
Date: Mon, 11 Mar 2013 16:17:50 -0500
From: Seth Forshee <seth.forshee@canonical.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Matt Fleming <matt.fleming@intel.com>,
        Matthew Garrett <matthew.garrett@nebula.com>,
        linux-kernel@vger.kernel.org, linux-efi@vger.kernel.org
Subject: Re: [PATCH] efivars: Allow disabling use as a pstore backend
Message-ID: <20130311211750.GB8440@thinkpad-t410>
Mail-Followup-To: "H. Peter Anvin" <hpa@zytor.com>,
	Matt Fleming <matt.fleming@intel.com>,
	Matthew Garrett <matthew.garrett@nebula.com>,
	linux-kernel@vger.kernel.org, linux-efi@vger.kernel.org
References: <1362678017-2862-1-git-send-email-seth.forshee@canonical.com>
 <5138FAD9.7050504@zytor.com>
 <20130307205915.GF24233@thinkpad-t410>
 <1362694529.15011.211.camel@mfleming-mobl1.ger.corp.intel.com>
 <513911F9.8050308@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <513911F9.8050308@zytor.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 07, 2013 at 02:17:29PM -0800, H. Peter Anvin wrote:
> On 03/07/2013 02:15 PM, Matt Fleming wrote:
> >>>
> >>> What about a command line option?
> >>
> >> That could be done. I'm assuming you want this instead of a config
> >> option, defaulted to on?
> >>
> >> How would you feel about a config option for the default value of the
> >> command line option? I intend to default this to off in Ubuntu for a
> >> while as a colleague's machine was recently bricked on two different
> >> occasions after the kernel oopsed. The config option would simplify
> >> things a bit for us, though we could always carry a patch changing the
> >> default value.
> > 
> > Not sure why a command line option would be a more natural solution to
> > this problem? The original patch looked fine to me. All other pstore
> > backends are guarded by Kconfig options.
> > 
> > Though I could see an argument for a kernel parameter to turn off the
> > EFI pstore backend code, even if it's compiled into the kernel. But that
> > would be better as an additional patch.
> > 
> 
> That way it can be enabled if needed, without the user having to build
> their own kernel.

Here's a patch that does the command line option. I'm happy with either
one.


>From 2febf7014f6fa0abf05326504423749505430b3f Mon Sep 17 00:00:00 2001
From: Seth Forshee <seth.forshee@canonical.com>
Date: Wed, 6 Mar 2013 14:25:36 -0600
Subject: [PATCH] efivars: Add module parameter to disable use as a pstore
 backend

We know that with some firmware implementations writing too much data to
UEFI variables can lead to bricking machines. Recent changes attempt to
address this issue, but for some it may still be prudent to avoid
writing large amounts of data until the solution has been proven on a
wide variety of hardware.

Crash dumps or other data from pstore can potentially be a large data
source. Add a pstore_module parameter to efivars to allow disabling its
use as a backend for pstore. Also add a config option,
CONFIG_EFI_VARS_PSTORE_DEFAULT_DISABLE, to allow setting the default
value of this paramter to true (i.e. disabled by default).

Signed-off-by: Seth Forshee <seth.forshee@canonical.com>
---
 drivers/firmware/Kconfig   |    9 ++++++
 drivers/firmware/efivars.c |   70 +++++++++++++++++---------------------------
 2 files changed, 36 insertions(+), 43 deletions(-)

diff --git a/drivers/firmware/Kconfig b/drivers/firmware/Kconfig
index 9b00072..8d556a5 100644
--- a/drivers/firmware/Kconfig
+++ b/drivers/firmware/Kconfig
@@ -53,6 +53,15 @@ config EFI_VARS
 	  Subsequent efibootmgr releases may be found at:
 	  <http://linux.dell.com/efibootmgr>
 
+config EFI_VARS_PSTORE_DEFAULT_DISABLE
+	bool "Disable using efivars as a pstore backend by default"
+	depends on EFI_VARS && PSTORE
+	default n
+	help
+	  Saying Y here will disable the use of efivars as a storage
+	  backend for pstore by default. This setting can be overridden
+	  using the efivars module's pstore_disable parameter.
+
 config EFI_PCDP
 	bool "Console device selection via EFI PCDP or HCDP table"
 	depends on ACPI && EFI && IA64
diff --git a/drivers/firmware/efivars.c b/drivers/firmware/efivars.c
index fe62aa3..7de25b7 100644
--- a/drivers/firmware/efivars.c
+++ b/drivers/firmware/efivars.c
@@ -103,6 +103,13 @@ MODULE_VERSION(EFIVARS_VERSION);
  */
 #define GUID_LEN 36
 
+#ifdef CONFIG_EFI_VARS_PSTORE_DEFAULT_DISABLE
+static bool efivars_pstore_disable = true;
+#else
+static bool efivars_pstore_disable = false;
+#endif
+module_param_named(pstore_disable, efivars_pstore_disable, bool, 0644);
+
 /*
  * The maximum size of VariableName + Data = 1024
  * Therefore, it's reasonable to save that much
@@ -1309,8 +1316,6 @@ static const struct inode_operations efivarfs_dir_inode_operations = {
 	.create = efivarfs_create,
 };
 
-static struct pstore_info efi_pstore_info;
-
 #ifdef CONFIG_PSTORE
 
 static int efi_pstore_open(struct pstore_info *psi)
@@ -1514,38 +1519,6 @@ static int efi_pstore_erase(enum pstore_type_id type, u64 id, int count,
 
 	return 0;
 }
-#else
-static int efi_pstore_open(struct pstore_info *psi)
-{
-	return 0;
-}
-
-static int efi_pstore_close(struct pstore_info *psi)
-{
-	return 0;
-}
-
-static ssize_t efi_pstore_read(u64 *id, enum pstore_type_id *type, int *count,
-			       struct timespec *timespec,
-			       char **buf, struct pstore_info *psi)
-{
-	return -1;
-}
-
-static int efi_pstore_write(enum pstore_type_id type,
-		enum kmsg_dump_reason reason, u64 *id,
-		unsigned int part, int count, size_t size,
-		struct pstore_info *psi)
-{
-	return 0;
-}
-
-static int efi_pstore_erase(enum pstore_type_id type, u64 id, int count,
-			    struct timespec time, struct pstore_info *psi)
-{
-	return 0;
-}
-#endif
 
 static struct pstore_info efi_pstore_info = {
 	.owner		= THIS_MODULE,
@@ -1557,6 +1530,24 @@ static struct pstore_info efi_pstore_info = {
 	.erase		= efi_pstore_erase,
 };
 
+static void efivar_pstore_register(struct efivars *efivars)
+{
+	efivars->efi_pstore_info = efi_pstore_info;
+	efivars->efi_pstore_info.buf = kmalloc(4096, GFP_KERNEL);
+	if (efivars->efi_pstore_info.buf) {
+		efivars->efi_pstore_info.bufsize = 1024;
+		efivars->efi_pstore_info.data = efivars;
+		spin_lock_init(&efivars->efi_pstore_info.buf_lock);
+		pstore_register(&efivars->efi_pstore_info);
+	}
+}
+#else
+static void efivar_pstore_register(struct efivars *efivars)
+{
+	return;
+}
+#endif
+
 static ssize_t efivar_create(struct file *filp, struct kobject *kobj,
 			     struct bin_attribute *bin_attr,
 			     char *buf, loff_t pos, size_t count)
@@ -2025,15 +2016,8 @@ int register_efivars(struct efivars *efivars,
 	if (error)
 		unregister_efivars(efivars);
 
-	efivars->efi_pstore_info = efi_pstore_info;
-
-	efivars->efi_pstore_info.buf = kmalloc(4096, GFP_KERNEL);
-	if (efivars->efi_pstore_info.buf) {
-		efivars->efi_pstore_info.bufsize = 1024;
-		efivars->efi_pstore_info.data = efivars;
-		spin_lock_init(&efivars->efi_pstore_info.buf_lock);
-		pstore_register(&efivars->efi_pstore_info);
-	}
+	if (!efivars_pstore_disable)
+		efivar_pstore_register(efivars);
 
 	register_filesystem(&efivarfs_type);
 
-- 
1.7.9.5

