Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755325Ab3HWQig (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Aug 2013 12:38:36 -0400
Received: from smtpauth05h.mfg.siteprotect.com ([64.26.60.146]:42887 "EHLO
	smtpauth05.mfg.siteprotect.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754285Ab3HWQif (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Aug 2013 12:38:35 -0400
Date: Fri, 23 Aug 2013 12:39:53 -0400 (EDT)
From: Vince Weaver <vince@deater.net>
X-X-Sender: vince@pianoman.cluster.toy
To: Robert Richter <rric@kernel.org>
cc: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@kernel.org>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Borislav Petkov <bp@alien8.de>, Jiri Olsa <jolsa@redhat.com>,
        linux-kernel@vger.kernel.org, Namhyung Kim <namhyung@kernel.org>
Subject: Re: [PATCH v3 08/12] perf, persistent: Exposing persistent events
 using sysfs
In-Reply-To: <20130823093708.GA10223@rric.localhost>
Message-ID: <alpine.DEB.2.02.1308231227180.7482@pianoman.cluster.toy>
References: <1377180807-12758-1-git-send-email-rric@kernel.org> <1377180807-12758-9-git-send-email-rric@kernel.org> <alpine.DEB.2.02.1308221344500.26486@pianoman.cluster.toy> <20130823093708.GA10223@rric.localhost>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-CTCH-Spam: Unknown
X-CTCH-RefID: str=0001.0A02020A.5217900B.0039,ss=1,re=0.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 23 Aug 2013, Robert Richter wrote:

> I thought it would be clear enough to refer to struct perf_event_attr.
> Since the index usually starts with 0 as in the config fields, I
> assumed this was clear in this case too. Though this can be documented
> better.

Make no assumptions when documenting.  When I as a user have to dig around
the kernel source tree to find out what is going on then the documentation 
is lacking.

> > Is this endian clean?  Will attr5:23 point to the same bit on a big-endian 
> > machine as on little-endian?
> 
> It is the endianness used in the syscall. Handled in the same way as
> for the config fields. I don't see where this could be an issue.

C bitfields go opposite ways on big-endian vs little-endian systems.
This has come up with some of the bitfields in the sample buffers.
It doesn't matter if you just use the bitfields, but if you're trying
to poke single bits into opaque 64-bit blobs it might be an issue.

> The format directories in /sys/bus/event_source/devices/*/format/ are
> already there to make it human readable. A user never has to deal
> directly with syntax provided there and may use already the
> abstractions for the event syntax.

The format directory for now was only for the "config" fields which
traditionally were needed to specify an event, that is all.

Things get a lot more complex if arbitrary subsets of the the perf_attr
structure start getting exported.

> The problem with this is that you have to implement this in the event
> parser of perf tools. Thus, you need to update the parser for any
> other syntax you want to use. This is not necessary with my
> implementation. It already provides the above. The pmu driver just
> need to add the sysfs entry.

I see.  Are you going to update the parsers for programs that
also try to read these values, like trinity?  

Or is the perf tool special because it is in the kernel?

> All this without updating perf tools.

So are we going to admit the ABI is "it doesn't break perf" after all?

> It's the whole intention of the new syntax that the event parser never
> needs to be modified again 

the *perf* event parser never needs to be modified again maybe.

In any case, Andi Kleen also has some patches to this effect so you might 
want to co-ordinate your efforts.  In his case it was the "precise" field 
he was exporting in events.

Vince

(yes, I still think events should be defined in a library or else a
 user parsable file in userspace.  Putting them in sysfs just complicates
 everything for no good reason)


