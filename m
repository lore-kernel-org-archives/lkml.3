Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753486AbaBJVEV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Feb 2014 16:04:21 -0500
Received: from mx1.redhat.com ([209.132.183.28]:1920 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752575AbaBJVES (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Feb 2014 16:04:18 -0500
Date: Mon, 10 Feb 2014 19:03:58 -0200
From: Arnaldo Carvalho de Melo <acme@redhat.com>
To: David Ahern <dsahern@gmail.com>
Cc: Stephane Eranian <eranian@google.com>, LKML <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <peterz@infradead.org>, "mingo@elte.hu" <mingo@elte.hu>,
        Jiri Olsa <jolsa@redhat.com>, Eric Dumazet <edumazet@google.com>,
        Peter Hurley <peter@hurleysoftware.com>
Subject: Re: [BUG] perf top: --stdio causes continuous refresh
Message-ID: <20140210210358.GD3202@infradead.org>
References: <CABPqkBSkSbWvdRu3iEtNvHhfV4J4sALHvdd40hZTcGxLe576yQ@mail.gmail.com>
 <20140206135627.GA26955@infradead.org>
 <CABPqkBS5qLDYyyv=n8fT4K+hA3uRWYmQOZmO+n-UE9=X=cEFzQ@mail.gmail.com>
 <20140206140705.GB26955@infradead.org>
 <20140206140936.GC26955@infradead.org>
 <CABPqkBRwy=0pnmm657TwV25GiYbpkqC1E8+cUGLEUbqxO=Gusw@mail.gmail.com>
 <52F3CAE3.7060007@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <52F3CAE3.7060007@gmail.com>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.20 (2009-12-10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Thu, Feb 06, 2014 at 10:48:19AM -0700, David Ahern escreveu:
> On 2/6/14, 8:24 AM, Stephane Eranian wrote:
> >On Thu, Feb 6, 2014 at 3:09 PM, Arnaldo Carvalho de Melo
> ><acme@redhat.com> wrote:
> >>Em Thu, Feb 06, 2014 at 12:07:05PM -0200, Arnaldo Carvalho de Melo escreveu:
> >>>Em Thu, Feb 06, 2014 at 02:58:01PM +0100, Stephane Eranian escreveu:
> >>>>On Thu, Feb 6, 2014 at 2:56 PM, Arnaldo Carvalho de Melo
> >>>><acme@redhat.com> wrote:
> >>>>>Em Wed, Feb 05, 2014 at 10:25:09PM +0100, Stephane Eranian escreveu:
> >>>>>>If you run perf top on 3.14 but you force --stdio mode, perf top
> >>>>>>goes crazy and constantly refreshes the output.

> >>>>>>It does that with many older versions of the perf as well on 3.14.
> >>>>>>It runs fine with newt mode.

> >>>>>>Works fine with my 3.11 kernel. So something must be broken
> >>>>>>with 3.14.

> >>>>>>Can you reproduce the problem as well?

> >>>>>Not so far, using my perf/urgent branch:

> >>>>I am using tip.git. Or try 3.11, 3.10.

> >>But my tests are on top of:

> >>[acme@ssdandy linux]$ uname -r
> >>3.11.4-101.fc18.x86_64

> >>I thought it was a 3.14ish one, building one to try there...
> >>
> >The kernel must be 3.14-rcX, the tool can be any version.
> 
> I don't have time to do a git bisect, but I can narrow the window to
> 3.13-rc6 and 3.14-rc1. Just happened to update a server yesterday.
> perf-top --stdio runs fine on the former and shows the problem on
> the latter.

Bisected it down to:

eb3e4668bd9e0bbda592e830e889f137e44ec9e4 is the first bad commit
commit eb3e4668bd9e0bbda592e830e889f137e44ec9e4
Author: Peter Hurley <peter@hurleysoftware.com>
Date:   Mon Dec 2 14:24:42 2013 -0500

    n_tty: Un-inline slow-path n_tty_receive_char()
    
    Commit e60d27c4d8b33ba20896b76b6558f061bc6460ff,
    n_tty: Factor LNEXT processing from per-char i/o path,
    mistakenly inlined the non-inline alias, n_tty_receive_char(),
    for the inline function, n_tty_receive_char_inline().
    
    As n_tty_receive_char() is intended for slow-path char
    processing only, un-inline it.
    
    Signed-off-by: Peter Hurley <peter@hurleysoftware.com>
    Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

:040000 040000 80215819e331ff95d80aa7c8a6a05f8c74d1fdb6 41a856dfeb6769e47c7689c92d91db497dfcc8cf M	drivers
[acme@fedora20 linux]$

In a hurry now, will continue later, trying to understand what is the problem
introduced by the above cset...

Need to revert just this one to confirm that it is the culprit, etc.

- Arnaldo
