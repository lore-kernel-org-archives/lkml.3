Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932521AbaICJ6j (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Sep 2014 05:58:39 -0400
Received: from ip4-83-240-67-251.cust.nbox.cz ([83.240.67.251]:57460 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S932470AbaICJ6h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Sep 2014 05:58:37 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Matt Fleming <matt.fleming@intel.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 54/56] x86/efi: Enforce CONFIG_RELOCATABLE for EFI boot stub
Date: Wed,  3 Sep 2014 11:27:13 +0200
Message-Id: <0defc6bd73004bc91727595c1380d2b0992ac79e.1409735865.git.jslaby@suse.cz>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <b4839e6cd4a236a81725e422b2e05c26fe36048a.1409735865.git.jslaby@suse.cz>
References: <b4839e6cd4a236a81725e422b2e05c26fe36048a.1409735865.git.jslaby@suse.cz>
In-Reply-To: <cover.1409735865.git.jslaby@suse.cz>
References: <cover.1409735865.git.jslaby@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Matt Fleming <matt.fleming@intel.com>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

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
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 arch/x86/Kconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index 9b6f78f57d86..f968d8527190 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -1608,6 +1608,7 @@ config EFI
 config EFI_STUB
        bool "EFI stub support"
        depends on EFI
+       select RELOCATABLE
        ---help---
           This kernel feature allows a bzImage to be loaded directly
 	  by EFI firmware without the use of a bootloader.
-- 
2.1.0

