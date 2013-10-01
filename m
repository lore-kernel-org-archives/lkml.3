Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751878Ab3JAQQs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Oct 2013 12:16:48 -0400
Received: from mail-wi0-f179.google.com ([209.85.212.179]:49508 "EHLO
	mail-wi0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750936Ab3JAQQq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Oct 2013 12:16:46 -0400
From: Tom Gundersen <teg@jklm.no>
To: x86@kernel.org
Cc: linux-kernel@vger.kernel.org, Tom Gundersen <teg@jklm.no>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@kernel.org>,
        Stephen Warren <swarren@nvidia.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: [PATCH v3] x86: simplefb: avoid overflow
Date: Tue,  1 Oct 2013 18:18:40 +0200
Message-Id: <1380644320-1026-1-git-send-email-teg@jklm.no>
X-Mailer: git-send-email 1.8.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On my MacBook Air lfb_size is 4M, which makes the bitshit overflow, meaning we
fall back to efifb unnecessarily.

Cast to u64 to avoid the overflow.

Signed-off-by: Tom Gundersen <teg@jklm.no>
Reviewed-by: David Herrmann <dh.herrmann@gmail.com>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: H. Peter Anvin <hpa@zytor.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Stephen Warren <swarren@nvidia.com>,
Cc: Stephen Warren <swarren@wwwdotorg.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
---
v2: use (__u64) rather than (unsigned long). This is strictly speaking not
    necessary, but as David poited out it makes it more obvious that we
    we won't have problems on 32bit.
v3: remove superfluous parens and use (u64) rather than (__64) as this is not
    shared by userspace.

 arch/x86/kernel/sysfb_simplefb.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/kernel/sysfb_simplefb.c b/arch/x86/kernel/sysfb_simplefb.c
index 22513e9..4ebd636 100644
--- a/arch/x86/kernel/sysfb_simplefb.c
+++ b/arch/x86/kernel/sysfb_simplefb.c
@@ -72,7 +72,7 @@ __init int create_simplefb(const struct screen_info *si,
 	 * the part that is occupied by the framebuffer */
 	len = mode->height * mode->stride;
 	len = PAGE_ALIGN(len);
-	if (len > si->lfb_size << 16) {
+	if (len > (u64)si->lfb_size << 16) {
 		printk(KERN_WARNING "sysfb: VRAM smaller than advertised\n");
 		return -EINVAL;
 	}
-- 
1.8.4

