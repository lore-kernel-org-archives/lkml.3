Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753100Ab3LQUCt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Dec 2013 15:02:49 -0500
Received: from mail-qc0-f172.google.com ([209.85.216.172]:35033 "EHLO
	mail-qc0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753027Ab3LQUCr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Dec 2013 15:02:47 -0500
Date: Tue, 17 Dec 2013 17:02:39 -0300
From: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
To: Namhyung Kim <namhyung@kernel.org>
Cc: Steven Rostedt <rostedt@goodmis.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Ingo Molnar <mingo@kernel.org>, Namhyung Kim <namhyung.kim@lge.com>,
        LKML <linux-kernel@vger.kernel.org>, Jiri Olsa <jolsa@redhat.com>
Subject: Re: [PATCH 13/14] tools lib traceevent: Get rid of die() in some
 string conversion funcitons
Message-ID: <20131217200239.GE6517@ghostprotocols.net>
References: <1386833777-3790-1-git-send-email-namhyung@kernel.org>
 <1386833777-3790-14-git-send-email-namhyung@kernel.org>
 <20131212184147.GE8164@ghostprotocols.net>
 <87y53phah9.fsf@sejong.aot.lge.com>
 <20131213145204.GC29275@ghostprotocols.net>
 <87sitth03c.fsf@sejong.aot.lge.com>
 <20131216124051.GA3598@ghostprotocols.net>
 <878uvkgx9f.fsf@sejong.aot.lge.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <878uvkgx9f.fsf@sejong.aot.lge.com>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Tue, Dec 17, 2013 at 09:02:36AM +0900, Namhyung Kim escreveu:
> On Mon, 16 Dec 2013 09:40:51 -0300, Arnaldo Carvalho de Melo wrote:
> > Em Mon, Dec 16, 2013 at 01:49:11PM +0900, Namhyung Kim escreveu:
> >> On Fri, 13 Dec 2013 11:52:04 -0300, Arnaldo Carvalho de Melo wrote:
> >> > All the rest is ok, so its just the malloc + strcpy that remains to be
> >> > converted, do you want me to do it?

> >> Hmm.. did you mean like this?

> >> 		str = NULL;
> >>                 if (val)
> >>                 	asprintf(&str, "TRUE");
> >>                 else
> >>                 	asprintf(&str, "FALSE");
> >>                 return str;

> > More compact:

> > 	if (asprintf(&str, "%s", val ? "TRUE" : "FALSE") < 0)
> > 		// error handling path

> > At that point str already is set to NULL.

> Okay, this is a new one:

Thanks, it all seems now, but just prior to applying this I noticed:

> Those functions are for stringify filter arguments.  As caller of
> those functions handles NULL string properly, it seems that it's
> enough to return NULL rather than calling die().

It handles NULL in what way? This comment:

> @@ -2369,7 +2340,7 @@ static char *arg_to_str(struct event_filter *filter, struct filter_arg *arg)
>   * Returns a string that displays the filter contents.
>   *  This string must be freed with free(str).
> - *  NULL is returned if no filter is found.
> + *  NULL is returned if no filter is found or allocation failed.
>   */
>  char *
>  pevent_filter_make_string(struct event_filter *filter, int event_id)

Made me a bit unconfortable, so if it handles NULL as a filter not
found, how will it figure out what happened?

/me looks at the callers...

>From just a quick look I couldn't see cases where NULL could cause
segfaults, but saw some cases where allocation errors would not be
notified in any way to the user :-\

Anyway, applying this patch, those are other kinds of problems, i.e. further
fallout from converting from the previous panic()-at-alloc-failure approach.

- Arnaldo
