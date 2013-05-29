Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966131Ab3E2N4K (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 May 2013 09:56:10 -0400
Received: from mail-wi0-f175.google.com ([209.85.212.175]:58444 "EHLO
	mail-wi0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935163Ab3E2N4I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 May 2013 09:56:08 -0400
From: Grant Likely <grant.likely@linaro.org>
To: linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Cc: Grant Likely <grant.likely@linaro.org>,
        Russell King <linux@arm.linux.org.uk>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Nicolas Pitre <nico@linaro.org>,
        Leif Lindholm <leif.lindholm@linaro.org>,
        Olivier Martin <olivier.martin@arm.com>,
        Marc Zyngier <marc.zyngier@arm.com>
Subject: [RFC] arm: Update Booting document for FDT placement and reserved map
Date: Wed, 29 May 2013 14:55:57 +0100
Message-Id: <1369835757-16371-1-git-send-email-grant.likely@linaro.org>
X-Mailer: git-send-email 1.8.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The Booting document isn't very clear about what a bootloader is
required to do when booting with an FDT. First, the placement of the FDT
isn't as strict as the document suggests. It can actually appear
anywhere in RAM and the decompressor will relocated if it absolutely
needs to (but it is better if it doesn't have to).

Second, the bootloader is expected to update the reserved map if there
are any memory regions that are hands-off for the firmware. While this
has always been the case, such as when an initrd is provided, it became
more obvious when starting to work with UEFI. UEFI may provide
additional data to the OS like a block of SMBIOS tables, but if those
regions aren't described in the reserved map then the kernel will
happily reclaim that memory for it's own purposes.

It is possible in the future when the kernel is able to parse UEFI
memory maps directly that we'll relax the requirement for UEFI
regions, but it is safe and pragmatic to be strict about it now, and it
really doesn't cause any new hardship. The existing UEFI LinuxLoader
already update the FDT reserved map.

Signed-off-by: Grant Likely <grant.likely@linaro.org>
Cc: Russell King <linux@arm.linux.org.uk>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Nicolas Pitre <nico@linaro.org>
Cc: Leif Lindholm <leif.lindholm@linaro.org>
Cc: Olivier Martin <olivier.martin@arm.com>
Cc: Marc Zyngier <marc.zyngier@arm.com>
---

In this patch I've stated that the initrd doesn't need to be included in
the reserved map. However, should this be changed? Right now the
decompressor doesn't actually look at the reserved map when
decompressing and moving things around. If I'm reading the code
correctly it is possible that the decompressor will overwrite the initrd
if it gets placed too close to the kernel.

So, my question is this; would it be better to require (or strongly
recommend) the initrd be included in the reserved map and make the
zImage wrapper aware of mem regions that is must not touch. Or should I
leave well enough alone because in practical terms it's working fine
as-is?

 Documentation/arm/Booting | 23 +++++++++++++++++++----
 1 file changed, 19 insertions(+), 4 deletions(-)

diff --git a/Documentation/arm/Booting b/Documentation/arm/Booting
index 0c1f475..1ea5020 100644
--- a/Documentation/arm/Booting
+++ b/Documentation/arm/Booting
@@ -118,13 +118,28 @@ physical address to determine if a dtb has been passed instead of a
 tagged list.
 
 The boot loader must pass at a minimum the size and location of the
-system memory, and the root filesystem location.  The dtb must be
+system memory, and the root filesystem location.  The dtb should be
 placed in a region of memory where the kernel decompressor will not
-overwrite it.  The recommended placement is in the first 16KiB of RAM
-with the caveat that it may not be located at physical address 0 since
-the kernel interprets a value of 0 in r2 to mean neither a tagged list
+overwrite it. The decompressor will relocate an inconveniently placed
+DTB, but it is better if it doesn't have to. The recommended placement
+is either in the first 16KiB of RAM with the caveat that it may not be
+located at physical address 0[1], or several megabytes past the end of the
+kernel image.
+
+[1] the kernel interprets a value of 0 in r2 to mean neither a tagged list
 nor a dtb were passed.
 
+The boot loader must also ensure that the FDT reserve memory map covers
+all areas of main memory that must not be overwritten. This includes
+firmware runtime support data[2], fixed framebuffers and DMA buffers.
+However the initrd does not need to be included as the kernel already
+knows how to protect the initrd location.
+
+[2] In particular when booting from UEFI the OS loader is expected to retrieve the
+UEFI memory map and add all UEFI runtime memory regions to the reserved
+map. This include UEFI runtime services, SMBIOS tables and ACPI tables
+if they exist.
+
 5. Calling the kernel image
 ---------------------------
 
-- 
1.8.1.2

