Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753814AbaKXP2t (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Nov 2014 10:28:49 -0500
Received: from mail-wi0-f181.google.com ([209.85.212.181]:34641 "EHLO
	mail-wi0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752915AbaKXP2r convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Nov 2014 10:28:47 -0500
Content-Type: text/plain; charset=utf-8
Mime-Version: 1.0 (Mac OS X Mail 8.1 \(1993\))
Subject: Re: [CFT PATCH 0/2] KVM: support XSAVES usage in the host
From: Nadav Amit <nadav.amit@gmail.com>
In-Reply-To: <547318E5.8070408@redhat.com>
Date: Mon, 24 Nov 2014 17:28:41 +0200
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        kvm list <kvm@vger.kernel.org>, Nadav Amit <namit@cs.technion.ac.il>,
        Wanpeng Li <wanpeng.li@linux.intel.com>
Content-Transfer-Encoding: 8BIT
Message-Id: <DAC65E0B-06CC-4B34-85B2-72AD5F86826B@gmail.com>
References: <1416594678-13011-1-git-send-email-pbonzini@redhat.com> <DE9192FA-6A22-4AEB-88C2-AE17DA503685@gmail.com> <547318E5.8070408@redhat.com>
To: Paolo Bonzini <pbonzini@redhat.com>
X-Mailer: Apple Mail (2.1993)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> On Nov 24, 2014, at 13:39, Paolo Bonzini <pbonzini@redhat.com> wrote:
> 
> 
> 
> On 23/11/2014 09:16, Nadav Amit wrote:
>> I’ll try to check it tomorrow (I don’t have access to the failing machine at the moment).
> 
> Thanks, you'll need to squash this in:
> 
> diff --git a/arch/x86/kernel/xsave.c b/arch/x86/kernel/xsave.c
> index 4c540c4719d8..0de1fae2bdf0 100644
> --- a/arch/x86/kernel/xsave.c
> +++ b/arch/x86/kernel/xsave.c
> @@ -738,3 +738,4 @@ void *get_xsave_addr(struct xsave_struct *xsave, int xstate)
> 
> 	return (void *)xsave + xstate_comp_offsets[feature];
> }
> +EXPORT_SYMBOL_GPL(get_xsave_addr);

I tested the patches but there are still problems.

Since kvm_load_guest_fpu is called before the guest_fpu is ever stored, there are 2 more problems that currently cause #GP:
1. XCOMP_BV[63] = 0
2. XSTATE_BV sets a bit (including bit 63) that is not set in XCOMP_BV (XCOMP_BV is initialised to zero).

[see SDM 13.11 "OPERATION OF XRSTORS”]

Once I initialise XCOMP_BV to (1ull << 63) | XSTATE_BV, the guest runs successfully.
I have not checked any other qemu functionality that might be affected by the patch.

Nadav



