Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753996Ab3JBOK4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Oct 2013 10:10:56 -0400
Received: from mx1.redhat.com ([209.132.183.28]:10959 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753207Ab3JBOKu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Oct 2013 10:10:50 -0400
Date: Wed, 2 Oct 2013 17:10:32 +0300
From: Gleb Natapov <gleb@redhat.com>
To: Michael Ellerman <michael@ellerman.id.au>
Cc: Alexander Graf <agraf@suse.de>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paolo Bonzini <pbonzini@redhat.com>, Paul Mackerras <paulus@samba.org>,
        linux-kernel@vger.kernel.org, mpm@selenic.com,
        herbert@gondor.hengli.com.au, linuxppc-dev@ozlabs.org,
        kvm@vger.kernel.org, kvm-ppc@vger.kernel.org, tytso@mit.edu
Subject: Re: [PATCH 3/3] KVM: PPC: Book3S: Add support for hwrng found on
 some powernv systems
Message-ID: <20131002141032.GI17294@redhat.com>
References: <20131001083908.GA17294@redhat.com>
 <1380620338.645.22.camel@pasglop>
 <524AAFAA.3010801@redhat.com>
 <20131002050940.GA25363@drongo>
 <524BDD73.3020106@redhat.com>
 <1380704789.645.57.camel@pasglop>
 <668E4650-BC22-4CBF-A282-E7875DF29DB6@suse.de>
 <3CBF5732-E7EE-4C96-8132-6D7B77270DAF@suse.de>
 <20131002100224.GF17294@redhat.com>
 <1380722275.12149.28.camel@concordia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1380722275.12149.28.camel@concordia>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 02, 2013 at 11:57:55PM +1000, Michael Ellerman wrote:
> On Wed, 2013-10-02 at 13:02 +0300, Gleb Natapov wrote:
> > On Wed, Oct 02, 2013 at 11:50:50AM +0200, Alexander Graf wrote:
> > > 
> > > On 02.10.2013, at 11:11, Alexander Graf wrote:
> > > 
> > > So how do you solve live migration between a kernel that has this patch and one that doesn't?
> > > 
> > Yes, I alluded to it in my email to Paul and Paolo asked also. How this
> > interface is disabled? 
> 
> Yes that is a valid point.
> 
> We can't disable the interface at runtime, the guest detects its
> presence at boot.
> 
> What will happen is the hcall will come through to QEMU, which will
> reject it with H_FUNCTION (~= ENOSYS).
> 
> The current pseries-rng driver does not handle that case well, which is
> exactly why I sent patches to fix it recently.
> 
> The only other option would be to feed it with /dev/random.
> 
What about other way, if guest migrates from kvm that has no this
hypercall to one that has? We try to not change HW under guest during
migration.

> > Also hwrnd is MMIO in a host why guest needs to
> > use hypercall instead of emulating the device (in kernel or somewhere
> > else?). 
> 
> Because PAPR is a platform specification and it specifies that the
> interface is a hypervisor call. We can't just decide we want to do it
> differently.
Any insights on why it was specified this what. What is special about
hwrnd device that hypercall is needed to access it? I got that you didn't
just decide to implement it that way :) Also what will happen if guest
will find emulated hwrnd device, will it use it?

> 
> > Another things is that on a host hwrnd is protected from
> > direct userspace access by virtue of been a device, but guest code (event
> > kernel mode) is userspace as far as hosts security model goes, so by
> > implementing this hypercall in a way that directly access hwrnd you
> > expose hwrnd to a userspace unconditionally. Why is this a good idea? 
> 
> I'm not sure I follow you.
> 
> The hwrng is accessible by host userspace via /dev/mem.
> 
Regular user has no access to /dev/mem, but he can start kvm guest and
gain access to the device.

--
			Gleb.
