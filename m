Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751618AbaGOOEX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2014 10:04:23 -0400
Received: from mail-we0-f173.google.com ([74.125.82.173]:61453 "EHLO
	mail-we0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750984AbaGOOEU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2014 10:04:20 -0400
Date: Tue, 15 Jul 2014 17:04:15 +0300
From: Gleb Natapov <gleb@kernel.org>
To: Jan Kiszka <jan.kiszka@web.de>
Cc: Tang Chen <tangchen@cn.fujitsu.com>, mtosatti@redhat.com,
        nadav.amit@gmail.com, kvm@vger.kernel.org, laijs@cn.fujitsu.com,
        isimatu.yasuaki@jp.fujitsu.com, guz.fnst@cn.fujitsu.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 5/5] kvm, mem-hotplug: Do not pin apic access page in
 memory.
Message-ID: <20140715140415.GM4399@minantech.com>
References: <1404824492-30095-1-git-send-email-tangchen@cn.fujitsu.com>
 <1404824492-30095-6-git-send-email-tangchen@cn.fujitsu.com>
 <20140712080442.GH4399@minantech.com>
 <53C38D55.2040307@cn.fujitsu.com>
 <20140714145822.GK4399@minantech.com>
 <53C51608.4080109@web.de>
 <20140715120921.GT18167@minantech.com>
 <53C51E66.7030208@cn.fujitsu.com>
 <20140715124048.GU18167@minantech.com>
 <53C52837.4030105@web.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <53C52837.4030105@web.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 15, 2014 at 03:10:15PM +0200, Jan Kiszka wrote:
> On 2014-07-15 14:40, Gleb Natapov wrote:
> >>
> >> ......
> >> 7922                         if (!vmx->nested.apic_access_page)
> >> 7923                                 exec_control &=
> >> 7924 ~SECONDARY_EXEC_VIRTUALIZE_APIC_ACCESSES;
> >> 7925                         else
> >> 7926                                 vmcs_write64(APIC_ACCESS_ADDR,
> >> 7927 page_to_phys(vmx->nested.apic_access_page));
> >> 7928                 } else if
> >> (vm_need_virtualize_apic_accesses(vmx->vcpu.kvm)) {
> >> 7929                         exec_control |=
> >> 7930 SECONDARY_EXEC_VIRTUALIZE_APIC_ACCESSES;
> >> 7931                         vmcs_write64(APIC_ACCESS_ADDR,
> >> 7932 page_to_phys(vcpu->kvm->arch.apic_access_page));
> >> 7933                 }
> >>
> >> And yes, we have the problem you said here. We can migrate the page while L2
> >> vm is running.
> >> So I think we should enforce L2 vm to exit to L1. Right ?
> >>
> > We can request APIC_ACCESS_ADDR reload during L2->L1 vmexit emulation, so
> > if APIC_ACCESS_ADDR changes while L2 is running it will be reloaded for L1 too.
> 
> How should this host-managed VMCS field possibly change while L2 is running?
> 
That what "Do not pin apic access page in memory" patch is doing. It changes APIC_ACCESS_ADDR
of a current vmcs. It kicks vcpu out of a guest mode of course, but vcpu may still be in 
L2 at this point, so only L2 vmcs will get new APIC_ACCESS_ADDR pointer, L1 vmcs will still have
an old one.
   
--
			Gleb.
