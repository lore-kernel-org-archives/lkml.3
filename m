Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756476Ab3KHHe2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Nov 2013 02:34:28 -0500
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:46964 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751078Ab3KHHeY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Nov 2013 02:34:24 -0500
X-SecurityPolicyCheck: OK by SHieldMailChecker v2.0.1
X-SHieldMailCheckerPolicyVersion: FJ-ISEC-20120718-3
Message-ID: <527C93B5.7010407@jp.fujitsu.com>
Date: Fri, 8 Nov 2013 16:33:09 +0900
From: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:17.0) Gecko/20130801 Thunderbird/17.0.8
MIME-Version: 1.0
To: <linux-efi@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC: <matt.fleming@intel.com>, <matthew.garrett@nebula.com>, <richard@nod.at>,
        <jlee@suse.com>
Subject: [PATCH] x86, efi: change name of efi_no_storage_paranoia parameter
 to efi_storage_paranoia
Content-Type: text/plain; charset="ISO-2022-JP"
Content-Transfer-Encoding: 7bit
X-SecurityPolicyCheck-GC: OK by FENCE-Mail
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

By following works, my system very often fails set_variable() to set new
variable to efi variable storage and shows "efivars: set_variable() failed:
status=-28" message.

- commit 31ff2f20d9003e74991d135f56e503fe776c127c
    efi: Distinguish between "remaining space" and actually used space
- commit 8c58bf3eec3b8fc8162fe557e9361891c20758f2
    x86,efi: Implement efi_no_storage_paranoia parameter
- commit f8b8404337de4e2466e2e1139ea68b1f8295974f
    Modify UEFI anti-bricking code

When booting my system, remaining space of efi variable storage is about
5KB. So there is no room that sets a new variable to the storage.

According to above works, efi_no_storage_paranoia parameter was prepared
for sane UEFI which can do gc and fulfills spec. But why need a system
with a sane UEFI set the parameter? It is wrong. A system with a broken
UEFI should set the parameter.

This patch changes name of the parameter to efi_storage_paranoia and uses
all efi variable storage with no parameter.

Signed-off-by: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>
CC: Matthew Garrett <matthew.garrett@nebula.com>
CC: Richard Weinberger <richard@nod.at>
CC: Lee, Chun-Y <jlee@suse.com>
CC: Matt Fleming <matt.fleming@intel.com>
---
 Documentation/kernel-parameters.txt | 10 +++++-----
 arch/x86/platform/efi/efi.c         |  8 ++++----
 2 files changed, 9 insertions(+), 9 deletions(-)

diff --git a/Documentation/kernel-parameters.txt b/Documentation/kernel-parameters.txt
index fcbb736..2157c8e 100644
--- a/Documentation/kernel-parameters.txt
+++ b/Documentation/kernel-parameters.txt
@@ -888,11 +888,11 @@ bytes respectively. Such letter suffixes can also be entirely omitted.
 	edd=		[EDD]
 			Format: {"off" | "on" | "skip[mbr]"}

-	efi_no_storage_paranoia [EFI; X86]
-			Using this parameter you can use more than 50% of
-			your efi variable storage. Use this parameter only if
-			you are really sure that your UEFI does sane gc and
-			fulfills the spec otherwise your board may brick.
+	efi_storage_paranoia [EFI; X86]
+			Using this parameter you cannot use your efi variable
+			storage when the remaining space of the storage becomes
+			less than 5KB. Use this parameter if your UEFI does
+			not sane gc and fulfills the spec.

 	eisa_irq_edge=	[PARISC,HW]
 			See header of drivers/parisc/eisa.c.
diff --git a/arch/x86/platform/efi/efi.c b/arch/x86/platform/efi/efi.c
index c7e22ab..010a0eb 100644
--- a/arch/x86/platform/efi/efi.c
+++ b/arch/x86/platform/efi/efi.c
@@ -107,14 +107,14 @@ static int __init setup_add_efi_memmap(char *arg)
 }
 early_param("add_efi_memmap", setup_add_efi_memmap);

-static bool efi_no_storage_paranoia;
+static bool efi_storage_paranoia;

 static int __init setup_storage_paranoia(char *arg)
 {
-	efi_no_storage_paranoia = true;
+	efi_storage_paranoia = true;
 	return 0;
 }
-early_param("efi_no_storage_paranoia", setup_storage_paranoia);
+early_param("efi_storage_paranoia", setup_storage_paranoia);


 static efi_status_t virt_efi_get_time(efi_time_t *tm, efi_time_cap_t *tc)
@@ -1066,7 +1066,7 @@ efi_status_t efi_query_variable_store(u32 attributes, unsigned long size)
 	 * 5KB. This figure was provided by Samsung, so should be safe.
 	 */
 	if ((remaining_size - size < EFI_MIN_RESERVE) &&
-		!efi_no_storage_paranoia) {
+		efi_storage_paranoia) {

 		/*
 		 * Triggering garbage collection may require that the firmware

