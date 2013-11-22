Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751839Ab3KVGai (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Nov 2013 01:30:38 -0500
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:38373 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750765Ab3KVGae (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Nov 2013 01:30:34 -0500
X-SecurityPolicyCheck: OK by SHieldMailChecker v2.0.1
X-SHieldMailCheckerPolicyVersion: FJ-ISEC-20120718-3
Message-ID: <528EF9CE.2070305@jp.fujitsu.com>
Date: Fri, 22 Nov 2013 15:29:34 +0900
From: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:17.0) Gecko/20130801 Thunderbird/17.0.8
MIME-Version: 1.0
To: "linux-efi@vger.kernel.org" <linux-efi@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
CC: Matthew Garrett <matthew.garrett@nebula.com>,
        "matt.fleming@intel.com" <matt.fleming@intel.com>,
        "jlee@suse.com" <jlee@suse.com>,
        "matt@console-pimps.org" <matt@console-pimps.org>,
        "richard@nod.at" <richard@nod.at>, "cxie@redhat.com" <cxie@redhat.com>
Subject: [PATCH] x86, efi: add efi_whitelist_table to use all efi variable
 storage
References: <528C740A.6010407@jp.fujitsu.com>  <1384963376.20536.3.camel@x230> <528DD3E0.3050606@jp.fujitsu.com>  <1385064722.12107.1.camel@x230> <528E9EB2.3060808@jp.fujitsu.com> <1385078632.12107.3.camel@x230> <528EF87D.4050300@jp.fujitsu.com>
In-Reply-To: <528EF87D.4050300@jp.fujitsu.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
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
  arch/x86/platform/efi/efi.c | 19 +++++++++++++++++++
  1 file changed, 19 insertions(+)

diff --git a/arch/x86/platform/efi/efi.c b/arch/x86/platform/efi/efi.c
index c7e22ab..f9fad62 100644
--- a/arch/x86/platform/efi/efi.c
+++ b/arch/x86/platform/efi/efi.c
@@ -42,6 +42,7 @@
  #include <linux/io.h>
  #include <linux/reboot.h>
  #include <linux/bcd.h>
+#include <linux/dmi.h>

  #include <asm/setup.h>
  #include <asm/efi.h>
@@ -116,6 +117,24 @@ static int __init setup_storage_paranoia(char *arg)
  }
  early_param("efi_no_storage_paranoia", setup_storage_paranoia);

+static struct dmi_system_id efi_whitelist_table[] __initdata = {
+	{
+		/* FUJITSU PRIMEQUEST */
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "FUJITSU"),
+			DMI_MATCH(DMI_PRODUCT_NAME, "PRIMEQUEST"),
+		},
+	},
+	{}
+};
+
+static int __init init_efi_no_storage_paranoia(void)
+{
+	if (dmi_check_system(efi_whitelist_table))
+		efi_no_storage_paranoia = true;
+	return 0;
+}
+late_initcall(init_efi_no_storage_paranoia);

  static efi_status_t virt_efi_get_time(efi_time_t *tm, efi_time_cap_t *tc)
  {

