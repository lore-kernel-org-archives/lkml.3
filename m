Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759917Ab3BHBTO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Feb 2013 20:19:14 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:41819 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758024Ab3BHA5f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Feb 2013 19:57:35 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Mike Qiu <qiudayu@linux.vnet.ibm.com>,
        "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>
Subject: [ 01/34] powerpc/mm: Fix hash computation function
Date: Thu,  7 Feb 2013 16:56:57 -0800
Message-Id: <20130208004627.594117876@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.rc1.5.g7e0651a
In-Reply-To: <20130208004627.375461662@linuxfoundation.org>
References: <20130208004627.375461662@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>

commit eda8eebdd153c48a4e2a3a3ac3cd9e2e31f5c6b3 upstream.

The ASM version of hash computation function was truncating the upper bit.
Make the ASM version similar to hpt_hash function. Remove masking vsid bits.
Without this patch, we observed hang during bootup due to not satisfying page
fault request correctly. The fault handler used wrong hash values to update
the HPTE. Hence we kept looping with page fault.

hash_page(ea=000001003e260008, access=203, trap=300 ip=3fff91787134 dsisr 42000000
The computed value of hash 000000000f22f390
update: avpnv=4003e46054003e00, hash=000000000722f390, f=80000006, psize: 2 ...

BenH: The over-masking has been there for ever but only hurts with the
new 64T support introduced in 3.7

Reported-by: Mike Qiu <qiudayu@linux.vnet.ibm.com>
Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
Tested-by: Mike Qiu <qiudayu@linux.vnet.ibm.com>
Signed-off-by: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/powerpc/mm/hash_low_64.S |   62 +++++++++++++++++++++++-------------------
 1 file changed, 35 insertions(+), 27 deletions(-)

--- a/arch/powerpc/mm/hash_low_64.S
+++ b/arch/powerpc/mm/hash_low_64.S
@@ -115,11 +115,13 @@ END_MMU_FTR_SECTION_IFSET(MMU_FTR_1T_SEG
 	sldi	r29,r5,SID_SHIFT - VPN_SHIFT
 	rldicl  r28,r3,64 - VPN_SHIFT,64 - (SID_SHIFT - VPN_SHIFT)
 	or	r29,r28,r29
-
-	/* Calculate hash value for primary slot and store it in r28 */
-	rldicl	r5,r5,0,25		/* vsid & 0x0000007fffffffff */
-	rldicl	r0,r3,64-12,48		/* (ea >> 12) & 0xffff */
-	xor	r28,r5,r0
+	/*
+	 * Calculate hash value for primary slot and store it in r28
+	 * r3 = va, r5 = vsid
+	 * r0 = (va >> 12) & ((1ul << (28 - 12)) -1)
+	 */
+	rldicl	r0,r3,64-12,48
+	xor	r28,r5,r0		/* hash */
 	b	4f
 
 3:	/* Calc vpn and put it in r29 */
@@ -130,11 +132,12 @@ END_MMU_FTR_SECTION_IFSET(MMU_FTR_1T_SEG
 	/*
 	 * calculate hash value for primary slot and
 	 * store it in r28 for 1T segment
+	 * r3 = va, r5 = vsid
 	 */
-	rldic	r28,r5,25,25		/* (vsid << 25) & 0x7fffffffff */
-	clrldi	r5,r5,40		/* vsid & 0xffffff */
-	rldicl	r0,r3,64-12,36		/* (ea >> 12) & 0xfffffff */
-	xor	r28,r28,r5
+	sldi	r28,r5,25		/* vsid << 25 */
+	/* r0 =  (va >> 12) & ((1ul << (40 - 12)) -1) */
+	rldicl	r0,r3,64-12,36
+	xor	r28,r28,r5		/* vsid ^ ( vsid << 25) */
 	xor	r28,r28,r0		/* hash */
 
 	/* Convert linux PTE bits into HW equivalents */
@@ -407,11 +410,13 @@ END_MMU_FTR_SECTION_IFSET(MMU_FTR_1T_SEG
 	 */
 	rldicl  r28,r3,64 - VPN_SHIFT,64 - (SID_SHIFT - VPN_SHIFT)
 	or	r29,r28,r29
-
-	/* Calculate hash value for primary slot and store it in r28 */
-	rldicl	r5,r5,0,25		/* vsid & 0x0000007fffffffff */
-	rldicl	r0,r3,64-12,48		/* (ea >> 12) & 0xffff */
-	xor	r28,r5,r0
+	/*
+	 * Calculate hash value for primary slot and store it in r28
+	 * r3 = va, r5 = vsid
+	 * r0 = (va >> 12) & ((1ul << (28 - 12)) -1)
+	 */
+	rldicl	r0,r3,64-12,48
+	xor	r28,r5,r0		/* hash */
 	b	4f
 
 3:	/* Calc vpn and put it in r29 */
@@ -426,11 +431,12 @@ END_MMU_FTR_SECTION_IFSET(MMU_FTR_1T_SEG
 	/*
 	 * Calculate hash value for primary slot and
 	 * store it in r28  for 1T segment
+	 * r3 = va, r5 = vsid
 	 */
-	rldic	r28,r5,25,25		/* (vsid << 25) & 0x7fffffffff */
-	clrldi	r5,r5,40		/* vsid & 0xffffff */
-	rldicl	r0,r3,64-12,36		/* (ea >> 12) & 0xfffffff */
-	xor	r28,r28,r5
+	sldi	r28,r5,25		/* vsid << 25 */
+	/* r0 = (va >> 12) & ((1ul << (40 - 12)) -1) */
+	rldicl	r0,r3,64-12,36
+	xor	r28,r28,r5		/* vsid ^ ( vsid << 25) */
 	xor	r28,r28,r0		/* hash */
 
 	/* Convert linux PTE bits into HW equivalents */
@@ -752,25 +758,27 @@ END_MMU_FTR_SECTION_IFSET(MMU_FTR_1T_SEG
 	rldicl  r28,r3,64 - VPN_SHIFT,64 - (SID_SHIFT - VPN_SHIFT)
 	or	r29,r28,r29
 
-	/* Calculate hash value for primary slot and store it in r28 */
-	rldicl	r5,r5,0,25		/* vsid & 0x0000007fffffffff */
-	rldicl	r0,r3,64-16,52		/* (ea >> 16) & 0xfff */
-	xor	r28,r5,r0
+	/* Calculate hash value for primary slot and store it in r28
+	 * r3 = va, r5 = vsid
+	 * r0 = (va >> 16) & ((1ul << (28 - 16)) -1)
+	 */
+	rldicl	r0,r3,64-16,52
+	xor	r28,r5,r0		/* hash */
 	b	4f
 
 3:	/* Calc vpn and put it in r29 */
 	sldi	r29,r5,SID_SHIFT_1T - VPN_SHIFT
 	rldicl  r28,r3,64 - VPN_SHIFT,64 - (SID_SHIFT_1T - VPN_SHIFT)
 	or	r29,r28,r29
-
 	/*
 	 * calculate hash value for primary slot and
 	 * store it in r28 for 1T segment
+	 * r3 = va, r5 = vsid
 	 */
-	rldic	r28,r5,25,25		/* (vsid << 25) & 0x7fffffffff */
-	clrldi	r5,r5,40		/* vsid & 0xffffff */
-	rldicl	r0,r3,64-16,40		/* (ea >> 16) & 0xffffff */
-	xor	r28,r28,r5
+	sldi	r28,r5,25		/* vsid << 25 */
+	/* r0 = (va >> 16) & ((1ul << (40 - 16)) -1) */
+	rldicl	r0,r3,64-16,40
+	xor	r28,r28,r5		/* vsid ^ ( vsid << 25) */
 	xor	r28,r28,r0		/* hash */
 
 	/* Convert linux PTE bits into HW equivalents */


