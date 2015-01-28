Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761160AbbA2CQQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2015 21:16:16 -0500
Received: from mout.kundenserver.de ([212.227.17.24]:64034 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755192AbbA2CQL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jan 2015 21:16:11 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Marc Zyngier <marc.zyngier@arm.com>,
        Christoffer Dall <cdall@cs.columbia.edu>
Cc: Russell King <rmk@arm.linux.org.uk>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: randconfig bug: ARM/KVM link error in hyp_idmap section
Date: Wed, 28 Jan 2015 20:57:19 +0100
Message-ID: <3919069.MpPCrczKD2@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.16.0-10-generic; KDE/4.11.5; x86_64; ; )
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V03:K0:hQOhm5v6eTTRxLQYYqRU5K51yOEZfPgnhFx/TNv5B/MFmbIl0nk
 8BI+GJkZvj/KGD7plye75wNm2FM7YPhld+Dk+QLnushA6ImCORyFNEGlYOa69uRxWZQsosc
 yBheSlaY9svB4APcVg1wo34gOznK7zWVht3GfklKr6R2wJFNnjjhY7Y1+URlv/vBuS3G+xH
 BMp3dC8NXCeCuYhPe/Ipg==
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Since 0394e1f60520 ("ARM: KVM: enforce maximum size for identity
mapped code"), some randconfigs started failing because the hyp_idmap
section grows too large. I've tracked this down to the problem of
veneers getting erroneously added to this section, but I'm not
sure about the fix. The patch below is what I came up with.

Any other ideas?

	Arnd

8<----
Subject: [PATCH] ARM: KVM: avoid "HYP init code too big" error

When building large kernels, the linker will emit lots of veneers
into the .hyp.idmap.text section, which causes it to grow beyond
one page, and that triggers the build error.

This moves the section into .rodata instead, which avoids the
veneers and is safe because the code is not executed directly
but always copied into a separate page first.

I am unsure if I wrote this the correct way though, so
it needs to be reviewed carefully.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>

diff --git a/arch/arm/kernel/vmlinux.lds.S b/arch/arm/kernel/vmlinux.lds.S
index ce01a2d3339f..f4de6e16d951 100644
--- a/arch/arm/kernel/vmlinux.lds.S
+++ b/arch/arm/kernel/vmlinux.lds.S
@@ -23,10 +23,14 @@
 	VMLINUX_SYMBOL(__idmap_text_start) = .;				\
 	*(.idmap.text)							\
 	VMLINUX_SYMBOL(__idmap_text_end) = .;				\
-	. = ALIGN(32);							\
+	. = ALIGN(32);							
+
+#define IDMAP_RODATA							\
+	.rodata : {							\
 	VMLINUX_SYMBOL(__hyp_idmap_text_start) = .;			\
 	*(.hyp.idmap.text)						\
-	VMLINUX_SYMBOL(__hyp_idmap_text_end) = .;
+	VMLINUX_SYMBOL(__hyp_idmap_text_end) = .;			\
+	}
 
 #ifdef CONFIG_HOTPLUG_CPU
 #define ARM_CPU_DISCARD(x)
@@ -123,6 +127,7 @@ SECTIONS
 	. = ALIGN(1<<SECTION_SHIFT);
 #endif
 	RO_DATA(PAGE_SIZE)
+	IDMAP_RODATA
 
 	. = ALIGN(4);
 	__ex_table : AT(ADDR(__ex_table) - LOAD_OFFSET) {

