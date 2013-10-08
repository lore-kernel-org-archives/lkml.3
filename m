Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756613Ab3JHQqJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Oct 2013 12:46:09 -0400
Received: from mail.skyhub.de ([78.46.96.112]:43504 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756478Ab3JHQpy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Oct 2013 12:45:54 -0400
Date: Tue, 8 Oct 2013 18:45:51 +0200
From: Borislav Petkov <bp@alien8.de>
To: X86 ML <x86@kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Borislav Petkov <bp@suse.de>,
        Matt Fleming <matt@console-pimps.org>,
        Matthew Garrett <mjg59@srcf.ucam.org>,
        "H. Peter Anvin" <hpa@zytor.com>,
        James Bottomley <James.Bottomley@HansenPartnership.com>,
        Vivek Goyal <vgoyal@redhat.com>, Dave Young <dyoung@redhat.com>,
        linux-efi@vger.kernel.org, fwts-devel@lists.ubuntu.com
Subject: Re: [PATCH 00/11] EFI runtime services virtual mapping
Message-ID: <20131008164551.GB16793@pd.tnic>
References: <1379602494-26684-1-git-send-email-bp@alien8.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1379602494-26684-1-git-send-email-bp@alien8.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ok,

here's some more changes to the UEFI RT odyssey: So we agreed upon
having a chicken bit to fallback to the old runtime services ioremapping
dance in case there's b0rked firmware (hahahah).

Then, I did some dirty fixing of fwts' efi_runtime.ko kernel module
because the new RT mapping method breaks their implicit assumption that
arguments passed to EFI RT functions are mapped in the same address
space as the kernel. This makes accessing of userspace pointers in the
EFI RT functions impossible so we need to copy stuff around.

I'm attaching a dirty patch which doesn't necessarily always do the
correct thing but it doesn't freeze the guest which is a good first
step. More correctness to it when there's time.

Btw, Matt, in order to make calling of EFI RT functions possible with
parameters in module space, we need to sync PGDs from PAGE_OFFSET all
the way to MODULES_END, see efi_sync_low_kernel_mappings().

Right, so the chicken bit is called "efi=old_map" and it should return
EFI code to the old functionality.

Anyway, the first 10 patches are the same so I'm sending only the last
two as a reply to this message.

Thanks.

--
diff --git a/efi_runtime/Makefile b/efi_runtime/Makefile
index a9c0ea7f9df6..9f197c08774d 100644
--- a/efi_runtime/Makefile
+++ b/efi_runtime/Makefile
@@ -1,9 +1,14 @@
+#ifneq ($(KERNELRELEASE),)
 obj-m += efi_runtime.o
+#else
+KERNELDIR ?= /lib/modules/$(shell uname -r)/build
+PWD := $(shell pwd)
+
 all:
-	make -C /lib/modules/$(KVER)/build M=`pwd` modules
+	make -C $(KERNELDIR) M=$(PWD) modules
 
 install:
-	make -C /lib/modules/$(KVER)/build M=`pwd` modules_install
+	make -C $(KERNELDIR) M=$(PWD) modules_install
 
 clean:
-	make -C /lib/modules/$(KVER)/build M=`pwd` clean
+	make -C $(KERNELDIR) M=$(PWD) clean
diff --git a/efi_runtime/efi_runtime.c b/efi_runtime/efi_runtime.c
index 7e3e9494ddce..8d3cf4f7f4ac 100644
--- a/efi_runtime/efi_runtime.c
+++ b/efi_runtime/efi_runtime.c
@@ -24,8 +24,9 @@
 #include <linux/init.h>
 #include <linux/proc_fs.h>
 #include <linux/efi.h>
-
+#include <linux/slab.h>
 #include <linux/uaccess.h>
+#include <linux/ucs2_string.h>
 
 #include "efi_runtime.h"
 
@@ -106,11 +107,14 @@ static long efi_runtime_ioctl(struct file *file, unsigned int cmd,
 	efi_status_t status;
 	struct efi_getvariable __user *pgetvariable;
 	struct efi_setvariable __user *psetvariable;
+	void *vardata;
+	uint16_t *varname;
+	unsigned namelen;
 
 	efi_guid_t vendor;
 	EFI_GUID vendor_guid;
 	unsigned long datasize;
-	uint32_t attr;
+	uint32_t attr, hc;
 
 	efi_time_t eft;
 	efi_time_cap_t cap;
@@ -127,8 +131,14 @@ static long efi_runtime_ioctl(struct file *file, unsigned int cmd,
 
 	struct efi_getnexthighmonotoniccount __user *pgetnexthighmonotoniccount;
 #if LINUX_VERSION_CODE >= KERNEL_VERSION(3,1,0)
-	struct efi_queryvariableinfo __user *pqueryvariableinfo;
-	struct efi_querycapsulecapabilities __user *pquerycapsulecapabilities;
+	struct efi_queryvariableinfo __user *pqvar;
+	uint64_t MaximumVariableStorageSize, RemainingVariableStorageSize, MaximumVariableSize;
+	struct efi_querycapsulecapabilities __user *u_ccaps;
+	struct efi_querycapsulecapabilities ccaps;
+	uint64_t MaximumCapsuleSize;
+	EFI_RESET_TYPE ResetType;
+	EFI_CAPSULE_HEADER *capsules;
+	int i;
 #endif
 
 	switch (cmd) {
@@ -141,34 +151,75 @@ static long efi_runtime_ioctl(struct file *file, unsigned int cmd,
 			return -EFAULT;
 
 		convert_from_guid(&vendor, &vendor_guid);
-		status = efi.get_variable(pgetvariable->VariableName, &vendor,
-					&attr, &datasize, pgetvariable->Data);
+
+		vardata = kmalloc(datasize, GFP_KERNEL);
+		if (!vardata)
+			return -ENOMEM;
+
+		namelen = ucs2_strsize(pgetvariable->VariableName, 1024);
+
+		varname = kmalloc(namelen, GFP_KERNEL);
+		if (!varname)
+			return -ENOMEM;
+
+		if (copy_from_user(varname, pgetvariable->VariableName, namelen))
+			return -EFAULT;
+
+		if (copy_from_user(vardata, pgetvariable->Data, datasize))
+			return -EFAULT;
+
+		status = efi.get_variable(varname, &vendor, &attr, &datasize, vardata);
 		if (put_user(status, pgetvariable->status))
 			return -EFAULT;
+
+		kfree(varname);
+		kfree(vardata);
+
 		if (status == EFI_SUCCESS) {
 			if (put_user(attr, pgetvariable->Attributes) ||
 				put_user(datasize, pgetvariable->DataSize))
 				return -EFAULT;
 			return 0;
 		} else {
-			printk(KERN_ERR "efi_runtime: can't get variable\n");
+			printk(KERN_ERR "efi_runtime: can't get variable, stat: 0x%lx\n",
+				status);
 			return -EINVAL;
 		}
 
 	case EFI_RUNTIME_SET_VARIABLE:
 		psetvariable = (struct efi_setvariable __user *)arg;
+
 		if (get_user(datasize, &psetvariable->DataSize) ||
 			get_user(attr, &psetvariable->Attributes) ||
 			copy_from_user(&vendor_guid, psetvariable->VendorGuid,
 							sizeof(EFI_GUID)))
 			return -EFAULT;
 
+		vardata = kmalloc(datasize, GFP_KERNEL);
+		if (!vardata)
+			return -ENOMEM;
+
+		namelen = ucs2_strsize(psetvariable->VariableName, 1024);
+
+		varname = kmalloc(namelen, GFP_KERNEL);
+		if (!varname)
+			return -ENOMEM;
+
+		if (copy_from_user(varname, psetvariable->VariableName, namelen))
+			return -EFAULT;
+
+		if (copy_from_user(vardata, psetvariable->Data, datasize))
+			return -EFAULT;
+
 		convert_from_guid(&vendor, &vendor_guid);
-		status = efi.set_variable(psetvariable->VariableName, &vendor,
-					attr, datasize, psetvariable->Data);
+		status = efi.set_variable(varname, &vendor, attr, datasize, vardata);
 
 		if (put_user(status, psetvariable->status))
 			return -EFAULT;
+
+		kfree(vardata);
+		kfree(varname);
+
 		return status == EFI_SUCCESS ? 0 : -EINVAL;
 
 	case EFI_RUNTIME_GET_TIME:
@@ -257,11 +308,19 @@ static long efi_runtime_ioctl(struct file *file, unsigned int cmd,
 		if (name_size > 1024)
 			return -EFAULT;
 
+		namelen = ucs2_strsize(pgetnextvariablename->VariableName, 1024);
+
+		varname = kmalloc(namelen, GFP_KERNEL);
+		if (!varname)
+			return -ENOMEM;
+
+		if (copy_from_user(varname, pgetnextvariablename->VariableName, namelen))
+			return -EFAULT;
+
 		convert_from_guid(&vendor, &vendor_guid);
 
-		status = efi.get_next_variable(&name_size,
-					pgetnextvariablename->VariableName,
-								&vendor);
+		status = efi.get_next_variable(&name_size, varname, &vendor);
+
 		if (put_user(status, pgetnextvariablename->status))
 			return -EFAULT;
 		convert_to_guid(&vendor, &vendor_guid);
@@ -272,6 +331,9 @@ static long efi_runtime_ioctl(struct file *file, unsigned int cmd,
 		if (copy_to_user(pgetnextvariablename->VendorGuid,
 						&vendor_guid, sizeof(EFI_GUID)))
 			return -EFAULT;
+
+		kfree(varname);
+
 		if (status != EFI_SUCCESS)
 			return -EINVAL;
 		return 0;
@@ -279,17 +341,26 @@ static long efi_runtime_ioctl(struct file *file, unsigned int cmd,
 #if LINUX_VERSION_CODE >= KERNEL_VERSION(3,1,0)
 	case EFI_RUNTIME_QUERY_VARIABLEINFO:
 
-		pqueryvariableinfo = (struct efi_queryvariableinfo __user *)arg;
+		pqvar = (struct efi_queryvariableinfo __user *)arg;
 
-		if (get_user(attr, &pqueryvariableinfo->Attributes))
+		if (get_user(attr, &pqvar->Attributes))
 			return -EFAULT;
 
 		status = efi.query_variable_info(attr,
-				pqueryvariableinfo->MaximumVariableStorageSize,
-				pqueryvariableinfo->RemainingVariableStorageSize
-				, pqueryvariableinfo->MaximumVariableSize);
-		if (put_user(status, pqueryvariableinfo->status))
+				&MaximumVariableStorageSize,
+				&RemainingVariableStorageSize,
+				&MaximumVariableSize);
+
+		if (put_user(MaximumVariableStorageSize,
+			     pqvar->MaximumVariableStorageSize) ||
+		    put_user(RemainingVariableStorageSize,
+			    pqvar->RemainingVariableStorageSize) ||
+		    put_user(MaximumVariableSize,
+			    pqvar->MaximumVariableSize) ||
+		    put_user(status, pqvar->status))
 			return -EFAULT;
+
+
 		if (status != EFI_SUCCESS)
 			return -EINVAL;
 
@@ -301,8 +372,10 @@ static long efi_runtime_ioctl(struct file *file, unsigned int cmd,
 		pgetnexthighmonotoniccount = (struct
 				efi_getnexthighmonotoniccount __user *)arg;
 
-		status = efi.get_next_high_mono_count(pgetnexthighmonotoniccount
-								->HighCount);
+		status = efi.get_next_high_mono_count(&hc);
+
+		if (put_user(hc, pgetnexthighmonotoniccount->HighCount))
+			return -EFAULT;
 		if (put_user(status, pgetnexthighmonotoniccount->status))
 			return -EFAULT;
 		if (status != EFI_SUCCESS)
@@ -313,21 +386,46 @@ static long efi_runtime_ioctl(struct file *file, unsigned int cmd,
 #if LINUX_VERSION_CODE >= KERNEL_VERSION(3,1,0)
 	case EFI_RUNTIME_QUERY_CAPSULECAPABILITIES:
 
-		pquerycapsulecapabilities = (struct
-				efi_querycapsulecapabilities __user *)arg;
+		u_ccaps = (struct efi_querycapsulecapabilities __user *)arg;
+
+		if (copy_from_user(&ccaps, u_ccaps, sizeof(ccaps)))
+			return -EFAULT;
+
+		capsules = kcalloc(ccaps.CapsuleCount + 1,
+				   sizeof(EFI_CAPSULE_HEADER),
+				   GFP_KERNEL);
+		if (!capsules)
+			return -ENOMEM;
+
+		for (i = 0; i < ccaps.CapsuleCount; i++)
+			if (copy_from_user(&capsules[i],
+					   (EFI_CAPSULE_HEADER *)u_ccaps->CapsuleHeaderArray[i],
+					   sizeof(EFI_CAPSULE_HEADER)))
+				return -EFAULT;
+
+		ccaps.CapsuleHeaderArray = &capsules;
 
 		status = efi.query_capsule_caps(
-				(efi_capsule_header_t **)
-				pquerycapsulecapabilities->CapsuleHeaderArray,
-				pquerycapsulecapabilities->CapsuleCount,
-				pquerycapsulecapabilities->MaximumCapsuleSize,
-				(int *)pquerycapsulecapabilities->ResetType);
+				(efi_capsule_header_t **) ccaps.CapsuleHeaderArray,
+				ccaps.CapsuleCount,
+				&MaximumCapsuleSize,
+				(int *)&ResetType);
 
-		if (put_user(status, pquerycapsulecapabilities->status))
+		if (put_user(status, u_ccaps->status))
 			return -EFAULT;
+
+		if (put_user(MaximumCapsuleSize,
+			     u_ccaps->MaximumCapsuleSize))
+			return -EFAULT;
+
+		if (put_user(ResetType, u_ccaps->ResetType))
+			return -EFAULT;
+
 		if (status != EFI_SUCCESS)
 			return -EINVAL;
 
+		kfree(capsules);
+
 		return 0;
 #endif
 	}

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
