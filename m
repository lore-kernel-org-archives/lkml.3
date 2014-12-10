Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755580AbaLJLMf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Dec 2014 06:12:35 -0500
Received: from ozlabs.org ([103.22.144.67]:60283 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752551AbaLJLMe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Dec 2014 06:12:34 -0500
Message-ID: <1418209952.9279.13.camel@ellerman.id.au>
Subject: Re: [RFC PATCH 3/8] perf probe: Improve detection of file/function
 name in the probe pattern
From: Michael Ellerman <mpe@ellerman.id.au>
To: "Naveen N. Rao" <naveen.n.rao@linux.vnet.ibm.com>
Cc: linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        acme@kernel.org, ananth@in.ibm.com
Date: Wed, 10 Dec 2014 22:12:32 +1100
In-Reply-To: <20141210105900.GC16045@naverao1-tp.in.ibm.com>
References: <cover.1418146300.git.naveen.n.rao@linux.vnet.ibm.com>
	 <de6c0cd8236de1cabc179e456514c2a399cbc7b5.1418146300.git.naveen.n.rao@linux.vnet.ibm.com>
	 <1418205606.9279.6.camel@ellerman.id.au>
	 <20141210105900.GC16045@naverao1-tp.in.ibm.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.12.7-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2014-12-10 at 16:29 +0530, Naveen N. Rao wrote:
> On 2014/12/10 09:00PM, Michael Ellerman wrote:
> > On Tue, 2014-12-09 at 23:04 +0530, Naveen N. Rao wrote:
> > > Currently, perf probe considers patterns including a '.' to be a file.
> > > However, this causes problems on powerpc ABIv1 where all functions have
> > > a leading '.':
> > > 
> > >   $ perf probe -F | grep schedule_timeout_interruptible
> > >   .schedule_timeout_interruptible
> > >   $ perf probe .schedule_timeout_interruptible
> > >   Semantic error :File always requires line number or lazy pattern.
> > >     Error: Command Parse Error.
> > > 
> > > Fix this by checking the probe pattern in more detail.
> > > 
> > > Signed-off-by: Naveen N. Rao <naveen.n.rao@linux.vnet.ibm.com>
> > > ---
> > >  tools/perf/util/probe-event.c | 23 ++++++++++++++++++++---
> > >  1 file changed, 20 insertions(+), 3 deletions(-)
> > > 
> > > diff --git a/tools/perf/util/probe-event.c b/tools/perf/util/probe-event.c
> > > index c150ca4..c7e01ef 100644
> > > --- a/tools/perf/util/probe-event.c
> > > +++ b/tools/perf/util/probe-event.c
> > > @@ -999,6 +999,24 @@ static int parse_perf_probe_point(char *arg, struct perf_probe_event *pev)
> > >  		arg = tmp;
> > >  	}
> > >  
> > > +	/*
> > > +	 * Check arg is function or file name and copy it.
> > > +	 *
> > > +	 * We consider arg to be a file spec if and only if it satisfies
> > > +	 * all of the below criteria::
> > > +	 * - it does not include any of "+@%",
> > > +	 * - it includes one of ":;", and
> > > +	 * - it has a period '.' in the name.
> > 
> > I don't think we need to be this elaborate.
> > 
> > AFAIK there are no source files in the kernel that start with '.'
> > 
> > So if the arg starts with '.' it must be a function?
> 
> Indeed, but this is also used for parsing uprobes. So, I coded this 
> based on the spec for the probe pattern.

OK. It also seems unlikely you'll want a uprobe on a file that starts with a . ?

I'll leave it up to the perf guys to decide if they're happy with it.

cheers


