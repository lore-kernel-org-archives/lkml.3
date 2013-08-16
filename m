Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757901Ab3HQAao (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Aug 2013 20:30:44 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:51377 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754463Ab3HPWfM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Aug 2013 18:35:12 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Mike Frysinger <vapier@gentoo.org>, Olof Johansson <olof@lixom.net>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 019/133] ARM: footbridge: fix overlapping PCI mappings
Date: Fri, 16 Aug 2013 15:32:41 -0700
Message-Id: <1376692475-28413-20-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1376692475-28413-1-git-send-email-kamal@canonical.com>
References: <1376692475-28413-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.7 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mike Frysinger <vapier@gentoo.org>

commit 6287e7319870ec949fb809e4eb4154c2b05b221f upstream.

Commit 8ef6e6201b26cb9fde79c1baa08145af6aca2815 (ARM: footbridge: use
fixed PCI i/o mapping) broke booting on my netwinder.  Before that,
everything boots fine.  Since then, it crashes on boot.

With earlyprintk, I see it BUG-ing like so:
kernel BUG at lib/ioremap.c:27!
Internal error: Oops - BUG: 0 [#1] ARM
...
[<c0139b54>] (ioremap_page_range+0x128/0x154) from [<c02e6a6c>] (dc21285_setup+0xd0/0x114)
[<c02e6a6c>] (dc21285_setup+0xd0/0x114) from [<c02e4874>] (pci_common_init+0xa0/0x298)
[<c02e4874>] (pci_common_init+0xa0/0x298) from [<c02e793c>] (netwinder_pci_init+0xc/0x18)
[<c02e793c>] (netwinder_pci_init+0xc/0x18) from [<c02e27d0>] (do_one_initcall+0xb4/0x180)
...

Russell points out it's because of overlapping PCI mappings that was
added with the aforementioned commit.  Rob thought the code would re-use
the static mapping, but that turns out to not be the case and instead
hits the BUG further down.

After deleting this hunk as suggested by Russel, the system boots up fine
again and all my PCI devices work (IDE, ethernet, the DC21285).

Signed-off-by: Mike Frysinger <vapier@gentoo.org>
Acked-by: Rob Herring <rob.herring@calxeda.com>
Signed-off-by: Olof Johansson <olof@lixom.net>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 arch/arm/mach-footbridge/dc21285.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/arch/arm/mach-footbridge/dc21285.c b/arch/arm/mach-footbridge/dc21285.c
index a7cd2cf..3490a24 100644
--- a/arch/arm/mach-footbridge/dc21285.c
+++ b/arch/arm/mach-footbridge/dc21285.c
@@ -276,8 +276,6 @@ int __init dc21285_setup(int nr, struct pci_sys_data *sys)
 
 	sys->mem_offset  = DC21285_PCI_MEM;
 
-	pci_ioremap_io(0, DC21285_PCI_IO);
-
 	pci_add_resource_offset(&sys->resources, &res[0], sys->mem_offset);
 	pci_add_resource_offset(&sys->resources, &res[1], sys->mem_offset);
 
-- 
1.8.1.2

