Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752682AbaF3GAy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jun 2014 02:00:54 -0400
Received: from mail-wg0-f47.google.com ([74.125.82.47]:49519 "EHLO
	mail-wg0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751030AbaF3GAx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jun 2014 02:00:53 -0400
Date: Mon, 30 Jun 2014 09:00:47 +0300
From: Gleb Natapov <gleb@kernel.org>
To: Tang Chen <tangchen@cn.fujitsu.com>
Cc: Marcelo Tosatti <mtosatti@redhat.com>, pbonzini@redhat.com,
        tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com, mgorman@suse.de,
        yinghai@kernel.org, isimatu.yasuaki@jp.fujitsu.com,
        guz.fnst@cn.fujitsu.com, laijs@cn.fujitsu.com, kvm@vger.kernel.org,
        linux-mm@kvack.org, x86@kernel.org, linux-kernel@vger.kernel.org,
        Avi Kivity <avi.kivity@gmail.com>
Subject: Re: [RFC PATCH 1/1] Move two pinned pages to non-movable node in kvm.
Message-ID: <20140630060047.GI18167@minantech.com>
References: <20140618061230.GA10948@minantech.com>
 <53A136C4.5070206@cn.fujitsu.com>
 <20140619092031.GA429@minantech.com>
 <20140619190024.GA3887@amt.cnet>
 <20140620111509.GE20764@minantech.com>
 <20140620125326.GA22283@amt.cnet>
 <20140620142622.GA28698@minantech.com>
 <20140620203146.GA6580@amt.cnet>
 <20140620203903.GA7838@amt.cnet>
 <53B0C13C.20206@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <53B0C13C.20206@cn.fujitsu.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 30, 2014 at 09:45:32AM +0800, Tang Chen wrote:
> On 06/21/2014 04:39 AM, Marcelo Tosatti wrote:
> >On Fri, Jun 20, 2014 at 05:31:46PM -0300, Marcelo Tosatti wrote:
> >>>IIRC your shadow page pinning patch series support flushing of ptes
> >>>by mmu notifier by forcing MMU reload and, as a result, faulting in of
> >>>pinned pages during next entry.  Your patch series does not pin pages
> >>>by elevating their page count.
> >>
> >>No but PEBS series does and its required to stop swap-out
> >>of the page.
> >
> >Well actually no because of mmu notifiers.
> >
> >Tang, can you implement mmu notifiers for the other breaker of
> >mem hotplug ?
> 
> Hi Marcelo,
> 
> I made a patch to update ept and apic pages when finding them in the
> next ept violation. And I also updated the APIC_ACCESS_ADDR phys_addr.
> The pages can be migrated, but the guest crached.
How does it crash?

> 
> How do I stop guest from access apic pages in mmu_notifier when the
> page migration starts ?  Do I need to stop all the vcpus by set vcpu
> state to KVM_MP_STATE_HALTED ?  If so, the vcpu will not able to go
> to the next ept violation.
When apic access page is unmapped from ept pages by mmu notifiers you
need to set its value in VMCS to a physical address that will never be
mapped into guest memory. Zero for instance. You can do it by introducing
new KVM_REQ_ bit and set VMCS value during next vcpu's vmentry. On ept
violation you need to update VMCS pointer to newly allocated physical
address, you can use the same KVM_REQ_ mechanism again.

> 
> So, may I write any specific value into APIC_ACCESS_ADDR to stop guest
> from access to apic page ?
> 
Any phys address that will never be mapped into guest's memory should work.

--
			Gleb.
