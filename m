Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752737Ab3EJMYi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 May 2013 08:24:38 -0400
Received: from mail-ie0-f176.google.com ([209.85.223.176]:46601 "EHLO
	mail-ie0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752149Ab3EJMYh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 May 2013 08:24:37 -0400
MIME-Version: 1.0
X-Originating-IP: [178.83.130.250]
In-Reply-To: <1368188011-23661-1-git-send-email-imre.deak@intel.com>
References: <1368188011-23661-1-git-send-email-imre.deak@intel.com>
Date: Fri, 10 May 2013 14:24:36 +0200
Message-ID: <CAKMK7uGVYxmpDANT+e5eOFtwqcM3AZdshQuy+9Xjcv=JiAeY7A@mail.gmail.com>
Subject: Re: [PATCH 01/11] time: add *_to_jiffies_min helpers to guarantee a
 minimum duration
From: Daniel Vetter <daniel.vetter@ffwll.ch>
To: Imre Deak <imre.deak@intel.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        John Stultz <john.stultz@linaro.org>, Ingo Molnar <mingo@kernel.org>,
        Arnd Bergmann <arnd@arndb.de>, "David S. Miller" <davem@davemloft.net>,
        Catalin Marinas <catalin.marinas@arm.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 10, 2013 at 2:13 PM, Imre Deak <imre.deak@intel.com> wrote:
> The *_to_jiffies(x) macros return a jiffy value, which if used as a
> delta to wait for a specific amount of time, may result in a wait-time
> that is less than x. Many callers already compensate for this by adding
> one to the returned value. To document why we need to add one and to get
> rid of some code duplication add a helper that does the same.
>
> Later patches will convert the currently open-coded call sites to use
> the new helpers.
>
> Also this can serve as a basis for auditing those users of *_to_jiffies
> that most likely do the wrong thing - for example set a timeout value of
> msecs_to_jiffies(1) - and converting them to use the new helpers.
>
> Kudos to Daniel Vetter for the idea of the new helpers.
>
> Signed-off-by: Imre Deak <imre.deak@intel.com>
> ---
>  include/linux/jiffies.h |   13 +++++++++++++
>  1 file changed, 13 insertions(+)
>
> diff --git a/include/linux/jiffies.h b/include/linux/jiffies.h
> index 82ed068..d12509b 100644
> --- a/include/linux/jiffies.h
> +++ b/include/linux/jiffies.h
> @@ -312,6 +312,19 @@ extern u64 nsec_to_clock_t(u64 x);
>  extern u64 nsecs_to_jiffies64(u64 n);
>  extern unsigned long nsecs_to_jiffies(u64 n);

Some piece of kerneldoc is missing here ... Also I'm a bit confused
about the _min suffix, I kinda expect something called _min to be less
than the normal one thing. A few ideas:
- to_jiffy_timeout (since pretty much all of the values computed like
this will end up in schedule_timeout eventually),
- to_jiffies_relative (iirc relative is already established in other parts)
- ...

In any case I'd like to have this + the i915 patch go into 3.10 cc:
stable if possible, since it fixes bugs (the i915 patch is missing
bugzilla links, too).

Cheers, Daniel

> +#define __define_time_to_jiffies_min(tname, ttype)                     \
> +static inline unsigned long                                            \
> +tname ## _to_jiffies_min(const ttype m)                                        \
> +{                                                                      \
> +       return max_t(long, MAX_JIFFY_OFFSET, tname ## _to_jiffies(m) + 1);\
> +}
> +
> +__define_time_to_jiffies_min(msecs, unsigned int)
> +__define_time_to_jiffies_min(usecs, unsigned int)
> +__define_time_to_jiffies_min(nsecs, u64)
> +__define_time_to_jiffies_min(timespec, struct timespec *)
> +__define_time_to_jiffies_min(timeval, struct timeval *)
> +
>  #define TIMESTAMP_SIZE 30
>
>  #endif
> --
> 1.7.10.4
>



--
Daniel Vetter
Software Engineer, Intel Corporation
+41 (0) 79 365 57 48 - http://blog.ffwll.ch
