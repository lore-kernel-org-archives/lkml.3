Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754548Ab3JCOBX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Oct 2013 10:01:23 -0400
Received: from terminus.zytor.com ([198.137.202.10]:45578 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751826Ab3JCOBV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Oct 2013 10:01:21 -0400
Date: Thu, 3 Oct 2013 07:01:06 -0700
From: tip-bot for David Herrmann <tipbot@zytor.com>
Message-ID: <tip-29d274b8d3e2404cd1832b3a999b12f9d1e1d895@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org, teg@jklm.no,
        tglx@linutronix.de, dh.herrmann@gmail.com, proski@gnu.org
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        tglx@linutronix.de, teg@jklm.no, dh.herrmann@gmail.com, proski@gnu.org
In-Reply-To: <1380724864-1757-1-git-send-email-dh.herrmann@gmail.com>
References: <1380724864-1757-1-git-send-email-dh.herrmann@gmail.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/urgent] x86/simplefb:
  Mark framebuffer mem-resources as IORESOURCE_BUSY to avoid bootup warning
Git-Commit-ID: 29d274b8d3e2404cd1832b3a999b12f9d1e1d895
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Thu, 03 Oct 2013 07:01:13 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  29d274b8d3e2404cd1832b3a999b12f9d1e1d895
Gitweb:     http://git.kernel.org/tip/29d274b8d3e2404cd1832b3a999b12f9d1e1d895
Author:     David Herrmann <dh.herrmann@gmail.com>
AuthorDate: Wed, 2 Oct 2013 16:41:04 +0200
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Thu, 3 Oct 2013 07:51:11 +0200

x86/simplefb: Mark framebuffer mem-resources as IORESOURCE_BUSY to avoid bootup warning

IORESOURCE_BUSY is used to mark temporary driver mem-resources
instead of global regions. This suppresses warnings if regions
overlap with a region marked as BUSY.

This was always the case for VESA/VGA/EFI framebuffer regions so
do the same for simplefb regions. The reason we do this is to
allow device handover to real GPU drivers like
i915/radeon/nouveau which get the same regions via PCI BARs.

Maybe at some point we will be able to unregister platform
devices properly during the handover. In this case the simplefb
region would get removed before the new region is created.
However, this is currently not the case and would require rather
huge changes in remove_conflicting_framebuffers(). Add the BUSY
marker now and try to eventually rewrite the handover for a next release.

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
Tested-by: Tom Gundersen <teg@jklm.no>
Tested-by: Pavel Roskin <proski@gnu.org>
Signed-off-by: David Herrmann <dh.herrmann@gmail.com>
Link: http://lkml.kernel.org/r/1380724864-1757-1-git-send-email-dh.herrmann@gmail.com
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 arch/x86/kernel/sysfb_simplefb.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/kernel/sysfb_simplefb.c b/arch/x86/kernel/sysfb_simplefb.c
index 4ebd636..86179d4 100644
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
