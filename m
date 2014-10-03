Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754791AbaJCVRg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Oct 2014 17:17:36 -0400
Received: from mail-wg0-f42.google.com ([74.125.82.42]:53293 "EHLO
	mail-wg0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752876AbaJCVRb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Oct 2014 17:17:31 -0400
Date: Fri, 3 Oct 2014 22:17:27 +0100
From: Matt Fleming <matt@console-pimps.org>
To: "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>
Cc: Peter Zijlstra <peterz@infradead.org>,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>, linux-efi@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [GIT PULL v2] EFI changes for v3.18
Message-ID: <20141003211727.GK14343@console-pimps.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Folks,

This is a respin of the previous pull request for v3.18 EFI material
without the in_nmi() conditional locking in the EFI runtime lock patch.

In addition, I picked up a trivial patch to the rtc-efi driver from Ard
because no one else has responded to it in ~3 weeks, and included a
regression fix for the rtc-efi driver (tagged for stable) since we've
basically run out of -rcs now and it definitely isn't urgent enough to
postpone the merge window.

As before, merging this tag into Linus' tree causes some conflicts,
which I've fixed up and pushed out as the efi-next-merge branch, in case
you or Linus want to take a look at it. The conflicts are fairly
straight forward to resolve.

The following changes since commit 7d1311b93e58ed55f3a31cc8f94c4b8fe988a2b9:

  Linux 3.17-rc1 (2014-08-16 10:40:26 -0600)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/mfleming/efi.git tags/efi-next

for you to fetch changes up to 7efe665903d0d963b0ebf4cab25cc3ae32c62600:

  rtc: Disable EFI rtc for x86 (2014-10-03 21:24:17 +0100)

----------------------------------------------------------------
 * Implement new EFI runtime lock which is required by the UEFI
   specification - Ard Biesheuvel

 * Add new efi= x86 EFI boot stub parameter which mimics the way that
   the regular kernel parameter works - Matt Fleming

 * Improve error handling in efi-bgrt driver - Josh Triplett

 * Extend the "noefi" kernel parameter to arm64, add an efi=noruntime
   synonym - Dave Young

 * Beautify the EFI memory map logs - Laszlo Ersek

 * Fix compiler shadow warnings and improve variable names - Mark Rustad

 * Remove unused efi_call() macros, update comments, tag initialization
   functions with __init - Mathias Krause

 * Add more informative efi_printk()s to the x86 EFI boot stub at the
   firmware call-sites - Andre Müller

 * Drop the in_nmi() checks from the EFI runtime locking code and
   instead provide a new EFI variable operation to be used when we're in
   a context that must not block - Matt Fleming

 * Export a module alias for the rtc-efi driver for automatic loading by
   udev - Ard Biesheuvel

 * Disable building the rtc-efi driver for x86 since the time-related
   EFI runtime services are notoriously crappy, and usually result in
   crashes - Matt Fleming

----------------------------------------------------------------
Andre Müller (1):
      x86/efi: Adding efi_printks on memory allocationa and pci.reads

Ard Biesheuvel (2):
      efi: Implement mandatory locking for UEFI Runtime Services
      efi: rtc-efi: Export platform:rtc-efi as module alias

Dave Young (6):
      efi: Move noefi early param code out of x86 arch code
      lib: Add a generic cmdline parse function parse_option_str
      efi: Add kernel param efi=noruntime
      arm64/efi: uefi_init error handling fix
      arm64/efi: Do not enter virtual mode if booting with efi=noruntime or noefi
      x86/efi: Clear EFI_RUNTIME_SERVICES if failing to enter virtual mode

Josh Triplett (1):
      efi-bgrt: Add error handling; inform the user when ignoring the BGRT

Laszlo Ersek (5):
      efi: Add macro for EFI_MEMORY_UCE memory attribute
      efi: Introduce efi_md_typeattr_format()
      x86: efi: Format EFI memory type & attrs with efi_md_typeattr_format()
      ia64: efi: Format EFI memory type & attrs with efi_md_typeattr_format()
      arm64: efi: Format EFI memory type & attrs with efi_md_typeattr_format()

Mark Rustad (1):
      efi: Resolve some shadow warnings

Mathias Krause (4):
      x86/efi: Remove unused efi_call* macros
      x86/efi: Unexport add_efi_memmap variable
      x86/efi: Update comment regarding required phys mapped EFI services
      x86/efi: Mark initialization code as such

Matt Fleming (4):
      efi: Add efi= parameter parsing to the EFI boot stub
      efi: Provide a non-blocking SetVariable() operation
      efi: Delete the in_nmi() conditional runtime locking
      rtc: Disable EFI rtc for x86

 Documentation/kernel-parameters.txt            |   8 +-
 arch/arm64/kernel/efi.c                        |  44 +++----
 arch/ia64/kernel/efi.c                         |   6 +-
 arch/x86/boot/compressed/eboot.c               |  32 +++--
 arch/x86/include/asm/efi.h                     |  31 ++---
 arch/x86/platform/efi/efi-bgrt.c               |  36 +++++-
 arch/x86/platform/efi/efi.c                    |  52 ++++----
 arch/x86/platform/efi/efi_32.c                 |  12 +-
 arch/x86/platform/efi/efi_64.c                 |   6 +-
 arch/x86/platform/efi/efi_stub_32.S            |   4 +-
 drivers/firmware/efi/efi.c                     |  79 ++++++++++++
 drivers/firmware/efi/libstub/arm-stub.c        |   4 +
 drivers/firmware/efi/libstub/efi-stub-helper.c |  62 +++++++++-
 drivers/firmware/efi/runtime-wrappers.c        | 164 +++++++++++++++++++++++--
 drivers/firmware/efi/vars.c                    |  61 +++++++--
 drivers/rtc/Kconfig                            |   2 +-
 drivers/rtc/rtc-efi.c                          |   1 +
 include/linux/efi.h                            |  17 +++
 include/linux/kernel.h                         |   1 +
 lib/cmdline.c                                  |  29 +++++
 20 files changed, 528 insertions(+), 123 deletions(-)

-- 
Matt Fleming, Intel Open Source Technology Center
