Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755904AbaIEBSL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Sep 2014 21:18:11 -0400
Received: from mail.kernel.org ([198.145.19.201]:44525 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751710AbaIEBSJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Sep 2014 21:18:09 -0400
Date: Thu, 4 Sep 2014 22:18:04 -0300
From: Arnaldo Carvalho de Melo <acme@kernel.org>
To: Namhyung Kim <namhyung@kernel.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@kernel.org>,
        Paul Mackerras <paulus@samba.org>, Namhyung Kim <namhyung.kim@lge.com>,
        LKML <linux-kernel@vger.kernel.org>, Jiri Olsa <jolsa@redhat.com>,
        David Ahern <dsahern@gmail.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Andi Kleen <andi@firstfloor.org>,
        Stephane Eranian <eranian@google.com>, stable@vger.kernel.org
Subject: Re: [PATCH] perf tools: Fix build-id matching on vmlinux
Message-ID: <20140905011804.GC30520@kernel.org>
References: <1409035119-24357-1-git-send-email-namhyung@kernel.org>
 <20140904141845.GD2997@kernel.org>
 <87a96f9bci.fsf@sejong.aot.lge.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87a96f9bci.fsf@sejong.aot.lge.com>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Fri, Sep 05, 2014 at 09:09:49AM +0900, Namhyung Kim escreveu:
> >> Before:
> >>   $ perf record -a usleep 1

> >>   $ perf buildid-list
> >>   00d5ff078efe1d30b8492854f259215fd877ce30 /lib/modules/3.16.0-rc2+/build/vmlinux
> >>   78186287bba77069a056a5ccbeb14b7fd2ca3a4b /usr/lib64/libc-2.17.so

> >>   $ perf buildid-list -H
> >>   0000000000000000000000000000000000000000 [kernel.kallsyms]
> >>   78186287bba77069a056a5ccbeb14b7fd2ca3a4b /usr/lib64/libc-2.17.so

> >> After:
> >>   $ perf record -a usleep 1

> >>   $ perf buildid-list
> >>   00d5ff078efe1d30b8492854f259215fd877ce30 [kernel.kallsyms]

> > We are losing information, namely the pathname for the kernel used, that
> > may be useful in analysis.
 
> Right.  That's a problem.

> > Why not make sure that if there is a build-id in the perf.data header,
> > then we completely refusing anything that doesn't match the build-id?
> > I.e. the name is irrelevant for this purpose, the contents, as keyed by
> > the build-id, is what matters.
 
> The perf report rebuilds machine states from the event records only.  In
> this case, the kernel map was recorded in the name of [kernel.kallsyms]
> so it couldn't find the build-id from the table.

Ok, but then we can special case this one, no?

Somehow mark in the buildid table that that entry is the one for the
kernel and hook it up to the synthesized event that has the
[kernel.kallsyms].ref_reloc_sym entry.

- Arnaldo
