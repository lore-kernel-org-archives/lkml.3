Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752548AbaKUUbL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Nov 2014 15:31:11 -0500
Received: from mail.kernel.org ([198.145.19.201]:35509 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750939AbaKUUbJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Nov 2014 15:31:09 -0500
Date: Fri, 21 Nov 2014 17:30:57 -0300
From: Arnaldo Carvalho de Melo <acme@kernel.org>
To: Andi Kleen <andi@firstfloor.org>
Cc: Jiri Olsa <jolsa@redhat.com>, Namhyung Kim <namhyung@kernel.org>,
        Jiri Olsa <jolsa@kernel.org>, linux-kernel@vger.kernel.org,
        "Liang, Kan" <kan.liang@intel.com>
Subject: Re: Implement lbr-as-callgraph v10
Message-ID: <20141121203057.GD18625@kernel.org>
References: <20141117213457.GE4163@kernel.org>
 <20141118104416.GE27645@krava.brq.redhat.com>
 <20141118110007.GF27645@krava.brq.redhat.com>
 <87zjbnpv64.fsf@sejong.aot.lge.com>
 <20141119092323.GC2592@krava.brq.redhat.com>
 <20141119105450.GA22132@krava.brq.redhat.com>
 <20141119141027.GF3790@kernel.org>
 <20141119160458.GG3790@kernel.org>
 <20141119214822.GM12538@two.firstfloor.org>
 <20141120193347.GL3790@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141120193347.GL3790@kernel.org>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Thu, Nov 20, 2014 at 04:33:47PM -0300, Arnaldo Carvalho de Melo escreveu:
> Em Wed, Nov 19, 2014 at 10:48:22PM +0100, Andi Kleen escreveu:
> > > > directory since I'm comparing the output of --stdio, --tui and --gtk,
> > > > since it looks --gtk is wrong, still unsure about what the problem is in
> > > > that case, but stumbled on:

> > > I need to investigate this further, so I created a perf/branch-history
> > > branch that has the patches I need to test more rebased on top of my
> > > perf/core branch I just pushed out to Ingo.

> > I tested --gtk and I don't see any differences to the console mode
> > with --branch-history.  What problem do you see?

> The difference is with --tui, but I haven't checked if this is a problem
> introduced by your patchkit or if this is something that was there
> before it was applied.

So, here it is, --gtk looks like --stdio:

$ perf report --no-children --branch-history --stdio

# Samples: 43  of event 'cycles'
# Event count (approx.): 26843162
#
# Overhead  Source:Line  Symbol                     Shared Object   
# ........  ...........  .........................  ................
#
    68.42%  tcall.c:5    [.] f2                     tcall           
            |          
            |--87.65%-- f2 tcall.c:4
            |          |          
            |          |--67.41%-- f1 tcall.c:10
            |          |          f1 tcall.c:9
            |          |          main tcall.c:17
            |          |          main tcall.c:17
            |          |          main tcall.c:16
            |          |          main tcall.c:16
            |          |          f1 tcall.c:12
            |          |          f1 tcall.c:12
            |          |          f2 tcall.c:6
            |          |          f2 tcall.c:4
            |          |          f1 tcall.c:11
            |          |          f1 tcall.c:11
            |          |          f2 tcall.c:6
            |          |          f2 tcall.c:4
            |          |          f1 tcall.c:10
            |          |          
            |           --32.59%-- f1 tcall.c:11
            |                     f1 tcall.c:11
            |                     f1 tcall.c:11
            |                     f2 tcall.c:6
            |                     f2 tcall.c:4
            |                     f1 tcall.c:10
            |                     f1 tcall.c:9
            |                     main tcall.c:17
            |                     main tcall.c:17
            |                     main tcall.c:16
            |                     main tcall.c:16
            |                     f1 tcall.c:12
            |                     f1 tcall.c:12
            |                     f2 tcall.c:6
            |                     f2 tcall.c:4
            |                     f1 tcall.c:11
            |          
             --12.35%-- f1 tcall.c:9
                       main tcall.c:17
                       main tcall.c:17
                       main tcall.c:16
                       main tcall.c:16
                       f1 tcall.c:12
                       f1 tcall.c:12
                       f2 tcall.c:6
                       f2 tcall.c:4
                       f1 tcall.c:11
                       f1 tcall.c:11
                       f2 tcall.c:6
                       f2 tcall.c:4
                       f1 tcall.c:10
                       f1 tcall.c:9
                       main tcall.c:17
<SNIP>

But:

$ perf report --no-children --branch-history --tui
# Then expand a few callchains and press 'P' to generate a perf.hist.0
# file:
-   68.42%  tcall.c:5    [.] f2                     tcall
   - f2 tcall.c:4
      - 67.41% f1 tcall.c:10
           f1 tcall.c:9
           main tcall.c:17
           main tcall.c:17
           main tcall.c:16
           main tcall.c:16
           f1 tcall.c:12
           f1 tcall.c:12
           f2 tcall.c:6
           f2 tcall.c:4
           f1 tcall.c:11
           f1 tcall.c:11
           f2 tcall.c:6
           f2 tcall.c:4
           f1 tcall.c:10
      - 32.59% f1 tcall.c:11
           f1 tcall.c:11
           f2 tcall.c:6
           f2 tcall.c:4
           f1 tcall.c:10
           f1 tcall.c:9
           main tcall.c:17
           main tcall.c:17
           main tcall.c:16
           main tcall.c:16
           f1 tcall.c:12
           f1 tcall.c:12
           f2 tcall.c:6
           f2 tcall.c:4
           f1 tcall.c:11
     f1 tcall.c:9
     main tcall.c:17
     main tcall.c:17
     main tcall.c:16
     main tcall.c:16
     f1 tcall.c:12
     f1 tcall.c:12
     f2 tcall.c:6
     f2 tcall.c:4
     f1 tcall.c:11
     f1 tcall.c:11
     f2 tcall.c:6
     f2 tcall.c:4
     f1 tcall.c:10
     f1 tcall.c:9
     main tcall.c:17
<SNIP>


Do you see the diff?  The 87.65% and 12.35% doesn't appear on the --tui
output.

But I don't know if this is due to your patchkit, trying to check.

- Arnaldo
