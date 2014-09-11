Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752579AbaIKOVk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Sep 2014 10:21:40 -0400
Received: from mail-wi0-f175.google.com ([209.85.212.175]:61267 "EHLO
	mail-wi0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751776AbaIKOVi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Sep 2014 10:21:38 -0400
Date: Thu, 11 Sep 2014 17:21:21 +0300
From: Gleb Natapov <gleb@kernel.org>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: Tang Chen <tangchen@cn.fujitsu.com>, mtosatti@redhat.com,
        nadav.amit@gmail.com, jan.kiszka@web.de, kvm@vger.kernel.org,
        laijs@cn.fujitsu.com, isimatu.yasuaki@jp.fujitsu.com,
        guz.fnst@cn.fujitsu.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v5 4/7] kvm, mem-hotplug: Reload L1' apic access page on
 migration in vcpu_enter_guest().
Message-ID: <20140911142121.GD26540@minantech.com>
References: <1410413886-32213-1-git-send-email-tangchen@cn.fujitsu.com>
 <1410413886-32213-5-git-send-email-tangchen@cn.fujitsu.com>
 <541169AD.6060908@redhat.com>
 <20140911101200.GF25317@minantech.com>
 <54117DB4.307@redhat.com>
 <20140911113051.GG25317@minantech.com>
 <54119E01.9000908@redhat.com>
 <20140911135956.GC26540@minantech.com>
 <5411AC82.4080005@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5411AC82.4080005@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 11, 2014 at 04:06:58PM +0200, Paolo Bonzini wrote:
> Il 11/09/2014 15:59, Gleb Natapov ha scritto:
> > 
> > Suppose vmcs01->APIC_ACCESS_ADDR = 0xf000. During L2 entry
> > vmcs02->APIC_ACCESS_ADDR is set to 0xf000 too (by prepare_vmcs02). Now
> > 0xf000 is migrated to 0x8000, mmu notifier is called, it forces vmexit,
> > but vcpu is in a guest mode so vmcs02->APIC_ACCESS_ADDR is never updated
> > to 0x8000 because of "if (!is_guest_mode(vcpu))" check. So what am I
> > missing here?
> 
> Right, guest mode isn't left as soon as you execute nested_vmx_vmexit,
> because this isn't an L2->L1 exit.  So we need an "else" for that "if
> (!is_guest_mode(vcpu))", in which case the hpa is ignored and
> vmcs12->apic_access_addr is used instead?
> 
As far as I can tell the if that is needed there is:

if (!is_guest_mode() || !(vmcs12->secondary_vm_exec_control & ECONDARY_EXEC_VIRTUALIZE_APIC_ACCESSES))
    write(PIC_ACCESS_ADDR)

In other words if L2 shares L1 apic access page then reload, otherwise do nothing.

--
			Gleb.
