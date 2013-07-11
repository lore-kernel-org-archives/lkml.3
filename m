Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933168Ab3GKO3J (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Jul 2013 10:29:09 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:43290 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933114Ab3GKO1N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Jul 2013 10:27:13 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Richard Weinberger <richard@nod.at>, Matt Fleming <matt.fleming@intel.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 93/98] x86,efi: Implement efi_no_storage_paranoia parameter
Date: Thu, 11 Jul 2013 15:25:03 +0100
Message-Id: <1373552708-15235-94-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1373552708-15235-1-git-send-email-luis.henriques@canonical.com>
References: <1373552708-15235-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.17 -stable review patch.  If anyone has any objections, please let me know.

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
[ luis: backported to 3.5: adjusted context ]
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 Documentation/kernel-parameters.txt |  6 ++++++
 arch/x86/platform/efi/efi.c         | 14 +++++++++++++-
 2 files changed, 19 insertions(+), 1 deletion(-)

diff --git a/Documentation/kernel-parameters.txt b/Documentation/kernel-parameters.txt
index 912785c..b5576c6 100644
--- a/Documentation/kernel-parameters.txt
+++ b/Documentation/kernel-parameters.txt
@@ -791,6 +791,12 @@ bytes respectively. Such letter suffixes can also be entirely omitted.
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
 
diff --git a/arch/x86/platform/efi/efi.c b/arch/x86/platform/efi/efi.c
index 0eb3066..da366ae 100644
--- a/arch/x86/platform/efi/efi.c
+++ b/arch/x86/platform/efi/efi.c
@@ -102,6 +102,15 @@ static int __init setup_add_efi_memmap(char *arg)
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
@@ -988,7 +997,10 @@ efi_status_t efi_query_variable_store(u32 attributes, unsigned long size)
 			    " is returning MaxVariableSize=0\n");
 
 	if (!storage_size || size > remaining_size ||
-	    (max_size && size > max_size) ||
+	    (max_size && size > max_size))
+		return EFI_OUT_OF_RESOURCES;
+
+	if (!efi_no_storage_paranoia &&
 	    (remaining_size - size) < (storage_size / 2))
 		return EFI_OUT_OF_RESOURCES;
 
-- 
1.8.1.2

