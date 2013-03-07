Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932183Ab3CGKf3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Mar 2013 05:35:29 -0500
Received: from smtp.nue.novell.com ([195.135.221.5]:42656 "EHLO
	smtp.nue.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752909Ab3CGKf1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Mar 2013 05:35:27 -0500
Subject: Re: [PATCH] efivarfs: fix abnormal GUID in variable name by using
 strcpy to replace null with dash
From: joeyli <jlee@suse.com>
To: Matt Fleming <matt@console-pimps.org>
Cc: linux-efi@vger.kernel.org, linux-kernel@vger.kernel.org,
        Michael Schroeder <mls@suse.com>, Josh Boyer <jwboyer@redhat.com>,
        Peter Jones <pjones@redhat.com>, Matthew Garrett <mjg59@srcf.ucam.org>,
        Frederic Crozat <fcrozat@suse.com>
In-Reply-To: <1362568750.15011.24.camel@mfleming-mobl1.ger.corp.intel.com>
References: <1362108018-13117-1-git-send-email-jlee@suse.com>
	 <1362151068.2842.440.camel@mfleming-mobl1.ger.corp.intel.com>
	 <1362155493.2842.446.camel@mfleming-mobl1.ger.corp.intel.com>
	 <1362181299.23932.168.camel@linux-s257.site>
	 <1362555258.23932.573.camel@linux-s257.site>
	 <1362568750.15011.24.camel@mfleming-mobl1.ger.corp.intel.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 07 Mar 2013 18:34:00 +0800
Message-ID: <1362652440.28562.26.camel@linux-s257.site>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.2 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

於 三，2013-03-06 於 11:19 +0000，Matt Fleming 提到：
> On Wed, 2013-03-06 at 15:34 +0800, joeyli wrote:
...
> > +static unsigned long variable_name_length(efi_char16_t *variable_name)
> > +{
> > +	unsigned long len;
> > +	efi_char16_t c;
> > +
> > +	len = 2;
> > +	do {
> > +		c = variable_name[len / sizeof(c) - 1];
> > +		if (c)
> > +			len += sizeof(c);
> > +	} while (c);
> > +
> > +	return len;
> > +}
> > +
> >  int register_efivars(struct efivars *efivars,
> >  		     const struct efivar_operations *ops,
> >  		     struct kobject *parent_kobj)
> > @@ -1944,7 +1959,7 @@ int register_efivars(struct efivars *efivars,
> >  		switch (status) {
> >  		case EFI_SUCCESS:
> >  			efivar_create_sysfs_entry(efivars,
> > -						  variable_name_size,
> > +						  variable_name_length(variable_name),
> >  						  variable_name,
> >  						  &vendor_guid);
> >  			break;
> > 
> 
> Hmm.. the reason I didn't implement the patch this way is because I do
> think it's important to make sure we don't go out of bounds looking for
> the terminating NULL, i.e. you need a 'len < variable_name_size' check
> somewhere.
> 
> Care to update and resend your patch, ensuring we don't inspect more
> than variable_name_size characters?

The VariableNameSize is not reliable when EFI_SUCCESS is returned
because UEFI 2.3.1 spec only mention VariableNameSize should updated
when EFI_BUFFER_TOO_SMALL is returned. And, the 1024 bytes of buffer is
from old UEFI spec. There doesn't have any size condition of variable
data or variable name in 2.3.1 spec.

I modified the patch to grab VariableNameSize when EFI_BUFFER_TOO_SMALL,
the behavior like what we do in efivarfs_file_read().

This patch works on a normal UEFI machine, we will test it on HP z220. I
will send out it formally after test success.


Thanks a lot!
Joey Lee


>From 1f88fab2bdf07da51975d31c20ee66415c51e14e Mon Sep 17 00:00:00 2001
From: Lee, Chun-Yi <jlee@suse.com>
Date: Thu, 7 Mar 2013 18:14:25 +0800
Subject: [PATCH] efivars: Sanitise length of variable name for register

On HP z220 system (firmware version 1.54), some EFI variables have
incorrectly named :

 /sys/firmware/efi/vars/dbxDefault-pport8be4df61-93ca-11d2-aa0d-00e098032b8c
 /sys/firmware/efi/vars/KEKDefault-pport8be4df61-93ca-11d2-aa0d-00e098032b8c
 /sys/firmware/efi/vars/SecureBoot-pport8be4df61-93ca-11d2-aa0d-00e098032b8c
 /sys/firmware/efi/vars/SetupMode-Information8be4df61-93ca-11d2-aa0d-00e098032b8c

Matt Fleming and Lingzhu Xiang pointed out the reason is the variable_name_size
longer then the name string in variable_name when we feed them to
efivar_create_sysfs_entry().

Per UEFI 2.3.1 spec, the VariableNameSize is updated to reflect the size of buffer
that needed by VariableName when EFI_BUFFER_TOO_SMALL is returned. This behavior
is the same with the DataSize for GetVariable().

This patch do the same thing like efivarfs_file_read(), it feed a zero
VariableNameSize to GetNextVariableName() for grab the variable name size from
UEFI BIOS. When VariableNameSize larger then the buffer size of variable name, we
will reallocate more buffer to handle it.
The default buffer size is 1024, this number is from old UEFI spec.

In addition, we calculate the length of VariableName by using utf16_strsize()
but not direct feed VariableNameSize to efivar_create_sysfs_entry() because the
value of VariableNameSize is not reliable when EFI_SUCCESS is returned. UEFI spec
only claim the VariableNameSize updated on EFI_BUFFER_TOO_SMALL but not
on EFI_SUCCESS.

Reported-by: Frederic Crozat <fcrozat@suse.com>
Cc: Matt Fleming <matt@console-pimps.org>
Cc: Matthew Garrett <mjg59@srcf.ucam.org>
Cc: Josh Boyer <jwboyer@redhat.com>
Cc: Michael Schroeder <mls@suse.com>
Cc: Lee, Chun-Yi <jlee@suse.com>
Cc: Lingzhu Xiang <lxiang@redhat.com>
Signed-off-by: Lee, Chun-Yi <jlee@suse.com>
---
 drivers/firmware/efivars.c |   35 +++++++++++++++++++++++++++--------
 1 files changed, 27 insertions(+), 8 deletions(-)

diff --git a/drivers/firmware/efivars.c b/drivers/firmware/efivars.c
index f5596db..ff61f91 100644
--- a/drivers/firmware/efivars.c
+++ b/drivers/firmware/efivars.c
@@ -1688,10 +1688,11 @@ int register_efivars(struct efivars *efivars,
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
@@ -1722,17 +1723,35 @@ int register_efivars(struct efivars *efivars,
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
+			if (variable_name_size < 2) {
+				/* set variable_name_size to buffer size when it's too small */
+				variable_name_size = variable_name_buff_size;
+			} else if (variable_name_size > variable_name_buff_size) {
+				/* re-allocate more buffer when size doesn't enough */
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
+			variable_name_size = utf16_strsize(variable_name, variable_name_buff_size)+2;
+			if (status == EFI_SUCCESS)
+				efivar_create_sysfs_entry(efivars,
+							  variable_name_size,
+							  variable_name,
+							  &vendor_guid);
 			break;
 		case EFI_NOT_FOUND:
 			break;
-- 
1.6.4.2



