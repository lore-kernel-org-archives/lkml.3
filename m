Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759940Ab3EOR4c (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 May 2013 13:56:32 -0400
Received: from mga02.intel.com ([134.134.136.20]:1088 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759921Ab3EOR43 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 May 2013 13:56:29 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,678,1363158000"; 
   d="scan'208";a="337818690"
Message-ID: <1368640576.28478.52.camel@ideak-mobl>
Subject: Re: [PATCH v2 1/8] time: add *_to_jiffies_timeout helpers to
 guarantee a minimum duration
From: Imre Deak <imre.deak@intel.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        John Stultz <john.stultz@linaro.org>, Ingo Molnar <mingo@kernel.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Eric Dumazet <edumazet@google.com>,
        Prarit Bhargava <prarit@redhat.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Dong Zhu <bluezhudong@gmail.com>
Date: Wed, 15 May 2013 20:56:16 +0300
In-Reply-To: <201305151726.44017.arnd@arndb.de>
References: <1368542918-8861-1-git-send-email-imre.deak@intel.com>
	 <1368542918-8861-2-git-send-email-imre.deak@intel.com>
	 <201305151726.44017.arnd@arndb.de>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.2-0ubuntu0.1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2013-05-15 at 17:26 +0200, Arnd Bergmann wrote:
> On Tuesday 14 May 2013, Imre Deak wrote:
> > The *_to_jiffies(x) macros return a jiffy value, which if used as a
> > delta to wait for a specific amount of time, may result in a wait time
> > that is less than x. Many callers already compensate for this by adding
> > one to the returned value. Instead of having this adjustment open-coded
> > at every call site add helpers that return the adjusted value. This will
> > make the intention for the adjustment more explicit and also provide
> > documentation for why it is needed.
> > 
> > Later patches will convert the currently open-coded call sites to use
> > the new helpers.
> > 
> > Also this can serve as a basis for auditing those users of *_to_jiffies
> > that most likely do the wrong thing - for example set a timeout value of
> > msecs_to_jiffies(1) - and converting them to use the new helpers.
> > 
> > Kudos to Daniel Vetter for the idea of the new helpers.
> > 
> > Signed-off-by: Imre Deak <imre.deak@intel.com>
> 
> This certainly looks like a reasonable change, but I wonder if we could take
> it one step further and add milisecond based interfaces for some of those
> functions that currently take a jiffies value, something like
> 
> int timer_set_msecs(struct timer_list *timer, unsigned long msecs)
> {
> 	unsigned long j = msec_to_jiffies(msecs);
> 	return mod_timer(timer, min_t(msecs, MAX_JIFFY_OFFSET));
> }

Ok, but I think we'd still need the *_to_jiffies_timeout helpers, so
that we don't have to open code the +1 magic anywhere.

> > +#define __define_time_to_jiffies_timeout(tname, ttype)                 \
> > +unsigned long tname ## _to_jiffies_timeout(const ttype v)              \
> > +{                                                                      \
> > +       unsigned long j = tname ## _to_jiffies(v);                      \
> > +       return min_t(unsigned long, MAX_JIFFY_OFFSET, j + 1);           \
> > +}                                                                      \
> > +EXPORT_SYMBOL(tname ## _to_jiffies_timeout);
> 
> The macro has a few disadvantages:
> 
> * It's impossible to grep for the function or use tags if you generate
>   the identifier using the macro.

They are fully spelled in include/linux/jiffies.h . Would it be ok if I
moved the kernel doc there with a reference to kernel/time.c?

> * msecs_to_jiffies is what puts MAX_JIFFY_OFFSET there in the first
>   place, which means you add an extra comparison here that should
>   not really be needed.

Yes, but that allows us to keep things simple across all the helpers. I
haven't checked but I'd assume compiler inlining/optimization should
make this a non-issue anyway.

--Imre

