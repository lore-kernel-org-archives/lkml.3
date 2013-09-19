Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753347Ab3ISOzu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Sep 2013 10:55:50 -0400
Received: from mail.skyhub.de ([78.46.96.112]:58737 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753047Ab3ISOzJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Sep 2013 10:55:09 -0400
From: Borislav Petkov <bp@alien8.de>
To: X86 ML <x86@kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Borislav Petkov <bp@suse.de>,
        Matt Fleming <matt@console-pimps.org>,
        Matthew Garrett <mjg59@srcf.ucam.org>,
        "H. Peter Anvin" <hpa@zytor.com>,
        James Bottomley <James.Bottomley@HansenPartnership.com>,
        Vivek Goyal <vgoyal@redhat.com>, Dave Young <dyoung@redhat.com>,
        linux-efi@vger.kernel.org
Subject: [PATCH 00/11] EFI runtime services virtual mapping
Date: Thu, 19 Sep 2013 16:54:43 +0200
Message-Id: <1379602494-26684-1-git-send-email-bp@alien8.de>
X-Mailer: git-send-email 1.8.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Borislav Petkov <bp@suse.de>

Hi all,

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

Thanks.

Borislav Petkov (11):
  efi: Simplify EFI_DEBUG
  efi: Remove EFI_PAGE_SHIFT and EFI_PAGE_SIZE
  x86, pageattr: Lookup address in an arbitrary PGD
  x86, pageattr: Add a PGD pagetable populating function
  x86, pageattr: Add a PUD pagetable populating function
  x86, pageattr: Add a PMD pagetable populating function
  x86, pageattr: Add a PTE pagetable populating function
  x86, pageattr: Add a PUD error unwinding path
  x86, pageattr: Add last levels of error path
  x86, cpa: Map in an arbitrary pgd
  EFI: Runtime services virtual mapping

 arch/x86/boot/compressed/eboot.c     |  12 +-
 arch/x86/boot/compressed/eboot.h     |   1 -
 arch/x86/include/asm/efi.h           |  58 +++--
 arch/x86/include/asm/pgtable_types.h |   3 +-
 arch/x86/mm/pageattr.c               | 461 +++++++++++++++++++++++++++++++++--
 arch/x86/platform/efi/efi.c          | 126 +++++-----
 arch/x86/platform/efi/efi_64.c       |  56 +----
 arch/x86/platform/efi/efi_stub_64.S  |  47 ++++
 include/linux/efi.h                  |   6 +-
 9 files changed, 615 insertions(+), 155 deletions(-)

-- 
1.8.4

