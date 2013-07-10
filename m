Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752517Ab3GJGfc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Jul 2013 02:35:32 -0400
Received: from mx1.redhat.com ([209.132.183.28]:12640 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750768Ab3GJGfb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Jul 2013 02:35:31 -0400
Message-ID: <51DD00DB.3010107@redhat.com>
Date: Wed, 10 Jul 2013 14:36:11 +0800
From: Dave Young <dyoung@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:13.0) Gecko/20120605 Thunderbird/13.0
MIME-Version: 1.0
To: lkml <linux-kernel@vger.kernel.org>
CC: Matthew Garrett <matthew.garrett@nebula.com>, matt.fleming@intel.com
Subject: uefi boot hang (bisected)
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

latest linus tree kernel hangs on my Thinkpad T420.

I bisected this issue, culprit commit is below:

commit 1acba98f810a14b1255e34bc620594f83de37e36
Author: Matthew Garrett <matthew.garrett@nebula.com>
Date:   Sun Jun 2 18:12:25 2013 -0400

    UEFI: Don't pass boot services regions to SetVirtualAddressMap()

    We need to map boot services regions during startup in order to avoid
    firmware bugs, but we shouldn't be passing those regions to
    SetVirtualAddressMap(). Ensure that we're only passing regions that are
    marked as being mapped at runtime.

    Signed-off-by: Matthew Garrett <matthew.garrett@nebula.com>
    Signed-off-by: Matt Fleming <matt.fleming@intel.com>


Reverting this patch, the kernel boot just fine.

Another problem is: With this patch applied I tried noefi boot, but
kernel paniced, looks like efivar_init depends on efi runtime. Below
patches works for me about noefi boot though I'm not sure if it's a
right fix, please review.

--- linux-2.6.orig/drivers/firmware/efi/vars.c
+++ linux-2.6/drivers/firmware/efi/vars.c
@@ -370,6 +370,8 @@ int efivar_init(int (*func)(efi_char16_t
 	efi_guid_t vendor_guid;
 	int err = 0;

+	if (! efi_enabled(EFI_RUNTIME_SERVICES))
+		return -ENODEV;
 	variable_name = kzalloc(variable_name_size, GFP_KERNEL);
 	if (!variable_name) {
 		printk(KERN_ERR "efivars: Memory allocation failed.\n");



-- 
Thanks
Dave

