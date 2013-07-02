Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754218Ab3GBRYO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Jul 2013 13:24:14 -0400
Received: from mail-pa0-f50.google.com ([209.85.220.50]:42110 "EHLO
	mail-pa0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753811Ab3GBRYM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Jul 2013 13:24:12 -0400
Date: Tue, 2 Jul 2013 10:24:09 -0700
From: Anton Vorontsov <anton@enomsg.org>
To: Luiz Capitulino <lcapitulino@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Minchan Kim <minchan@kernel.org>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, mhocko@suse.cz, kmpark@infradead.org,
        hyunhee.kim@samsung.com
Subject: Re: [PATCH v2] vmpressure: implement strict mode
Message-ID: <20130702172409.GA13695@teo>
References: <20130628043411.GA9100@teo>
 <20130628050712.GA10097@teo>
 <20130628100027.31504abe@redhat.com>
 <20130628165722.GA12271@teo>
 <20130628170917.GA12610@teo>
 <20130628144507.37d28ed9@redhat.com>
 <20130628185547.GA14520@teo>
 <20130628154402.4035f2fa@redhat.com>
 <20130629005637.GA16068@teo>
 <20130702105911.2830181d@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20130702105911.2830181d@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 02, 2013 at 10:59:11AM -0400, Luiz Capitulino wrote:
>  2. Considering the interface can be extended, how can new applications
>     work on backwards mode? Say, we add ultra-critical on 3.12 and
>     I update my application to work on it, how will my application
>     work on 3.11?

It will refuse to run, as expected. We are returning -EINVAL on unknown
levels. The same way you try to run e.g. systemd on linux-2.4. Systemd
requires new features of the kernel, if there are no features present the
kernel returns an error and then app gracefully fails.

>     Hint: Try and error is an horribly bad approach.
> 
>  3. I also don't believe we have good forward compatibility with
>     the current API, as adding new events will cause existing ones
>     to be triggered more often,

If they don't register for the new events (the old apps don't know about
them, so they won't), there will be absolutely no difference in the
behaviour, and that is what is most important.

There is a scalability problem I can see because of the need of the read()
call on each fd, but the "scalability" problem will actually arise if we
have insane number of levels.

> Honestly, what Andrew suggested is the best design for me: apps
> are notified on all events but the event name is sent to the application.

I am fine with this approach (or any other, I'm really indifferent to the
API itself -- read/netlink/notification per file/whatever for the
payload), except that you still have the similar problem:

  read() old    read() new
  --------------------------
       "low"           "low"
       "low"           "foo" -- the app does not know what does this mean
       "med"           "bar" -- ditto
       "med"           "med"

> This is pretty simple and solves all the problems we've discussed
> so far.
> 
> Why can't we just do it?

Because of the problems described above. Again, add versioning and there
will be no problem (but just the fact that we need for versioning for that
kind of interface might raise questions).

> > > > Here is more complicated case:
> > > > 
> > > > Old kernels, pressure_level reads:
> > > > 
> > > >   low, med, crit
> > > > 
> > > > The app just wants to listen for med level.
> > > > 
> > > > New kernels, pressure_level reads:
> > > > 
> > > >   low, FOO, med, BAR, crit
> > > > 
> > > > How would application decide which of FOO and BAR are ex-med levels?
> > > 
> > > What you meant by ex-med?
> > 
> > The scale is continuous and non-overlapping. If you add some other level,
> > you effectively "shrinking" other levels, so the ex-med in the list above
> > might correspond to "FOO, med" or "med, BAR" or "FOO, med, BAR", and that
> > is exactly the problem.
> 
> Just return the events in order?

The order is not a problem, the meaning is. The old app does not know the
meaning of FOO or BAR levels, for it is is literally "some foo" and "some
bar" -- it can't make any decision.

Anton
