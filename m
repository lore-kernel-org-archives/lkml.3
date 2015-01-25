Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759363AbbAYTUH (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Jan 2015 14:20:07 -0500
Received: from smtprelay0147.hostedemail.com ([216.40.44.147]:44684 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754966AbbAYTT7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Jan 2015 14:19:59 -0500
X-Session-Marker: 6E657665747340676F6F646D69732E6F7267
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,rostedt@goodmis.org,:::::::::::::,RULES_HIT:41:355:379:541:599:800:960:973:988:989:1260:1277:1311:1313:1314:1345:1359:1431:1437:1515:1516:1518:1534:1541:1593:1594:1711:1730:1747:1777:1792:2393:2553:2559:2562:2693:3138:3139:3140:3141:3142:3354:3622:3865:3866:3867:3868:3871:3872:3874:4321:4362:5007:6261:7576:7875:10004:10400:10450:10455:10848:10967:11026:11232:11658:11914:12517:12519:12555:12740:13069:13311:13357:14096:14097:19904:19999:21060:21063:21080,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: spot25_56ddcdc287c03
X-Filterd-Recvd-Size: 2975
Date: Sun, 25 Jan 2015 14:19:54 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: Namhyung Kim <namhyung@kernel.org>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Jiri Olsa <jolsa@kernel.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Subject: Re: [PATCH 5/5] perf: Make perf aware of tracefs
Message-ID: <20150125141954.50a26917@gandalf.local.home>
In-Reply-To: <20150125135010.GA24454@danjae>
References: <20150124181330.195149364@goodmis.org>
	<20150124181449.157590751@goodmis.org>
	<20150125135010.GA24454@danjae>
X-Mailer: Claws Mail 3.11.1 (GTK+ 2.24.25; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 25 Jan 2015 22:50:10 +0900
Namhyung Kim <namhyung@kernel.org> wrote:

> Hi Steve,
> 
> On Sat, Jan 24, 2015 at 01:13:35PM -0500, Steven Rostedt wrote:
> > From: "Steven Rostedt (Red Hat)" <rostedt@goodmis.org>
> > 
> > As tracefs may be mounted instead of debugfs to get to the event directories,
> > have perf know about tracefs, and use that file system over debugfs if it
> > is present.
> > 
> > Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
> > ---
> >  const char *find_tracing_dir(void)
> >  {
> > +	const char *tracing_dir = "";
> >  	static char *tracing;
> >  	static int tracing_found;
> >  	const char *debugfs;
> > @@ -351,11 +385,15 @@ const char *find_tracing_dir(void)
> >  	if (tracing_found)
> >  		return tracing;
> >  
> > -	debugfs = find_debugfs();
> > -	if (!debugfs)
> > -		return NULL;
> > +	debugfs = find_tracefs();
> > +	if (!debugfs) {
> > +		tracing_dir = "/tracing";
> > +		debugfs = find_debugfs();
> > +		if (!debugfs)
> > +			return NULL;
> > +	}
> >  
> > -	if (asprintf(&tracing, "%s/tracing", debugfs) < 0)
> > +	if (asprintf(&tracing, "%s%s", tracing_dir, debugfs) < 0)
> 
> s/tracing_dir, debugfs/debugfs, tracing_dir/

Hmm, I wonder how I missed this during testing. Ah, I think it broke on
tracefs, so I added this, but never tested it again without tracefs.

Thanks, will fix.

-- Steve

> 
> Thanks,
> Namhyung
> 
> 
> >  		return NULL;
> >  
> >  	tracing_found = 1;
> > diff --git a/tools/perf/util/util.h b/tools/perf/util/util.h
> > index 027a5153495c..73c2f8e557ab 100644
> > --- a/tools/perf/util/util.h
> > +++ b/tools/perf/util/util.h
> > @@ -75,6 +75,7 @@
> >  #include <linux/types.h>
> >  #include <sys/ttydefaults.h>
> >  #include <api/fs/debugfs.h>
> > +#include <api/fs/tracefs.h>
> >  #include <termios.h>
> >  #include <linux/bitops.h>
> >  #include <termios.h>
> > -- 
> > 2.1.4
> > 
> > 

