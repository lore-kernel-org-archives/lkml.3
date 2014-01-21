Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754623AbaAUN4F (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Jan 2014 08:56:05 -0500
Received: from mail-yh0-f54.google.com ([209.85.213.54]:53243 "EHLO
	mail-yh0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754441AbaAUN4C (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Jan 2014 08:56:02 -0500
Date: Tue, 21 Jan 2014 10:55:52 -0300
From: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
To: Namhyung Kim <namhyung@kernel.org>
Cc: Gaurav Jain <gjain@fb.com>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@kernel.org>,
        Namhyung Kim <namhyung.kim@lge.com>,
        LKML <linux-kernel@vger.kernel.org>, Jiri Olsa <jolsa@redhat.com>,
        David Ahern <dsahern@gmail.com>, Andi Kleen <andi@firstfloor.org>
Subject: Re: [PATCH] perf tools: Fix JIT profiling on heap
Message-ID: <20140121135552.GD18027@ghostprotocols.net>
References: <20140116143749.GA21526@ghostprotocols.net>
 <CEFDA8E4.2D359%gjain@fb.com>
 <87sisn6ojf.fsf@sejong.aot.lge.com>
 <20140117143404.GB3207@ghostprotocols.net>
 <87iotd7ucn.fsf@sejong.aot.lge.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87iotd7ucn.fsf@sejong.aot.lge.com>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Tue, Jan 21, 2014 at 02:54:32PM +0900, Namhyung Kim escreveu:
> On Fri, 17 Jan 2014 11:34:04 -0300, Arnaldo Carvalho de Melo wrote:
> > Em Fri, Jan 17, 2014 at 04:44:04PM +0900, Namhyung Kim escreveu:
> >> On Thu, 16 Jan 2014 20:23:27 +0000, Gaurav Jain wrote:
> >> > Does perf support data mappings from perf map files?

> >> IIUC there's no difference between function and data mapping.  So

> > Do the /tmp/perf mapping has any per entry indication on the type of
> > symbol it is (data, text) like ELF and kallsyms symtabs have?

> Quoting Documentation/jit-interface.txt:
 
>   Each line has the following format, fields separated with spaces:
 
>   START SIZE symbolname

> > It is possible for a function and a variable to have the same virt
> > addrin some arches (SPARC, iirc), that is why we have different MAP_
> > types (FUNCTION, VARIABLE)
 
> Hmm.. didn't know that, interesting..

> > So a 'struct map' for a data mmap should point to a different 'dso'
> > of the JIT /tmp/perf-... style if those maps don't have per entry
> > indication of text/data.
 
> Yes, but there's no way to do it currently.

Why not? Its just a matter of having a /tmp/perf-...-data file that has
the same structure as the current files for text mmaps :-)

It would then be used as the map->dso for resolving data addresses.
 
> >> only function symbols in function mappings and variables in data
> >> mapping based on the address it accesses.

> > Well, the lookup should figure out if the IP refers to TEXT or DATA and
> > use MAP__{FUNCTION, VARIABLE} accordingly when asking for symbol
> > resolution.

> Right.  But in this case we cannot determine whether a symbol in the
> /tmp/perf-... file is a function or variable.

That is why we would then need to have separate /tmp/perf-... files,
disambiguated by an extension, one for text addresses, another for data
ones.

Or change the format to match /proc/kallsyms, which probably is what we
should've done from day one...

Detecting the format change would be trivial, as we would find 3 tokens
in the new format, instead of the current 2.
 
> >> What I wasn't sure is whether JIT program also produces some dynamic data.
> >> And I think only perf mem command cares about data mappings, no?

> > Well, I think it would be great to do that kind of data resolution for
> > JITs the same way it is interesting to do for ELF ones :-)
> >
> > I need to stare harder at that patch, but with the above in mind, do we
> > really have to check if the map is MAP__FUNCTION as IIRC this patch
> > does?
> 
> Not sure.  For a JIT case, I guess the mapping is always executable and
> we don't support data mapping yet, so it seems okay for now.

Ok, agreed, applying the patch, thanks,

- Arnaldo
