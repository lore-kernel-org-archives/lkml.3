Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753451Ab3JBIiM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Oct 2013 04:38:12 -0400
Received: from mail-ea0-f179.google.com ([209.85.215.179]:40096 "EHLO
	mail-ea0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753185Ab3JBIiG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Oct 2013 04:38:06 -0400
Message-ID: <524BDB7D.8000708@redhat.com>
Date: Wed, 02 Oct 2013 10:38:21 +0200
From: Paolo Bonzini <pbonzini@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130923 Thunderbird/17.0.9
MIME-Version: 1.0
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
CC: Gleb Natapov <gleb@redhat.com>, Michael Ellerman <michael@ellerman.id.au>,
        linux-kernel@vger.kernel.org, Paul Mackerras <paulus@samba.org>,
        agraf@suse.de, mpm@selenic.com, herbert@gondor.hengli.com.au,
        linuxppc-dev@ozlabs.org, kvm@vger.kernel.org, kvm-ppc@vger.kernel.org,
        tytso@mit.edu
Subject: Re: [PATCH 3/3] KVM: PPC: Book3S: Add support for hwrng found on
 some powernv systems
References: <1380177066-3835-1-git-send-email-michael@ellerman.id.au>  <1380177066-3835-3-git-send-email-michael@ellerman.id.au>  <5243F933.7000907@redhat.com> <20131001083426.GB27484@concordia>  <20131001083908.GA17294@redhat.com> <1380620338.645.22.camel@pasglop>  <524AAFAA.3010801@redhat.com> <1380663871.645.44.camel@pasglop>
In-Reply-To: <1380663871.645.44.camel@pasglop>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Il 01/10/2013 23:44, Benjamin Herrenschmidt ha scritto:
> On Tue, 2013-10-01 at 13:19 +0200, Paolo Bonzini wrote:
>> Il 01/10/2013 11:38, Benjamin Herrenschmidt ha scritto:
>>> So for the sake of that dogma you are going to make us do something that
>>> is about 100 times slower ? (and possibly involves more lines of code)
>>
>> If it's 100 times slower there is something else that's wrong.  It's
>> most likely not 100 times slower, and this makes me wonder if you or
>> Michael actually timed the code at all.
> 
> So no we haven't measured. But it is going to be VERY VERY VERY much
> slower. Our exit latencies are bad with our current MMU *and* any exit
> is going to cause all secondary threads on the core to have to exit as
> well (remember P7 is 4 threads, P8 is 8)

Ok, this is indeed the main difference between Power and x86.

>>   100 cycles            bare metal rdrand
>>   2000 cycles           guest->hypervisor->guest
>>   15000 cycles          guest->userspace->guest
>>
>> (100 cycles = 40 ns = 200 MB/sec; 2000 cycles = ~1 microseconds; 15000
>> cycles = ~7.5 microseconds).  Even on 5 year old hardware, a userspace
>> roundtrip is around a dozen microseconds.
> 
> So in your case going to qemu to "emulate" rdrand would indeed be 150
> times slower, I don't see in what universe that would be considered a
> good idea.

rdrand is not privileged on x86, guests can use it.  But my point is
that going to the kernel is already 20 times slower.  Getting entropy
(not just a pseudo-random number seeded by the HWRNG) with rdrand is
~1000 times slower according to Intel's recommendations, so the
roundtrip to userspace is entirely invisible in that case.

The numbers for PPC seem to be a bit different though (it's faster to
read entropy, and slower to do a userspace exit).

> It's a random number obtained from sampling a set of oscillators. It's
> slightly biased but we have very simple code (I believe shared with the
> host kernel implementation) for whitening it as is required by PAPR.

Good.  Actually, passing the dieharder tests does not mean much (an
AES-encrypted counter should also pass them with flashing colors), but
if it's specified by the architecture gods it's likely to have received
some scrutiny.

>> 2) If the hwrng returns entropy, a read from the hwrng is going to even
>> more expensive than an x86 rdrand (perhaps ~2000 cycles).
> 
> Depends how often you read, the HW I think is sampling asynchronously so
> you only block on the MMIO if you already consumed the previous sample
> but I'll let Paulus provide more details here.

Given Paul's description, there's indeed very little extra cost compared
to a "nop" hypercall.  That's nice.

Still, considering that QEMU code has to be there anyway for
compatibility, kernel emulation is not particularly necessary IMHO.  I
would of course like to see actual performance numbers, but besides that
are you ever going to ever see this in the profile except if you run "dd
if=/dev/hwrng of=/dev/null"?

Can you instrument pHyp to find out how many times per second is this
hypercall called by a "normal" Linux or AIX guest?

>> 3) If the hypercall returns random numbers, then it is a pretty
>> braindead interface since returning 8 bytes at a time limits the
>> throughput to a handful of MB/s (compare to 200 MB/sec for x86 rdrand).
>>  But more important: in this case drivers/char/hw_random/pseries-rng.c
>> is completely broken and insecure, just like patch 2 in case (1) above.
> 
> How so ?

Paul confirmed that it returns real entropy so this is moot.

Paolo
