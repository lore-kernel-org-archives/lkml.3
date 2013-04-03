Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759116Ab3DCAWw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Apr 2013 20:22:52 -0400
Received: from terminus.zytor.com ([198.137.202.10]:59710 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759036Ab3DCAWu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Apr 2013 20:22:50 -0400
Date: Tue, 2 Apr 2013 17:21:57 -0700
From: tip-bot for Borislav Petkov <tipbot@zytor.com>
Message-ID: <tip-73f460408ca9b6e917f32c89c9a85c586f17f732@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        tglx@linutronix.de, hpa@linux.intel.com, bp@suse.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        tglx@linutronix.de, bp@suse.de, hpa@linux.intel.com
In-Reply-To: <1362428180-8865-6-git-send-email-bp@alien8.de>
References: <1362428180-8865-6-git-send-email-bp@alien8.de>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/cleanups] x86, quirks:
  Shut-up a long-standing gcc warning
Git-Commit-ID: 73f460408ca9b6e917f32c89c9a85c586f17f732
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Tue, 02 Apr 2013 17:22:02 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  73f460408ca9b6e917f32c89c9a85c586f17f732
Gitweb:     http://git.kernel.org/tip/73f460408ca9b6e917f32c89c9a85c586f17f732
Author:     Borislav Petkov <bp@suse.de>
AuthorDate: Mon, 4 Mar 2013 21:16:20 +0100
Committer:  H. Peter Anvin <hpa@linux.intel.com>
CommitDate: Tue, 2 Apr 2013 16:03:34 -0700

x86, quirks: Shut-up a long-standing gcc warning

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
Link: http://lkml.kernel.org/r/1362428180-8865-6-git-send-email-bp@alien8.de
Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
---
 arch/x86/kernel/quirks.c | 18 +++++++++++-------
 1 file changed, 11 insertions(+), 7 deletions(-)

diff --git a/arch/x86/kernel/quirks.c b/arch/x86/kernel/quirks.c
index 26ee48a..04ee1e2 100644
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
 
