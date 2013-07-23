Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935150Ab3GWWdl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jul 2013 18:33:41 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:41857 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934877Ab3GWW15 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jul 2013 18:27:57 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Baruch Siach <baruch@tkos.co.il>, Max Filippov <jcmvbkbc@gmail.com>,
        Chris Zankel <chris@zankel.net>
Subject: [ 089/103] xtensa: adjust boot parameters address when INITIALIZE_XTENSA_MMU_INSIDE_VMLINUX is selected
Date: Tue, 23 Jul 2013 15:26:40 -0700
Message-Id: <20130723220430.977875137@linuxfoundation.org>
X-Mailer: git-send-email 1.8.3.rc0.20.gb99dd2e
In-Reply-To: <20130723220418.532514378@linuxfoundation.org>
References: <20130723220418.532514378@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Max Filippov <jcmvbkbc@gmail.com>

commit c5a771d0678f9613e9f89cf1a5bdcfa5b08b225b upstream.

The virtual address of boot parameters chain is passed to the kernel via
a2 register. Adjust it in case it is remapped during MMUv3 -> MMUv2
mapping change, i.e. when it is in the first 128M.

Also fix interpretation of initrd and FDT addresses passed in the boot
parameters: these are physical addresses.

Reported-by: Baruch Siach <baruch@tkos.co.il>
Signed-off-by: Max Filippov <jcmvbkbc@gmail.com>
Signed-off-by: Chris Zankel <chris@zankel.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/xtensa/kernel/head.S  |    9 +++++++++
 arch/xtensa/kernel/setup.c |    6 +++---
 2 files changed, 12 insertions(+), 3 deletions(-)

--- a/arch/xtensa/kernel/head.S
+++ b/arch/xtensa/kernel/head.S
@@ -68,6 +68,15 @@ _SetupMMU:
 
 #ifdef CONFIG_INITIALIZE_XTENSA_MMU_INSIDE_VMLINUX
 	initialize_mmu
+#if defined(CONFIG_MMU) && XCHAL_HAVE_PTP_MMU && XCHAL_HAVE_SPANNING_WAY
+	rsr	a2, excsave1
+	movi	a3, 0x08000000
+	bgeu	a2, a3, 1f
+	movi	a3, 0xd0000000
+	add	a2, a2, a3
+	wsr	a2, excsave1
+1:
+#endif
 #endif
 	.end	no-absolute-literals
 
--- a/arch/xtensa/kernel/setup.c
+++ b/arch/xtensa/kernel/setup.c
@@ -152,8 +152,8 @@ static int __init parse_tag_initrd(const
 {
 	meminfo_t* mi;
 	mi = (meminfo_t*)(tag->data);
-	initrd_start = (void*)(mi->start);
-	initrd_end = (void*)(mi->end);
+	initrd_start = __va(mi->start);
+	initrd_end = __va(mi->end);
 
 	return 0;
 }
@@ -164,7 +164,7 @@ __tagtable(BP_TAG_INITRD, parse_tag_init
 
 static int __init parse_tag_fdt(const bp_tag_t *tag)
 {
-	dtb_start = (void *)(tag->data[0]);
+	dtb_start = __va(tag->data[0]);
 	return 0;
 }
 


