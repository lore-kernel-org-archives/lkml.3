Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932455Ab3CDURc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Mar 2013 15:17:32 -0500
Received: from mail.skyhub.de ([78.46.96.112]:55855 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932399Ab3CDUQh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Mar 2013 15:16:37 -0500
From: Borislav Petkov <bp@alien8.de>
To: X86 ML <x86@kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Borislav Petkov <bp@suse.de>
Subject: [PATCH 5/5] x86, quirks: Shut-up a long-standing gcc warning
Date: Mon,  4 Mar 2013 21:16:20 +0100
Message-Id: <1362428180-8865-6-git-send-email-bp@alien8.de>
X-Mailer: git-send-email 1.8.1.3.535.ga923c31
In-Reply-To: <1362428180-8865-1-git-send-email-bp@alien8.de>
References: <1362428180-8865-1-git-send-email-bp@alien8.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Borislav Petkov <bp@suse.de>

So gcc nags about those since forever in randconfig builds.

arch/x86/kernel/quirks.c: In function ‘ati_ixp4x0_rev’:
arch/x86/kernel/quirks.c:361:4: warning: ‘b’ is used uninitialized in this function [-Wuninitialized]
arch/x86/kernel/quirks.c: In function ‘ati_force_enable_hpet’:
arch/x86/kernel/quirks.c:367:4: warning: ‘d’ may be used uninitialized in this function [-Wuninitialized]
arch/x86/kernel/quirks.c:357:6: note: ‘d’ was declared here
arch/x86/kernel/quirks.c:407:21: warning: ‘val’ may be used uninitialized in this function [-Wuninitialized]

This function quirk is called on a SB400 chipset only anyway so the
distant possibility of a PCI access failing becomes almost impossible
there. Even if it did fail, then something else more serious is the
problem.

So zero-out the variables so that gcc shuts up but do a coarse check
on the PCI accesses at the end and signal whether any of them had an
error. They shouldn't but in case they do, we'll at least know and we
can address it.

Signed-off-by: Borislav Petkov <bp@suse.de>
---
 arch/x86/kernel/quirks.c | 18 +++++++++++-------
 1 file changed, 11 insertions(+), 7 deletions(-)

diff --git a/arch/x86/kernel/quirks.c b/arch/x86/kernel/quirks.c
index 26ee48a33dc4..04ee1e2e4c02 100644
--- a/arch/x86/kernel/quirks.c
+++ b/arch/x86/kernel/quirks.c
@@ -354,18 +354,22 @@ static void ati_force_hpet_resume(void)
 
 static u32 ati_ixp4x0_rev(struct pci_dev *dev)
 {
-	u32 d;
-	u8  b;
+	int err = 0;
+	u32 d = 0;
+	u8  b = 0;
 
-	pci_read_config_byte(dev, 0xac, &b);
+	err = pci_read_config_byte(dev, 0xac, &b);
 	b &= ~(1<<5);
-	pci_write_config_byte(dev, 0xac, b);
-	pci_read_config_dword(dev, 0x70, &d);
+	err |= pci_write_config_byte(dev, 0xac, b);
+	err |= pci_read_config_dword(dev, 0x70, &d);
 	d |= 1<<8;
-	pci_write_config_dword(dev, 0x70, d);
-	pci_read_config_dword(dev, 0x8, &d);
+	err |= pci_write_config_dword(dev, 0x70, d);
+	err |= pci_read_config_dword(dev, 0x8, &d);
 	d &= 0xff;
 	dev_printk(KERN_DEBUG, &dev->dev, "SB4X0 revision 0x%x\n", d);
+
+	WARN_ON_ONCE(err);
+
 	return d;
 }
 
-- 
1.8.1.3.535.ga923c31

