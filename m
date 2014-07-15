Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758910AbaGOMJa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2014 08:09:30 -0400
Received: from mail-we0-f178.google.com ([74.125.82.178]:54059 "EHLO
	mail-we0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758628AbaGOMJ1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2014 08:09:27 -0400
Date: Tue, 15 Jul 2014 15:09:21 +0300
From: Gleb Natapov <gleb@kernel.org>
To: Jan Kiszka <jan.kiszka@web.de>
Cc: Tang Chen <tangchen@cn.fujitsu.com>, mtosatti@redhat.com,
        nadav.amit@gmail.com, kvm@vger.kernel.org, laijs@cn.fujitsu.com,
        isimatu.yasuaki@jp.fujitsu.com, guz.fnst@cn.fujitsu.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 5/5] kvm, mem-hotplug: Do not pin apic access page in
 memory.
Message-ID: <20140715120921.GT18167@minantech.com>
References: <1404824492-30095-1-git-send-email-tangchen@cn.fujitsu.com>
 <1404824492-30095-6-git-send-email-tangchen@cn.fujitsu.com>
 <20140712080442.GH4399@minantech.com>
 <53C38D55.2040307@cn.fujitsu.com>
 <20140714145822.GK4399@minantech.com>
 <53C51608.4080109@web.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <53C51608.4080109@web.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 15, 2014 at 01:52:40PM +0200, Jan Kiszka wrote:
> On 2014-07-14 16:58, Gleb Natapov wrote:
> >>>> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> >>>> index ffbe557..7080eda 100644
> >>>> --- a/arch/x86/kvm/x86.c
> >>>> +++ b/arch/x86/kvm/x86.c
> >>>> @@ -5929,6 +5929,18 @@ static void vcpu_scan_ioapic(struct kvm_vcpu *vcpu)
> >>>>  	kvm_apic_update_tmr(vcpu, tmr);
> >>>>  }
> >>>>
> >>>> +static void vcpu_reload_apic_access_page(struct kvm_vcpu *vcpu)
> >>>> +{
> >>>> +	/*
> >>>> +	 * When the page is being migrated, GUP will wait till the migrate
> >>>> +	 * entry is replaced with the new pte entry pointing to the new page.
> >>>> +	 */
> >>>> +	struct page *page = gfn_to_page_no_pin(vcpu->kvm,
> >>>> +					APIC_DEFAULT_PHYS_BASE>>  PAGE_SHIFT);
> >>> If you do not use kvm->arch.apic_access_page to get current address why not drop it entirely?
> >>>
> >>
> >> I should also update kvm->arch.apic_access_page here. It is used in other
> >> places
> >> in kvm, so I don't think we should drop it. Will update the patch.
> > What other places? The only other place I see is in nested kvm code and you can call
> > gfn_to_page_no_pin() there instead of using kvm->arch.apic_access_page directly. But
> > as far as I see nested kvm code cannot handle change of APIC_ACCESS_ADDR phys address.
> > If APIC_ACCESS_ADDR changes during nested guest run, non nested vmcs will still have old
> > physical address. One way to fix that is to set KVM_REQ_APIC_PAGE_RELOAD during nested exit.
> 
> I cannot follow your concerns yet. Specifically, how should
> APIC_ACCESS_ADDR (the VMCS field, right?) change while L2 is running? We
> currently pin/unpin on L1->L2/L2->L1, respectively. Or what do you mean?
> 
I am talking about this case:
         if (cpu_has_secondary_exec_ctrls()) {a
         } else {
             exec_control |=
                SECONDARY_EXEC_VIRTUALIZE_APIC_ACCESSES;
            vmcs_write64(APIC_ACCESS_ADDR,
                page_to_phys(vcpu->kvm->arch.apic_access_page));
         }
We do not pin here.

--
			Gleb.
