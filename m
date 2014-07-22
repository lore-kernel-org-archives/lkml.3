Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756879AbaGVUpA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jul 2014 16:45:00 -0400
Received: from mail-la0-f47.google.com ([209.85.215.47]:40894 "EHLO
	mail-la0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751353AbaGVUo6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jul 2014 16:44:58 -0400
MIME-Version: 1.0
In-Reply-To: <20140722135915.GB25291@thunk.org>
References: <cover.1405620944.git.luto@amacapital.net> <9c2a0549519b4eb5eee2d5d480f8e83a574273df.1405620944.git.luto@amacapital.net>
 <20140722135915.GB25291@thunk.org>
From: Andy Lutomirski <luto@amacapital.net>
Date: Tue, 22 Jul 2014 13:44:36 -0700
Message-ID: <CALCETrVY9KNLsbxhtLRatdb34ZP3XvMyys358dpB3oCKezdBwA@mail.gmail.com>
Subject: Re: [PATCH v4 2/5] random: Add and use arch_get_rng_seed
To: "Theodore Ts'o" <tytso@mit.edu>, Andy Lutomirski <luto@amacapital.net>,
        kvm list <kvm@vger.kernel.org>, "H. Peter Anvin" <hpa@zytor.com>,
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

On Tue, Jul 22, 2014 at 6:59 AM, Theodore Ts'o <tytso@mit.edu> wrote:
> On Thu, Jul 17, 2014 at 11:22:17AM -0700, Andy Lutomirski wrote:
>> Currently, init_std_data contains its own logic for using arch
>> random sources.  This logic is a bit strange: it reads one long of
>> arch random data per byte of internal state.
>
> This isn't true.  Check out the init_std_data() a bit more closely.
>
>         unsigned long rv;
>
>         ...
>
>         for (i = r->poolinfo->poolbytes; i > 0; i -= sizeof(rv)) {
>             ...
>
> In particular, note the "i -= sizeof(rv)".  We are reading one bit per
> bit of internal state beeing seeded.

Whoops, my bad.

>
>> Assuming the arch sources are perfect, this is the right thing to
>> do.  They're not, though, so the followup patch attempts to
>> implement the correct logic on x86.
>
> ... and that's not a problem because we aren't giving any entropy
> credit --- and this is deliberate, because we don't want to trust
> un-auditable hardware.  We are deliberately trying to be conservative
> here.

True.

But, if you Intel's hardware does, in fact, work as documented, then
the current code will collect very little entropy on RDSEED-less
hardware.  I see no great reason that we should do something weaker
than following Intel's explicit recommendation for how to seed a PRNG
from RDRAND.

>
> So I don't think either this patch or the next one is needed.  It adds
> far more complexity than is warranted.

The real reason I did this is because I didn't want to pollute the
kernel with yet more arch_get_random_xyz functions.  In the previous
iteration of this patchset, init_std_data had to deal with no less
than three arch random sources.  If Xen adds something (which, IMO,
they should), then either it'll be up to four, or one of them will
have to multiplex.

Another benefit of this split is that it will potentially allow
arch_get_rng_seed to be made to work before alternatives are run.
There's no fundamental reason that it couldn't work *extremely* early
in boot.  (The KASLR code is an example of how this might work.)  On
the other hand, making arch_get_random_long work very early in boot
would either slow down all the other callers or add a considerable
amount of extra complexity.

So I think that this patch is a slight improvement in RNG
initialization and will actually result in simpler code.  (And yes, if
I submit a new version of it, I'll fix the changelog.)

--Andy
