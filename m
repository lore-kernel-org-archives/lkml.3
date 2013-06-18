Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756410Ab3FRWVw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Jun 2013 18:21:52 -0400
Received: from mx1.redhat.com ([209.132.183.28]:30841 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754090Ab3FRWVu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Jun 2013 18:21:50 -0400
Date: Tue, 18 Jun 2013 19:21:06 -0300
From: Marcelo Tosatti <mtosatti@redhat.com>
To: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
Cc: Takuya Yoshikawa <takuya.yoshikawa@gmail.com>, gleb@redhat.com,
        avi.kivity@gmail.com, pbonzini@redhat.com,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Subject: Re: [PATCH v3 0/6] KVM: MMU: fast invalidate all mmio sptes
Message-ID: <20130618222106.GB13856@amt.cnet>
References: <1370595088-3315-1-git-send-email-xiaoguangrong@linux.vnet.ibm.com>
 <20130614000821.GA3183@amt.cnet>
 <20130615112211.c28016009d4da2be4833eadc@gmail.com>
 <51BEFA13.20809@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <51BEFA13.20809@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 17, 2013 at 07:59:15PM +0800, Xiao Guangrong wrote:
> Sorry for the delay reply since i was on vacation.
> 
> On 06/15/2013 10:22 AM, Takuya Yoshikawa wrote:
> > On Thu, 13 Jun 2013 21:08:21 -0300
> > Marcelo Tosatti <mtosatti@redhat.com> wrote:
> > 
> >> On Fri, Jun 07, 2013 at 04:51:22PM +0800, Xiao Guangrong wrote:
> > 
> >> - Where is the generation number increased?
> > 
> > Looks like when a new slot is installed in update_memslots() because
> > it's based on slots->generation.  This is not restricted to "create"
> > and "move".
> 
> Yes. It reuses slots->generation to avoid unnecessary synchronizations
> (RCU, memory barrier).
> 
> Increasing mmio generation number in the case of "create" and "move"
> is ok - it is no addition work unless mmio generation number is overflow
> which is hardly triggered (since the valid mmio generation number is
> large enough and zap_all is scale well now.) and the mmio spte is updated
> only when it is used in the future.
> 
> > 
> >> - Should use spinlock breakable code in kvm_mmu_zap_mmio_sptes()
> >> (picture guest with 512GB of RAM, even walking all those pages is
> >> expensive) (ah, patch to remove kvm_mmu_zap_mmio_sptes does that).
> >> - Is -13 enough to test wraparound? Its highly likely the guest has 
> >> not began executing by the time 13 kvm_set_memory_calls are made
> >> (so no sptes around). Perhaps -2000 is more sensible (should confirm
> >> though).
> > 
> > In the future, after we've tested enough, we should change the testing
> > code to be executed only for some debugging configs.  Especially, if we
> > change zap_mmio_sptes() to zap_all_shadows(), very common guests, even
> > without huge memory like 512GB, can see the effect induced by sudden page
> > faults unnecessarily.
> > 
> > If necessary, developers can test the wraparound code by lowering the
> > max_gen itself anyway.
> 
> I agree.
> 
> > 
> >> - Why remove "if (change == KVM_MR_CREATE) || (change
> >> ==  KVM_MR_MOVE)" from kvm_arch_commit_memory_region?
> >> Its instructive.
> > 
> > There may be a chance that we miss generation wraparounds if we don't
> > check other cases: seems unlikely, but theoretically possible.
> > 
> > In short, all memory slot changes make mmio sptes stored in shadow pages
> > obsolete, or zapped for wraparounds, in the new way -- am I right?
> 
> Yes. You are definitely right. :)
> 
> Takuya-san, thank you very much for you answering the questions for me and thanks
> all of you for patiently reviewing my patches.
> 
> Marcelo, your points?

Agreed - points are clear. Patchset looks good.

