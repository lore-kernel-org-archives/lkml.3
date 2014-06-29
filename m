Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753074AbaF2KYQ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Jun 2014 06:24:16 -0400
Received: from mail-wg0-f49.google.com ([74.125.82.49]:45932 "EHLO
	mail-wg0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752659AbaF2KYO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Jun 2014 06:24:14 -0400
Date: Sun, 29 Jun 2014 13:24:04 +0300
From: Gleb Natapov <gleb@kernel.org>
To: Jan Kiszka <jan.kiszka@web.de>
Cc: Borislav Petkov <bp@alien8.de>, Paolo Bonzini <pbonzini@redhat.com>,
        lkml <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Steven Rostedt <rostedt@goodmis.org>, x86-ml <x86@kernel.org>,
        kvm@vger.kernel.org, =?utf-8?B?SsO2cmcgUsO2ZGVs?= <joro@8bytes.org>
Subject: Re: __schedule #DF splat
Message-ID: <20140629102403.GE18167@minantech.com>
References: <20140625153227.GA13845@pd.tnic>
 <20140625202650.GC13845@pd.tnic>
 <20140627101831.GB23153@pd.tnic>
 <53AD586A.40900@redhat.com>
 <20140627115545.GC23153@pd.tnic>
 <53AD5D27.2090505@redhat.com>
 <20140627121053.GD23153@pd.tnic>
 <20140628114431.GB4373@pd.tnic>
 <20140629064626.GD18167@minantech.com>
 <53AFE2B3.5080300@web.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <53AFE2B3.5080300@web.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jun 29, 2014 at 11:56:03AM +0200, Jan Kiszka wrote:
> On 2014-06-29 08:46, Gleb Natapov wrote:
> > On Sat, Jun 28, 2014 at 01:44:31PM +0200, Borislav Petkov wrote:
> >>  qemu-system-x86-20240 [006] ...1  9406.484134: kvm_page_fault: address 7fffb62ba318 error_code 2
> >>  qemu-system-x86-20240 [006] ...1  9406.484136: kvm_inj_exception: #PF (0x2)a
> >>
> >> kvm injects the #PF into the guest.
> >>
> >>  qemu-system-x86-20240 [006] d..2  9406.484136: kvm_entry: vcpu 1
> >>  qemu-system-x86-20240 [006] d..2  9406.484137: kvm_exit: reason PF excp rip 0xffffffff8161130f info 2 7fffb62ba318
> >>  qemu-system-x86-20240 [006] ...1  9406.484138: kvm_page_fault: address 7fffb62ba318 error_code 2
> >>  qemu-system-x86-20240 [006] ...1  9406.484141: kvm_inj_exception: #DF (0x0)
> >>
> >> Second #PF at the same address and kvm injects the #DF.
> >>
> >> BUT(!), why?
> >>
> >> I probably am missing something but WTH are we pagefaulting at a
> >> user address in context_switch() while doing a lockdep call, i.e.
> >> spin_release? We're not touching any userspace gunk there AFAICT.
> >>
> >> Is this an async pagefault or so which kvm is doing so that the guest
> >> rip is actually pointing at the wrong place?
> >>
> > There is nothing in the trace that point to async pagefault as far as I see.
> > 
> >> Or something else I'm missing, most probably...
> >>
> > Strange indeed. Can you also enable kvmmmu tracing? You can also instrument
> > kvm_multiple_exception() to see which two exception are combined into #DF.
> > 
> 
> FWIW, I'm seeing the same issue here (likely) on an E-450 APU. It
> disappears with older KVM (didn't bisect yet, some 3.11 is fine) and
> when patch-disabling the vmport in QEMU.
> 
> Let me know if I can help with the analysis.
>
Bisection would be great of course. Once thing that is special about
vmport that comes to mind is that it reads vcpu registers to userspace and
write them back. IIRC "info registers" does the same. Can you see if the
problem is reproducible with disabled vmport, but doing "info registers"
in qemu console? Although trace does not should any exists to userspace
near the failure...

--
			Gleb.
