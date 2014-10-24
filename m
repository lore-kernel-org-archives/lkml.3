Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756239AbaJXOkL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Oct 2014 10:40:11 -0400
Received: from mail.kernel.org ([198.145.19.201]:38524 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754174AbaJXOkI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Oct 2014 10:40:08 -0400
Date: Fri, 24 Oct 2014 11:40:02 -0300
From: Arnaldo Carvalho de Melo <acme@kernel.org>
To: Adrian Hunter <adrian.hunter@intel.com>
Cc: Namhyung Kim <namhyung@kernel.org>, Peter Zijlstra <peterz@infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Paul Mackerras <paulus@samba.org>,
        Stephane Eranian <eranian@google.com>
Subject: Re: [PATCH 05/16] perf tools: Add facility to export data in
 database-friendly way
Message-ID: <20141024144002.GC14687@kernel.org>
References: <1414061124-26830-1-git-send-email-adrian.hunter@intel.com>
 <1414061124-26830-6-git-send-email-adrian.hunter@intel.com>
 <87lho6c8ec.fsf@sejong.aot.lge.com>
 <544A099C.50104@intel.com>
 <544A2E5F.80508@intel.com>
 <CAM9d7ci6bv_JnK8DkqqTEttPkEp1mtMPN07XjqX=K4ADOUC6SA@mail.gmail.com>
 <544A505C.5030203@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <544A505C.5030203@intel.com>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Fri, Oct 24, 2014 at 04:13:00PM +0300, Adrian Hunter escreveu:
> On 24/10/14 15:26, Namhyung Kim wrote:
> > Hi Adrian,
> > 
> > On Fri, Oct 24, 2014 at 7:47 PM, Adrian Hunter <adrian.hunter@intel.com> wrote:
> >> On 24/10/14 11:11, Adrian Hunter wrote:
> >>> On 24/10/14 09:02, Namhyung Kim wrote:
> >>>> Can we do it somewhere in a script not in the core code?  I don't feel
> >>>> comfortable to add those bits into the core code.  What if we export
> >>>
> >>> Please explain what you mean by "comfortable".
> >>
> >> Or rather: What about it is wrong for core code?
> > 
> > Well, there's nothing "wrong" about it. :)
> > 
> > But I think if some code is used only by a specific bits, it'd be
> > better hiding it from the rest as much as possible.
> 
> It is pretty self-contained in db-export.[ch] and the scripting
> engines.

So, what I meant was the patch below, on top of yours.

In some data structures where there were no provision for tool specific
storage, I added an unnamed union with db_id and a void *priv pointer,
where there were, be it a priv pointer, like in perf_evsel, I moved
db_id to it, no extra costs for the other tools.

And in struct symbol, I made it use symbol__priv(), that will access the
area reserved by setting symbol.priv_size at tool start time, like done
for the annotation case in top, report, annotate. I.e. on the tool that
will use symbol->db_id you will need to add this just before calling
symbol__init():

	symbol_conf.priv_size = sizeof(u64);

Since this is all specific to your tool, there should be no problems and
I'm now applying this change merged with your original patch + note
about that and then moving on to the other patches that make use of it.

- Arnaldo
