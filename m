Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754189Ab3IZVzJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Sep 2013 17:55:09 -0400
Received: from ch1ehsobe005.messaging.microsoft.com ([216.32.181.185]:28962
	"EHLO ch1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753458Ab3IZVzG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Sep 2013 17:55:06 -0400
X-Forefront-Antispam-Report: CIP:165.204.84.221;KIP:(null);UIP:(null);IPV:NLI;H:atltwp01.amd.com;RD:none;EFVD:NLI
X-SpamScore: 0
X-BigFish: VPS0(zzzz1f42h208ch1ee6h1de0h1fdah2073h1202h1e76h1d1ah1d2ah1fc6hzz1de098h1de097h8275bhz2dh839hd24he5bhf0ah1288h12a5h12a9h12bdh12e5h137ah139eh13b6h1441h14ddh1504h1537h162dh1631h1758h1898h18e1h1946h19b5h1ad9h1b0ah1d0ch1d2eh1d3fh1dc1h1dfeh1dffh1e1dh1e23h1fe8h1ff5h1155h)
X-WSS-ID: 0MTR5YP-07-OOB-02
X-M-MSG: 
From: <suravee.suthikulpanit@amd.com>
To: <herrmann.der.user@googlemail.com>
CC: <bp@alien8.de>, <jacob.w.shin@gmail.com>, <linux-kernel@vger.kernel.org>,
        Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
Subject: [PATCH] x86, microcode, AMD: Fix patch level reporting for family15h
Date: Thu, 26 Sep 2013 16:54:32 -0500
Message-ID: <1380232472-2589-1-git-send-email-suravee.suthikulpanit@amd.com>
X-Mailer: git-send-email 1.8.1.2
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: amd.com
X-FOPE-CONNECTOR: Id%0$Dn%*$RO%0$TLS%0$FQDN%$TlsDn%
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>

On AMD family15h, applying microcode patch on the a core (core0)
would also affect the other core (core1) in the same compute unit.
The driver would skip applying the patch on core1, but it still
need to update kernel structures to reflect the proper patch level.

The current logic is not updating the struct ucode_cpu_info.cpu_sig.rev
of the skipped core. This causes the /sys/devices/system/cpu/cpu1/microcode/version
to report incorrect patch level as shown below:

[   10.708841] microcode: CPU0: new patch_level=0x0600063d
[   10.714256] microcode: CPU1: patch_level=0x06000626
[   10.719345] microcode: CPU2: patch_level=0x06000626
[   10.748095] microcode: CPU2: new patch_level=0x0600063d
[   10.753365] microcode: CPU3: patch_level=0x06000626
[   10.758264] microcode: CPU4: patch_level=0x06000626
[   10.786999] microcode: CPU4: new patch_level=0x0600063d

Signed-off-by: Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
---
 arch/x86/kernel/microcode_amd.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/x86/kernel/microcode_amd.c b/arch/x86/kernel/microcode_amd.c
index 7123b5d..af99f71 100644
--- a/arch/x86/kernel/microcode_amd.c
+++ b/arch/x86/kernel/microcode_amd.c
@@ -216,6 +216,7 @@ int apply_microcode_amd(int cpu)
 	/* need to apply patch? */
 	if (rev >= mc_amd->hdr.patch_id) {
 		c->microcode = rev;
+		uci->cpu_sig.rev = rev;
 		return 0;
 	}
 
-- 
1.8.1.2


