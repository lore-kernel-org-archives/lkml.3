Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752138AbaHTOxf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Aug 2014 10:53:35 -0400
Received: from mail-qg0-f46.google.com ([209.85.192.46]:42662 "EHLO
	mail-qg0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751812AbaHTOxd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Aug 2014 10:53:33 -0400
MIME-Version: 1.0
In-Reply-To: <532c68b54b1894b9da1d9807701872cab28f8a70.1407994704.git.luto@amacapital.net>
References: <cover.1407994704.git.luto@amacapital.net>
	<532c68b54b1894b9da1d9807701872cab28f8a70.1407994704.git.luto@amacapital.net>
Date: Wed, 20 Aug 2014 09:53:28 -0500
Message-ID: <CALAqxLVZDwX6XWyOgRUtzN4NOLaRaim4azrnbQHC95UkGSHeJw@mail.gmail.com>
Subject: Re: [PATCH v6 2/7] random, timekeeping: Collect timekeeping entropy
 in the timekeeping code
From: John Stultz <john.stultz@linaro.org>
To: Andy Lutomirski <luto@amacapital.net>
Cc: kvm@vger.kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
        "Theodore Ts'o" <tytso@mit.edu>, lkml <linux-kernel@vger.kernel.org>,
        Kees Cook <keescook@chromium.org>, "x86@kernel.org" <x86@kernel.org>,
        Daniel Borkmann <dborkman@redhat.com>,
        Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>,
        Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>,
        Gleb Natapov <gleb@kernel.org>, Paolo Bonzini <pbonzini@redhat.com>,
        Andrew Honig <ahonig@google.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 14, 2014 at 12:43 AM, Andy Lutomirski <luto@amacapital.net> wrote:
> Currently, init_std_data calls ktime_get_real().  This imposes
> awkward constraints on when init_std_data can be called, and
> init_std_data is unlikely to collect the full unpredictable data
> available to the timekeeping code, especially after resume.
>
> Remove this code from random.c and add the appropriate
> add_device_randomness calls to timekeeping.c instead.
>
> Cc: John Stultz <john.stultz@linaro.org>
> Signed-off-by: Andy Lutomirski <luto@amacapital.net>
> ---
>  drivers/char/random.c     |  2 --
>  kernel/time/timekeeping.c | 11 +++++++++++
>  2 files changed, 11 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/char/random.c b/drivers/char/random.c
> index 7673e60..8dc3e3a 100644
> --- a/drivers/char/random.c
> +++ b/drivers/char/random.c
> @@ -1263,12 +1263,10 @@ static void seed_entropy_store(void *ctx, u32 data)
>  static void init_std_data(struct entropy_store *r)
>  {
>         int i;
> -       ktime_t now = ktime_get_real();
>         unsigned long rv;
>         char log_prefix[128];
>
>         r->last_pulled = jiffies;
> -       mix_pool_bytes(r, &now, sizeof(now), NULL);
>         for (i = r->poolinfo->poolbytes; i > 0; i -= sizeof(rv)) {
>                 rv = random_get_entropy();
>                 mix_pool_bytes(r, &rv, sizeof(rv), NULL);
> diff --git a/kernel/time/timekeeping.c b/kernel/time/timekeeping.c
> index 32d8d6a..9609db9 100644
> --- a/kernel/time/timekeeping.c
> +++ b/kernel/time/timekeeping.c
> @@ -23,6 +23,7 @@
>  #include <linux/stop_machine.h>
>  #include <linux/pvclock_gtod.h>
>  #include <linux/compiler.h>
> +#include <linux/random.h>
>
>  #include "tick-internal.h"
>  #include "ntp_internal.h"
> @@ -835,6 +836,9 @@ void __init timekeeping_init(void)
>         memcpy(&shadow_timekeeper, &timekeeper, sizeof(timekeeper));
>
>         write_seqcount_end(&timekeeper_seq);
> +
> +       add_device_randomness(tk, sizeof(tk));
> +


So I can't (and really don't want to) vouch for the correctness side
of this. The initial idea of using the structure instead of reading
the time worried me a bit, but we have already read the clocksource
and stored it in cycle_last so there's a wee bit more then just the
RTC time and a bunch of zeros in the timekeeper structure.

Though on some systems the read_persistent_clock call can't access the
RTC at timekeeping_init, so I'm not sure we're really getting that
much more then the cycle_last clocksource value here. Probably should
add something like this to the RTC hctosys logic.

thanks
-john
