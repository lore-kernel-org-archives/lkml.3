Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753419AbbAUR3R (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jan 2015 12:29:17 -0500
Received: from mail-qg0-f51.google.com ([209.85.192.51]:56601 "EHLO
	mail-qg0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751757AbbAUR3K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jan 2015 12:29:10 -0500
MIME-Version: 1.0
In-Reply-To: <1421859236-19782-1-git-send-email-daniel.thompson@linaro.org>
References: <1421859236-19782-1-git-send-email-daniel.thompson@linaro.org>
Date: Wed, 21 Jan 2015 09:29:09 -0800
Message-ID: <CALAqxLUmf_TNvTG2-=uavXjXk3040-MQ73V5z7S1UiGa+7c29Q@mail.gmail.com>
Subject: Re: [RFC PATCH] sched_clock: Avoid tearing during read from NMI
From: John Stultz <john.stultz@linaro.org>
To: Daniel Thompson <daniel.thompson@linaro.org>
Cc: lkml <linux-kernel@vger.kernel.org>, Patch Tracking <patches@linaro.org>,
        Linaro Kernel Mailman List <linaro-kernel@lists.linaro.org>,
        Sumit Semwal <sumit.semwal@linaro.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Stephen Boyd <sboyd@codeaurora.org>,
        Steven Rostedt <rostedt@goodmis.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 21, 2015 at 8:53 AM, Daniel Thompson
<daniel.thompson@linaro.org> wrote:
> Currently it is possible for an NMI (or FIQ on ARM) to come in and
> read sched_clock() whilst update_sched_clock() has half updated the
> state. This results in a bad time value being observed.
>
> This patch fixes that problem in a similar manner to Thomas Gleixner's
> 4396e058c52e("timekeeping: Provide fast and NMI safe access to
> CLOCK_MONOTONIC").
>
> Note that ripping out the seqcount lock from sched_clock_register() and
> replacing it with a large comment is not nearly as bad as it looks! The
> locking here is actually pretty useless since most of the variables
> modified within the write lock are not covered by the read lock. As a
> result a big comment and the sequence bump implicit in the call
> to update_epoch() should work pretty much the same.

It still looks pretty bad, even with the current explanation.


> -       raw_write_seqcount_begin(&cd.seq);
> +       /*
> +        * sched_clock will report a bad value if it executes
> +        * concurrently with the following code. No locking exists to
> +        * prevent this; we rely mostly on this function being called
> +        * early during kernel boot up before we have lots of other
> +        * stuff going on.
> +        */
>         read_sched_clock = read;
>         sched_clock_mask = new_mask;
>         cd.rate = rate;
>         cd.wrap_kt = new_wrap_kt;
>         cd.mult = new_mult;
>         cd.shift = new_shift;
> -       cd.epoch_cyc = new_epoch;
> -       cd.epoch_ns = ns;
> -       raw_write_seqcount_end(&cd.seq);
> +       update_epoch(new_epoch, ns);


So looking at this, the sched_clock_register() function may not be
called super early, so I was looking to see what prevented bad reads
prior to registration. And from quick inspection, its nothing. I
suspect the undocumented trick that makes this work is that the mult
value is initialzied to zero, so sched_clock returns 0 until things
have been registered.

So it does seem like it would be worth while to do the initialization
under the lock, or possibly use the suspend flag to make the first
initialization safe.

thanks
-john
