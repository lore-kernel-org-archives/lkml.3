Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751081AbaKAVtd (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Nov 2014 17:49:33 -0400
Received: from mail-la0-f54.google.com ([209.85.215.54]:45109 "EHLO
	mail-la0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750712AbaKAVtc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Nov 2014 17:49:32 -0400
MIME-Version: 1.0
In-Reply-To: <alpine.DEB.2.11.1411012135040.5308@nanos>
References: <cover.1414190806.git.luto@amacapital.net> <266afcba1d1f91ea5501e4e16e94bbbc1a9339b6.1414190806.git.luto@amacapital.net>
 <alpine.DEB.2.11.1411012058030.5308@nanos> <CALCETrXBkc8_rMdr0ueBTBYwSVQ7C3juZo4JCEY9UU=rm_nNww@mail.gmail.com>
 <alpine.DEB.2.11.1411012135040.5308@nanos>
From: Andy Lutomirski <luto@amacapital.net>
Date: Sat, 1 Nov 2014 14:49:10 -0700
Message-ID: <CALCETrVjG4T-+jZ+4AZX-i9s_Do8BY=+fp1JmWCxnbAfGiVvug@mail.gmail.com>
Subject: Re: [PATCH v2 5/8] perf: Add pmu callbacks to track event mapping and unmapping
To: Thomas Gleixner <tglx@linutronix.de>
Cc: X86 ML <x86@kernel.org>, Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@redhat.com>, "hillf.zj" <hillf.zj@alibaba-inc.com>,
        Vince Weaver <vince@deater.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Paul Mackerras <paulus@samba.org>, Kees Cook <keescook@chromium.org>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Valdis Kletnieks <Valdis.Kletnieks@vt.edu>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Nov 1, 2014 1:39 PM, "Thomas Gleixner" <tglx@linutronix.de> wrote:
>
> On Sat, 1 Nov 2014, Andy Lutomirski wrote:
> > On Sat, Nov 1, 2014 at 12:59 PM, Thomas Gleixner <tglx@linutronix.de> wrote:
> > > On Fri, 24 Oct 2014, Andy Lutomirski wrote:
> > >
> > > I'm probably missing something.
> > >
> > > Why is this tied to the mmap? If I just open a counter then I should
> > > be able to read the counter from user space w/o mmapping something in
> > > the first place.
> >
> > You can read it with read(2), which this patch shouldn't affect.  If
> > you want to read it with rdpmc, then you need to know what rdpmc index
> > to use, and the API for that is to mmap the event, check the
> > userpage's cap_user_rdpmc, and then rdpmc on ->idx - 1 (assuming that
> > ->idx != 0).  You can't safely make any assumptions about which rdpmc
> > index it will be without explicitly checking, because perf reserves
> > the right to change the index whenever it wants.
>
> Got it. As I expected: I was missing something :)
>
> > There's plenty of room to tighten up the restrictions further, but
> > this is, I think, a decent first step, and it solves the problem of
> > information leaking into seccomp sandboxes.
>
> In which way?

All the performance counters were readable without using any syscalls.
That leaks hints as to which events are in use, and it possibly leaks
interesting side channel information.   With this series applied, you
need a at least mmap an rdpmc-able event, which most seccomp sandboxes
won't allow.

Unfortunately, rdpmc access to counters can't be controlled
individually, so it's hard to do all that much better than this.

--Andy

>
> Thanks,
>
>         tglx
>
