Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753497Ab3JBJLQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Oct 2013 05:11:16 -0400
Received: from cantor2.suse.de ([195.135.220.15]:36740 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752992Ab3JBJLM convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Oct 2013 05:11:12 -0400
Subject: Re: [PATCH 3/3] KVM: PPC: Book3S: Add support for hwrng found on some powernv systems
Mime-Version: 1.0 (Apple Message framework v1278)
Content-Type: text/plain; charset=us-ascii
From: Alexander Graf <agraf@suse.de>
In-Reply-To: <1380704789.645.57.camel@pasglop>
Date: Wed, 2 Oct 2013 11:11:06 +0200
Cc: Paolo Bonzini <pbonzini@redhat.com>, Paul Mackerras <paulus@samba.org>,
        Gleb Natapov <gleb@redhat.com>,
        Michael Ellerman <michael@ellerman.id.au>,
        linux-kernel@vger.kernel.org, mpm@selenic.com,
        herbert@gondor.hengli.com.au, linuxppc-dev@ozlabs.org,
        kvm@vger.kernel.org, kvm-ppc@vger.kernel.org, tytso@mit.edu
Content-Transfer-Encoding: 8BIT
Message-Id: <668E4650-BC22-4CBF-A282-E7875DF29DB6@suse.de>
References: <1380177066-3835-1-git-send-email-michael@ellerman.id.au> <1380177066-3835-3-git-send-email-michael@ellerman.id.au> <5243F933.7000907@redhat.com> <20131001083426.GB27484@concordia> <20131001083908.GA17294@redhat.com> <1380620338.645.22.camel@pasglop> <524AAFAA.3010801@redhat.com> <20131002050940.GA25363@drongo> <524BDD73.3020106@redhat.com> <1380704789.645.57.camel@pasglop>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
X-Mailer: Apple Mail (2.1278)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On 02.10.2013, at 11:06, Benjamin Herrenschmidt wrote:

> On Wed, 2013-10-02 at 10:46 +0200, Paolo Bonzini wrote:
> 
>> 
>> Thanks.  Any chance you can give some numbers of a kernel hypercall and
>> a userspace hypercall on Power, so we have actual data?  For example a
>> hypercall that returns H_PARAMETER as soon as possible.
> 
> I don't have (yet) numbers at hand but we have basically 3 places where
> we can handle hypercalls:
> 
> - Kernel real mode. This is where most of our MMU stuff goes for
> example unless it needs to trigger a page fault in Linux. This is
> executed with translation disabled and the MMU still in guest context.
> This is the fastest path since we don't take out the other threads nor
> perform any expensive context change. This is where we put the
> "accelerated" H_RANDOM as well.
> 
> - Kernel virtual mode. That's a full exit, so all threads are out and
> MMU switched back to host Linux. Things like vhost MMIO emulation goes
> there, page faults, etc...
> 
> - Qemu. This adds the round trip to userspace on top of the above.

Right, and the difference for the patch in question is really whether we handle in in kernel virtual mode or in QEMU, so the bulk of the overhead (kicking threads out of  guest context, switching MMU context, etc) happens either way.

So the additional overhead when handling it in QEMU here really boils down to the user space roundtrip (plus another random number read roundtrip).


Alex

