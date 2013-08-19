Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751293Ab3HSUBI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Aug 2013 16:01:08 -0400
Received: from g5t0006.atlanta.hp.com ([15.192.0.43]:14364 "EHLO
	g5t0006.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751053Ab3HSUBF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Aug 2013 16:01:05 -0400
From: Linn Crosetto <linn@hp.com>
To: matt.fleming@intel.com, hpa@zytor.com, tglx@linutronix.de,
        mingo@redhat.com, x86@kernel.org, yinghai@kernel.org,
        penberg@kernel.org, jacob.shin@amd.com, linux-efi@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Linn Crosetto <linn@hp.com>
Subject: [RFC PATCH 0/4] EFI boot stub memory map fix
Date: Mon, 19 Aug 2013 14:00:15 -0600
Message-Id: <1376942419-5684-1-git-send-email-linn@hp.com>
X-Mailer: git-send-email 1.7.11.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I realize the EFI stub for ARM patches are in flight, 

https://lkml.org/lkml/2013/8/9/554

and overlap with some of the files but I wanted to send these out for comment.

This series fixes a problem with EFI memory maps larger than 128 entries when
booting using the EFI boot stub, which results in overflowing the e820_map in
boot_params and an eventual halt when checking the map size in
sanitize_e820_map().

The fix implemented is to add the EFI memory map from setup_arch() via a
memory_setup hook.

Two options were considered:

 1. Use the SETUP_E820_EXT setup_data type to add the extra entries.

 2. Create a memory_setup function to be enabled when the EFI memory map is
    needed.

Option 2 appeared to be the cleaner solution, reducing duplication with
existing code, given a reasonable mechanism for determining when to
replace the default memory_setup function.


Linn Crosetto (4):
  efi: Decouple efi_memmap_init() and do_add_efi_memmap()
  efi: Add memory_setup function efi_memory_setup()
  efi: Add efi_memmap_needed()
  x86: Fix EFI boot stub for large memory maps

 arch/x86/boot/compressed/eboot.c | 64 ++--------------------------------------
 arch/x86/kernel/setup.c          |  3 ++
 arch/x86/platform/efi/efi.c      | 51 +++++++++++++++++++++++---------
 include/linux/efi.h              |  2 ++
 4 files changed, 45 insertions(+), 75 deletions(-)

-- 
1.7.11.3

