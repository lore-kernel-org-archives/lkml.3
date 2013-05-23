Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758461Ab3EWShY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 May 2013 14:37:24 -0400
Received: from mx1.redhat.com ([209.132.183.28]:48194 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756958Ab3EWShW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 May 2013 14:37:22 -0400
From: Peter Jones <pjones@redhat.com>
To: Matt Fleming <matt.fleming@intel.com>
Cc: Matthew Garrett <matthew.garrett@nebula.com>, linux-efi@vger.kernel.org,
        linux-kernel@vger.kernel.org, Peter Jones <pjones@redhat.com>
Subject: [PATCH] Print the actual UEFI error name, not just the error code.
Date: Thu, 23 May 2013 14:37:11 -0400
Message-Id: <1369334231-11100-1-git-send-email-pjones@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

EFI error numbers are useful, but symbol names are way easier to
understand when you're reading bug reports.  And since, for the most
part, we know the names, we should show them.

Signed-off-by: Peter Jones <pjones@redhat.com>
Reviewed-by: Adam Jackson <ajax@redhat.com>
---
 drivers/firmware/efivars.c | 19 +++++-------
 include/linux/efi.h        | 75 +++++++++++++++++++++++++++++++++++++++-------
 2 files changed, 71 insertions(+), 23 deletions(-)

diff --git a/drivers/firmware/efivars.c b/drivers/firmware/efivars.c
index 182ce94..6dc0676 100644
--- a/drivers/firmware/efivars.c
+++ b/drivers/firmware/efivars.c
@@ -382,8 +382,7 @@ get_var_data(struct efivars *efivars, struct efi_variable *var)
 	spin_unlock_irqrestore(&efivars->lock, flags);
 
 	if (status != EFI_SUCCESS) {
-		printk(KERN_WARNING "efivars: get_variable() failed 0x%lx!\n",
-			status);
+		efi_pr_warn(status, "efivars: get_variable() failed");
 	}
 	return status;
 }
@@ -549,8 +548,7 @@ efivar_store_raw(struct efivar_entry *entry, const char *buf, size_t count)
 	spin_unlock_irq(&efivars->lock);
 
 	if (status != EFI_SUCCESS) {
-		printk(KERN_WARNING "efivars: set_variable() failed: status=%lx\n",
-			status);
+		efi_pr_warn(status, "efivars: set_variable() failed");
 		return -EIO;
 	}
 
@@ -802,8 +800,8 @@ static ssize_t efivarfs_file_write(struct file *file,
 
 	} else {
 		spin_unlock_irq(&efivars->lock);
-		pr_warn("efivarfs: inconsistent EFI variable implementation? "
-				"status = %lx\n", status);
+		efi_pr_warn(status,
+			"efivarfs: inconsistent EFI variable implementation? ");
 	}
 
 out:
@@ -1549,8 +1547,7 @@ static ssize_t efivar_create(struct file *filp, struct kobject *kobj,
 					    new_var->Data);
 
 	if (status != EFI_SUCCESS) {
-		printk(KERN_WARNING "efivars: set_variable() failed: status=%lx\n",
-			status);
+		efi_pr_warn(status, "efivars: set_variable() failed");
 		spin_unlock_irq(&efivars->lock);
 		return -EIO;
 	}
@@ -1614,8 +1611,7 @@ static ssize_t efivar_delete(struct file *filp, struct kobject *kobj,
 					    del_var->Data);
 
 	if (status != EFI_SUCCESS) {
-		printk(KERN_WARNING "efivars: set_variable() failed: status=%lx\n",
-			status);
+		efi_pr_warn(status, "efivars: set_variable() failed");
 		spin_unlock_irq(&efivars->lock);
 		return -EIO;
 	}
@@ -2023,8 +2019,7 @@ int register_efivars(struct efivars *efivars,
 		case EFI_NOT_FOUND:
 			break;
 		default:
-			printk(KERN_WARNING "efivars: get_next_variable: status=%lx\n",
-				status);
+			efi_pr_warn(status, "efivars: get_next_variable");
 			status = EFI_NOT_FOUND;
 			break;
 		}
