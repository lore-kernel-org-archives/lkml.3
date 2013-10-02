Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753551Ab3JBOlU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Oct 2013 10:41:20 -0400
Received: from mail-ee0-f54.google.com ([74.125.83.54]:54729 "EHLO
	mail-ee0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753104Ab3JBOlR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Oct 2013 10:41:17 -0400
From: David Herrmann <dh.herrmann@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Tom Gundersen <teg@jklm.no>, Pavel Roskin <proski@gnu.org>,
        "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@kernel.org>,
        x86@kernel.org, David Herrmann <dh.herrmann@gmail.com>
Subject: [PATCH] x86: sysfb: mark simplefb resources as BUSY
Date: Wed,  2 Oct 2013 16:41:04 +0200
Message-Id: <1380724864-1757-1-git-send-email-dh.herrmann@gmail.com>
X-Mailer: git-send-email 1.8.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

IORESOURCE_BUSY is used to mark temporary driver mem-resources instead of
global regions. This suppresses warnings if regions overlap with a region
marked as BUSY.

This was always the case for VESA/VGA/EFI framebuffer regions so do the
same for simplefb regions. The reason we do this is to allow device
handover to real GPU drivers like i915/radeon/nouveau which get the same
regions via PCI BARs. Maybe at some point we will be able to unregister
platform devices properly during the handover. In this case the simplefb
region would get removed before the new region is created. However, this
is currently not the case and would require rather huge changes in
remove_conflicting_framebuffers(). Add the BUSY marker now and try to
eventually rewrite the handover for a next release.

Also see kernel/resource.c for more information:
  /*
   * if a resource is "BUSY", it's not a hardware resource
   * but a driver mapping of such a resource; we don't want
   * to warn for those; some drivers legitimately map only
   * partial hardware resources. (example: vesafb)
   */

This suppresses warnings like:
  ------------[ cut here ]------------
  WARNING: CPU: 2 PID: 199 at arch/x86/mm/ioremap.c:171 __ioremap_caller+0x2e3/0x390()
  Info: mapping multiple BARs. Your kernel is fine.
  Call Trace:
    dump_stack+0x54/0x8d
    warn_slowpath_common+0x7d/0xa0
    warn_slowpath_fmt+0x4c/0x50
    iomem_map_sanity_check+0xac/0xe0
    __ioremap_caller+0x2e3/0x390
    ioremap_wc+0x32/0x40
    i915_driver_load+0x670/0xf50 [i915]
    ...

Reported-by: Tom Gundersen <teg@jklm.no>
Signed-off-by: David Herrmann <dh.herrmann@gmail.com>
Tested-by: Tom Gundersen <teg@jklm.no>
Tested-by: Pavel Roskin <proski@gnu.org>
---
Hi

Sorry for the delay, but I was in the US for the last 2 weeks and this is really
no major issue, just suppresses a warning that says "Your kernel is fine".
Anyhow, thanks to Tom and Pavel for reporting and testing this! This is
targeted at 3.12-rc4 as bugfix. I think it's still early/mid rc-stage and is a
one-line patch so it should be fine, right?

Thanks
David

 arch/x86/kernel/sysfb_simplefb.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/kernel/sysfb_simplefb.c b/arch/x86/kernel/sysfb_simplefb.c
index 22513e9..b7bb615 100644
--- a/arch/x86/kernel/sysfb_simplefb.c
+++ b/arch/x86/kernel/sysfb_simplefb.c
@@ -79,7 +79,7 @@ __init int create_simplefb(const struct screen_info *si,
 
 	/* setup IORESOURCE_MEM as framebuffer memory */
 	memset(&res, 0, sizeof(res));
-	res.flags = IORESOURCE_MEM;
+	res.flags = IORESOURCE_MEM | IORESOURCE_BUSY;
 	res.name = simplefb_resname;
 	res.start = si->lfb_base;
 	res.end = si->lfb_base + len - 1;
-- 
1.8.4

