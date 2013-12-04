Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932361Ab3LDM5Q (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Dec 2013 07:57:16 -0500
Received: from mail-qe0-f49.google.com ([209.85.128.49]:33253 "EHLO
	mail-qe0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932201Ab3LDM5O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Dec 2013 07:57:14 -0500
Date: Wed, 4 Dec 2013 09:57:03 -0300
From: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
To: Ingo Molnar <mingo@kernel.org>
Cc: David Ahern <dsahern@gmail.com>, Namhyung Kim <namhyung@kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>, Namhyung Kim <namhyung.kim@lge.com>,
        LKML <linux-kernel@vger.kernel.org>, Jiri Olsa <jolsa@redhat.com>,
        Stephane Eranian <eranian@google.com>,
        Andi Kleen <andi@firstfloor.org>, Pekka Enberg <penberg@kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Borislav Petkov <bp@alien8.de>
Subject: Re: [PATCH 3/3] perf report: Add --show-time-info option
Message-ID: <20131204125703.GA6359@ghostprotocols.net>
References: <20131202192315.GA17149@ghostprotocols.net>
 <529CDEA6.8000807@gmail.com>
 <20131202193850.GC17149@ghostprotocols.net>
 <529CE66B.5070209@gmail.com>
 <20131202201705.GE17149@ghostprotocols.net>
 <20131204101117.GC2363@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131204101117.GC2363@gmail.com>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Wed, Dec 04, 2013 at 11:11:17AM +0100, Ingo Molnar escreveu:
> * Arnaldo Carvalho de Melo <acme@ghostprotocols.net> wrote:
> > Em Mon, Dec 02, 2013 at 12:58:35PM -0700, David Ahern escreveu:
> > > On 12/2/13, 12:38 PM, Arnaldo Carvalho de Melo wrote:
> > > Why not just --event-time?

> > > Really should have dropped the 'show' from the recent perf-script
> > > change (just --task-events and --mmap-events).

> > Probably, yeah, Ingo made some point about using --show- for some reason,
> > Ingo?
 
> So the reason for my suggestion was that I've noticed a proliferation 
> of such flags in perf report. To reduce namespace pollution it's 
> always good to bring a certain kind of hierarchy into command line 
> options.
 
> Options that work alike should spell alike. Users shouldn't be 
> required to memorize every naming quirk of the various disjunct 
> 'display this extra data' options.
 
> So if we expect more --show options in the future (and in particular 
> if there are existing oddball options that could be changed to the 
> --show-xyz pattern) then I'd suggest to do it unified. For example 
> there's --show-nr-samples and --show-info already which follows this 
> pattern.
 
> This pattern would distinguish this option from the other perf report 
> options, such as --vmlinux, --force, --sort, etc.
 
> It might even make sense to unify it all into a single --show option. 
> That would allow the following current mismash of options:
 
>        --task-events --mmap-events --show-nr-samples --show-info
 
> to be replaced by a much more obvious, much more coherent looking 
> option sequence:
 
> 	--show task-events,mmap-events,nr-samples,info

Excellent idea, agreed, we should probably try to implement this as a
generic facility to be used accross all the tools.

This, together with the other options processing code should be a
natural candidate for a tools/lib/opt/ directory, implemented in the way
we discussed: a .a for tools that want all the options processing, but
also as untangled as possible so that tools that want just specific bits
can chew them individually.

So, in summary, we _will_ be dropping the 'show-' prefix from all those
options, and those options as well, that then just become a single (top
level) option with entries in a bitmask that are set via some OPT_
callback that receives some struct with a string table and has a bitmask
that it will set.

> an added bonus would be that '--show help' could be implemented as 
> well, to list all displayable extra data.

Right, the string table I mentioned in fact should be a struct table
that in turn has two strings, the --show bitname and bithelp.
 
> (I'm not married to the specific naming, it could be something else as 
> well, like --display or --report.)

I think 'show' is ok, 4 letters, shorter than 'display', already used in
several places.

- Arnaldo
