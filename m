Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932983AbaDHSPr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Apr 2014 14:15:47 -0400
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.230]:13646 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S932649AbaDHSPp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Apr 2014 14:15:45 -0400
Date: Tue, 8 Apr 2014 14:15:43 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Tony Luck <tony.luck@gmail.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@redhat.com>, Mauro Chehab <m.chehab@samsung.com>
Subject: Re: [RFC PATCH] time: Fix truncation in jiffies_to_usecs()
Message-ID: <20140408141543.2de9449d@gandalf.local.home>
In-Reply-To: <20140408174946.GA11121@localhost.localdomain>
References: <0214020@agluck-desk.sc.intel.com>
	<CA+8MBb+E_zT47qu4a6pqQWArrhs0gv1W=JKoy252_-Uw6HfbkA@mail.gmail.com>
	<20140408174946.GA11121@localhost.localdomain>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.22; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.130:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 8 Apr 2014 19:49:51 +0200
Frederic Weisbecker <fweisbec@gmail.com> wrote:

> On Mon, Apr 07, 2014 at 10:34:51PM -0700, Tony Luck wrote:
> > On Mon, Apr 7, 2014 at 3:25 PM, Tony Luck <tony.luck@intel.com> wrote:
> > 
> > > c) If not this ... then what? Separate routine to convert large numbers
> > >    of jiffies to usec/nsecs?  Should we make the existing one barf when
> > >    handed a number that overflows?
> > 
> > Having thought about this a bit more - I'm leaning towards leaving
> > jiffies_to_usecs() alone, but using it as a model for a from-scratch
> > implementation of:
> > u64 jiffies_to_nsecs(const unsigned long j)
> > {
> > }
> > 
> > This is what the uptime tracer actually needs - and there is only
> > one user of jiffies_to_nsecs() to worry about.
> 
> I'm not sure I get what you're trying to do. We already have jiffies_to_nsecs().
> Anyway I'll just wait and check out the next patch :)

I believe the issue is the way it's implemented:

static inline u64 jiffies_to_nsecs(const unsigned long j)
{
	return (u64)jiffies_to_usecs(j) * NSEC_PER_USEC;
}

The problem is with jiffies_to_usecs(). Which we probably should
change.

With HZ = 100,
1 second jiffies_to_usecs(100) = 1000,000.
1 minute jiffies_to_usec(6000) = 60,000,000.
1 hour jiffies_to_usecs(360000) = 3,600,000,000
1 hour 11 minutes 35 seconds -
    jiffies_to_usecs(429500) = 4,295,000,000

2^32 = 4294967296  <  4,295,000,000

Overflow!

That means after 1 hour, 11 minutes and 35 seconds, jiffies_to_usecs()
will return a reset number. Time will go backwards. It doesn't matter
what you typecast the return value of jiffies_to_usecs() to, the result
is wrong.

Actually, I like Tony's first patch. I really think jiffies_to_usecs()
should return a u64 number.

-- Steve
