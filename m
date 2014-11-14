Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965820AbaKNPn3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Nov 2014 10:43:29 -0500
Received: from helcar.apana.org.au ([209.40.204.226]:60992 "EHLO
	helcar.apana.org.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965015AbaKNPn2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Nov 2014 10:43:28 -0500
Date: Fri, 14 Nov 2014 23:43:15 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: "H. Peter Anvin" <hpa@linux.intel.com>, Suresh Siddha <sbsiddha@gmail.com>,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Cc: Steffen Klassert <steffen.klassert@secunet.com>,
        Ming Liu <ming.liu@windriver.com>
Subject: simd: Allow simd use in kernel threads with softirqs disabled
Message-ID: <20141114154315.GA15771@gondor.apana.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

While working on the cryptd request reordering problem, I noticed
an anomaly where kernel threads are normally allowed to use simd
per may_use_simd, but as soon as you disable softirqs, they suddenly
lose that ability for no good reason.

The problem is that in_interrupt does not distinguish between
softirq processing and simply having softirqs disabled.  This
patch creates a new helper in_serving_interrupt which makes that
distinction.  It then uses this in all current implementations
of may_use_simd.

Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>

diff --git a/arch/x86/kernel/i387.c b/arch/x86/kernel/i387.c
index a9a4229..6cdaa852 100644
--- a/arch/x86/kernel/i387.c
+++ b/arch/x86/kernel/i387.c
@@ -63,7 +63,7 @@ static inline bool interrupted_user_mode(void)
  */
 bool irq_fpu_usable(void)
 {
-	return !in_interrupt() ||
+	return !in_serving_interrupt() ||
 		interrupted_user_mode() ||
 		interrupted_kernel_fpu_idle();
 }
diff --git a/include/asm-generic/simd.h b/include/asm-generic/simd.h
index f57eb7b..74e0b05 100644
--- a/include/asm-generic/simd.h
+++ b/include/asm-generic/simd.h
@@ -10,5 +10,5 @@
  */
 static __must_check inline bool may_use_simd(void)
 {
-	return !in_interrupt();
+	return !in_serving_interrupt();
 }
diff --git a/include/linux/preempt_mask.h b/include/linux/preempt_mask.h
index dbeec4d..18f3b46 100644
--- a/include/linux/preempt_mask.h
+++ b/include/linux/preempt_mask.h
@@ -65,6 +65,8 @@
 #define in_softirq()		(softirq_count())
 #define in_interrupt()		(irq_count())
 #define in_serving_softirq()	(softirq_count() & SOFTIRQ_OFFSET)
+#define in_serving_interrupt()	(irq_count() & (HARDIRQ_MASK | \
+						SOFTIRQ_OFFSET | NMI_MASK))
 
 /*
  * Are we in NMI context?

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
