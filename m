Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752938Ab3CRNTN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Mar 2013 09:19:13 -0400
Received: from mx1.redhat.com ([209.132.183.28]:14080 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751858Ab3CRNTL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Mar 2013 09:19:11 -0400
Date: Mon, 18 Mar 2013 15:19:07 +0200
From: Gleb Natapov <gleb@redhat.com>
To: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
Cc: Marcelo Tosatti <mtosatti@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        KVM <kvm@vger.kernel.org>
Subject: Re: [PATCH 5/5] KVM: MMU: fast invalid all mmio sptes
Message-ID: <20130318131907.GK4020@redhat.com>
References: <51433D98.4050605@linux.vnet.ibm.com>
 <51433E71.2070107@linux.vnet.ibm.com>
 <20130317150239.GM11223@redhat.com>
 <5146CB92.7060203@linux.vnet.ibm.com>
 <20130318091303.GA1276@redhat.com>
 <514708A9.8040009@linux.vnet.ibm.com>
 <20130318124616.GH4020@redhat.com>
 <51471217.7070801@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <51471217.7070801@linux.vnet.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 18, 2013 at 09:09:43PM +0800, Xiao Guangrong wrote:
> On 03/18/2013 08:46 PM, Gleb Natapov wrote:
> > On Mon, Mar 18, 2013 at 08:29:29PM +0800, Xiao Guangrong wrote:
> >> On 03/18/2013 05:13 PM, Gleb Natapov wrote:
> >>> On Mon, Mar 18, 2013 at 04:08:50PM +0800, Xiao Guangrong wrote:
> >>>> On 03/17/2013 11:02 PM, Gleb Natapov wrote:
> >>>>> On Fri, Mar 15, 2013 at 11:29:53PM +0800, Xiao Guangrong wrote:
> >>>>>> This patch tries to introduce a very simple and scale way to invalid all
> >>>>>> mmio sptes - it need not walk any shadow pages and hold mmu-lock
> >>>>>>
> >>>>>> KVM maintains a global mmio invalid generation-number which is stored in
> >>>>>> kvm->arch.mmio_invalid_gen and every mmio spte stores the current global
> >>>>>> generation-number into his available bits when it is created
> >>>>>>
> >>>>>> When KVM need zap all mmio sptes, it just simply increase the global
> >>>>>> generation-number. When guests do mmio access, KVM intercepts a MMIO #PF
> >>>>>> then it walks the shadow page table and get the mmio spte. If the
> >>>>>> generation-number on the spte does not equal the global generation-number,
> >>>>>> it will go to the normal #PF handler to update the mmio spte
> >>>>>>
> >>>>>> Since 19 bits are used to store generation-number on mmio spte, the
> >>>>>> generation-number can be round after 33554432 times. It is large enough
> >>>>>> for nearly all most cases, but making the code be more strong, we zap all
> >>>>>> shadow pages when the number is round
> >>>>>>
> >>>>> Very nice idea, but why drop Takuya patches instead of using
> >>>>> kvm_mmu_zap_mmio_sptes() when generation number overflows.
> >>>>
> >>>> I am not sure whether it is still needed. Requesting to zap all mmio sptes for
> >>>> more than 500000 times is really really rare, it nearly does not happen.
> >>>> (By the way, 33554432 is wrong in the changelog, i just copy that for my origin
> >>>> implantation.) And, after my patch optimizing zapping all shadow pages,
> >>>> zap-all-sps should not be a problem anymore since it does not take too much lock
> >>>> time.
> >>>>
> >>>> Your idea?
> >>>>
> >>> I expect 500000 to become less since I already had plans to store some
> >>
> >> Interesting, just curious, what are the plans? ;)
> >>
> > Currently we uses pio to signal that work is pending to virtio devices. The
> > requirement is that signaling should be fast and PIO is fast since there
> > is not need to emulate instruction. PCIE though is not really designed
> > with PIO in mind, so we will have to use MMIO to do signaling. To avoid
> > instruction emulation I thought about making guest access these devices using
> > predefined variety of MOV instruction so that emulation can be skipped.
> > The idea is to mark mmio spte to know that emulation is not needed.
> 
> How to know page-fault is caused by the predefined instruction?
> 
Only predefined phys address rages will be accessed that way. If page
fault is in a range we assume the knows instruction is used.

--
			Gleb.
