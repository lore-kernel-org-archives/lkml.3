Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932762AbaIOWPA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Sep 2014 18:15:00 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:50879 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932732AbaIOWOw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Sep 2014 18:14:52 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: "H. Peter Anvin" <hpa@zytor.com>, Matt Fleming <matt.fleming@intel.com>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.13 162/187] x86/efi: Enforce CONFIG_RELOCATABLE for EFI boot stub
Date: Mon, 15 Sep 2014 15:09:32 -0700
Message-Id: <1410818997-9432-163-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1410818997-9432-1-git-send-email-kamal@canonical.com>
References: <1410818997-9432-1-git-send-email-kamal@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Extended-Stable: 3.13
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13.11.7 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Matt Fleming <matt.fleming@intel.com>

commit 7b2a583afb4ab894f78bc0f8bd136e96b6499a7e upstream.

Without CONFIG_RELOCATABLE the early boot code will decompress the
kernel to LOAD_PHYSICAL_ADDR. While this may have been fine in the BIOS
days, that isn't going to fly with UEFI since parts of the firmware
code/data may be located at LOAD_PHYSICAL_ADDR.

Straying outside of the bounds of the regions we've explicitly requested
from the firmware will cause all sorts of trouble. Bruno reports that
his machine resets while trying to decompress the kernel image.

We already go to great pains to ensure the kernel is loaded into a
suitably aligned buffer, it's just that the address isn't necessarily
LOAD_PHYSICAL_ADDR, because we can't guarantee that address isn't in-use
by the firmware.

Explicitly enforce CONFIG_RELOCATABLE for the EFI boot stub, so that we
can load the kernel at any address with the correct alignment.

Reported-by: Bruno Prémont <bonbons@linux-vserver.org>
Tested-by: Bruno Prémont <bonbons@linux-vserver.org>
Cc: H. Peter Anvin <hpa@zytor.com>
Signed-off-by: Matt Fleming <matt.fleming@intel.com>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 arch/x86/Kconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index 08fa7df..03e74b3 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -1613,6 +1613,7 @@ config EFI
 config EFI_STUB
        bool "EFI stub support"
        depends on EFI
+       select RELOCATABLE
        ---help---
           This kernel feature allows a bzImage to be loaded directly
 	  by EFI firmware without the use of a bootloader.
-- 
1.9.1

