Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755363Ab3JaQZ0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Oct 2013 12:25:26 -0400
Received: from mail.skyhub.de ([78.46.96.112]:49558 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751805Ab3JaQZU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Oct 2013 12:25:20 -0400
From: Borislav Petkov <bp@alien8.de>
To: Linux EFI <linux-efi@vger.kernel.org>
Cc: Borislav Petkov <bp@suse.de>, Dave Young <dyoung@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        James Bottomley <James.Bottomley@HansenPartnership.com>,
        Matt Fleming <matt@console-pimps.org>,
        Matthew Garrett <mjg59@srcf.ucam.org>, Vivek Goyal <vgoyal@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>, X86 ML <x86@kernel.org>
Subject: [PATCH 00/11] EFI runtime services virtual mapping, vN++
Date: Thu, 31 Oct 2013 17:24:58 +0100
Message-Id: <1383236709-19716-1-git-send-email-bp@alien8.de>
X-Mailer: git-send-email 1.8.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Borislav Petkov <bp@suse.de>

Hi all,

here's maybe the final version of the patchset, no major changes since
the last time but cosmetic and cleanups and tidying as requested by Matt
and others.

Patches also at:

git://git.kernel.org/pub/scm/linux/kernel/git/bp/bp.git#efi

The previous announcement:

here's finally a new version of the runtime services VA mapping patchset
which hopefully implements hpa's idea of statically mapping EFI runtime
regions in a top-down manner starting at -4Gb virtual.

We're also using a different pagetable so as not to pollute kernel
address space. For that, we switch to that table before doing an EFI
call, and afterwards we switch back to the previous one.

To the patches:

1-2 are simple cleanups which Matt probably can take now

3-10 add the machinery to map regions into an arbitrary PGD. Those I've
split deliberately into very small bites so that they can be reviewed
more thoroughly and easily for my pagetable skills are pretty basic.

11 is the actual patch which implements that mapping so that we can use
runtime services in kexec (which is the whole reason for this fuss :))

So please take a long hard look at those, hammer on them on your
boxes and let me know. They boot fine on my Dell UEFI box and in OVMF
(obviously :)).

Borislav Petkov (11):
  efi: Simplify EFI_DEBUG
  x86, pageattr: Lookup address in an arbitrary PGD
  x86, pageattr: Add a PGD pagetable populating function
  x86, pageattr: Add a PUD pagetable populating function
  x86, pageattr: Add a PMD pagetable populating function
  x86, pageattr: Add a PTE pagetable populating function
  x86, pageattr: Add a PUD error unwinding path
  x86, pageattr: Add last levels of error path
  x86, cpa: Map in an arbitrary pgd
  EFI: Runtime services virtual mapping
  efi: Check krealloc return value

 Documentation/kernel-parameters.txt  |   6 +
 Documentation/x86/x86_64/mm.txt      |   7 +
 arch/x86/include/asm/efi.h           |  64 +++--
 arch/x86/include/asm/pgtable_types.h |   3 +-
 arch/x86/mm/pageattr.c               | 461 +++++++++++++++++++++++++++++++++--
 arch/x86/platform/efi/efi.c          | 111 ++++++---
 arch/x86/platform/efi/efi_32.c       |   9 +-
 arch/x86/platform/efi/efi_64.c       | 109 +++++++++
 arch/x86/platform/efi/efi_stub_64.S  |  54 ++++
 include/linux/efi.h                  |   1 +
 10 files changed, 755 insertions(+), 70 deletions(-)

-- 
1.8.4

