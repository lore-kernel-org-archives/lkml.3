Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755567AbaD1LbJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Apr 2014 07:31:09 -0400
Received: from mx1.redhat.com ([209.132.183.28]:3168 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754944AbaD1LbC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Apr 2014 07:31:02 -0400
Message-ID: <535E3BEA.4050704@redhat.com>
Date: Mon, 28 Apr 2014 13:30:50 +0200
From: Paolo Bonzini <pbonzini@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>, gleb@kernel.org
CC: avi.kivity@gmail.com, mtosatti@redhat.com, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Subject: Re: [PATCH v5 5/5] KVM: MMU: flush tlb out of mmu lock when write-protect
 the sptes
References: <1397725576-6617-1-git-send-email-xiaoguangrong@linux.vnet.ibm.com> <1397725576-6617-6-git-send-email-xiaoguangrong@linux.vnet.ibm.com>
In-Reply-To: <1397725576-6617-6-git-send-email-xiaoguangrong@linux.vnet.ibm.com>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

What about some editing of the big comment...

/*
 * Currently, shadow PTEs are write protected in two cases, 1) write protecting
 * guest page tables, 2) resetting dirty tracking after KVM_GET_DIRTY_LOG. The
 * differences between these two sorts are:
 *
 * a) only the first case clears SPTE_MMU_WRITEABLE bit.
 *
 * b) the first case requires flushing the TLB immediately to avoid corruption
 *    of the shadow page table on other VCPUs.  In order to synchronize with
 *    other VCPUs the flush is done under the MMU lock.
 *
 *    The second case instead can delay flushing of the TLB until just before
 *    returning the dirty bitmap is returned to userspace; this is because it
 *    only write-protects pages that are set in the bitmap, and further writes
 *    to those pages can be safely ignored until userspace examines the bitmap.
 *    We rely on this to flush the TLB outside the MMU lock.
 *
 * A problem arises when these two cases occur concurrently.  Userspace can
 * call KVM_GET_DIRTY_LOG, which write-protects pages but does not immediately
 * flush the TLB; in the meanwhile, KVM wants to write-protect a guest page
 * table, sees it's already write-protected, and the result is a corrupted TLB.
 *
 * To avoid this problem, when write protecting guest page tables we *always*
 * flush the TLB if the spte has the SPTE_MMU_WRITEABLE bit set, even if 
 * the spte was already write-protected.  This works since case 2 never touches
 * SPTE_MMU_WRITEABLE bit.  In other words, whenever a spte is updated (only
 * permission and status bits are changed) we need to check whether a spte with
 * SPTE_MMU_WRITEABLE becomes readonly.  If that happens, we flush the TLB.
 * mmu_spte_update() handles this.
 *
 * The rules to use SPTE_MMU_WRITEABLE and PT_WRITABLE_MASK are as follows:
 *
 * a) if you want to see if it has a writable TLB entry, or if the spte can be
 *    writable on the mmu mapping, check SPTE_MMU_WRITEABLE.  This is the most
 *    common case, otherwise
 *
 * b) when fixing a page fault on the spte or doing write-protection for
 *    dirty logging, check PT_WRITABLE_MASK.


Is the above accurate?

>  * TODO: introduce APIs to split these two cases.

What do you mean exactly?

Paolo
