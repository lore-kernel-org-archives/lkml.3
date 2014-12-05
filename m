Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933446AbaLEAzE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Dec 2014 19:55:04 -0500
Received: from mga11.intel.com ([192.55.52.93]:60541 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933009AbaLEAzC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Dec 2014 19:55:02 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.07,519,1413270000"; 
   d="scan'208";a="632975616"
Date: Fri, 5 Dec 2014 08:34:47 +0800
From: Wanpeng Li <wanpeng.li@linux.intel.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: linux-kernel@vger.kernel.org, kvm@vger.kernel.org, rkrcmar@redhat.com
Subject: Re: [PATCH 6/9] KVM: cpuid: mask more bits in leaf 0xd and subleaves
Message-ID: <20141205003446.GA6967@kernel>
Reply-To: Wanpeng Li <wanpeng.li@linux.intel.com>
References: <1417708634-24333-1-git-send-email-pbonzini@redhat.com>
 <1417708634-24333-7-git-send-email-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1417708634-24333-7-git-send-email-pbonzini@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Paolo,
On Thu, Dec 04, 2014 at 04:57:11PM +0100, Paolo Bonzini wrote:
>- EAX=0Dh, ECX=1: output registers ECX/EDX are reserved.
>
>- EAX=0Dh, ECX>1: output register ECX bit 0 is clear for all the CPUID
>leaves we support, because variable "supported" comes from XCR0 and not
>XSS.  Bits above 0 are reserved, so ECX is overall zero.  Output register
>EDX is reserved.
>
>Source: Intel Architecture Instruction Set Extensions Programming
>Reference, ref. number 319433-022
>
>Reviewed-by: Radim Krčmář <rkrcmar@redhat.com>
>Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
>---
> arch/x86/kvm/cpuid.c | 10 ++++++++--
> 1 file changed, 8 insertions(+), 2 deletions(-)
>

Do you miss this in your patch?

+       /* cpuid 0xD.1.eax */
+       const u32 kvm_supported_word10_x86_features =
+               F(XSAVEOPT) | F(XSAVEC) | F(XGETBV1);
+

In addition, there is bisect issue if this is added in this patch.
(4/9 will take advantage of kvm_supported_word10_x86_features)

Regards,
Wanpeng Li 

>diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
>index 2f7bc2de9915..644bfe828ce1 100644
>--- a/arch/x86/kvm/cpuid.c
>+++ b/arch/x86/kvm/cpuid.c
>@@ -482,8 +482,14 @@ static inline int __do_cpuid_ent(struct kvm_cpuid_entry2 *entry, u32 function,
> 					entry[i].ebx =
> 						xstate_required_size(supported,
> 								     true);
>-			} else if (entry[i].eax == 0 || !(supported & mask))
>-				continue;
>+			} else {
>+				if (entry[i].eax == 0 || !(supported & mask))
>+					continue;
>+				if (WARN_ON_ONCE(entry[i].ecx & 1))
>+					continue;
>+			}
>+			entry[i].ecx = 0;
>+			entry[i].edx = 0;
> 			entry[i].flags |=
> 			       KVM_CPUID_FLAG_SIGNIFCANT_INDEX;
> 			++*nent;
>-- 
>1.8.3.1
>
