Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757005AbaGVU5w (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jul 2014 16:57:52 -0400
Received: from terminus.zytor.com ([198.137.202.10]:60079 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756778AbaGVU5v (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jul 2014 16:57:51 -0400
Message-ID: <53CED031.9090907@zytor.com>
Date: Tue, 22 Jul 2014 13:57:21 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Andy Lutomirski <luto@amacapital.net>, "Theodore Ts'o" <tytso@mit.edu>,
        kvm list <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Kees Cook <keescook@chromium.org>, X86 ML <x86@kernel.org>,
        Daniel Borkmann <dborkman@redhat.com>,
        Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>,
        Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>,
        Gleb Natapov <gleb@kernel.org>, Paolo Bonzini <pbonzini@redhat.com>,
        Bandan Das <bsd@redhat.com>, Andrew Honig <ahonig@google.com>
Subject: Re: [PATCH v4 2/5] random: Add and use arch_get_rng_seed
References: <cover.1405620944.git.luto@amacapital.net> <9c2a0549519b4eb5eee2d5d480f8e83a574273df.1405620944.git.luto@amacapital.net> <20140722135915.GB25291@thunk.org> <CALCETrVY9KNLsbxhtLRatdb34ZP3XvMyys358dpB3oCKezdBwA@mail.gmail.com>
In-Reply-To: <CALCETrVY9KNLsbxhtLRatdb34ZP3XvMyys358dpB3oCKezdBwA@mail.gmail.com>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/22/2014 01:44 PM, Andy Lutomirski wrote:
> 
> But, if you Intel's hardware does, in fact, work as documented, then
> the current code will collect very little entropy on RDSEED-less
> hardware.  I see no great reason that we should do something weaker
> than following Intel's explicit recommendation for how to seed a PRNG
> from RDRAND.
> 

Very little entropy in the architectural worst case.  However, since we
are running single-threaded at this point, actual hardware performs
orders of magnitude better.  Since we run the mixing function (for no
particularly good reason -- it is a linear function and doesn't add
security) there will be enough delay that RDRAND will in practice catch
up and the output will be quite high quality.  Since the pool is quite
large, the likely outcome is that there will be enough randomness that
in practice we would probably be okay if *no* further entropy was ever
collected.

> Another benefit of this split is that it will potentially allow
> arch_get_rng_seed to be made to work before alternatives are run.
> There's no fundamental reason that it couldn't work *extremely* early
> in boot.  (The KASLR code is an example of how this might work.)  On
> the other hand, making arch_get_random_long work very early in boot
> would either slow down all the other callers or add a considerable
> amount of extra complexity.
> 
> So I think that this patch is a slight improvement in RNG
> initialization and will actually result in simpler code.  (And yes, if
> I submit a new version of it, I'll fix the changelog.)

There really isn't any significant reason why we could not permit
randomness initialization very early in the boot, indeed.  It has
largely been useless in the past because until the I/O system gets
initialized there is no randomness of any kind available on traditional
hardware.

	-hpa


