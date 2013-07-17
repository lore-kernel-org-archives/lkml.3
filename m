Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757906Ab3GQWxt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Jul 2013 18:53:49 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:56392 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933538Ab3GQWxp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Jul 2013 18:53:45 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: David Daney <david.daney@cavium.com>, linux-mips@linux-mips.org,
        Ralf Baechle <ralf@linux-mips.org>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 102/145] MIPS: Octeon: Don't clobber bootloader data structures.
Date: Wed, 17 Jul 2013 15:47:14 -0700
Message-Id: <1374101277-7915-103-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1374101277-7915-1-git-send-email-kamal@canonical.com>
References: <1374101277-7915-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.5 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: David Daney <david.daney@cavium.com>

commit d949b4fe6d23dd92b5fa48cbf7af90ca32beed2e upstream.

Commit abe77f90dc (MIPS: Octeon: Add kexec and kdump support) added a
bootmem region for the kernel image itself.  The problem is that this
is rounded up to a 0x100000 boundary, which is memory that may not be
owned by the kernel.  Depending on the kernel's configuration based
size, this 'extra' memory may contain data passed from the bootloader
to the kernel itself, which if clobbered makes the kernel crash in
various ways.

The fix: Quit rounding the size up, so that we only use memory
assigned to the kernel.

Signed-off-by: David Daney <david.daney@cavium.com>
Cc: linux-mips@linux-mips.org
Patchwork: https://patchwork.linux-mips.org/patch/5449/
Signed-off-by: Ralf Baechle <ralf@linux-mips.org>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 arch/mips/cavium-octeon/setup.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/mips/cavium-octeon/setup.c b/arch/mips/cavium-octeon/setup.c
index d7e0a09..1271047 100644
--- a/arch/mips/cavium-octeon/setup.c
+++ b/arch/mips/cavium-octeon/setup.c
@@ -990,7 +990,7 @@ void __init plat_mem_setup(void)
 	cvmx_bootmem_unlock();
 	/* Add the memory region for the kernel. */
 	kernel_start = (unsigned long) _text;
-	kernel_size = ALIGN(_end - _text, 0x100000);
+	kernel_size = _end - _text;
 
 	/* Adjust for physical offset. */
 	kernel_start &= ~0xffffffff80000000ULL;
-- 
1.8.1.2

