Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753083AbaF2NOt (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Jun 2014 09:14:49 -0400
Received: from mail.skyhub.de ([78.46.96.112]:40979 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752600AbaF2NOr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Jun 2014 09:14:47 -0400
Date: Sun, 29 Jun 2014 15:14:43 +0200
From: Borislav Petkov <bp@alien8.de>
To: Jan Kiszka <jan.kiszka@web.de>
Cc: Gleb Natapov <gleb@kernel.org>, Paolo Bonzini <pbonzini@redhat.com>,
        lkml <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Steven Rostedt <rostedt@goodmis.org>, x86-ml <x86@kernel.org>,
        kvm@vger.kernel.org, =?utf-8?B?SsO2cmcgUsO2ZGVs?= <joro@8bytes.org>
Subject: Re: __schedule #DF splat
Message-ID: <20140629131443.GA5199@pd.tnic>
References: <20140627121053.GD23153@pd.tnic>
 <20140628114431.GB4373@pd.tnic>
 <20140629064626.GD18167@minantech.com>
 <53AFE2B3.5080300@web.de>
 <20140629102403.GE18167@minantech.com>
 <53AFEB16.5040608@web.de>
 <20140629105339.GF18167@minantech.com>
 <53AFF192.7020801@web.de>
 <20140629115143.GA4362@pd.tnic>
 <53B0050B.90104@web.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <53B0050B.90104@web.de>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jun 29, 2014 at 02:22:35PM +0200, Jan Kiszka wrote:
> OK, looks like I won ;):

I gladly let you win. :-P

> The issue was apparently introduced with "KVM: x86: get CPL from
> SS.DPL" (ae9fedc793). Maybe we are not properly saving or restoring
> this state on SVM since then.

I wonder if this change in the CPL saving would have anything to do with
the fact that we're doing a CR3 write right before we fail pagetable
walk and end up walking a user page table. It could be unrelated though,
as in the previous dump I had a get_user right before the #DF. Hmmm.

I better go and revert that one and check whether it fixes things.

> Need a break, will look into details later.

Ok, some more info from my side, see relevant snippet below. We're
basically not finding the pte at level 3 during the page walk for
7fff0b0f8908.

However, why we're even page walking this userspace address at that
point I have no idea.

And the CR3 write right before this happens is there so I'm pretty much
sure by now that this is related...

 qemu-system-x86-5007  [007] ...1   346.126204: vcpu_match_mmio: gva 0xffffffffff5fd0b0 gpa 0xfee000b0 Write GVA
 qemu-system-x86-5007  [007] ...1   346.126204: kvm_mmio: mmio write len 4 gpa 0xfee000b0 val 0x0
 qemu-system-x86-5007  [007] ...1   346.126205: kvm_apic: apic_write APIC_EOI = 0x0
 qemu-system-x86-5007  [007] ...1   346.126205: kvm_eoi: apicid 0 vector 253
 qemu-system-x86-5007  [007] d..2   346.126206: kvm_entry: vcpu 0
 qemu-system-x86-5007  [007] d..2   346.126211: kvm_exit: reason write_cr3 rip 0xffffffff816113a0 info 8000000000000000 0
 qemu-system-x86-5007  [007] ...2   346.126214: kvm_mmu_get_page: sp gen 25 gfn 7b2b1 4 pae q0 wux !nxe root 0 sync existing
 qemu-system-x86-5007  [007] d..2   346.126215: kvm_entry: vcpu 0
 qemu-system-x86-5007  [007] d..2   346.126216: kvm_exit: reason PF excp rip 0xffffffff816113df info 2 7fff0b0f8908
 qemu-system-x86-5007  [007] ...1   346.126217: kvm_page_fault: address 7fff0b0f8908 error_code 2
 qemu-system-x86-5007  [007] ...1   346.126218: kvm_mmu_pagetable_walk: addr 7fff0b0f8908 pferr 2 W
 qemu-system-x86-5007  [007] ...1   346.126219: kvm_mmu_paging_element: pte 7b2b6067 level 4
 qemu-system-x86-5007  [007] ...1   346.126220: kvm_mmu_paging_element: pte 0 level 3
 qemu-system-x86-5007  [007] ...1   346.126220: kvm_mmu_walker_error: pferr 2 W
 qemu-system-x86-5007  [007] ...1   346.126221: kvm_multiple_exception: nr: 14, prev: 255, has_error: 1, error_code: 0x2, reinj: 0
 qemu-system-x86-5007  [007] ...1   346.126221: kvm_inj_exception: #PF (0x2)
 qemu-system-x86-5007  [007] d..2   346.126222: kvm_entry: vcpu 0
 qemu-system-x86-5007  [007] d..2   346.126223: kvm_exit: reason PF excp rip 0xffffffff816113df info 2 7fff0b0f8908
 qemu-system-x86-5007  [007] ...1   346.126224: kvm_multiple_exception: nr: 14, prev: 14, has_error: 1, error_code: 0x2, reinj: 1
 qemu-system-x86-5007  [007] ...1   346.126225: kvm_page_fault: address 7fff0b0f8908 error_code 2
 qemu-system-x86-5007  [007] ...1   346.126225: kvm_mmu_pagetable_walk: addr 7fff0b0f8908 pferr 0 
 qemu-system-x86-5007  [007] ...1   346.126226: kvm_mmu_paging_element: pte 7b2b6067 level 4
 qemu-system-x86-5007  [007] ...1   346.126227: kvm_mmu_paging_element: pte 0 level 3
 qemu-system-x86-5007  [007] ...1   346.126227: kvm_mmu_walker_error: pferr 0 
 qemu-system-x86-5007  [007] ...1   346.126228: kvm_mmu_pagetable_walk: addr 7fff0b0f8908 pferr 2 W
 qemu-system-x86-5007  [007] ...1   346.126229: kvm_mmu_paging_element: pte 7b2b6067 level 4
 qemu-system-x86-5007  [007] ...1   346.126230: kvm_mmu_paging_element: pte 0 level 3
 qemu-system-x86-5007  [007] ...1   346.126230: kvm_mmu_walker_error: pferr 2 W
 qemu-system-x86-5007  [007] ...1   346.126231: kvm_multiple_exception: nr: 14, prev: 14, has_error: 1, error_code: 0x2, reinj: 0
 qemu-system-x86-5007  [007] ...1   346.126231: kvm_inj_exception: #DF (0x0)
 qemu-system-x86-5007  [007] d..2   346.126232: kvm_entry: vcpu 0
 qemu-system-x86-5007  [007] d..2   346.126371: kvm_exit: reason io rip 0xffffffff8131e623 info 3d40220 ffffffff8131e625
 qemu-system-x86-5007  [007] ...1   346.126372: kvm_pio: pio_write at 0x3d4 size 2 count 1 val 0x130e 
 qemu-system-x86-5007  [007] ...1   346.126374: kvm_userspace_exit: reason KVM_EXIT_IO (2)
 qemu-system-x86-5007  [007] d..2   346.126383: kvm_entry: vcpu 0

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
