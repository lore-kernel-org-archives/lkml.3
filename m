Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933321Ab3ICTeI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Sep 2013 15:34:08 -0400
Received: from usmamail.tilera.com ([12.216.194.151]:33090 "EHLO
	USMAMAIL.TILERA.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932248Ab3ICTeG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Sep 2013 15:34:06 -0400
Message-ID: <309272f99f3e65b9bb5c49a2901c63a1859172f3.1378235372.git.cmetcalf@tilera.com>
From: Chris Metcalf <cmetcalf@tilera.com>
Date: Tue, 3 Sep 2013 14:13:31 -0400
Subject: [PATCH 1/3] tile: clean up relocate_kernel_64 debug code
To: Gleb Natapov <gleb@redhat.com>, <linux-kernel@vger.kernel.org>,
        <kvm@vger.kernel.org>, Paolo Bonzini <pbonzini@redhat.com>,
        Jan Kiszka <jan.kiszka@siemens.com>
In-Reply-To: <20130903173931.GO10142@redhat.com>
References: <52091682.8020004@siemens.com>
  <201308122037.r7CKbo99011833@farm-0021.internal.tilera.com>
  <20130825113953.GN8218@redhat.com>
  <521AAED7.4080407@tilera.com>
  <20130826120445.GD8218@redhat.com>
  <52261D26.7060206@tilera.com>
  <20130903173931.GO10142@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We remove some debug code in relocate_kernel_64.S that made raw
calls to the hv_console_putc Tilera hypervisor API, since everything
should funnel through the early_hv_write() API.

Signed-off-by: Chris Metcalf <cmetcalf@tilera.com>
---
 arch/tile/kernel/relocate_kernel_64.S | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/arch/tile/kernel/relocate_kernel_64.S b/arch/tile/kernel/relocate_kernel_64.S
index 1c09a4f..02bc446 100644
--- a/arch/tile/kernel/relocate_kernel_64.S
+++ b/arch/tile/kernel/relocate_kernel_64.S
@@ -34,11 +34,11 @@ STD_ENTRY(relocate_new_kernel)
 	addi	sp, sp, -8
 	/* we now have a stack (whether we need one or not) */
 
+#ifdef RELOCATE_NEW_KERNEL_VERBOSE
 	moveli	r40, hw2_last(hv_console_putc)
 	shl16insli r40, r40, hw1(hv_console_putc)
 	shl16insli r40, r40, hw0(hv_console_putc)
 
-#ifdef RELOCATE_NEW_KERNEL_VERBOSE
 	moveli	r0, 'r'
 	jalr	r40
 
@@ -176,10 +176,12 @@ STD_ENTRY(relocate_new_kernel)
 
 	/* we should not get here */
 
+#ifdef RELOCATE_NEW_KERNEL_VERBOSE
 	moveli	r0, '?'
 	jalr	r40
 	moveli	r0, '\n'
 	jalr	r40
+#endif
 
 	j	.Lhalt
 
@@ -237,7 +239,9 @@ STD_ENTRY(relocate_new_kernel)
 	j	.Lloop
 
 
-.Lerr:	moveli	r0, 'e'
+.Lerr:
+#ifdef RELOCATE_NEW_KERNEL_VERBOSE
+	moveli	r0, 'e'
 	jalr	r40
 	moveli	r0, 'r'
 	jalr	r40
@@ -245,6 +249,7 @@ STD_ENTRY(relocate_new_kernel)
 	jalr	r40
 	moveli	r0, '\n'
 	jalr	r40
+#endif
 .Lhalt:
 	moveli r41, hw2_last(hv_halt)
 	shl16insli r41, r41, hw1(hv_halt)
-- 
1.8.3.1

