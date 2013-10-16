Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759980Ab3JPAmF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Oct 2013 20:42:05 -0400
Received: from mail-pb0-f43.google.com ([209.85.160.43]:58738 "EHLO
	mail-pb0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759708Ab3JPAmD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Oct 2013 20:42:03 -0400
Content-Type: text/plain; charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 6.6 \(1510\))
Subject: Re: [PATCH v2 12/15] KVM: MMU: allow locklessly access shadow page table out of vcpu thread
From: Xiao Guangrong <xiaoguangrong.eric@gmail.com>
In-Reply-To: <20131015222119.GA3125@amt.cnet>
Date: Wed, 16 Oct 2013 08:41:56 +0800
Cc: Gleb Natapov <gleb@redhat.com>,
        Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>,
        avi.kivity@gmail.com, pbonzini@redhat.com,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Content-Transfer-Encoding: 7bit
Message-Id: <089E37AA-3E8A-4FBF-A9C1-CA7362A5A789@gmail.com>
References: <20131010014710.GA2198@amt.cnet> <20131010120845.GT3574@redhat.com> <20131010164222.GB3211@amt.cnet> <20131010191646.GE15954@redhat.com> <20131010210301.GA7275@amt.cnet> <20131011053831.GG15954@redhat.com> <20131011203017.GA29576@amt.cnet> <20131012055356.GC14789@redhat.com> <20131014192945.GA22655@amt.cnet> <20131015035705.GB30802@redhat.com> <20131015222119.GA3125@amt.cnet>
To: Marcelo Tosatti <mtosatti@redhat.com>
X-Mailer: Apple Mail (2.1510)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Oct 16, 2013, at 6:21 AM, Marcelo Tosatti <mtosatti@redhat.com> wrote:

> On Tue, Oct 15, 2013 at 06:57:05AM +0300, Gleb Natapov wrote:
>>> 
>>> Why is it safe to allow access, by the lockless page write protect
>>> side, to spt pointer for shadow page A that can change to a shadow page 
>>> pointer of shadow page B?
>>> 
>>> Write protect spte of any page at will? Or verify that in fact thats the
>>> shadow you want to write protect?
>>> 
>>> Note that spte value might be the same for different shadow pages, 
>>> so cmpxchg succeeding does not guarantees its the same shadow page that
>>> has been protected.
>>> 
>> Two things can happen: spte that we accidentally write protect is some
>> other last level spte - this is benign, it will be unprotected on next
>> fault.  
> 
> Nothing forbids two identical writable sptes to point to a same pfn. How
> do you know you are write protecting the correct one? (the proper gfn).
> 
> Lockless walk sounds interesting. By the time you get to the lower
> level, that might be a different spte.

That's safe. Since get-dirty-log is serialized by slot-lock the dirty-bit
can not be lost - even if we write-protect on the different memslot
 (the dirty bit is still set). The worst case is we write-protect on a
unnecessary spte and cause a extra #PF but that is really race.

And the lockless rmap-walker can detect the new spte so that
write-protection on the memslot is not missed.

