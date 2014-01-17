Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752241AbaAQOeN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Jan 2014 09:34:13 -0500
Received: from mail-qc0-f170.google.com ([209.85.216.170]:58170 "EHLO
	mail-qc0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751960AbaAQOeL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Jan 2014 09:34:11 -0500
Date: Fri, 17 Jan 2014 11:34:04 -0300
From: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
To: Namhyung Kim <namhyung@kernel.org>
Cc: Gaurav Jain <gjain@fb.com>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@kernel.org>,
        Namhyung Kim <namhyung.kim@lge.com>,
        LKML <linux-kernel@vger.kernel.org>, Jiri Olsa <jolsa@redhat.com>,
        David Ahern <dsahern@gmail.com>, Andi Kleen <andi@firstfloor.org>
Subject: Re: [PATCH] perf tools: Fix JIT profiling on heap
Message-ID: <20140117143404.GB3207@ghostprotocols.net>
References: <20140116143749.GA21526@ghostprotocols.net>
 <CEFDA8E4.2D359%gjain@fb.com>
 <87sisn6ojf.fsf@sejong.aot.lge.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87sisn6ojf.fsf@sejong.aot.lge.com>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Fri, Jan 17, 2014 at 04:44:04PM +0900, Namhyung Kim escreveu:
> On Thu, 16 Jan 2014 20:23:27 +0000, Gaurav Jain wrote:
> > On 1/16/14, 9:37 AM, "Arnaldo Carvalho de Melo" <acme@ghostprotocols.net>
> > wrote:
> >
> >>Em Thu, Jan 16, 2014 at 10:49:31AM +0900, Namhyung Kim escreveu:
> >>> Gaurav reported that perf cannot profile JIT program if it executes
> >>> the code on heap.  This was because current map__new() only handle JIT
> >>> on anon mappings - extends it to handle no_dso (heap, stack) case too.
> >>> 
> >>> This patch assumes JIT profiling only provides dynamic function
> >>> symbols so check the mapping type to distinguish the case.  It'd
> >>> provide no symbols for data mapping - if we need to support symbols on
> >>> data mappings later it should be changed.
> >>
> >>But we do support symbols in data mappings, that is why we have
> >>MAP__VARIABLE, etc, can you elaborate?

> > Does perf support data mappings from perf map files? Could you please
> > share an example of how I may be able to use this.

> IIUC there's no difference between function and data mapping.  So you
> can use same perf map file for both - in fact there's no way to use
> different map file in a single task.  I guess perf will use it to find

Do the /tmp/perf mapping has any per entry indication on the type of
symbol it is (data, text) like ELF and kallsyms symtabs have?

It is possible for a function and a variable to have the same virtual
address in some architectures (SPARC, iirc), that is why we have
different MAP_ types (FUNCTION, VARIABLE) (which should really be
renamed to TEXT, DATA).

So a 'struct map' for a data mmap should possibly point to a different
'dso' of the JIT /tmp/perf-... style if those maps don't have per entry
indication of text/data.

> only function symbols in function mappings and variables in data
> mapping based on the address it accesses.

Well, the lookup should figure out if the IP refers to TEXT or DATA and
use MAP__{FUNCTION, VARIABLE} accordingly when asking for symbol
resolution.

> What I wasn't sure is whether JIT program also produces some dynamic data.
> And I think only perf mem command cares about data mappings, no?

Well, I think it would be great to do that kind of data resolution for
JITs the same way it is interesting to do for ELF ones :-)

I need to stare harder at that patch, but with the above in mind, do we
really have to check if the map is MAP__FUNCTION as IIRC this patch
does?

- Arnaldo
