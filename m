Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756225Ab3JGQmG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Oct 2013 12:42:06 -0400
Received: from mail-ea0-f171.google.com ([209.85.215.171]:48607 "EHLO
	mail-ea0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755519Ab3JGQmB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Oct 2013 12:42:01 -0400
Date: Mon, 7 Oct 2013 18:41:56 +0200
From: Ingo Molnar <mingo@kernel.org>
To: David Ahern <dsahern@gmail.com>
Cc: linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Namhyung Kim <namhyung@kernel.org>, Jiri Olsa <jolsa@redhat.com>
Subject: Re: [RFC PATCH 00/50] tools/perf: Speed up the build system
Message-ID: <20131007164156.GA12790@gmail.com>
References: <1381147003-2574-1-git-send-email-mingo@kernel.org>
 <5252BCB4.5030802@gmail.com>
 <20131007141100.GA21873@gmail.com>
 <5252D4DB.30302@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5252D4DB.30302@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* David Ahern <dsahern@gmail.com> wrote:

> I also noticed that the dwarf test is still run even with the NO_DWARF 
> option passed in:
> 
> [daahern@nxos-vdc-dev1 perf]$ make O=/tmp/junk LDFLAGS=-static
> NO_DWARF=1 -j 4
>     BUILD: Doing 'make -j16' parallel build
> 
> Auto-detecting system features:
> 
> ...                     backtrace: [ on  ]
> ...                         dwarf: [ on  ]
> ...                fortify-source: [ on  ]
> 
> Note the dwarf test shows 'on'.

Hm, yes.

This is just the print-out though - the actual feature logic should still 
follow the NO_DWARF=1 setting (modulo bugs).

So I'm wondering, should we solve this by adding extra logic linking the 
feature flags with their legacy names. It would get unwieldy rather 
quickly I think.

Another solution would be to introduce a new method to disable features, 
via something like:

	make FEATURE_dwarf=0

Where the pattern would follow the auto-detected naming. This would 
simplify the printout logic and would simplify the feature support / flags 
decision tree as well.

Furthermore, it would unify the various flags we have today, which is 
rather mixed: for example there's NO_DWARF which is a name that shows 
negated logic, but there's also HAVE_CPLUS_DEMANGLE_SUPPORT is is a name 
with positive logic. We'd have one uniform naming scheme permeating the 
whole build system.

And that brings in your [K]config patches: which would make sense in that 
context as well, as they'd allow the permanent configuration of features 
with 3 states for each feature flag:

	off
	auto-detect
	on

Your scheme I think makes a lot of sense on top of my bits. Packagers 
would likely want to use a .config to build perf, most users would likely 
be fine with a default of everything on auto-detect. Specialized users 
would want to use their own .config's.

Thanks,

	Ingo
