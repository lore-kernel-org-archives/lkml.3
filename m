Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756893Ab3CUDdr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Mar 2013 23:33:47 -0400
Received: from mail.openrapids.net ([64.15.138.104]:52701 "EHLO
	blackscsi.openrapids.net" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753955Ab3CUDdq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Mar 2013 23:33:46 -0400
Date: Wed, 20 Mar 2013 23:33:44 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
To: Keun-O Park <kpark3469@gmail.com>
Cc: Steven Rostedt <rostedt@goodmis.org>, keun-o.park@windriver.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] tracepoints: prevents null probe from being added
Message-ID: <20130321033344.GA4973@Krystal>
References: <1363749497-12176-1-git-send-email-kpark3469@gmail.com> <1363800712.6345.17.camel@gandalf.local.home> <20130320180113.GA24537@Krystal> <1363820491.6345.21.camel@gandalf.local.home> <CA+KhAHaWT5FR5J8iBr_DExrNTBC50LyEo8NG-qZbF6NPEy+zFA@mail.gmail.com> <20130321024502.GB3874@Krystal> <CA+KhAHbbDAqdNGCPmVjN5rCKToVV+gv-mN_0ya1zEG5-RTYieA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+KhAHbbDAqdNGCPmVjN5rCKToVV+gv-mN_0ya1zEG5-RTYieA@mail.gmail.com>
X-Editor: vi
X-Info: http://www.efficios.com
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Keun-O Park (kpark3469@gmail.com) wrote:
> On Thu, Mar 21, 2013 at 11:45 AM, Mathieu Desnoyers
> <mathieu.desnoyers@efficios.com> wrote:
> > * Keun-O Park (kpark3469@gmail.com) wrote:
> >> On Thu, Mar 21, 2013 at 8:01 AM, Steven Rostedt <rostedt@goodmis.org> wrote:
> >> > On Wed, 2013-03-20 at 14:01 -0400, Mathieu Desnoyers wrote:
> >> >> * Steven Rostedt (rostedt@goodmis.org) wrote:
> >> >> > On Wed, 2013-03-20 at 12:18 +0900, kpark3469@gmail.com wrote:
> >> >> > > From: Sahara <keun-o.park@windriver.com>
> >> >> > >
> >> >> > > Somehow tracepoint_entry_add/remove_probe functions allow a null probe
> >> >> > > function.
> >> >> >
> >> >> > You actually hit this in practice, or is this just something that you
> >> >> > observe from code review?
> >> >> >
> >> >> > >  Especially on getting a null probe in remove function, it seems
> >> >> > > to be used to remove all probe functions in the entry.
> >> >> >
> >> >> > Hmm, that actually sounds like a feature.
> >> >>
> >> >> Yep. It's been a long time since I wrote this code, but the removal code
> >> >> seems to use NULL probe pointer to remove all probes for a given
> >> >> tracepoint.
> >> >>
> >> >> I'd be tempted to just validate non-NULL probe within
> >> >> tracepoint_entry_add_probe() and let other sites as is, just in case
> >> >> anyone would be using this feature.
> >> >>
> >> >> I cannot say that I have personally used this "remove all" feature much
> >> >> though.
> >> >>
> >> >
> >> > I agree. I don't see anything wrong in leaving the null probe feature in
> >> > the removal code. But updating the add code looks like a proper change.
> >> >
> >> > -- Steve
> >> >
> >> >
> >>
> >> Hello Steve & Mathieu,
> >> If we want to leave the null probe feature enabled, I think it would
> >> be better modifying the code like the following for code efficiency.
> >>
> >> @@ -112,7 +112,8 @@ tracepoint_entry_add_probe(struct tracepoint_entry *entry,
> >>         int nr_probes = 0;
> >>         struct tracepoint_func *old, *new;
> >>
> >> -       WARN_ON(!probe);
> >> +       if (WARN_ON(!probe))
> >> +               return ERR_PTR(-EINVAL);
> >>
> >>         debug_print_probes(entry);
> >>         old = entry->funcs;
> >> @@ -152,14 +153,15 @@ tracepoint_entry_remove_probe(struct tracepoint_entry *ent
> >>
> >>         debug_print_probes(entry);
> >>         /* (N -> M), (N > 1, M >= 0) probes */
> >> -       for (nr_probes = 0; old[nr_probes].func; nr_probes++) {
> >> -               if (!probe ||
> >> -                   (old[nr_probes].func == probe &&
> >> -                    old[nr_probes].data == data))
> >> -                       nr_del++;
> >> +       if (probe) {
> >> +               for (nr_probes = 0; old[nr_probes].func; nr_probes++) {
> >> +                       if (old[nr_probes].func == probe &&
> >> +                            old[nr_probes].data == data)
> >> +                               nr_del++;
> >> +               }
> >>         }
> >>
> >> -       if (nr_probes - nr_del == 0) {
> >> +       if (!probe || nr_probes - nr_del == 0) {
> >
> > We might want to do:
> >
> > if (probe) {
> >   ...
> > } else {
> >   nr_del = nr_probes;
> > }
> >
> > if (nr_probes - nr_del == 0) {
> >    ...
> > }
> 
> This code has a problem.
> nr_probes is initialized as zero.

yes,

> And, in order to get correct count of probes,
> we need to go through the for-loop even though probe is null.
> So with above code, nr_del will be zero. Anyhow, the code will fall
> through if-clause(nr_probes-nr_del==0).
> It looks odd to me.

Ah, I see what you mean: the nr_del = nr_probes assignment is useless,
because both nr_probes and nr_del are equal to 0. So we could go for:

        if (probe) {
                for (nr_probes = 0; old[nr_probes].func; nr_probes++) {
                        if (old[nr_probes].func == probe &&
                             old[nr_probes].data == data)
                                nr_del++;
                }
        }

        if (nr_probes - nr_del == 0) {
                ...
        } else {
                ...
        }

Does it look better ?

Thanks,

Mathieu

> 
> -- Kpark
> 
> >
> > rather than:
> >
> > if (probe) {
> >   ...
> > }
> >
> > if (!probe || nr_probes - nr_del == 0) {
> >    ...
> > }
> >
> > Using nr_del makes the code easier to follow IMHO.
> >
> > Thanks,
> >
> > Mathieu
> >

-- 
Mathieu Desnoyers
EfficiOS Inc.
http://www.efficios.com
