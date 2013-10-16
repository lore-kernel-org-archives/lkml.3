Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934538Ab3JPUns (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Oct 2013 16:43:48 -0400
Received: from mx1.redhat.com ([209.132.183.28]:52540 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932603Ab3JPUnq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Oct 2013 16:43:46 -0400
Date: Wed, 16 Oct 2013 17:43:20 -0300
From: Marcelo Tosatti <mtosatti@redhat.com>
To: Gleb Natapov <gleb@redhat.com>
Cc: Xiao Guangrong <xiaoguangrong.eric@gmail.com>,
        Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>,
        avi.kivity@gmail.com, pbonzini@redhat.com,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Subject: Re: [PATCH v2 12/15] KVM: MMU: allow locklessly access shadow page
 table out of vcpu thread
Message-ID: <20131016204320.GB479@amt.cnet>
References: <20131010164222.GB3211@amt.cnet>
 <20131010191646.GE15954@redhat.com>
 <20131010210301.GA7275@amt.cnet>
 <20131011053831.GG15954@redhat.com>
 <20131011203017.GA29576@amt.cnet>
 <20131012055356.GC14789@redhat.com>
 <20131014192945.GA22655@amt.cnet>
 <20131015035705.GB30802@redhat.com>
 <20131015222119.GA3125@amt.cnet>
 <20131016091211.GC15657@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131016091211.GC15657@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 16, 2013 at 12:12:11PM +0300, Gleb Natapov wrote:
> On Tue, Oct 15, 2013 at 07:21:19PM -0300, Marcelo Tosatti wrote:
> > On Tue, Oct 15, 2013 at 06:57:05AM +0300, Gleb Natapov wrote:
> > > > 
> > > > Why is it safe to allow access, by the lockless page write protect
> > > > side, to spt pointer for shadow page A that can change to a shadow page 
> > > > pointer of shadow page B?
> > > > 
> > > > Write protect spte of any page at will? Or verify that in fact thats the
> > > > shadow you want to write protect?
> > > > 
> > > > Note that spte value might be the same for different shadow pages, 
> > > > so cmpxchg succeeding does not guarantees its the same shadow page that
> > > > has been protected.
> > > > 
> > > Two things can happen: spte that we accidentally write protect is some
> > > other last level spte - this is benign, it will be unprotected on next
> > > fault.  
> > 
> > Nothing forbids two identical writable sptes to point to a same pfn. How
> > do you know you are write protecting the correct one? (the proper gfn).
> > 
> I am not sure I understand what you mean. If spt was freed and reallocated
> while lockless shadow page walk happened we definitely write protecting
> incorrect one, but this is not a problem unless the spte that is write
> protected is not last level, but there are ways to solve that.

Was assuming cmpxchg success on wrong spte would be problematic, but
Xiao says its detectable on the lockless rmap path.

> > Lockless walk sounds interesting. By the time you get to the lower
> > level, that might be a different spte.
> > 
> > All of this to avoid throttling, is it worthwhile?
> >
> I do not like kvm->arch.rcu_free_shadow_page, feels like a hack. I
> proposed slab RCU solution before, but it needs some more work to encode
> pt level into spte, so Xiao wanted to do it on top. But since something,
> either throttling or slab RCU, needs to be implemented anyway I prefer
> the later.

Yes, seems OK to me.

