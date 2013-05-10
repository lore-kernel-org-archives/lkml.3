Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753126Ab3EJNtQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 May 2013 09:49:16 -0400
Received: from mga02.intel.com ([134.134.136.20]:36100 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751271Ab3EJNtP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 May 2013 09:49:15 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,648,1363158000"; 
   d="scan'208";a="331962022"
Message-ID: <1368193751.7024.34.camel@ideak-mobl>
Subject: Re: [PATCH 01/11] time: add *_to_jiffies_min helpers to guarantee a
 minimum duration
From: Imre Deak <imre.deak@intel.com>
To: Daniel Vetter <daniel.vetter@ffwll.ch>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        John Stultz <john.stultz@linaro.org>, Ingo Molnar <mingo@kernel.org>,
        Arnd Bergmann <arnd@arndb.de>, "David S. Miller" <davem@davemloft.net>,
        Catalin Marinas <catalin.marinas@arm.com>
Date: Fri, 10 May 2013 16:49:11 +0300
In-Reply-To: <CAKMK7uGVYxmpDANT+e5eOFtwqcM3AZdshQuy+9Xjcv=JiAeY7A@mail.gmail.com>
References: <1368188011-23661-1-git-send-email-imre.deak@intel.com>
	 <CAKMK7uGVYxmpDANT+e5eOFtwqcM3AZdshQuy+9Xjcv=JiAeY7A@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.2-0ubuntu0.1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2013-05-10 at 14:24 +0200, Daniel Vetter wrote:
> On Fri, May 10, 2013 at 2:13 PM, Imre Deak <imre.deak@intel.com> wrote:
> > The *_to_jiffies(x) macros return a jiffy value, which if used as a
> > delta to wait for a specific amount of time, may result in a wait-time
> > that is less than x. Many callers already compensate for this by adding
> > one to the returned value. To document why we need to add one and to get
> > rid of some code duplication add a helper that does the same.
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
> > ---
> >  include/linux/jiffies.h |   13 +++++++++++++
> >  1 file changed, 13 insertions(+)
> >
> > diff --git a/include/linux/jiffies.h b/include/linux/jiffies.h
> > index 82ed068..d12509b 100644
> > --- a/include/linux/jiffies.h
> > +++ b/include/linux/jiffies.h
> > @@ -312,6 +312,19 @@ extern u64 nsec_to_clock_t(u64 x);
> >  extern u64 nsecs_to_jiffies64(u64 n);
> >  extern unsigned long nsecs_to_jiffies(u64 n);
> 
> Some piece of kerneldoc is missing here ...

True, I'll add it.

>  Also I'm a bit confused
> about the _min suffix, I kinda expect something called _min to be less
> than the normal one thing. A few ideas:
> - to_jiffy_timeout (since pretty much all of the values computed like
> this will end up in schedule_timeout eventually),
> - to_jiffies_relative (iirc relative is already established in other parts)
> - ...

_min as in minimum guaranteed. As for _timeout, the returned value can
be used in other ways too for example to directly compare against
jiffies. I don't have a strong preference, so I can use _timeout
instead.

> In any case I'd like to have this + the i915 patch go into 3.10 cc:
> stable if possible, since it fixes bugs
> (the i915 patch is missing bugzilla links, too).

Ok, I will CC stable. I planned to post the patchset with the actual
fixes as a follow-up, so haven't included any bugzilla links here.

> Cheers, Daniel
> 
> > +#define __define_time_to_jiffies_min(tname, ttype)                     \
> > +static inline unsigned long                                            \
> > +tname ## _to_jiffies_min(const ttype m)                                        \
> > +{                                                                      \
> > +       return max_t(long, MAX_JIFFY_OFFSET, tname ## _to_jiffies(m) + 1);\

Here I meant min_t :/

--Imre

> > +}
> > +
> > +__define_time_to_jiffies_min(msecs, unsigned int)
> > +__define_time_to_jiffies_min(usecs, unsigned int)
> > +__define_time_to_jiffies_min(nsecs, u64)
> > +__define_time_to_jiffies_min(timespec, struct timespec *)
> > +__define_time_to_jiffies_min(timeval, struct timeval *)
> > +
> >  #define TIMESTAMP_SIZE 30
> >
> >  #endif
> > --
> > 1.7.10.4

