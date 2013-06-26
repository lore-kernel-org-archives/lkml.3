Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752607Ab3FZCsS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Jun 2013 22:48:18 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:54131 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752198Ab3FZCpZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Jun 2013 22:45:25 -0400
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org, "Matt Fleming" <matt.fleming@intel.com>
Date: Wed, 26 Jun 2013 03:35:58 +0100
Message-ID: <lsq.1372214158.331667502@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [09/26] x86/efi: Fix dummy variable buffer allocation
In-Reply-To: <lsq.1372214158.425780530@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.101
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.48-rc1 review patch.  If anyone has any objections, please let me know.

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
---
 arch/x86/platform/efi/efi.c |    7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

--- a/arch/x86/platform/efi/efi.c
+++ b/arch/x86/platform/efi/efi.c
@@ -875,7 +875,10 @@ efi_status_t efi_query_variable_store(u3
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
@@ -895,6 +898,8 @@ efi_status_t efi_query_variable_store(u3
 					 0, dummy);
 		}
 
+		kfree(dummy);
+
 		/*
 		 * The runtime code may now have triggered a garbage collection
 		 * run, so check the variable info again

