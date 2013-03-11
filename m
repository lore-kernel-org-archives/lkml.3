Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752892Ab3CKNT3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Mar 2013 09:19:29 -0400
Received: from smtp.nue.novell.com ([195.135.221.5]:57030 "EHLO
	smtp.nue.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751181Ab3CKNT1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Mar 2013 09:19:27 -0400
Subject: Re: [PATCH] efivarfs: fix abnormal GUID in variable name by using
 strcpy to replace null with dash
From: joeyli <jlee@suse.com>
To: Matt Fleming <matt@console-pimps.org>
Cc: linux-efi@vger.kernel.org, linux-kernel@vger.kernel.org,
        Michael Schroeder <mls@suse.com>, Josh Boyer <jwboyer@redhat.com>,
        Peter Jones <pjones@redhat.com>, Matthew Garrett <mjg59@srcf.ucam.org>,
        Frederic Crozat <fcrozat@suse.com>
In-Reply-To: <1362664663.15011.194.camel@mfleming-mobl1.ger.corp.intel.com>
References: <1362108018-13117-1-git-send-email-jlee@suse.com>
	 <1362151068.2842.440.camel@mfleming-mobl1.ger.corp.intel.com>
	 <1362155493.2842.446.camel@mfleming-mobl1.ger.corp.intel.com>
	 <1362181299.23932.168.camel@linux-s257.site>
	 <1362555258.23932.573.camel@linux-s257.site>
	 <1362568750.15011.24.camel@mfleming-mobl1.ger.corp.intel.com>
	 <1362652440.28562.26.camel@linux-s257.site>
	 <1362656348.15011.166.camel@mfleming-mobl1.ger.corp.intel.com>
	 <1362664663.15011.194.camel@mfleming-mobl1.ger.corp.intel.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 11 Mar 2013 21:17:53 +0800
Message-ID: <1363007873.13754.44.camel@linux-s257.site>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.2 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Matt, 

於 四，2013-03-07 於 13:57 +0000，Matt Fleming 提到：
> On Thu, 2013-03-07 at 11:39 +0000, Matt Fleming wrote:
> > On Thu, 2013-03-07 at 18:34 +0800, joeyli wrote:
> > > The VariableNameSize is not reliable when EFI_SUCCESS is returned
> > > because UEFI 2.3.1 spec only mention VariableNameSize should updated
> > > when EFI_BUFFER_TOO_SMALL is returned. And, the 1024 bytes of buffer is
> > > from old UEFI spec. There doesn't have any size condition of variable
> > > data or variable name in 2.3.1 spec.
> > 
> > The spec may only mention what happens in the EFI_BUFFER_TOO_SMALL case,
> > but for EFI_SUCCESS, any behaviour other than leaving VariableNameSize
> > alone or updating it with the required size of the buffer is just
> > completely insane.
> > 
> > > I modified the patch to grab VariableNameSize when EFI_BUFFER_TOO_SMALL,
> > > the behavior like what we do in efivarfs_file_read().
> > 
> > Thanks, this does seem like the most robust solution.
> 
> Also, you're probably going to need to update
> efivar_update_sysfs_entries() too.
> 

Sorry for after I wrote patch, I think it's better we still use your
original patch to fix this bug, because I found the
efi_variable->VariableName allocated 1024 size and it also used by old
vars system. 

The following is my patch for reference, but I think your original patch
is better for backward compatible on variable name.

Please consider to merge your original patch!


Thanks a lot!
Joey Lee


>From c067288dbbb963b9cf9be4c5f59f5e39e88361ad Mon Sep 17 00:00:00 2001
From: Lee, Chun-Yi <jlee@suse.com>
Date: Mon, 11 Mar 2013 18:26:04 +0800
Subject: [PATCH] efivars: Sanitise length of variable name for register


Signed-off-by: Lee, Chun-Yi <jlee@suse.com>
---
 drivers/firmware/efivars.c |   39 ++++++++++++++++++++++++++++++---------
 1 files changed, 30 insertions(+), 9 deletions(-)

diff --git a/drivers/firmware/efivars.c b/drivers/firmware/efivars.c
index 3edade0..1e854b3 100644
--- a/drivers/firmware/efivars.c
+++ b/drivers/firmware/efivars.c
@@ -111,7 +111,7 @@ MODULE_VERSION(EFIVARS_VERSION);
  */
 
 struct efi_variable {
-	efi_char16_t  VariableName[1024/sizeof(efi_char16_t)];
+	efi_char16_t  VariableName[1024/sizeof(efi_char16_t)];		/* PROBLEM: 1024 size, need backward compatible to old vars */
 	efi_guid_t    VendorGuid;
 	unsigned long DataSize;
 	__u8          Data[1024];
@@ -1903,10 +1903,11 @@ int register_efivars(struct efivars *efivars,
 	efi_status_t status = EFI_NOT_FOUND;
 	efi_guid_t vendor_guid;
 	efi_char16_t *variable_name;
-	unsigned long variable_name_size = 1024;
+	unsigned long variable_name_size;
+	unsigned long variable_name_buff_size = 1024;
 	int error = 0;
 
-	variable_name = kzalloc(variable_name_size, GFP_KERNEL);
+	variable_name = kzalloc(variable_name_buff_size, GFP_KERNEL);
 	if (!variable_name) {
 		printk(KERN_ERR "efivars: Memory allocation failed.\n");
 		return -ENOMEM;
@@ -1937,17 +1938,37 @@ int register_efivars(struct efivars *efivars,
 	 */
 
 	do {
-		variable_name_size = 1024;
+		variable_name_size = 0;
 
 		status = ops->get_next_variable(&variable_name_size,
 						variable_name,
 						&vendor_guid);
 		switch (status) {
-		case EFI_SUCCESS:
-			efivar_create_sysfs_entry(efivars,
-						  variable_name_size,
-						  variable_name,
-						  &vendor_guid);
+		case EFI_BUFFER_TOO_SMALL:
+			if (variable_name_size < sizeof(efi_char16_t) * 2) {
+				/* Bogus size - expect at least one char + NULL */
+				variable_name_size = variable_name_buff_size;
+			} else if (variable_name_size > variable_name_buff_size) {
+				kfree(variable_name);
+				variable_name = kzalloc(variable_name_size, GFP_KERNEL);
+				if (!variable_name) {
+					printk(KERN_ERR "efivars: Memory allocation failed.\n");
+					return -ENOMEM;
+				}
+				variable_name_buff_size = variable_name_size;
+			}
+			status = ops->get_next_variable(&variable_name_size,
+							variable_name,
+							&vendor_guid);
+			/* Length of the variable_name, plus terminating NULL */
+			variable_name_size = utf16_strsize(
+					variable_name, variable_name_buff_size)
+					+ sizeof(efi_char16_t);
+			if (status == EFI_SUCCESS)
+				efivar_create_sysfs_entry(efivars,
+							  variable_name_size,	/* PROBLEM: variable_name_size could not larger then new_efivar->var.VariableName = 1024 */
+							  variable_name,
+							  &vendor_guid);
 			break;
 		case EFI_NOT_FOUND:
 			break;
-- 
1.6.4.2



