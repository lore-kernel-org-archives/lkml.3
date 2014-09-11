Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755830AbaIKOII (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Sep 2014 10:08:08 -0400
Received: from mail-wi0-f170.google.com ([209.85.212.170]:52320 "EHLO
	mail-wi0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753831AbaIKOIE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Sep 2014 10:08:04 -0400
Date: Thu, 11 Sep 2014 16:59:56 +0300
From: Gleb Natapov <gleb@kernel.org>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: Tang Chen <tangchen@cn.fujitsu.com>, mtosatti@redhat.com,
        nadav.amit@gmail.com, jan.kiszka@web.de, kvm@vger.kernel.org,
        laijs@cn.fujitsu.com, isimatu.yasuaki@jp.fujitsu.com,
        guz.fnst@cn.fujitsu.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v5 4/7] kvm, mem-hotplug: Reload L1' apic access page on
 migration in vcpu_enter_guest().
Message-ID: <20140911135956.GC26540@minantech.com>
References: <1410413886-32213-1-git-send-email-tangchen@cn.fujitsu.com>
 <1410413886-32213-5-git-send-email-tangchen@cn.fujitsu.com>
 <541169AD.6060908@redhat.com>
 <20140911101200.GF25317@minantech.com>
 <54117DB4.307@redhat.com>
 <20140911113051.GG25317@minantech.com>
 <54119E01.9000908@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <54119E01.9000908@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 11, 2014 at 03:05:05PM +0200, Paolo Bonzini wrote:
> Il 11/09/2014 13:30, Gleb Natapov ha scritto:
> >> > +			vmcs_write64(APIC_ACCESS_ADDR, page_to_phys(page));
> >> > +			/*
> >> > +			 * Do not pin apic access page in memory so that memory
> >> > +			 * hotplug process is able to migrate it.
> >> > +			 */
> >> > +			put_page(page);
> >> >  		}
> > This code is in prepare_vmcs02() and is executed during L1->L2 vmentry. What happens
> > when apic access page is migrated while L2 is running? It needs to be update somewhere.
> 
> Before it is migrated, the MMU notifier is called and will force a
> vmexit on all CPUs.  The reload code will call GUP again on the page
> again and swap it in.
> 
This is how it will work without "if (!is_guest_mode(vcpu))". But,
unless I am missing something, with this check it will not work while
vcpu is in L2.

Suppose vmcs01->APIC_ACCESS_ADDR = 0xf000. During L2 entry
vmcs02->APIC_ACCESS_ADDR is set to 0xf000 too (by prepare_vmcs02). Now
0xf000 is migrated to 0x8000, mmu notifier is called, it forces vmexit,
but vcpu is in a guest mode so vmcs02->APIC_ACCESS_ADDR is never updated
to 0x8000 because of "if (!is_guest_mode(vcpu))" check. So what am I
missing here?

--
			Gleb.
