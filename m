Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751605AbaJYSYn (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 Oct 2014 14:24:43 -0400
Received: from mout.kundenserver.de ([212.227.17.13]:55370 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750738AbaJYSYl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 Oct 2014 14:24:41 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Heena Sirwani <heenasirwani@gmail.com>, linux-kernel@vger.kernel.org,
        john.stultz@linaro.org
Subject: Re: [PATCH v5] timekeeping: Added a function to return tv_sec portion of ktime_get_ts64()
Date: Sat, 25 Oct 2014 17:39:38 +0200
Message-ID: <12462229.Mz3a4d4AP9@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.16.0-10-generic; KDE/4.11.5; x86_64; ; )
In-Reply-To: <alpine.DEB.2.11.1410251714460.5308@nanos>
References: <20141025123406.GA13128@heena.com> <alpine.DEB.2.11.1410251705550.5308@nanos> <alpine.DEB.2.11.1410251714460.5308@nanos>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:UMFcbV7A+nrbRu/AkuOHCRC2hq70yab+LBwN9sex6of
 Juo+dm2Zz0bPl1CyUgGbdnBTL7t6poEPAn3EY6Tjopv+tMm46F
 hBH5mE+28clzF54QkXkzRUakUESu+fAg1pL1Np8w9IQilzO027
 2gjmvYCZNMuRjJFlc4V6o5o3BxSWTEobDLnimi1Wn02trM0eWP
 joYwl9CXusxCS4E3Sb4lcmgk1QY/1YGj1iLEBi8xm6qTCGD6pE
 PJ89VxKNVMNdZvNP5rhqJ8n0sbiMcPhJ+lJV2vQm5xifDEHhqE
 c2SDO1bTL7YjkKLaxJBWLDT39mrXHxAP8m10jC42AOyzj98gYt
 G3sgCG/DjNQV4MHkcR6c=
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 25 October 2014 17:22:23 Thomas Gleixner wrote:
> On Sat, 25 Oct 2014, Thomas Gleixner wrote:
> > On Sat, 25 Oct 2014, Heena Sirwani wrote:
> > > +time64_t ktime_get_seconds(void)
> > > +{
> > > +   time64_t ts;
> > > +   struct timekeeper *tk = &tk_core.timekeeper;
> > > +   struct timespec64 tomono;
> > > +   s32 nsec;
> > > +   unsigned int seq;
> > > +
> > > +   WARN_ON(timekeeping_suspended);
> > > +
> > > +   do {
> > > +           seq = read_seqcount_begin(&tk_core.seq);
> > > +           ts = tk->xtime_sec;
> > > +           nsec = (long)(tk->tkr.xtime_nsec >> tk->tkr.shift);
> > > +           tomono = tk->wall_to_monotonic;
> > > +
> > > +   } while (read_seqcount_retry(&tk_core.seq, seq));
> > > +
> > > +   ts += tomono.tv_sec;
> > > +   if (nsec + tomono.tv_nsec >= NSEC_PER_SEC)
> > > +           ts += 1;
> > > +   return ts;
> > 
> > I'd rather have an extra field in the timekeeper
> > 
> >     u64 xtime_sec;
> > +   u64 ktime_sec;
> > 
> > and update this in tk_update_ktime_data() so the readout function
> > boils down to
> > 
> > time64_t ktime_get_seconds(void)
> > {
> > #if BITS_PER_LONG < 64
> >       u64 sec;
> >       int seq;
> > 
> >       do {
> >               seq = read_seqcount_begin(&tk_core.seq);
> >               sec = tk->ktime_sec;
> >       } while (read_seqcount_retry(&tk_core.seq, seq));
> > 
> >       return sec;
> > #else
> >       return tk->ktime_sec;
> > #endif
> > }
> > 
> > So 64bit can do w/o the seqcount and 32bit avoids all extra math, right?
> 
> Hmm. Thinking more about it. That's actually overkill. For ktime_sec a
> 32bit value is plenty enough unless we care about systems with more
> than 136 years uptime. So if we calculate the seconds value of ktime,
> i.e. CLOCK_MONOTONIC, in the update function, we can read it on both
> 32 and 64bit w/o the seqcount loop.

Ah, very good point. That opens the question which type that function
should return. I really want to remove all uses of time_t from the
kernel, mostly so we know when we're done with this. However as you
say we know that we only need a 32-bit value here. Some possible
ideas:

- use time64_t here anyway and accept the slight inefficiency in return
  for clarity
- introduce a monotonic_time_t (we probably also want a struct
  monotonic_timespec if we do that) which is basically the old time_t
  but is known to be y2038 safe because we only ever use it to store
  monotonic times.
- return u32 and use the same type in the callers instead of
  time_t/time64_t/monotonic_time_t.

> Where we really need the above readout mechanism is get_seconds() as
> that will break in 2038 on 32bit. So there you need to change the
> return value from unsigned long to time64_t and change the
> implementation as above just xtime_sec instead of ktime_sec.

Heena already posted a first draft of that patch to the opw internal
mailing list, I found a small issue that needs to be resolved and
then she can post the new version to you for review.

	Arnd
