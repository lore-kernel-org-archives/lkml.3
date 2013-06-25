Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753856Ab3FYTGU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Jun 2013 15:06:20 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:40936 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752403Ab3FYSdv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Jun 2013 14:33:51 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Ben Hutchings <ben@decadent.org.uk>,
        Matt Fleming <matt.fleming@intel.com>
Subject: [ 30/95] x86/efi: Fix dummy variable buffer allocation
Date: Tue, 25 Jun 2013 11:32:17 -0700
Message-Id: <20130625182157.050825943@linuxfoundation.org>
X-Mailer: git-send-email 1.8.3.rc0.20.gb99dd2e
In-Reply-To: <20130625182153.605455184@linuxfoundation.org>
References: <20130625182153.605455184@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ben Hutchings <ben@decadent.org.uk>

commit b8cb62f82103083a6e8fa5470bfe634a2c06514d upstream.

1. Check for allocation failure
2. Clear the buffer contents, as they may actually be written to flash
3. Don't leak the buffer

Compile-tested only.

[ Tested successfully on my buggy ASUS machine - Matt ]

Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
Signed-off-by: Matt Fleming <matt.fleming@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/x86/platform/efi/efi.c |    7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

--- a/arch/x86/platform/efi/efi.c
+++ b/arch/x86/platform/efi/efi.c
@@ -1059,7 +1059,10 @@ efi_status_t efi_query_variable_store(u3
 		 * that by attempting to use more space than is available.
 		 */
 		unsigned long dummy_size = remaining_size + 1024;
-		void *dummy = kmalloc(dummy_size, GFP_ATOMIC);
+		void *dummy = kzalloc(dummy_size, GFP_ATOMIC);
+
+		if (!dummy)
+			return EFI_OUT_OF_RESOURCES;
 
 		status = efi.set_variable(efi_dummy_name, &EFI_DUMMY_GUID,
 					  EFI_VARIABLE_NON_VOLATILE |
@@ -1079,6 +1082,8 @@ efi_status_t efi_query_variable_store(u3
 					 0, dummy);
 		}
 
+		kfree(dummy);
+
 		/*
 		 * The runtime code may now have triggered a garbage collection
 		 * run, so check the variable info again


