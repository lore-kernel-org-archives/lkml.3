Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753273Ab3F2A4m (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Jun 2013 20:56:42 -0400
Received: from mail-pa0-f54.google.com ([209.85.220.54]:33456 "EHLO
	mail-pa0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752779Ab3F2A4k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Jun 2013 20:56:40 -0400
Date: Fri, 28 Jun 2013 17:56:37 -0700
From: Anton Vorontsov <anton@enomsg.org>
To: Luiz Capitulino <lcapitulino@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Minchan Kim <minchan@kernel.org>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, mhocko@suse.cz, kmpark@infradead.org,
        hyunhee.kim@samsung.com
Subject: Re: [PATCH v2] vmpressure: implement strict mode
Message-ID: <20130629005637.GA16068@teo>
References: <20130628005852.GA8093@teo>
 <20130627181353.3d552e64.akpm@linux-foundation.org>
 <20130628043411.GA9100@teo>
 <20130628050712.GA10097@teo>
 <20130628100027.31504abe@redhat.com>
 <20130628165722.GA12271@teo>
 <20130628170917.GA12610@teo>
 <20130628144507.37d28ed9@redhat.com>
 <20130628185547.GA14520@teo>
 <20130628154402.4035f2fa@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20130628154402.4035f2fa@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 28, 2013 at 03:44:02PM -0400, Luiz Capitulino wrote:
> > Why can't you use poll() and demultiplex the events? Check if there is an
> > event in the crit fd, and if there is, then just ignore all the rest.
> 
> This may be a valid workaround for current kernels, but application
> behavior will be different among kernels with a different number of
> events.

This is not a workaround, this is how poll works, and this is kinda
expected... But not that I had this plan in mind when I was designing the
current scheme... :)

> Say, we events on top of critical. Then crit fd will now be
> notified for cases where it didn't use to on older kernels.

I'm not sure I am following here... but thinking about it more, I guess
the extra read() will be needed anyway (to reset the counter).

> > > However, it *is* possible to make non-strict work on strict if we make
> > > strict default _and_ make reads on memory.pressure_level return
> > > available events. Just do this on app initialization:
> > > 
> > > for each event in memory.pressure_level; do
> > > 	/* register eventfd to be notified on "event" */
> > > done
> > 
> > This scheme registers "all" events.
> 
> Yes, because I thought that's the user-case that matters for activity
> manager :)

Some activity managers use only low levels (Android), some might use only
medium levels (simple load-balancing).

Being able to register only "all" does not make sense to me.

> > Here is more complicated case:
> > 
> > Old kernels, pressure_level reads:
> > 
> >   low, med, crit
> > 
> > The app just wants to listen for med level.
> > 
> > New kernels, pressure_level reads:
> > 
> >   low, FOO, med, BAR, crit
> > 
> > How would application decide which of FOO and BAR are ex-med levels?
> 
> What you meant by ex-med?

The scale is continuous and non-overlapping. If you add some other level,
you effectively "shrinking" other levels, so the ex-med in the list above
might correspond to "FOO, med" or "med, BAR" or "FOO, med, BAR", and that
is exactly the problem.

> Let's not over-design. I agree that allowing the API to be extended
> is a good thing, but we shouldn't give complex meaning to events,
> otherwise we're better with a numeric scale instead.

I am not over-desiging at all. Again, you did not provide any solution for
the case if we are going to add a new level. Thing is, I don't know if we
are going to add more levels, but the three-levels scheme is not something
scientifically proven, it is just an arbitrary thing we made up. We may
end up with four, or five... or not.

Thanks,

Anton
