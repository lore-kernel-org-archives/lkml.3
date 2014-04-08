Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758028AbaDHS4V (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Apr 2014 14:56:21 -0400
Received: from mail-wg0-f48.google.com ([74.125.82.48]:47380 "EHLO
	mail-wg0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757790AbaDHS4R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Apr 2014 14:56:17 -0400
Date: Tue, 8 Apr 2014 20:56:13 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Tony Luck <tony.luck@gmail.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@redhat.com>, Mauro Chehab <m.chehab@samsung.com>
Subject: Re: [RFC PATCH] time: Fix truncation in jiffies_to_usecs()
Message-ID: <20140408185609.GA14519@localhost.localdomain>
References: <0214020@agluck-desk.sc.intel.com>
 <CA+8MBb+E_zT47qu4a6pqQWArrhs0gv1W=JKoy252_-Uw6HfbkA@mail.gmail.com>
 <20140408174946.GA11121@localhost.localdomain>
 <20140408141543.2de9449d@gandalf.local.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140408141543.2de9449d@gandalf.local.home>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 08, 2014 at 02:15:43PM -0400, Steven Rostedt wrote:
> On Tue, 8 Apr 2014 19:49:51 +0200
> Frederic Weisbecker <fweisbec@gmail.com> wrote:
> 
> > On Mon, Apr 07, 2014 at 10:34:51PM -0700, Tony Luck wrote:
> > > On Mon, Apr 7, 2014 at 3:25 PM, Tony Luck <tony.luck@intel.com> wrote:
> > > 
> > > > c) If not this ... then what? Separate routine to convert large numbers
> > > >    of jiffies to usec/nsecs?  Should we make the existing one barf when
> > > >    handed a number that overflows?
> > > 
> > > Having thought about this a bit more - I'm leaning towards leaving
> > > jiffies_to_usecs() alone, but using it as a model for a from-scratch
> > > implementation of:
> > > u64 jiffies_to_nsecs(const unsigned long j)
> > > {
> > > }
> > > 
> > > This is what the uptime tracer actually needs - and there is only
> > > one user of jiffies_to_nsecs() to worry about.
> > 
> > I'm not sure I get what you're trying to do. We already have jiffies_to_nsecs().
> > Anyway I'll just wait and check out the next patch :)
> 
> I believe the issue is the way it's implemented:
> 
> static inline u64 jiffies_to_nsecs(const unsigned long j)
> {
> 	return (u64)jiffies_to_usecs(j) * NSEC_PER_USEC;
> }
> 
> The problem is with jiffies_to_usecs(). Which we probably should
> change.
> 
> With HZ = 100,
> 1 second jiffies_to_usecs(100) = 1000,000.
> 1 minute jiffies_to_usec(6000) = 60,000,000.
> 1 hour jiffies_to_usecs(360000) = 3,600,000,000
> 1 hour 11 minutes 35 seconds -
>     jiffies_to_usecs(429500) = 4,295,000,000
> 
> 2^32 = 4294967296  <  4,295,000,000
> 
> Overflow!
> 
> That means after 1 hour, 11 minutes and 35 seconds, jiffies_to_usecs()
> will return a reset number. Time will go backwards. It doesn't matter
> what you typecast the return value of jiffies_to_usecs() to, the result
> is wrong.

Ah! Ok got it now.
 
> Actually, I like Tony's first patch. I really think jiffies_to_usecs()
> should return a u64 number.

Agreed it's way too error-prone. OTOH there are too many users to allow such a blind
broad conversion of its return type:

    $ git grep jiffies_to_usecs | cut -f1 | wc -l
    52

So it may indeed be a better idea to first create a standalone jiffies_to_nsecs().
It can then be used to deprecate and replace most (if not all) calls to jiffies_to_usecs()
altogether. Just the conversion must be made one by one to make sure that users can
handle that.

Of course a big fat comment on jiffies_to_usecs() to describe that it's unsafe
and deprecated would help a bit.
