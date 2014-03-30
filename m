Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751668AbaC3Ohy (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Mar 2014 10:37:54 -0400
Received: from mx1.redhat.com ([209.132.183.28]:33573 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750967AbaC3Ohx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Mar 2014 10:37:53 -0400
From: Denys Vlasenko <dvlasenk@redhat.com>
To: "H. Peter Anvin" <hpa@linux.intel.com>, Borislav Petkov <bp@suse.de>,
        Jacob Shin <jacob.shin@amd.com>, Jeff Layton <jlayton@redhat.com>,
        Prarit Bhargava <prarit@redhat.com>,
        Mikulas Patocka <mpatocka@redhat.com>,
        Fenghua Yu <fenghua.yu@intel.com>, linux-kernel@vger.kernel.org
Cc: Denys Vlasenko <dvlasenk@redhat.com>
Subject: [PATCH 2/3] x86: microcode: report if no microcode file was found
Date: Sun, 30 Mar 2014 16:09:33 +0200
Message-Id: <1396188574-2067-2-git-send-email-dvlasenk@redhat.com>
In-Reply-To: <1396188574-2067-1-git-send-email-dvlasenk@redhat.com>
References: <1396188574-2067-1-git-send-email-dvlasenk@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Before this change, successful microcode uploads clearly
indicate that it was done:

microcode: CPU1 sig=0x206a7, pf=0x10, revision=0x1a
microcode: CPU1 updated to revision 0x29, date = 2013-06-12

whereas if microcode was not uploaded, it is not clear why:

microcode: CPU1 sig=0x206a7, pf=0x10, revision=0x29
(nothing more)

So, what was it? No microcode file? No microcode for this sig/pf?
CPU already has microcode with this (or newer) revision?

In practice, it means that I heed to ask people to provide me
with more information ("do you have microcode package installed?
which version is it?").

This change upgrades existing message from pr_debug to pr_info,
which covers "no microcode file" case:

microcode: CPU1 sig=0x206a7, pf=0x10, revision=0x29
microcode: data file intel-ucode/06-2a-07 load failed

Signed-off-by: Denys Vlasenko <dvlasenk@redhat.com>
---
 arch/x86/kernel/cpu/microcode/intel.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/kernel/cpu/microcode/intel.c b/arch/x86/kernel/cpu/microcode/intel.c
index ef8b17c..9ce22b0 100644
--- a/arch/x86/kernel/cpu/microcode/intel.c
+++ b/arch/x86/kernel/cpu/microcode/intel.c
@@ -279,7 +279,7 @@ static enum ucode_state request_microcode_fw(int cpu, struct device *device,
 		c->x86, c->x86_model, c->x86_mask);
 
 	if (request_firmware_direct(&firmware, name, device)) {
-		pr_debug("data file %s load failed\n", name);
+		pr_info("data file %s load failed\n", name);
 		return UCODE_NFOUND;
 	}
 
-- 
1.8.1.4

