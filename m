Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757070AbaGVVEy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jul 2014 17:04:54 -0400
Received: from mail-la0-f53.google.com ([209.85.215.53]:53112 "EHLO
	mail-la0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756225AbaGVVEw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jul 2014 17:04:52 -0400
MIME-Version: 1.0
In-Reply-To: <53CED031.9090907@zytor.com>
References: <cover.1405620944.git.luto@amacapital.net> <9c2a0549519b4eb5eee2d5d480f8e83a574273df.1405620944.git.luto@amacapital.net>
 <20140722135915.GB25291@thunk.org> <CALCETrVY9KNLsbxhtLRatdb34ZP3XvMyys358dpB3oCKezdBwA@mail.gmail.com>
 <53CED031.9090907@zytor.com>
From: Andy Lutomirski <luto@amacapital.net>
Date: Tue, 22 Jul 2014 14:04:30 -0700
Message-ID: <CALCETrV3FHinFXSWJsQjnsXM2H5OyuAbR3_1A401raLes6fNAg@mail.gmail.com>
Subject: Re: [PATCH v4 2/5] random: Add and use arch_get_rng_seed
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: "Theodore Ts'o" <tytso@mit.edu>, kvm list <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Kees Cook <keescook@chromium.org>, X86 ML <x86@kernel.org>,
        Daniel Borkmann <dborkman@redhat.com>,
        Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>,
        Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>,
        Gleb Natapov <gleb@kernel.org>, Paolo Bonzini <pbonzini@redhat.com>,
        Bandan Das <bsd@redhat.com>, Andrew Honig <ahonig@google.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 22, 2014 at 1:57 PM, H. Peter Anvin <hpa@zytor.com> wrote:
> On 07/22/2014 01:44 PM, Andy Lutomirski wrote:
>>
>> But, if you Intel's hardware does, in fact, work as documented, then
>> the current code will collect very little entropy on RDSEED-less
>> hardware.  I see no great reason that we should do something weaker
>> than following Intel's explicit recommendation for how to seed a PRNG
>> from RDRAND.
>>
>
> Very little entropy in the architectural worst case.  However, since we
> are running single-threaded at this point, actual hardware performs
> orders of magnitude better.  Since we run the mixing function (for no
> particularly good reason -- it is a linear function and doesn't add
> security) there will be enough delay that RDRAND will in practice catch
> up and the output will be quite high quality.  Since the pool is quite
> large, the likely outcome is that there will be enough randomness that
> in practice we would probably be okay if *no* further entropy was ever
> collected.

Just to check: do you mean the RDRAND is very likely to work (i.e.
arch_get_random_long will return true) or that RDRAND will actually
reseed several times during initialization?

I have no RDRAND-capable hardware, so I can't benchmark it, but I
imagine that we're talking about adding 1-2 ms per boot to ensure that
the pool is filled to capacity with *NRBG* data according to the the
architectural specification.

Anyway, the current code is IMO very much encoding some form of
knowledge of how arch_get_random_* work into init_std_data, and I
don't think that's the place for it.

>
>> Another benefit of this split is that it will potentially allow
>> arch_get_rng_seed to be made to work before alternatives are run.
>> There's no fundamental reason that it couldn't work *extremely* early
>> in boot.  (The KASLR code is an example of how this might work.)  On
>> the other hand, making arch_get_random_long work very early in boot
>> would either slow down all the other callers or add a considerable
>> amount of extra complexity.
>>
>> So I think that this patch is a slight improvement in RNG
>> initialization and will actually result in simpler code.  (And yes, if
>> I submit a new version of it, I'll fix the changelog.)
>
> There really isn't any significant reason why we could not permit
> randomness initialization very early in the boot, indeed.  It has
> largely been useless in the past because until the I/O system gets
> initialized there is no randomness of any kind available on traditional
> hardware.

To me, the question is whether this is a sufficient reason to add
arch_get_rng_data.  If it is, then great.  If not, then I'd like to
know what other way of doing this would be acceptable.  You disliked
arch_get_slow_rng_u64 or whatever I called it, and I agree -- I think
it sucked.

--Andy
