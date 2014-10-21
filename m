Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754766AbaJUE2y (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Oct 2014 00:28:54 -0400
Received: from mail-la0-f47.google.com ([209.85.215.47]:61942 "EHLO
	mail-la0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754486AbaJUE2v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Oct 2014 00:28:51 -0400
MIME-Version: 1.0
In-Reply-To: <alpine.DEB.2.10.1410210003300.5251@pianoman.cluster.toy>
References: <cover.1413323611.git.luto@amacapital.net> <alpine.DEB.2.10.1410210003300.5251@pianoman.cluster.toy>
From: Andy Lutomirski <luto@amacapital.net>
Date: Mon, 20 Oct 2014 21:28:29 -0700
Message-ID: <CALCETrV0UCodO7FAi2fXd9ED6K_RHs-0yb+P4Ubmo=EUKZs3gg@mail.gmail.com>
Subject: Re: [RFC 0/5] CR4 handling improvements
To: Vince Weaver <vince@deater.net>
Cc: Peter Zijlstra <peterz@infradead.org>,
        Valdis Kletnieks <Valdis.Kletnieks@vt.edu>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Paul Mackerras <paulus@samba.org>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Ingo Molnar <mingo@redhat.com>, Kees Cook <keescook@chromium.org>,
        Andrea Arcangeli <aarcange@redhat.com>, Erik Bosman <ebn310@few.vu.nl>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 20, 2014 at 9:06 PM, Vince Weaver <vince@deater.net> wrote:
> On Tue, 14 Oct 2014, Andy Lutomirski wrote:
>
>> This little series tightens up rdpmc permissions.  With it applied,
>> rdpmc can only be used if a perf_event is actually mmapped.  For now,
>> this is only really useful for seccomp.
>
> So just to be difficult...
>
> I am aware of at least one group who is doing low-latency performance
> measures using rdpmc on Linux.
>
> They start the counters manually by poking the MSRs directly (bypassing
> perf_event_open()).
>
> They use rdpmc, grateful for the fact that currently CR4 is set up so they
> can do this w/o patching the kernel.
>
> These patches of course would break this use case...

ISTM it would be a lot better to use the perf subsystem for this.  You
can probably pin an event to a pmu.  I don't know whether you can pin
an event systemwide.  I also don't know whether pinning an event will
prevent perf from changing its value periodically, and it certainly
doesn't magically make wraparound issues go away.

It would be easy to add a new setting for rdpmc to deal with the PCE part.

E.g. rdpmc = 2 could allow all tasks to use rdpmc regardless of
whether they have an event mapped.  (And I would have to re-add the
static key.  Sigh.)

--Andy

P.S. Hey, Intel, you forgot to add rdpmcp :-/
