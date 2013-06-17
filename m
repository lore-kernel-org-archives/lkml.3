Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932815Ab3FQL72 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Jun 2013 07:59:28 -0400
Received: from e28smtp02.in.ibm.com ([122.248.162.2]:37136 "EHLO
	e28smtp02.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932663Ab3FQL70 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Jun 2013 07:59:26 -0400
Message-ID: <51BEFA13.20809@linux.vnet.ibm.com>
Date: Mon, 17 Jun 2013 19:59:15 +0800
From: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130510 Thunderbird/17.0.6
MIME-Version: 1.0
To: Takuya Yoshikawa <takuya.yoshikawa@gmail.com>
CC: Marcelo Tosatti <mtosatti@redhat.com>, gleb@redhat.com,
        avi.kivity@gmail.com, pbonzini@redhat.com,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Subject: Re: [PATCH v3 0/6] KVM: MMU: fast invalidate all mmio sptes
References: <1370595088-3315-1-git-send-email-xiaoguangrong@linux.vnet.ibm.com> <20130614000821.GA3183@amt.cnet> <20130615112211.c28016009d4da2be4833eadc@gmail.com>
In-Reply-To: <20130615112211.c28016009d4da2be4833eadc@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13061711-5816-0000-0000-0000087B891D
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sorry for the delay reply since i was on vacation.

On 06/15/2013 10:22 AM, Takuya Yoshikawa wrote:
> On Thu, 13 Jun 2013 21:08:21 -0300
> Marcelo Tosatti <mtosatti@redhat.com> wrote:
> 
>> On Fri, Jun 07, 2013 at 04:51:22PM +0800, Xiao Guangrong wrote:
> 
>> - Where is the generation number increased?
> 
> Looks like when a new slot is installed in update_memslots() because
> it's based on slots->generation.  This is not restricted to "create"
> and "move".

Yes. It reuses slots->generation to avoid unnecessary synchronizations
(RCU, memory barrier).

Increasing mmio generation number in the case of "create" and "move"
is ok - it is no addition work unless mmio generation number is overflow
which is hardly triggered (since the valid mmio generation number is
large enough and zap_all is scale well now.) and the mmio spte is updated
only when it is used in the future.

> 
>> - Should use spinlock breakable code in kvm_mmu_zap_mmio_sptes()
>> (picture guest with 512GB of RAM, even walking all those pages is
>> expensive) (ah, patch to remove kvm_mmu_zap_mmio_sptes does that).
>> - Is -13 enough to test wraparound? Its highly likely the guest has 
>> not began executing by the time 13 kvm_set_memory_calls are made
>> (so no sptes around). Perhaps -2000 is more sensible (should confirm
>> though).
> 
> In the future, after we've tested enough, we should change the testing
> code to be executed only for some debugging configs.  Especially, if we
> change zap_mmio_sptes() to zap_all_shadows(), very common guests, even
> without huge memory like 512GB, can see the effect induced by sudden page
> faults unnecessarily.
> 
> If necessary, developers can test the wraparound code by lowering the
> max_gen itself anyway.

I agree.

> 
>> - Why remove "if (change == KVM_MR_CREATE) || (change
>> ==  KVM_MR_MOVE)" from kvm_arch_commit_memory_region?
>> Its instructive.
> 
> There may be a chance that we miss generation wraparounds if we don't
> check other cases: seems unlikely, but theoretically possible.
> 
> In short, all memory slot changes make mmio sptes stored in shadow pages
> obsolete, or zapped for wraparounds, in the new way -- am I right?

Yes. You are definitely right. :)

Takuya-san, thank you very much for you answering the questions for me and thanks
all of you for patiently reviewing my patches.

Marcelo, your points?

