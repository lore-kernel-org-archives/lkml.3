Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752496AbaCJIsT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Mar 2014 04:48:19 -0400
Received: from mga02.intel.com ([134.134.136.20]:9061 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751675AbaCJIsS convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Mar 2014 04:48:18 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,622,1389772800"; 
   d="scan'208,223";a="469460122"
From: "Liu, Jinsong" <jinsong.liu@intel.com>
To: Paolo Bonzini <pbonzini@redhat.com>,
        "'kvm@vger.kernel.org'" <kvm@vger.kernel.org>,
        "'linux-kernel@vger.kernel.org'" <linux-kernel@vger.kernel.org>,
        "'qemu-devel@nongnu.org'" <qemu-devel@nongnu.org>
Subject: [PATCH] KVM: x86: Work around buggy MPX platform
Thread-Topic: [PATCH] KVM: x86: Work around buggy MPX platform
Thread-Index: Ac88PXlfQ4/brVIqQkCnTIGrpxnr+Q==
Date: Mon, 10 Mar 2014 08:48:15 +0000
Message-ID: <DE8DF0795D48FD4CA783C40EC82923350155757D@SHSMSX152.ccr.corp.intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.239.127.40]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From 5854070994c5002b3a37577165ed3e82f36f712d Mon Sep 17 00:00:00 2001
From: Liu Jinsong <jinsong.liu@intel.com>
Date: Sat, 8 Mar 2014 04:40:02 +0800
Subject: [PATCH] KVM: x86: Work around buggy MPX platform

Work around buggy MPX platform which support MSR_IA32_BNDCFGS
but has issue at, say, VMX ucode.

Signed-off-by: Liu Jinsong <jinsong.liu@intel.com>
---
 arch/x86/kvm/x86.c |   14 +++++++++++++-
 1 files changed, 13 insertions(+), 1 deletions(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 1e91a24..1fc184d 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -3936,6 +3936,16 @@ static void kvm_init_msr_list(void)
 	for (i = j = KVM_SAVE_MSRS_BEGIN; i < ARRAY_SIZE(msrs_to_save); i++) {
 		if (rdmsr_safe(msrs_to_save[i], &dummy[0], &dummy[1]) < 0)
 			continue;
+
+		/*
+		 * Work around some buggy MPX platform which support
+		 * MSR_IA32_BNDCFGS but has issue at, say, VMX ucode.
+		 */
+		if ((msrs_to_save[i] == MSR_IA32_BNDCFGS) &&
+			(kvm_x86_ops->mpx_supported   ?
+			!kvm_x86_ops->mpx_supported() : 1))
+				continue;
+
 		if (j < i)
 			msrs_to_save[j] = msrs_to_save[i];
 		j++;
@@ -5576,9 +5586,11 @@ int kvm_arch_init(void *opaque)
 		goto out_free_percpu;
 
 	kvm_set_mmio_spte_mask();
-	kvm_init_msr_list();
 
 	kvm_x86_ops = ops;
+
+	kvm_init_msr_list();
+
 	kvm_mmu_set_mask_ptes(PT_USER_MASK, PT_ACCESSED_MASK,
 			PT_DIRTY_MASK, PT64_NX_MASK, 0);
 
-- 
1.7.1
