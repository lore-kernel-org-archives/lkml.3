Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753551Ab3JBIqd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Oct 2013 04:46:33 -0400
Received: from mail-ee0-f54.google.com ([74.125.83.54]:63991 "EHLO
	mail-ee0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753034Ab3JBIq2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Oct 2013 04:46:28 -0400
Message-ID: <524BDD73.3020106@redhat.com>
Date: Wed, 02 Oct 2013 10:46:43 +0200
From: Paolo Bonzini <pbonzini@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130923 Thunderbird/17.0.9
MIME-Version: 1.0
To: Paul Mackerras <paulus@samba.org>
CC: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Gleb Natapov <gleb@redhat.com>,
        Michael Ellerman <michael@ellerman.id.au>,
        linux-kernel@vger.kernel.org, agraf@suse.de, mpm@selenic.com,
        herbert@gondor.hengli.com.au, linuxppc-dev@ozlabs.org,
        kvm@vger.kernel.org, kvm-ppc@vger.kernel.org, tytso@mit.edu
Subject: Re: [PATCH 3/3] KVM: PPC: Book3S: Add support for hwrng found on
 some powernv systems
References: <1380177066-3835-1-git-send-email-michael@ellerman.id.au> <1380177066-3835-3-git-send-email-michael@ellerman.id.au> <5243F933.7000907@redhat.com> <20131001083426.GB27484@concordia> <20131001083908.GA17294@redhat.com> <1380620338.645.22.camel@pasglop> <524AAFAA.3010801@redhat.com> <20131002050940.GA25363@drongo>
In-Reply-To: <20131002050940.GA25363@drongo>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Il 02/10/2013 07:09, Paul Mackerras ha scritto:
> On Tue, Oct 01, 2013 at 01:19:06PM +0200, Paolo Bonzini wrote:
> 
>> Anyhow, I would like to know more about this hwrng and hypercall.
>>
>> Does the hwrng return random numbers (like rdrand) or real entropy (like
>> rdseed that Intel will add in Broadwell)?  What about the hypercall?
> 
> Well, firstly, your terminology is inaccurate.  Real entropy will give
> you random numbers.  I think when you say "random numbers" you
> actually mean "pseudo-random numbers".

Yes---I meant pseudo-random numbers where the generator is periodically
seeded by a random number.

> Secondly, the RNG produces real entropy.

Good to know, thanks.

> Not sure why they are particularly "precious"; we get 64 bits per
> microsecond whether we use them or not.  What are you suggesting
> arch_get_random_long() should do instead?

If you are running rngd, there is no need to have arch_get_random_long()
at all.

>> 3) If the hypercall returns random numbers, then it is a pretty
>> braindead interface since returning 8 bytes at a time limits the
>> throughput to a handful of MB/s (compare to 200 MB/sec for x86 rdrand).
>>  But more important: in this case drivers/char/hw_random/pseries-rng.c
>> is completely broken and insecure, just like patch 2 in case (1) above.
> 
> Assuming that by "random numbers" you actually mean "pseudo-random
> numbers", then this doesn't apply.

Indeed.

>> 4) If the hypercall returns entropy (same as virtio-rng), the same
>> considerations on speed apply.  If you can only produce entropy at say 1
>> MB/s (so reading 8 bytes take 8 microseconds---which is actually very
>> fast), it doesn't matter that much to spend 7 microseconds on a
>> userspace roundtrip.  It's going to be only half the speed of bare
>> metal, not 100 times slower.
> 
> 8 bytes takes at most 1 microsecond, so the round-trip to userspace is
> definitely noticeable.

Thanks.  Any chance you can give some numbers of a kernel hypercall and
a userspace hypercall on Power, so we have actual data?  For example a
hypercall that returns H_PARAMETER as soon as possible.

Paolo
