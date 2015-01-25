Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932984AbbAYTb7 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Jan 2015 14:31:59 -0500
Received: from smtprelay0106.hostedemail.com ([216.40.44.106]:35558 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1759941AbbAYTby (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Jan 2015 14:31:54 -0500
X-Session-Marker: 6E657665747340676F6F646D69732E6F7267
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,rostedt@goodmis.org,:::::::::::::::,RULES_HIT:41:355:379:541:599:800:960:973:988:989:1260:1277:1311:1313:1314:1345:1359:1437:1515:1516:1518:1534:1541:1593:1594:1711:1730:1747:1777:1792:2393:2553:2559:2562:2691:2901:3138:3139:3140:3141:3142:3353:3622:3865:3866:3867:3870:3871:3872:3874:5007:6119:6261:7875:7903:10004:10400:10450:10455:10848:10967:11026:11232:11658:11914:12438:12517:12519:12740:13069:13311:13357:19904:19999:21080,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: berry00_2d782780ab937
X-Filterd-Recvd-Size: 2835
Date: Sun, 25 Jan 2015 14:31:51 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: Jiri Olsa <jolsa@redhat.com>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Jiri Olsa <jolsa@kernel.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Namhyung Kim <namhyung@kernel.org>
Subject: Re: [PATCH 5/5] perf: Make perf aware of tracefs
Message-ID: <20150125143151.4c42c836@gandalf.local.home>
In-Reply-To: <20150125173433.GA10390@krava.brq.redhat.com>
References: <20150124181330.195149364@goodmis.org>
	<20150124181449.157590751@goodmis.org>
	<20150125173433.GA10390@krava.brq.redhat.com>
X-Mailer: Claws Mail 3.11.1 (GTK+ 2.24.25; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 25 Jan 2015 18:34:33 +0100
Jiri Olsa <jolsa@redhat.com> wrote:

> On Sat, Jan 24, 2015 at 01:13:35PM -0500, Steven Rostedt wrote:
> 
> SNIP
> 
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
> 
> so this pattern 'try tracefs, if that does not work try debugfs'
> is all over the patch.. how about we add new new 'virtual' fs to
> encapsulate that, like:
> 
>   with followign interface:
>     bool tpfs_configured(void);
>     const char *tpfs_find_mountpoint(void);
>     int tpfs_valid_mountpoint(const char *debugfs);
>     char *tpfs_mount(const char *mountpoint);
>     extern char tpfs_mountpoint[];
> 
> It does not neceserily needs to reside in tools/lib/api/fs/tpfs.[ch],
> but I believe we need some form of encapsulation for this.

I did it this way because perf had no encapsulation for finding debugfs
paths. I made the change in trace-cmd in one location. Perf does it a
little different in each place. I have no idea why there was more than
one location slapping on "/tracing".

I'd like to get tracefs into perf before doing any redesign of perf's
infrastructure. That could come later as a cleanup.

This is not a fast path, it wont hurt performance. I agree it should be
encapsulated, but that's going outside of the scope of this patch
series, which is only to add awareness to tracefs, not to clean up
perf's access to the debugfs/tracing directory.

-- Steve
