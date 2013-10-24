Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754464Ab3JXJck (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Oct 2013 05:32:40 -0400
Received: from mx1.redhat.com ([209.132.183.28]:21740 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753832Ab3JXJcj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Oct 2013 05:32:39 -0400
Date: Thu, 24 Oct 2013 12:32:33 +0300
From: Gleb Natapov <gleb@redhat.com>
To: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
Cc: avi.kivity@gmail.com, mtosatti@redhat.com, pbonzini@redhat.com,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Subject: Re: [PATCH v3 13/15] KVM: MMU: locklessly write-protect the page
Message-ID: <20131024093233.GC5289@redhat.com>
References: <1382534973-13197-1-git-send-email-xiaoguangrong@linux.vnet.ibm.com>
 <1382534973-13197-14-git-send-email-xiaoguangrong@linux.vnet.ibm.com>
 <20131024091732.GA5289@redhat.com>
 <5268E73C.7030302@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5268E73C.7030302@linux.vnet.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 24, 2013 at 05:24:12PM +0800, Xiao Guangrong wrote:
> On 10/24/2013 05:17 PM, Gleb Natapov wrote:
> 
> >>  
> >> -/**
> >> - * kvm_mmu_write_protect_pt_masked - write protect selected PT level pages
> >> +static void __rmap_write_protect_lockless(u64 *sptep)
> >> +{
> >> +	u64 spte;
> >> +
> >> +retry:
> >> +	/*
> >> +	 * Note we may partly read the sptep on 32bit host, however, we
> >> +	 * allow this case because:
> >> +	 * - we do not access the page got from the sptep.
> >> +	 * - cmpxchg64 can detect that case and avoid setting a wrong value
> >> +	 *   to the sptep.
> >> +	 */
> >> +	spte = *rcu_dereference(sptep);
> >> +	if (unlikely(!is_last_spte(spte) || !is_writable_pte(spte)))
> > is_last_spte gets two parameters.
> 
> In patch [PATCH v3 12/15] KVM: MMU: check last spte with unawareness of mapping level,
> we have removed the 'level' from the parameter list.
Ah, I haven't got 12/15 and git am did not complain :(

--
			Gleb.
