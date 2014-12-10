Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755301AbaLJK7p (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Dec 2014 05:59:45 -0500
Received: from e28smtp03.in.ibm.com ([122.248.162.3]:56266 "EHLO
	e28smtp03.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751688AbaLJK7n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Dec 2014 05:59:43 -0500
Date: Wed, 10 Dec 2014 16:29:00 +0530
From: "Naveen N. Rao" <naveen.n.rao@linux.vnet.ibm.com>
To: Michael Ellerman <mpe@ellerman.id.au>
Cc: linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        acme@kernel.org, ananth@in.ibm.com
Subject: Re: [RFC PATCH 3/8] perf probe: Improve detection of file/function
 name in the probe pattern
Message-ID: <20141210105900.GC16045@naverao1-tp.in.ibm.com>
References: <cover.1418146300.git.naveen.n.rao@linux.vnet.ibm.com>
 <de6c0cd8236de1cabc179e456514c2a399cbc7b5.1418146300.git.naveen.n.rao@linux.vnet.ibm.com>
 <1418205606.9279.6.camel@ellerman.id.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1418205606.9279.6.camel@ellerman.id.au>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14121010-0009-0000-0000-000002D4A4A9
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2014/12/10 09:00PM, Michael Ellerman wrote:
> On Tue, 2014-12-09 at 23:04 +0530, Naveen N. Rao wrote:
> > Currently, perf probe considers patterns including a '.' to be a file.
> > However, this causes problems on powerpc ABIv1 where all functions have
> > a leading '.':
> > 
> >   $ perf probe -F | grep schedule_timeout_interruptible
> >   .schedule_timeout_interruptible
> >   $ perf probe .schedule_timeout_interruptible
> >   Semantic error :File always requires line number or lazy pattern.
> >     Error: Command Parse Error.
> > 
> > Fix this by checking the probe pattern in more detail.
> > 
> > Signed-off-by: Naveen N. Rao <naveen.n.rao@linux.vnet.ibm.com>
> > ---
> >  tools/perf/util/probe-event.c | 23 ++++++++++++++++++++---
> >  1 file changed, 20 insertions(+), 3 deletions(-)
> > 
> > diff --git a/tools/perf/util/probe-event.c b/tools/perf/util/probe-event.c
> > index c150ca4..c7e01ef 100644
> > --- a/tools/perf/util/probe-event.c
> > +++ b/tools/perf/util/probe-event.c
> > @@ -999,6 +999,24 @@ static int parse_perf_probe_point(char *arg, struct perf_probe_event *pev)
> >  		arg = tmp;
> >  	}
> >  
> > +	/*
> > +	 * Check arg is function or file name and copy it.
> > +	 *
> > +	 * We consider arg to be a file spec if and only if it satisfies
> > +	 * all of the below criteria::
> > +	 * - it does not include any of "+@%",
> > +	 * - it includes one of ":;", and
> > +	 * - it has a period '.' in the name.
> 
> I don't think we need to be this elaborate.
> 
> AFAIK there are no source files in the kernel that start with '.'
> 
> So if the arg starts with '.' it must be a function?

Indeed, but this is also used for parsing uprobes. So, I coded this 
based on the spec for the probe pattern.

- Naveen

