Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754984AbaKEOEg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Nov 2014 09:04:36 -0500
Received: from mail-wg0-f45.google.com ([74.125.82.45]:36618 "EHLO
	mail-wg0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752695AbaKEOEa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Nov 2014 09:04:30 -0500
MIME-Version: 1.0
In-Reply-To: <CADLDEKvFvw7Aa98tVtM3z5JV8oocKqAdV4PqOMoZH2mXZ6x2jg@mail.gmail.com>
References: <20141031170326.1491a63f@gandalf.local.home>
	<1414913427.5380.110.camel@marge.simpson.net>
	<CADLDEKvFvw7Aa98tVtM3z5JV8oocKqAdV4PqOMoZH2mXZ6x2jg@mail.gmail.com>
Date: Wed, 5 Nov 2014 15:04:29 +0100
Message-ID: <CADLDEKsGgP1tyGQ+JsTF1tv4NLhnDnGjBvFUU+w8pO8F4nQP=w@mail.gmail.com>
Subject: Re: [ANNOUNCE] 3.14.23-rt20
From: Juerg Haefliger <juergh@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>,
        linux-rt-users <linux-rt-users@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Resending to the list due to mailer/html issues.


On Sun, Nov 2, 2014 at 8:30 AM, Mike Galbraith <umgwanakikbuti@gmail.com> wrote:
>
> On Fri, 2014-10-31 at 17:03 -0400, Steven Rostedt wrote:
> > Dear RT Folks,
> >
> > I'm pleased to announce the 3.14.23-rt20 stable release.
> >
> > This is the first 3.14-rt release in the stable-rt series. Normally I
> > wait till the next development release is out before I pull in a new
> > one. That is, I would pull in 3.14-rt when 3.16-rt or later was
> > released. But because development is now moving at a "hobbyist rate"
> > (read http://lwn.net/Articles/617140/ for details)
> > and 3.14-rt is no longer being developed against, I figured it was
> > time
> > to put it under the "stable-rt" umbrella.
>
> I piddled about with it yesterday, found that you can't change cpufreq
> governor IFF the tree is configured as rt, but works fine as voluntary
> preempt.

The problem seems to be this patch: https://lkml.org/lkml/2014/4/8/584

The cpufreq code does nested down_read_trylocks and only the first one succeeds:

drivers/cpufreq/cpufreq.c:
store
  down_read_trylock(cpufreq_rwsem)  <- succeeds
  store_scaling_governor
    cpufreq_get_policy
      cpufreq_cpu_get
        down_read_trylock(cpufreq_rwsem)  <-- fails

Reverting the above patch 'fixes' the problem. I don't understand
Steven's commit comment that readers of rwsem are not allowed to nest
in mainline since this works just fine in mainline.

...Juerg


>  I'll poke about for the entertainment value.  Having no
> personal need/use for rt detracts from its hobby value somewhat, but rt
> problems do have a tendency to be 'entertaining'.
>
> I'll follow up with a few patches that folks can apply to their trees if
> they so desire.  There being no devel tree to submit against, I can't do
> a proper submission (rules), and some of them you surely don't want :)
>
>         -Mike
