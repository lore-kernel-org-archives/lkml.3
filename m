Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752075Ab3KTIfI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Nov 2013 03:35:08 -0500
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:44056 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750834Ab3KTIfG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Nov 2013 03:35:06 -0500
X-SecurityPolicyCheck: OK by SHieldMailChecker v2.0.1
X-SHieldMailCheckerPolicyVersion: FJ-ISEC-20120718-3
Message-ID: <528C740A.6010407@jp.fujitsu.com>
Date: Wed, 20 Nov 2013 17:34:18 +0900
From: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:17.0) Gecko/20130801 Thunderbird/17.0.8
MIME-Version: 1.0
To: <linux-efi@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC: <matt@console-pimps.org>, <richard@nod.at>, <matt.fleming@intel.com>,
        <matthew.garrett@nebula.com>, <jlee@suse.com>, <cxie@redhat.com>
Subject: [PATCH] x86, efi: add no_bricked_efi whitelist
Content-Type: text/plain; charset="ISO-2022-JP"
Content-Transfer-Encoding: 7bit
X-SecurityPolicyCheck-GC: OK by FENCE-Mail
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

By following works, my system very often fails set_variable() to set new
variable to efi variable storage and shows "efivars: set_variable() failed:
status=-28" message.

- commit 68d929862e29a8b52a7f2f2f86a0600423b093cd
    efi: be more paranoid about available space when creating variables
- commit 31ff2f20d9003e74991d135f56e503fe776c127c
    efi: Distinguish between "remaining space" and actually used space
- commit 8c58bf3eec3b8fc8162fe557e9361891c20758f2
    x86,efi: Implement efi_no_storage_paranoia parameter
- commit f8b8404337de4e2466e2e1139ea68b1f8295974f
    Modify UEFI anti-bricking code

When booting my system, remaining space of efi variable storage is about
5KB. So there is no room that sets a new variable to the storage. On my
system, trigger of gc is when EFI_OUT_OF_RESOURCES occurs on pre OS
environment with UEFI. So if EFI_OUT_OF_RESOURCES occurs by the 5Kbyte
threshold, nvram storage cannot be used until EFI_OUT_OF_RESOURCES occurs
on pre OS environment with UEFI.

This patch adds whitelist. If a server is in the whitelist,
efi_no_storage_paranoia is set to true. And the system can use all efi
variable storage.

Signed-off-by: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>
CC: Matthew Garrett <matthew.garrett@nebula.com>
CC: Richard Weinberger <richard@nod.at>
CC: Lee, Chun-Y <jlee@suse.com>
CC: Madper Xie <cxie@redhat.com>
CC: Matt Fleming <matt.fleming@intel.com>
---
 arch/x86/platform/efi/efi.c | 29 +++++++++++++++++++++++++++++
 1 file changed, 29 insertions(+)

diff --git a/arch/x86/platform/efi/efi.c b/arch/x86/platform/efi/efi.c
index c7e22ab..9fadf5d 100644
--- a/arch/x86/platform/efi/efi.c
+++ b/arch/x86/platform/efi/efi.c
@@ -116,6 +116,15 @@ static int __init setup_storage_paranoia(char *arg)
 }
 early_param("efi_no_storage_paranoia", setup_storage_paranoia);

+struct no_bricked_efi {
+	char vendor[100];
+	u32 revision;
+};
+
+static struct no_bricked_efi efi_whitelist[] __initdata = {
+	{"FUJITSU LIMITED", 0},
+	{""}
+};

 static efi_status_t virt_efi_get_time(efi_time_t *tm, efi_time_cap_t *tc)
 {
@@ -704,6 +713,24 @@ static int __init efi_memmap_init(void)
 	return 0;
 }

+static bool __init is_no_bricked_efi(char *vendor, u32 revision)
+{
+	int i = 0;
+
+	while (efi_whitelist[i].vendor[0] != '\0') {
+		if (strncmp(efi_whitelist[i].vendor, vendor,
+			    sizeof(efi_whitelist[i].vendor))) {
+			i++;
+			continue;
+		}
+
+		if (revision >= efi_whitelist[i].revision)
+			return true;
+	}
+
+	return false;
+}
+
 void __init efi_init(void)
 {
 	efi_char16_t *c16;
@@ -778,6 +805,8 @@ void __init efi_init(void)
 #if EFI_DEBUG
 	print_efi_memmap();
 #endif
+	if (is_no_bricked_efi(vendor, efi.systab->hdr.revision))
+		efi_no_storage_paranoia = true;
 }

 void __init efi_late_init(void)