diff --git a/include/linux/efi.h b/include/linux/efi.h
index 3d7df3d..9f3ed60 100644
--- a/include/linux/efi.h
+++ b/include/linux/efi.h
@@ -23,18 +23,71 @@
 
 #include <asm/page.h>
 
+#define EFI_ERROR(x)		((x) | (1UL << (BITS_PER_LONG-1)))
+#define EFI_REVERSE_ERROR(x)	((x) & ~(1UL << (BITS_PER_LONG-1)))
+
 #define EFI_SUCCESS		0
-#define EFI_LOAD_ERROR          ( 1 | (1UL << (BITS_PER_LONG-1)))
-#define EFI_INVALID_PARAMETER	( 2 | (1UL << (BITS_PER_LONG-1)))
-#define EFI_UNSUPPORTED		( 3 | (1UL << (BITS_PER_LONG-1)))
-#define EFI_BAD_BUFFER_SIZE     ( 4 | (1UL << (BITS_PER_LONG-1)))
-#define EFI_BUFFER_TOO_SMALL	( 5 | (1UL << (BITS_PER_LONG-1)))
-#define EFI_NOT_READY		( 6 | (1UL << (BITS_PER_LONG-1)))
-#define EFI_DEVICE_ERROR	( 7 | (1UL << (BITS_PER_LONG-1)))
-#define EFI_WRITE_PROTECTED	( 8 | (1UL << (BITS_PER_LONG-1)))
-#define EFI_OUT_OF_RESOURCES	( 9 | (1UL << (BITS_PER_LONG-1)))
-#define EFI_NOT_FOUND		(14 | (1UL << (BITS_PER_LONG-1)))
-#define EFI_SECURITY_VIOLATION	(26 | (1UL << (BITS_PER_LONG-1)))
+#define EFI_LOAD_ERROR		EFI_ERROR(1)
+#define EFI_INVALID_PARAMETER	EFI_ERROR(2)
+#define EFI_UNSUPPORTED		EFI_ERROR(3)
+#define EFI_BAD_BUFFER_SIZE	EFI_ERROR(4)
+#define EFI_BUFFER_TOO_SMALL	EFI_ERROR(5)
+#define EFI_NOT_READY		EFI_ERROR(6)
+#define EFI_DEVICE_ERROR	EFI_ERROR(7)
+#define EFI_WRITE_PROTECTED	EFI_ERROR(8)
+#define EFI_OUT_OF_RESOURCES	EFI_ERROR(9)
+#define EFI_NOT_FOUND		EFI_ERROR(14)
+#define EFI_SECURITY_VIOLATION	EFI_ERROR(26)
+#define EFI_COMPROMISED_DATA	EFI_ERROR(33)
+
+#define EFI_MAX_ERROR	EFI_COMPROMISED_DATA
+
+static char const *efi_error_strings[] = {
+	"Success",
+	"Load Error",
+	"Invalid Parameter",
+	"Unsupported",
+	"Bad Buffer Size",
+	"Buffer Too Small",
+	"Not Ready",
+	"Device Error",
+	"Write Protected",
+	"Out Of Resources",
+	"Volume Corrupted",
+	"Volume Full",
+	"No Media",
+	"Media Changed",
+	"Not Found",
+	"Access Denied",
+	"No Response",
+	"No Mapping",
+	"Timeout",
+	"Not Started",
+	"Already Started",
+	"Aborted",
+	"ICMP Error",
+	"TFTP Error",
+	"Protocol Error",
+	"Incompatible Version",
+	"Security Violation",
+	"CRC Error",
+	"End of Media",
+	"29",
+	"30",
+	"End of File",
+	"Invalid Language",
+	"Compromised Data"
+};
+
+#define efi_pr_warn(status, fmt, ...) ({				\
+		typeof(status) __status = EFI_REVERSE_ERROR(status);	\
+		if (__status >= 0 &&					\
+				__status <= EFI_REVERSE_ERROR(EFI_MAX_ERROR))\
+			pr_warn(fmt ": %s (0x%lx)\n", ## __VA_ARGS__,	\
+				efi_error_strings[__status], __status);	\
+		else							\
+			pr_warn(fmt ": 0x%lx\n", ## __VA_ARGS__, __status);\
+	})
 
 typedef unsigned long efi_status_t;
 typedef u8 efi_bool_t;
-- 
1.8.2.1

