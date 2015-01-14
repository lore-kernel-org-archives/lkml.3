Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755816AbbANIgu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jan 2015 03:36:50 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:57851 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754269AbbANH1O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jan 2015 02:27:14 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>
Subject: [PATCH 3.18 063/150] kvm: x86: mask out XSAVES
Date: Tue, 13 Jan 2015 23:22:14 -0800
Message-Id: <20150114072058.704308676@linuxfoundation.org>
X-Mailer: git-send-email 2.2.2
In-Reply-To: <20150114072055.842408181@linuxfoundation.org>
References: <20150114072055.842408181@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Paolo Bonzini <pbonzini@redhat.com>

commit b65d6e17fe2239c9b2051727903955d922083fbf upstream.

This feature is not supported inside KVM guests yet, because we do not emulate
MSR_IA32_XSS.  Mask it out.

Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/x86/kvm/cpuid.c |   11 ++++++++++-
 1 file changed, 10 insertions(+), 1 deletion(-)

--- a/arch/x86/kvm/cpuid.c
+++ b/arch/x86/kvm/cpuid.c
@@ -319,6 +319,10 @@ static inline int __do_cpuid_ent(struct
 		F(BMI2) | F(ERMS) | f_invpcid | F(RTM) | f_mpx | F(RDSEED) |
 		F(ADX) | F(SMAP);
 
+	/* cpuid 0xD.1.eax */
+	const u32 kvm_supported_word10_x86_features =
+		F(XSAVEOPT) | F(XSAVEC) | F(XGETBV1);
+
 	/* all calls to cpuid_count() should be made on the same cpu */
 	get_cpu();
 
@@ -455,13 +459,18 @@ static inline int __do_cpuid_ent(struct
 		entry->eax &= supported;
 		entry->edx &= supported >> 32;
 		entry->flags |= KVM_CPUID_FLAG_SIGNIFCANT_INDEX;
+		if (!supported)
+			break;
+
 		for (idx = 1, i = 1; idx < 64; ++idx) {
 			u64 mask = ((u64)1 << idx);
 			if (*nent >= maxnent)
 				goto out;
 
 			do_cpuid_1_ent(&entry[i], function, idx);
-			if (entry[i].eax == 0 || !(supported & mask))
+			if (idx == 1)
+				entry[i].eax &= kvm_supported_word10_x86_features;
+			else if (entry[i].eax == 0 || !(supported & mask))
 				continue;
 			entry[i].flags |=
 			       KVM_CPUID_FLAG_SIGNIFCANT_INDEX;


