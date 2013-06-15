Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754045Ab3FOCWT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Jun 2013 22:22:19 -0400
Received: from mail-pa0-f41.google.com ([209.85.220.41]:65010 "EHLO
	mail-pa0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751737Ab3FOCWR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Jun 2013 22:22:17 -0400
Date: Sat, 15 Jun 2013 11:22:11 +0900
From: Takuya Yoshikawa <takuya.yoshikawa@gmail.com>
To: Marcelo Tosatti <mtosatti@redhat.com>
Cc: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>, gleb@redhat.com,
        avi.kivity@gmail.com, pbonzini@redhat.com,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Subject: Re: [PATCH v3 0/6] KVM: MMU: fast invalidate all mmio sptes
Message-Id: <20130615112211.c28016009d4da2be4833eadc@gmail.com>
In-Reply-To: <20130614000821.GA3183@amt.cnet>
References: <1370595088-3315-1-git-send-email-xiaoguangrong@linux.vnet.ibm.com>
	<20130614000821.GA3183@amt.cnet>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 13 Jun 2013 21:08:21 -0300
Marcelo Tosatti <mtosatti@redhat.com> wrote:

> On Fri, Jun 07, 2013 at 04:51:22PM +0800, Xiao Guangrong wrote:

> - Where is the generation number increased?

Looks like when a new slot is installed in update_memslots() because
it's based on slots->generation.  This is not restricted to "create"
and "move".

> - Should use spinlock breakable code in kvm_mmu_zap_mmio_sptes()
> (picture guest with 512GB of RAM, even walking all those pages is
> expensive) (ah, patch to remove kvm_mmu_zap_mmio_sptes does that).
> - Is -13 enough to test wraparound? Its highly likely the guest has 
> not began executing by the time 13 kvm_set_memory_calls are made
> (so no sptes around). Perhaps -2000 is more sensible (should confirm
> though).

In the future, after we've tested enough, we should change the testing
code to be executed only for some debugging configs.  Especially, if we
change zap_mmio_sptes() to zap_all_shadows(), very common guests, even
without huge memory like 512GB, can see the effect induced by sudden page
faults unnecessarily.

If necessary, developers can test the wraparound code by lowering the
max_gen itself anyway.

> - Why remove "if (change == KVM_MR_CREATE) || (change
> ==  KVM_MR_MOVE)" from kvm_arch_commit_memory_region?
> Its instructive.

There may be a chance that we miss generation wraparounds if we don't
check other cases: seems unlikely, but theoretically possible.

In short, all memory slot changes make mmio sptes stored in shadow pages
obsolete, or zapped for wraparounds, in the new way -- am I right?

	Takuya
