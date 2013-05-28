Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932526Ab3E1ESI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 May 2013 00:18:08 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:52528 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758927Ab3E1Dy0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 May 2013 23:54:26 -0400
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org, "Richard Weinberger" <richard@nod.at>,
        "Matt Fleming" <matt.fleming@intel.com>
Date: Tue, 28 May 2013 04:49:53 +0100
Message-ID: <lsq.1369712993.595694465@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [79/94] x86,efi: Implement efi_no_storage_paranoia parameter
In-Reply-To: <lsq.1369712992.755341692@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.101
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.46-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Richard Weinberger <richard@nod.at>

commit 8c58bf3eec3b8fc8162fe557e9361891c20758f2 upstream.

Using this parameter one can disable the storage_size/2 check if
he is really sure that the UEFI does sane gc and fulfills the spec.

This parameter is useful if a devices uses more than 50% of the
storage by default.
The Intel DQSW67 desktop board is such a sucker for exmaple.

Signed-off-by: Richard Weinberger <richard@nod.at>
Signed-off-by: Matt Fleming <matt.fleming@intel.com>
[bwh: Backported to 3.2: adjust context]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 Documentation/kernel-parameters.txt |    6 ++++++
 arch/x86/platform/efi/efi.c         |   14 +++++++++++++-
 2 files changed, 19 insertions(+), 1 deletion(-)

--- a/Documentation/kernel-parameters.txt
+++ b/Documentation/kernel-parameters.txt
@@ -734,6 +734,12 @@ bytes respectively. Such letter suffixes
 	edd=		[EDD]
 			Format: {"off" | "on" | "skip[mbr]"}
 
+	efi_no_storage_paranoia [EFI; X86]
+			Using this parameter you can use more than 50% of
+			your efi variable storage. Use this parameter only if
+			you are really sure that your UEFI does sane gc and
+			fulfills the spec otherwise your board may brick.
+
 	eisa_irq_edge=	[PARISC,HW]
 			See header of drivers/parisc/eisa.c.
 
--- a/arch/x86/platform/efi/efi.c
+++ b/arch/x86/platform/efi/efi.c
@@ -101,6 +101,15 @@ static int __init setup_add_efi_memmap(c
 }
 early_param("add_efi_memmap", setup_add_efi_memmap);
 
+static bool efi_no_storage_paranoia;
+
+static int __init setup_storage_paranoia(char *arg)
+{
+	efi_no_storage_paranoia = true;
+	return 0;
+}
+early_param("efi_no_storage_paranoia", setup_storage_paranoia);
+
 
 static efi_status_t virt_efi_get_time(efi_time_t *tm, efi_time_cap_t *tc)
 {
@@ -839,7 +848,10 @@ efi_status_t efi_query_variable_store(u3
 			    " is returning MaxVariableSize=0\n");
 
 	if (!storage_size || size > remaining_size ||
-	    (max_size && size > max_size) ||
+	    (max_size && size > max_size))
+		return EFI_OUT_OF_RESOURCES;
+
+	if (!efi_no_storage_paranoia &&
 	    (remaining_size - size) < (storage_size / 2))
 		return EFI_OUT_OF_RESOURCES;
 

