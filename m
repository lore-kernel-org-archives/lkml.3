Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754202AbaGOOkm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2014 10:40:42 -0400
Received: from mail-we0-f171.google.com ([74.125.82.171]:37748 "EHLO
	mail-we0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753717AbaGOOkg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2014 10:40:36 -0400
Date: Tue, 15 Jul 2014 17:40:31 +0300
From: Gleb Natapov <gleb@kernel.org>
To: Tang Chen <tangchen@cn.fujitsu.com>
Cc: Jan Kiszka <jan.kiszka@web.de>, mtosatti@redhat.com, nadav.amit@gmail.com,
        kvm@vger.kernel.org, laijs@cn.fujitsu.com,
        isimatu.yasuaki@jp.fujitsu.com, guz.fnst@cn.fujitsu.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 5/5] kvm, mem-hotplug: Do not pin apic access page in
 memory.
Message-ID: <20140715144030.GN4399@minantech.com>
References: <1404824492-30095-1-git-send-email-tangchen@cn.fujitsu.com>
 <1404824492-30095-6-git-send-email-tangchen@cn.fujitsu.com>
 <20140712080442.GH4399@minantech.com>
 <53C38D55.2040307@cn.fujitsu.com>
 <20140714145822.GK4399@minantech.com>
 <53C51608.4080109@web.de>
 <20140715120921.GT18167@minantech.com>
 <53C51E66.7030208@cn.fujitsu.com>
 <20140715124048.GU18167@minantech.com>
 <53C52469.3060607@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <53C52469.3060607@cn.fujitsu.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 15, 2014 at 08:54:01PM +0800, Tang Chen wrote:
> On 07/15/2014 08:40 PM, Gleb Natapov wrote:
> >On Tue, Jul 15, 2014 at 08:28:22PM +0800, Tang Chen wrote:
> >>On 07/15/2014 08:09 PM, Gleb Natapov wrote:
> >>>On Tue, Jul 15, 2014 at 01:52:40PM +0200, Jan Kiszka wrote:
> >>......
> >>>>
> >>>>I cannot follow your concerns yet. Specifically, how should
> >>>>APIC_ACCESS_ADDR (the VMCS field, right?) change while L2 is running? We
> >>>>currently pin/unpin on L1->L2/L2->L1, respectively. Or what do you mean?
> >>>>
> >>>I am talking about this case:
> >>>          if (cpu_has_secondary_exec_ctrls()) {a
> >>>          } else {
> >>>              exec_control |=
> >>>                 SECONDARY_EXEC_VIRTUALIZE_APIC_ACCESSES;
> >>>             vmcs_write64(APIC_ACCESS_ADDR,
> >>>                 page_to_phys(vcpu->kvm->arch.apic_access_page));
> >>>          }
> >>>We do not pin here.
> >>>
> >>
> >>Hi Gleb,
> >>
> >>
> >>7905                 if (exec_control&
> >>SECONDARY_EXEC_VIRTUALIZE_APIC_ACCESSES) {
> >>......
> >>7912                         if (vmx->nested.apic_access_page) /* shouldn't
> >>happen */
> >>7913 nested_release_page(vmx->nested.apic_access_page);
> >>7914                         vmx->nested.apic_access_page =
> >>7915                                 nested_get_page(vcpu,
> >>vmcs12->apic_access_addr);
> >>
> >>I thought you were talking about the problem here. We pin
> >>vmcs12->apic_access_addr
> >>in memory. And I think we should do the same thing to this page as to L1 vm.
> >>Right ?
> >Nested kvm pins a lot of pages, it will probably be not easy to handle all of them,
> >so for now I am concerned with non nested case only (but nested should continue to
> >work obviously, just pin pages like it does now).
> 
> True. I will work on it.
> 
> And also, when using PCI passthrough, kvm_pin_pages() also pins some pages.
> This is
> also in my todo list.
Those pages are (almost) directly accessible by assigned PCI devices,
I am not sure this is even doable.

> 
> But sorry, a little strange. I didn't find where vmcs12->apic_access_addr is
> allocated
> or initialized... Would you please tell me ?
handle_vmwrite() writes it when guest is executing vmwrite(APIC_ACCESS_ADDR);

> 
> >
> >>
> >>......
> >>7922                         if (!vmx->nested.apic_access_page)
> >>7923                                 exec_control&=
> >>7924 ~SECONDARY_EXEC_VIRTUALIZE_APIC_ACCESSES;
> >>7925                         else
> >>7926                                 vmcs_write64(APIC_ACCESS_ADDR,
> >>7927 page_to_phys(vmx->nested.apic_access_page));
> >>7928                 } else if
> >>(vm_need_virtualize_apic_accesses(vmx->vcpu.kvm)) {
> >>7929                         exec_control |=
> >>7930 SECONDARY_EXEC_VIRTUALIZE_APIC_ACCESSES;
> >>7931                         vmcs_write64(APIC_ACCESS_ADDR,
> >>7932 page_to_phys(vcpu->kvm->arch.apic_access_page));
> >>7933                 }
> >>
> >>And yes, we have the problem you said here. We can migrate the page while L2
> >>vm is running.
> >>So I think we should enforce L2 vm to exit to L1. Right ?
> >>
> >We can request APIC_ACCESS_ADDR reload during L2->L1 vmexit emulation, so
> >if APIC_ACCESS_ADDR changes while L2 is running it will be reloaded for L1 too.
> >
> 
> apic pages for L2 and L1 are not the same page, right ?
> 
If L2 guest enable apic access page then they are different, otherwise
they are the same.

> I think, just like we are doing in patch 5/5, we cannot wait for the next
> L2->L1 vmexit.
> We should enforce a L2->L1 vmexit in mmu_notifier, just like
> make_all_cpus_request() does.
> 
> Am I right ?
> 
I do not see why forcing APIC_ACCESS_ADDR reload during L2->L1 exit is not enough.

--
			Gleb.
