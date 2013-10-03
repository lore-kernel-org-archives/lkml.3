Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756884Ab3JCFoS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Oct 2013 01:44:18 -0400
Received: from mx1.redhat.com ([209.132.183.28]:30827 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754387Ab3JCFoQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Oct 2013 01:44:16 -0400
Date: Thu, 3 Oct 2013 08:43:55 +0300
From: Gleb Natapov <gleb@redhat.com>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Alexander Graf <agraf@suse.de>, Paolo Bonzini <pbonzini@redhat.com>,
        Paul Mackerras <paulus@samba.org>,
        Michael Ellerman <michael@ellerman.id.au>,
        linux-kernel@vger.kernel.org, mpm@selenic.com,
        herbert@gondor.hengli.com.au, linuxppc-dev@ozlabs.org,
        kvm@vger.kernel.org, kvm-ppc@vger.kernel.org, tytso@mit.edu
Subject: Re: [PATCH 3/3] KVM: PPC: Book3S: Add support for hwrng found on
 some powernv systems
Message-ID: <20131003054355.GT17294@redhat.com>
References: <20131001083908.GA17294@redhat.com>
 <1380620338.645.22.camel@pasglop>
 <524AAFAA.3010801@redhat.com>
 <20131002050940.GA25363@drongo>
 <524BDD73.3020106@redhat.com>
 <1380704789.645.57.camel@pasglop>
 <668E4650-BC22-4CBF-A282-E7875DF29DB6@suse.de>
 <3CBF5732-E7EE-4C96-8132-6D7B77270DAF@suse.de>
 <20131002100224.GF17294@redhat.com>
 <1380751340.645.68.camel@pasglop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1380751340.645.68.camel@pasglop>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 03, 2013 at 08:02:20AM +1000, Benjamin Herrenschmidt wrote:
> On Wed, 2013-10-02 at 13:02 +0300, Gleb Natapov wrote:
> 
> > Yes, I alluded to it in my email to Paul and Paolo asked also. How this
> > interface is disabled? Also hwrnd is MMIO in a host why guest needs to
> > use hypercall instead of emulating the device (in kernel or somewhere
> > else?).
> 
> Migration will have to be dealt with one way or another, I suppose we
> will indeed need a qemu fallback.
> 
So at least from amount of code perspective userspace and kernel space
solutions are on par since later will require former anyway.

What about other direction? Migration from KVM that does not have the
hypercall to one that has? We try to not change HW under a guest.

> As for why hypercall instead of MMIO, well, you'd have to ask the folks
> who wrote the PAPR spec :-) It's specified as a hypercall and
> implemented as such in pHyp (PowerVM). The existing guests expect it
> that way.
OK.

> 
> It might have to do with the required whitening done by the hypervisor
> (H_RANDOM output is supposed to be clean). It also abstracts us from the
> underlying HW implementation which could in theory change.
>  
But I guess bare metal OS has to know how to do whitening and deal with
HW change already. Anyway this is not the place to discuss PAPR
decisions. Thanks for insights.

> >  Another things is that on a host hwrnd is protected from
> > direct userspace access by virtue of been a device, but guest code (event
> > kernel mode) is userspace as far as hosts security model goes, so by
> > implementing this hypercall in a way that directly access hwrnd you
> > expose hwrnd to a userspace unconditionally. Why is this a good idea? 
> 
> Why would this be a bad idea ?
> 
When you elevate privilege you need to explain why it is not harmful
and why the privilege was restricted in the first place. /dev/hwrng
that first patch created gives access only to root, this patch changes
it to whoever can create a guest. 

Why it can be a bad idea? User can drain hwrng continuously making other
users of it much slower, or even worse, making them fall back to another
much less reliable, source of entropy.

--
			Gleb.
