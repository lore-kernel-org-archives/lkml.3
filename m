Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755499Ab3KTVcN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Nov 2013 16:32:13 -0500
Received: from mx1.redhat.com ([209.132.183.28]:63806 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755222Ab3KTVcL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Nov 2013 16:32:11 -0500
Date: Wed, 20 Nov 2013 17:47:27 -0200
From: Marcelo Tosatti <mtosatti@redhat.com>
To: Xiao Guangrong <xiaoguangrong.eric@gmail.com>
Cc: Gleb Natapov <gleb@redhat.com>, avi.kivity@gmail.com,
        "pbonzini@redhat.com Bonzini" <pbonzini@redhat.com>,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Subject: Re: [PATCH 04/12] KVM: MMU: log dirty page after marking spte
 writable
Message-ID: <20131120194727.GA3353@amt.cnet>
References: <1375189330-24066-1-git-send-email-xiaoguangrong@linux.vnet.ibm.com>
 <1375189330-24066-5-git-send-email-xiaoguangrong@linux.vnet.ibm.com>
 <20130807014828.GA4781@amt.cnet>
 <5201C7D9.20004@linux.vnet.ibm.com>
 <20131120002920.GA14230@amt.cnet>
 <B166B522-2CDB-44CA-B594-687B45A1CF01@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <B166B522-2CDB-44CA-B594-687B45A1CF01@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 20, 2013 at 10:20:09PM +0800, Xiao Guangrong wrote:
> > But what guarantee does userspace require, from GET_DIRTY_LOG, while vcpus are
> > executing? 
> 
> Aha. Single calling GET_DIRTY_LOG is useless since new dirty page can be generated
> when GET_DIRTY_LOG is being returned. If user wants to get exact dirty pages the vcpus
> should be stopped. 
> 
> > 
> > With fast page fault:
> > 
> >      if (cmpxchg64(sptep, spte, spte | PT_WRITABLE_MASK) == spte)
> >              /* The window in here... */
> >              mark_page_dirty(vcpu->kvm, gfn);
> > 
> > And the $SUBJECT set_spte reordering, the rule becomes
> > 
> > A call to GET_DIRTY_LOG guarantees to return correct information about 
> > dirty pages before invocation of the previous GET_DIRTY_LOG call.
> > 
> > (see example 1: the next GET_DIRTY_LOG will return the dirty information
> > there).
> > 
> 
> It seems no.
> 
> The first GET_DIRTY_LOG can happen before fast-page-fault，
> the second GET_DIRTY_LOG happens in the window between cmpxchg()
> and mark_page_dirty(), for the second one, the information is still “incorrect”.

Its correct for the previous GET_DIRTY_LOG call.

> > The rule for sptes that is, because kvm_write_guest does not match the
> > documentation at all.
> 
> You mean the case of “kvm_write_guest” is valid (I do not know why it is)?
> Or anything else?
> 
> > 
> > So before example 1 and this patch, the rule (well for sptes at least) was
> > 
> > "Given a memory slot, return a bitmap containing any pages dirtied
> > since the last call to this ioctl.  Bit 0 is the first page in the
> > memory slot.  Ensure the entire structure is cleared to avoid padding
> > issues."
> > 
> > Can you explain why it is OK to relax this rule?
> 
> It’s because:
> 1) it doesn’t break current use cases, i.e. Live migration and FB-flushing.
> 2) the current code, like kvm_write_guest  has already broken the documentation
>    (the guest page has been written but missed in the dirty bitmap).
> 3) it’s needless to implement a exact get-dirty-pages since the dirty pages can
>    no be exactly got except stopping vcpus. 
> 
> So i think we'd document this case instead. No?

Lets figure out the requirements, then. I don't understand why
FB-flushing is safe (think kvm-autotest: one pixel off the entire
test fails).

Before fast page fault: Pages are either write protected or the
corresponding dirty bitmap bit is set. Any write faults to dirty logged
sptes while GET_DIRTY log is executing in the protected section are
allowed to instantiate writeable spte after GET_DIRTY log is finished.

After fast page fault: Pages can be writeable and the dirty bitmap not
set. Therefore data can be dirty before GET_DIRTY executes and still
fail to be returned in the bitmap.

Since this patchset does not introduce change in behaviour (fast pf
did), no reason to avoid merging this.

BTW, since GET_DIRTY log does not require to report concurrent (to
GET_DIRTY_LOG) write faults, it is not necessary to rewalk the spte
list, is it?



