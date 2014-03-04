Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755361AbaCDTBz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Mar 2014 14:01:55 -0500
Received: from mail-ob0-f170.google.com ([209.85.214.170]:51639 "EHLO
	mail-ob0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752144AbaCDTBx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Mar 2014 14:01:53 -0500
MIME-Version: 1.0
In-Reply-To: <20140304153841.GN1872@titan.lakedaemon.net>
References: <20140303235148.GA7601@www.outflux.net>
	<20140304153841.GN1872@titan.lakedaemon.net>
Date: Tue, 4 Mar 2014 11:01:49 -0800
X-Google-Sender-Auth: 22TQM0DfWBKbXGZKcdgnaFLzldU
Message-ID: <CAGXu5jKqB62ZaD0HEG=vJoROOqvdSYeHYB2h61Kw1-ov5phFww@mail.gmail.com>
Subject: Re: [PATCH][RESEND 3] hwrng: add randomness to system from rng sources
From: Kees Cook <keescook@chromium.org>
To: Jason Cooper <jason@lakedaemon.net>
Cc: "Theodore Ts'o" <tytso@mit.edu>, LKML <linux-kernel@vger.kernel.org>,
        Matt Mackall <mpm@selenic.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Rusty Russell <rusty@rustcorp.com.au>,
        Satoru Takeuchi <satoru.takeuchi@gmail.com>,
        linux-crypto <linux-crypto@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 4, 2014 at 7:38 AM, Jason Cooper <jason@lakedaemon.net> wrote:
> Kees, Ted,
>
> On Mon, Mar 03, 2014 at 03:51:48PM -0800, Kees Cook wrote:
>> When bringing a new RNG source online, it seems like it would make sense
>> to use some of its bytes to make the system entropy pool more random,
>> as done with all sorts of other devices that contain per-device or
>> per-boot differences.
>
> Why is this necessary?  init_std_data() already calls
> arch_get_random_long() while stirring each of the pools.

I may be misunderstanding something here, but hwrng isn't going to get
hit by a arch_get_random_long(). That's just for arch-specific RNGs
(e.g. RDRAND), where as hwrng is for, effectively, add-on devices
(e.g. TPMs).

> I'm a little concerned here because this gives potentially untrusted
> hwrngs more influence over the entropy pools initial state than most
> users of random.c expect.  Many of the drivers in hw_random/ are
> platform drivers and are initialized before random.c.
>
> I'm comfortable with the design decisions Ted has made wrt random.c and
> hwrngs.  However, I think that this changes that trust relationship in a
> fundamental way.  I'm ok with building support into my kernels for
> hwrngs as long as random.c's internal use of them is limited to the
> mixing in extract_buf() and init_std_data().
>
> By adding this patch, even without crediting entropy to the pool, a
> rogue hwrng now has significantly more influence over the initial state
> of the entropy pools.  Or, am I missing something?

I wasn't viewing this as dealing with rouge hwrngs (though shouldn't
that state still be covered due to the existing mixing), but more as a
"hey this thing has some randomness associated with it", similar to
the mixing done for things like NIC MAC, etc. (Better, actually, since
NIC MAC is going to be the same every boot.) It seemed silly to ignore
an actual entropy source when seeding.

-Kees

>
> thx,
>
> Jason.
>
>> Signed-off-by: Kees Cook <keescook@chromium.org>
>> ---
>>  drivers/char/hw_random/core.c |    7 +++++++
>>  1 file changed, 7 insertions(+)
>>
>> diff --git a/drivers/char/hw_random/core.c b/drivers/char/hw_random/core.c
>> index a0f7724852eb..6e5bb68a708c 100644
>> --- a/drivers/char/hw_random/core.c
>> +++ b/drivers/char/hw_random/core.c
>> @@ -41,6 +41,7 @@
>>  #include <linux/miscdevice.h>
>>  #include <linux/delay.h>
>>  #include <linux/slab.h>
>> +#include <linux/random.h>
>>  #include <asm/uaccess.h>
>>
>>
>> @@ -305,6 +306,8 @@ int hwrng_register(struct hwrng *rng)
>>       int must_register_misc;
>>       int err = -EINVAL;
>>       struct hwrng *old_rng, *tmp;
>> +     unsigned char bytes[16];
>> +     int bytes_read;
>>
>>       if (rng->name == NULL ||
>>           (rng->data_read == NULL && rng->read == NULL))
>> @@ -348,6 +351,10 @@ int hwrng_register(struct hwrng *rng)
>>       }
>>       INIT_LIST_HEAD(&rng->list);
>>       list_add_tail(&rng->list, &rng_list);
>> +
>> +     bytes_read = rng_get_data(rng, bytes, sizeof(bytes), 1);
>> +     if (bytes_read > 0)
>> +             add_device_randomness(bytes, bytes_read);
>>  out_unlock:
>>       mutex_unlock(&rng_mutex);
>>  out:
>> --
>> 1.7.9.5
>>
>>
>> --
>> Kees Cook
>> Chrome OS Security
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-crypto" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html



-- 
Kees Cook
Chrome OS Security
