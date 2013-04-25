Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759451Ab3DYVpz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Apr 2013 17:45:55 -0400
Received: from terminus.zytor.com ([198.137.202.10]:60578 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757914Ab3DYVpy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Apr 2013 17:45:54 -0400
Date: Thu, 25 Apr 2013 14:44:43 -0700
Message-Id: <201304252144.r3PLihDe025383@terminus.zytor.com>
From: "H. Peter Anvin" <hpa@linux.intel.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: [GIT PULL] x86 fixes for 3.9
Cc: Borislav Petkov <bp@suse.de>, "H. Peter Anvin" <hpa@linux.intel.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@elte.hu>,
        Josh Boyer <jwboyer@redhat.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Matt Fleming <matt.fleming@intel.com>,
        Matthew Garrett <matthew.garrett@nebula.com>,
        Paul Bolle <pebolle@tiscali.nl>, Thomas Gleixner <tglx@linutronix.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

The following changes since commit 0fbd06761f5c17cc9b20e02af60fd7ee9c895996:

  Merge git://git.kernel.org/pub/scm/linux/kernel/git/davem/sparc (2013-04-24 17:10:18 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git x86-urgent-for-linus

This is exclusively two EFI fixes:

 * The EFI variable anti-bricking algorithm merged in -rc8 broke
   booting on some Apple machines because they implement EFI spec
   1.10, which doesn't provide a QueryVariableInfo() runtime function
   and the logic used to check for the existence of that function was
   insufficient.  Fix from Josh Boyer.

 * The anti-bricking algorithm also introduced a compiler warning on
   32-bit. Fix from Borislav Petkov.

----------------------------------------------------------------

Borislav Petkov (1):
      x86, efi: Fix a build warning

H. Peter Anvin (1):
      Merge tag 'efi-urgent' into x86/urgent

Josh Boyer (1):
      efi: Check EFI revision in setup_efi_vars

 arch/x86/boot/compressed/eboot.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/x86/boot/compressed/eboot.c b/arch/x86/boot/compressed/eboot.c
index 8615f75..35ee62f 100644
--- a/arch/x86/boot/compressed/eboot.c
+++ b/arch/x86/boot/compressed/eboot.c
@@ -258,7 +258,7 @@ static efi_status_t setup_efi_vars(struct boot_params *params)
 	u64 store_size, remaining_size, var_size;
 	efi_status_t status;
 
-	if (!sys_table->runtime->query_variable_info)
+	if (sys_table->runtime->hdr.revision < EFI_2_00_SYSTEM_TABLE_REVISION)
 		return EFI_UNSUPPORTED;
 
 	data = (struct setup_data *)(unsigned long)params->hdr.setup_data;
@@ -266,7 +266,7 @@ static efi_status_t setup_efi_vars(struct boot_params *params)
 	while (data && data->next)
 		data = (struct setup_data *)(unsigned long)data->next;
 
-	status = efi_call_phys4(sys_table->runtime->query_variable_info,
+	status = efi_call_phys4((void *)sys_table->runtime->query_variable_info,
 				EFI_VARIABLE_NON_VOLATILE |
 				EFI_VARIABLE_BOOTSERVICE_ACCESS |
 				EFI_VARIABLE_RUNTIME_ACCESS, &store_size,
