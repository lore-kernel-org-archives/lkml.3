Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756098Ab3EQNgJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 May 2013 09:36:09 -0400
Received: from moutng.kundenserver.de ([212.227.126.186]:56681 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751490Ab3EQNgH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 May 2013 09:36:07 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Imre Deak <imre.deak@intel.com>
Subject: Re: [PATCH v2 1/8] time: add *_to_jiffies_timeout helpers to guarantee a minimum duration
Date: Fri, 17 May 2013 15:35:51 +0200
User-Agent: KMail/1.12.2 (Linux/3.8.0-18-generic; KDE/4.3.2; x86_64; ; )
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        John Stultz <john.stultz@linaro.org>, Ingo Molnar <mingo@kernel.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Eric Dumazet <edumazet@google.com>,
        Prarit Bhargava <prarit@redhat.com>,
        "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>,
        Dong Zhu <bluezhudong@gmail.com>
References: <1368542918-8861-1-git-send-email-imre.deak@intel.com> <201305151726.44017.arnd@arndb.de> <1368640576.28478.52.camel@ideak-mobl>
In-Reply-To: <1368640576.28478.52.camel@ideak-mobl>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201305171535.51652.arnd@arndb.de>
X-Provags-ID: V02:K0:+u2IYCpPJTH7WY/X/yfnjgU2785vkqZSAUrdo570wvK
 WNJKfrUSrFUpJFpnU4Tc9swEcYxWgowmPabs93FWDqjY7TtgvX
 v0sAqgxO0jG/GVb/itpopQFkGuJa0gTDQ/gAMSHFGPNL7MGsN1
 7hGW9T+5+eX9FuVeGTNBaRzoGu1zSpS6cVJaeaJMy7JzPdS/2P
 YSgYdmyOQRd3oV5oy1/Fb4wY793vx0llyopd5iPpSDQnWAgL2v
 CF1GOiYMM6v286bUv8pc6vB+tievUJKxKIzJi449GFH/W0kP+K
 5JA2YW9u7iRyPqut4kXVSEOb1koLoukVNZU6hfMcfa2dKo97qa
 kOomhBwBy7vJKyp+52FM=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 15 May 2013, Imre Deak wrote:
> On Wed, 2013-05-15 at 17:26 +0200, Arnd Bergmann wrote:
>
> > > Signed-off-by: Imre Deak <imre.deak@intel.com>
> > 
> > This certainly looks like a reasonable change, but I wonder if we could take
> > it one step further and add milisecond based interfaces for some of those
> > functions that currently take a jiffies value, something like
> > 
> > int timer_set_msecs(struct timer_list *timer, unsigned long msecs)
> > {
> > 	unsigned long j = msec_to_jiffies(msecs);
> > 	return mod_timer(timer, min_t(msecs, MAX_JIFFY_OFFSET));
> > }
> 
> Ok, but I think we'd still need the *_to_jiffies_timeout helpers, so
> that we don't have to open code the +1 magic anywhere.

Yes, but we would not change any driver code to use those.
We probably would not need all of the helpers and add only the
ones that are required by other infrastructure.

> > > +#define __define_time_to_jiffies_timeout(tname, ttype)                 \
> > > +unsigned long tname ## _to_jiffies_timeout(const ttype v)              \
> > > +{                                                                      \
> > > +       unsigned long j = tname ## _to_jiffies(v);                      \
> > > +       return min_t(unsigned long, MAX_JIFFY_OFFSET, j + 1);           \
> > > +}                                                                      \
> > > +EXPORT_SYMBOL(tname ## _to_jiffies_timeout);
> > 
> > The macro has a few disadvantages:
> > 
> > * It's impossible to grep for the function or use tags if you generate
> >   the identifier using the macro.
> 
> They are fully spelled in include/linux/jiffies.h . Would it be ok if I
> moved the kernel doc there with a reference to kernel/time.c?

Yes, I guess that's ok. I would prefer to have them open-coded, but
it's not a big issue.

> > * msecs_to_jiffies is what puts MAX_JIFFY_OFFSET there in the first
> >   place, which means you add an extra comparison here that should
> >   not really be needed.
> 
> Yes, but that allows us to keep things simple across all the helpers. I
> haven't checked but I'd assume compiler inlining/optimization should
> make this a non-issue anyway.

msecs_to_jiffies is a global function, so it won't normally get inlined.

	Arnd.
